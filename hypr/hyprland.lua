-- This is an example Hyprland Lua config file.
-- Refer to the wiki for more information.
-- https://wiki.hypr.land/Configuring/Start/

-- Please note not all available settings / options are set here.
-- For a full list, see the wiki

-- You can (and should!!) split this configuration into multiple files
-- Create your files separately and then require them like this:
local Utility = require("libs.utility")
local Data    = require("libs.data")

------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})
-- hl.monitor({
--     output   = "HDMI-A-1",
--     mode     = "1920x1080",
--     position = "auto",
--     scale    = "auto",
-- })


---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal    = "kitty "
local fileManager = "dolphin "
local menu        = "wofi -I -p \"$(date +%H:%M) <3\" --show "
local toolbox     = " printf \"\npingd\nsystemctl suspend\nnmtui\nimpala\nbtop\nbluetui\nlove antiburn\npoweroff\nwiremix\nnano .config/hypr/hyprland.lua\nfirefox --new-window Desktop/numworks.html --kiosk \nstart-hyprland\n\" | wofi --dmenu --prompt \"System\" | xargs -r kitty -e -c exec "


-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function () 
  hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
  hl.exec_cmd("rm -r /home/emma/.copilot/")
  hl.exec_cmd("cp /home/emma/Pictures/Wallpapers/wall* /usr/share/hypr/")
  hl.exec_cmd("cp .cache/wofi-drun.bak .cache/wofi-drun")
  hl.exec_cmd("eww daemon -c /usr/share/crcl-select")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")


-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")


-----------------------
---- LOOK AND FEEL ----
-----------------------
require("bloat")


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "fr, us",
        kb_variant = "azerty,",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = false,
            disable_while_typing = false
        },
    },
})



------------------
---- Gestures ----
------------------


hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

hl.gesture({ fingers = 3, direction = "vertical", action = "special", workspace_name = "magic" })
-- hl.gesture({ fingers = 4, direction = "left", action = function() os.execute("brightnessctl set 10%-" ) Utility.notify_brightness() end})
-- hl.gesture({ fingers = 4, direction = "right", action = function() os.execute("brightnessctl set 10%+" ) Utility.notify_brightness() end})
hl.gesture(
    {
    fingers = 4,
    direction = "horizontal",
    action = 
        {
            start = function (e)     Utility.brightness_set_dt(tonumber(e.delta.x))      end,
            update = function (e)    Utility.brightness_set_dt(tonumber(e.delta.x))      end,
            finish = function ()     Utility.notify_brightness() end
        }
    })
hl.gesture({ fingers = 4, direction = "up", action = "fullscreen", scale = 1.5})




-- per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more




---------------------
---- KEYBINDINGS ----
---------------------
 --callabacks
hl.on("config.reloaded", function () hl.exec_cmd("notify-send -r 67 reloaded")  hl.exec_cmd("espeak \"realoaded " .. tostring(Data.get_bat("BAT1")) .."%\"")  end)
-- hl.on("window.active", function (workspace)
    -- hl.exec_cmd("notify-send -r 67 -t 200 " .. workspace.id)
    -- hl.exec_cmd("espeak " .. hl.get_active_window().class)
-- end)
local mainMod = "SUPER" -- Sets "Windows" key as main modifier
local prntscrn = "PRINT"

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
local closeWindowBind = hl.bind(mainMod .. " + C", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(terminal .. "--start-as=fullscreen btop "))
hl.bind(           "   twosuperior", hl.dsp.exec_cmd(toolbox))
hl.bind(mainMod .. " + K", hl.dsp.exec_cmd("notify-send -r 67 \"$(nm-online -t 1)\""))
--crcl-select
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("crcl-select open toolbox.json"))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("crcl-select close toolbox.json"), {release = true})

hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu .. "run"))
hl.bind(mainMod .. " + P", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))    -- dwindle only
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind("SHIFT       + F1", hl.dsp.exec_cmd("systemctl suspend"))
hl.bind(mainMod .. " + F1", function () Utility.notify_bat("BAT1") end)
hl.bind("ALT + SHIFT_L", function ()
    hl.exec_cmd("hyprctl switchxkblayout all next") 
    -- hl.device({ name = "current", kb_layout='next' })
    hl.exec_cmd("notify-send \"$(hyprctl devices | grep keymap | head -1)\"  -i /usr/share/icons/Pop/scalable/apps/accessories-character-map-symbolic.svg -r 998")
end)
hl.bind("SUPER       + Super_L", function () 
    local window = hl.get_active_window() 
    if not window or window.class ~= "scrcpy" then
        hl.exec_cmd("pkill wofi || " .. menu .. "drun")
    end
end
)

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))


-- stolen from https://github.com/mylinuxforwork/dotfiles/blob/main/dotfiles/.config/hypr/conf/keybindings/default.lua
local fr_keys = {
    "ampersand", "eacute", "quotedbl", "apostrophe", "parenleft",
    "minus", "egrave", "underscore", "ccedilla", "agrave"
}
for i = 1, 10 do
    local key = fr_keys[i]
    -- Switch workspaces with mainMod + [0-9]
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}), { description = "Focus workspace " .. i })
    -- Move active window to a workspace with mainMod + SHIFT + [0-9]
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }), { description = "Move window to workspace " .. i })
end

--Cycling workspaces
hl.bind("ALT + TAB", 
function ()
    if #hl.get_monitors() == 1 then
        hl.dispatch(hl.dsp.focus({ workspace = "e+1" }))
    else
        hl.dispatch(hl.dsp.focus({ monitor = "+1" }))
    end
end
)
--Cycling widnows
hl.bind(mainMod .. " + TAB", hl.dsp.window.cycle_next())

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", function () os.execute("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+") Utility.notify_sound() end, { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", function () os.execute("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")      Utility.notify_sound() end, { locked = true, repeating = true })
hl.bind("XF86AudioMute",        function () os.execute("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")     Utility.notify_sound() end, { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     function () hl.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle")  Utility.notify_sound() end, { locked = true, repeating = true })
-- hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
-- hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })
hl.bind(mainMod .. "+ f2",  function () os.execute("brightnessctl -e4 -n2 set 5%-") Utility.notify_brightness() end,           { locked = true, repeating = true })
hl.bind(mainMod .. "+ f3",  function () os.execute("brightnessctl -e4 -n2 set 5%+") Utility.notify_brightness() end,           { locked = true, repeating = true })



-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


---Scrrenshots---
hl.bind(prntscrn,               hl.dsp.exec_cmd("hyprshot -m output -m active --clipboard-only"))
hl.bind("CTRL + "         .. prntscrn, hl.dsp.exec_cmd("hyprshot -m window -m active "))
hl.bind("SHIFT + "        .. prntscrn, hl.dsp.exec_cmd("hyprshot -m region --clipboard-only "))
hl.bind("CTRL + SHIFT + " .. prntscrn, hl.dsp.exec_cmd("hyprshot -m region "))








--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})
