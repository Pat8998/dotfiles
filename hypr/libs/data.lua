-- Made by Emma ✨ with love 
local data = {}
-- I should seriously consider : connecting to the daemon's sockets
-- Rather than calling bash, that would probavly save on performance
function data.get_brightness()
-- run brightnessctl -m and capture output
  local fh = io.popen("brightnessctl -m 2>/dev/null")
  local raw = fh and fh:read("*a") or ""
  if fh then fh:close() end

  -- try to extract the numeric percentage (e.g. "42%")
  local out = raw:match("(%d+)%%") 
  return tonumber(out) or -1
end

function data.get_volume()
    local fh = io.popen("wpctl get-volume @DEFAULT_AUDIO_SINK@")
    local raw = fh and fh:read("*a") or ""
    if fh then fh:close() end

    -- try to extract the numeric percentage (e.g. "42%")
    local out = raw:match("%d.%d+")
    local muted = raw:match("MUTED") == "MUTED"
    local vol = math.floor(100 * tonumber(out)) or 0
    return vol, muted
end

function data.get_bat(bat)
    local file = io.popen("cat /sys/class/power_supply/" .. bat .. "/capacity 2>/dev/null") 
    local capacity = tonumber(file and file:read("*a") or "0")
    if file then file:close() end
    file = io.popen("upower -b 2>/dev/null") --can I precise the battery?
    local raw = file and file:read("*a") or ""
    local status = raw:match("state: *%a+"):match(" %a+"):match("%a+")
    local icon = raw:match("'%g+'"):match("[^']+")
    if file then file:close() end
    return capacity, status, icon
end

return data