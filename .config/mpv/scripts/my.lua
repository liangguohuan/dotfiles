------------------------------------------------------------
-- function helper
------------------------------------------------------------
function shell_exec(cmd)
    local fd = io.popen(cmd)
    local output = fd:read("*all")
    return output
end

------------------------------------------------------------
-- seek to here
------------------------------------------------------------
function seek_here()
    local width, height = mp.get_osd_size()
    local x, y = mp.get_mouse_pos()
    mp.commandv("seek", x / width * 100, "absolute-percent")
end

------------------------------------------------------------
-- toggle show osc
------------------------------------------------------------
local osc_show = true

function toggle_osc()
    if osc_show then osc_show = false else osc_show = true end
    mp.commandv("script-message", "osc-visibility", (osc_show and "always" or "auto"), "no-osd")
    mp.commandv("set", "options/osd-level", 0)
end

------------------------------------------------------------
-- toggle show fileinfo
------------------------------------------------------------
local timer = nil
local timer_duration = 1
local file_info_show = true
local output = ""
local fontsize = 32
local fontsize_custom = 18

function toggle_fileinfo()
    if output == "" then
        local filename = mp.get_property("filename")
        filename = filename:gsub("'", "'\\''")
        local cmd = string.format("ffprobe -pretty '%s' 2>&1 | tail -n 20 | egrep -v 'libav|libp|libs'", filename)
        fontsize = mp.get_property("osd-font-size")
        output = shell_exec(cmd)
    end
    if file_info_show == true then
        mp.set_property("osd-font-size", fontsize_custom)
        mp.osd_message(output)
        timer = mp.add_periodic_timer(timer_duration, function () mp.osd_message(output) end)
        file_info_show = false
    else
        mp.osd_message("")
        mp.set_property("osd-font-size", fontsize) -- reveal fontsize
        timer:kill()
        file_info_show = true
    end
end

mp.add_key_binding(nil, "right-click-here", seek_here)
mp.add_key_binding(nil, "toggle-osc", toggle_osc)
mp.add_key_binding(nil, "toggle-fileinfo", toggle_fileinfo)
