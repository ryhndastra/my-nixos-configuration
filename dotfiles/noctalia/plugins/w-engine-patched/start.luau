-- W-Engine autostart service
-- Kills old wallpaper, cleans up, then restores last session's wallpaper

local function trim(s)
    return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

-- Kill any leftover wallpaper processes first, then launch saved wallpaper
noctalia.runAsync("pkill -f linux-wallpaperengine", function()
    -- Clean up old PID files
    local entries = noctalia.listDir("/tmp")
    if entries then
        for _, name in entries do
            if name:match("^w%-engine") then
                noctalia.removeFile("/tmp/" .. name)
            end
        end
    end

    -- Read saved wallpaper from last session
    local savePath = noctalia.pluginDataDir() .. "/last_wallpaper.json"
    local raw = noctalia.readFile(savePath)
    if raw then
        local data = noctalia.json.decode(raw)
        if data and data.id and data.screen then
            local pidFile = "/tmp/w-engine-" .. data.screen .. ".pid"
            local cmd = "XDG_SESSION_TYPE=wayland setsid linux-wallpaperengine --silent --screen-root " .. data.screen .. " " .. data.id
                .. " > /dev/null 2>&1 & echo $! > " .. pidFile
            noctalia.runAsync(cmd, function() end, 10000)
        end
    end
end, 5000)