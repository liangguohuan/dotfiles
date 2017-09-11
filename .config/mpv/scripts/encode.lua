------------------------------------------------------------------
-- https://github.com/occivink/mpv-scripts#encodelua
------------------------------------------------------------------
local start_timestamp = nil
local utils = require "mp.utils"
local options = require "mp.options"
local timer = nil
local timer_duration = 3

function append_table(lhs, rhs)
    for i = 1,#rhs do
        lhs[#lhs+1] = rhs[i]
    end
    return lhs
end

function file_exists(name)
    local f = io.open(name, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end

function get_output_string(dir, format, input, from, to, profile)
    local res = utils.readdir(dir)
    if not res then
        return nil
    end
    local files = {}
    for _, f in ipairs(res) do
        files[f] = true
    end
    local output = format
    output = string.gsub(output, "$f", input)
    output = string.gsub(output, "$s", seconds_to_time_string(from, true))
    output = string.gsub(output, "$e", seconds_to_time_string(to, true))
    output = string.gsub(output, "$d", seconds_to_time_string(to-from, true))
    output = string.gsub(output, "$p", profile)
    if not string.find(output, "$n") then
        if not files[output] then
            return output
        else
            return nil
        end
    end
    local i = 1
    while true do
        local potential_name = string.gsub(output, "$n", tostring(i))
        if not files[potential_name] then
            return potential_name
        end
        i = i + 1
    end
end

function get_video_filters()
    local filters = {}
    local vf_table = mp.get_property_native("vf")
    for _, vf in ipairs(vf_table) do
        local name = vf["name"]
        local filter
        if name == "crop" then
            local p = vf["params"]
            filter = string.format("crop=%d:%d:%d:%d", p["w"], p["h"], p["x"], p["y"])
        elseif name == "mirror" then
            filter = "hflip"
        elseif name == "flip" then
            filter = "vflip"
        elseif name == "rotate" then
            local rotation = tonumber(vf["params"]["angle"])
            -- rotate is NOT the filter we want here
            if rotation == 90 then
                filter = string.format("transpose=clock")
            elseif rotation == 180 then
                filter = string.format("transpose=clock,transpose=clock")
            elseif rotation == 270 then
                filter = string.format("transpose=cclock")
            end
        end
        filters[#filters + 1] = filter
    end
    return filters
end

function get_active_tracks()
    local tracks = mp.get_property_native("track-list")
    local accepted = {
        video = true,
        audio = not mp.get_property_bool("mute"),
        sub = mp.get_property_bool("sub-visibility")
    }
    local active_tracks = {}
    for _, track in ipairs(tracks) do
        if track["selected"] and accepted[track["type"]] then
            active_tracks[#active_tracks + 1] = string.format("0:%d", track["ff-index"])
        end
    end
    return active_tracks
end

function seconds_to_time_string(seconds, full)
    local ret = string.format("%02d:%02d.%03d"
        , math.floor(seconds / 60) % 60
        , math.floor(seconds) % 60
        , seconds * 1000 % 1000
    )
    if full or seconds > 3600 then
        ret = string.format("%d:%s", math.floor(seconds / 3600), ret)
    end
    return ret
end

function start_encoding(input_path, from, to, settings)
    local args = {
        "ffmpeg",
        "-loglevel", "panic", "-hide_banner", --stfu ffmpeg
        "-i", input_path,
        "-ss", seconds_to_time_string(from, false),
        "-to", seconds_to_time_string(to, false)
    }

    -- map currently playing channels
    if settings.only_active_tracks then
        for _, t in ipairs(get_active_tracks()) do
            args = append_table(args, { "-map", t })
        end
    else
        args = append_table(args, { "-map", "0" })
    end

    -- apply some of the video filters currently in the chain
    local filters = {}
    if settings.preserve_filters then
        filters = append_table(filters, get_video_filters())
    end
    if settings.append_filter ~= "" then
        filters[#filters + 1] = settings.append_filter
    end
    if #filters > 0 then
        args = append_table(args, {
            "-filter:v", table.concat(filters, ",")
        })
    end

    -- split the user-passed settings on whitespace
    for token in string.gmatch(settings.codec, "[^%s]+") do
        args[#args + 1] = token
    end

    -- path of the output
    local output_directory = settings.output_directory
    if output_directory == "" then
        output_directory, _ = utils.split_path(input_path)
    else
        output_directory = string.gsub(output_directory, "^~", os.getenv("HOME"))
    end
    local output_name = string.format("%s.%s", settings.output_format, settings.container)
    local input_name = mp.get_property("filename/no-ext") or "encode"
    output_name = get_output_string(output_directory, output_name, input_name, from, to, settings.profile)
    if not output_name then
        mp.osd_message("Invalid path " .. output_directory)
        return
    end
    args[#args + 1] = utils.join_path(output_directory, output_name)

    if settings.print then
        local o = ""
        -- fuck this is ugly
        for i = 1, #args do
            local fmt = ""
            if i == 1 then
                fmt = "%s%s"
            elseif i >= 2 and i <= 4 then
                fmt = "%s"
            elseif args[i-1] == "-i" or i == #args or args[i-1] == "-filter:v" then
                fmt = "%s \"%s\""
            else
                fmt = "%s %s"
            end
            o = string.format(fmt, o, args[i])
        end
        print(o)
    end
    if settings.detached then
        utils.subprocess_detached({ args = args })
    else
        local res = utils.subprocess({ args = args, max_size = 0, cancellable = false })
        if res.status == 0 then
            mp.osd_message("Finished encoding succesfully")
        else
            mp.osd_message("Failed to encode, check the log")
        end
    end
end

function clear_timestamp()
    timer:kill()
    start_timestamp = nil
    mp.remove_key_binding("encode-ESC")
    mp.osd_message("", 0)
end

function set_timestamp(profile)
    local path = mp.get_property("path")
    if not path then
        mp.osd_message("No file currently playing")
        return
    end
    if not file_exists(path) then
        mp.osd_message("Cannot encode streams")
        return
    end

    if start_timestamp == nil then
        start_timestamp = mp.get_property_number("time-pos")
        start_timestamp = start_timestamp > 2 and start_timestamp -2 or start_timestamp
        msg = function()
            mp.osd_message("encode: waiting for end timestamp", timer_duration)
        end
        msg()
        timer = mp.add_periodic_timer(timer_duration, msg)
        mp.add_forced_key_binding("ESC", "encode-ESC", clear_timestamp)
    else
        local from = start_timestamp
        local to = mp.get_property_number("time-pos")
        if to <= from then
            mp.osd_message("Second timestamp cannot be before the first")
            return
        end
        clear_timestamp()
        mp.osd_message(string.format("Encoding from %s to %s"
            , seconds_to_time_string(from, false)
            , seconds_to_time_string(to, false)
        ), timer_duration)
        -- include the current frame into the extract
        local fps = mp.get_property_number("container-fps")
        to = to + 1 / fps / 2
        local settings = {
            detached = true,
            container = "webm",
            only_active_tracks = false,
            preserve_filters = true,
            append_filter = "",
            codec = "-an -sn -c:v libvpx -crf 10 -b:v 1000k",
            output_format = "$f_$n",
            output_directory = "",
            print = true,
        }
        if profile then
            options.read_options(settings, profile)
            settings.profile = profile
        else
            settings.profile = "default"
        end
        start_encoding(path, from, to, settings)
    end
end

mp.add_key_binding(nil, "set-timestamp", set_timestamp)
mp.add_key_binding(nil, "clear-timestamp", clear_timestamp)
