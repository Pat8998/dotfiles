local Utility = {}
local Data = require("libs.data")

-- Requires Lua 5.3+ for utf8.char
function Utility.bar(percent)
  local tot = 20
  -- compute filled/empty segments out of 20
  local filled = math.max(math.min(math.floor(percent * tot / 100), tot), 0)

  -- glyph codepoints used in the original shell snippet
  local g_left_empty  = utf8.char(0xEE00)
  local g_left_filled = utf8.char(0xEE03)
  local g_fill_mid    = utf8.char(0xEE04)
  local g_empty_mid   = utf8.char(0xEE01)
  local g_right_filled= utf8.char(0xEE05)
  local g_right_empty = utf8.char(0xEE02)

  -- ends: left cap depends on whether there's any fill; right cap depends on whether it's full
  local left = (filled == 0) and g_left_empty or g_left_filled
  local right = (filled == tot) and g_right_filled or g_right_empty

  -- middle counts: filled-1 and empty-1 (to mimic the original loops)
  local mid = (filled - 1) -- pour la gauche
                    - (filled == tot and 1 or 0) 
  local mid_empty = (tot - 2) - mid
                    - (filled == 0  and 1 or 0)
  return left .. string.rep(g_fill_mid, mid) .. string.rep(g_empty_mid, mid_empty) .. right
end



function Utility.notify_brightness()
  local vol = Data.get_brightness()
  local bar = Utility.bar (vol) 

  -- send notification (replace icon/path or options as desired)
  local notif = string.format('notify-send -r 997 -t 700 -i %s "%s %d%%"',
    "/usr/share/icons/Adwaita/symbolic/status/display-brightness-symbolic.svg",
    bar, vol)
    -- call the function
  hl.exec_cmd(notif)
end

function Utility.notify_sound()

    local vol, muted = Data.get_volume()
    local icon =
        (muted or vol == 0) and "audio-volume-muted-symbolic.svg"
        or (vol <= 30)      and "audio-volume-low-symbolic.svg"
        or (vol <= 70)      and "audio-volume-medium-symbolic.svg"
        or (vol <= 100)     and "audio-volume-high-symbolic.svg"
        or "audio-volume-overamplified-symbolic.svg"


    -- hl.notification.create({text = tostring(vol), timeout = 2000})
    -- send notification (replace icon/path or options as desired)
    local notif = string.format('notify-send -r 997 -t 700 -i %s "%s %d%%"',
    "/usr/share/icons/Adwaita/symbolic/status/" .. icon,
    Utility.bar(vol), vol)
    hl.exec_cmd(notif)
    -- call the function
end


function Utility.notify_bat(bat)
    local capacity, status = Data.get_bat(bat)
    local icon = "battery-level-" .. tostring(math.floor((capacity +5) /10 ) * 10) .. (status == "Charging" and "-charging" or "") .. "-symbolic.svg"
    local notif = string.format('notify-send -r 997 -t 700 -i %s " %s%%"',
    "/usr/share/icons/Adwaita/symbolic/status/" .. icon,
    capacity)
  hl.exec_cmd(notif)
end


function Utility.brightness_set_dt(dt)
      local sgn =  (math.abs(dt) == dt and "+" or "-" )
      os.execute("brightnessctl set " .. tostring(math.ceil(math.abs(dt))) .. "%" .. sgn)
end



return Utility