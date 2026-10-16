{...}: {
  xdg.configFile."hypr/hyprland.lua".text = ''
    local ok, theme = pcall(dofile, os.getenv("HOME") .. "/.config/hypr/noctalia.lua")

    local function col(key, fallback)
        if ok and theme and theme.colors and theme.colors[key] then
            return theme.colors[key]
        end
        return fallback
    end

    local primary      = col("primary",      "rgb(f05c6c)")
    local secondary    = col("secondary",    "rgb(ee8644)")
    local error        = col("error",        "rgb(ce1328)")
    local on_error     = col("on_error",     "rgb(f5e2e4)")
    local surface      = col("surface",      "rgb(291416)")
    local on_surface   = col("on_surface",   "rgb(f3f2f2)")
    local on_secondary = col("on_secondary", "rgb(25181a)")

    hl.monitor({
        output   = "",
        mode     = "1920x1080@60.02",
        position = "auto",
        scale    = "1.0",
    })

    local terminal = "kitty"

    hl.config({
        general = {
            gaps_in  = 15,
            gaps_out = 25,

            border_size = 2,

            col = {
                active_border   = { colors = { primary, secondary }, angle = 135 },
                inactive_border = surface,
            },

            resize_on_border = false,
            allow_tearing    = false,

            layout = "dwindle",
        },

        decoration = {
            rounding       = 14,
            rounding_power = 2,

            active_opacity   = 0.9,
            inactive_opacity = 0.6,

            shadow = {
                enabled      = true,
                range        = 24,
                render_power = 4,
                color        = 0xdd000000, },

            blur = {
                enabled   = true,
                size      = 4,
                passes    = 3,
                vibrancy  = 0.1696,
            },
        },

        animations = {
            enabled = true,
        },

        input = {
            kb_layout  = "us",
            kb_variant = "",
            kb_model   = "",
            kb_options = "caps:escape",
            kb_rules   = "",

            follow_mouse = 1,
            sensitivity  = 0,

            touchpad = {
                natural_scroll = false,
            },
        },

        dwindle = {
            preserve_split = true,
        },

        group = {
            col = {
                border_active   = secondary,
                border_inactive = surface,
                border_locked_active   = error,
                border_locked_inactive = surface,
            },
            groupbar = {
                gradients = true,
                col = {
                    active          = primary,
                    inactive        = surface,
                    locked_active   = error,
                    locked_inactive = surface,
                },
                text_color            = on_secondary,
                text_color_inactive   = on_surface,
                text_color_locked_active   = on_error,
                text_color_locked_inactive = on_surface,
            },
        },

        misc = {
            force_default_wallpaper = 0,
            disable_hyprland_logo   = true,
        },
    })

    hl.config({
        cursor = {
            no_hardware_cursors = false,
            enable_hyprcursor   = true,
        },
    })

    hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
    hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
    hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
    hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
    hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })
    hl.curve("easy",           { type = "spring", mass = 1, stiffness = 238.1191, dampening = 24.21279333 })

    hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
    hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
    hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, spring = "easy" })
    hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  spring = "easy",         style = "popin 87%" })
    hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
    hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
    hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
    hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
    hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
    hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
    hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
    hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
    hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
    hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 3,    bezier = "easeOutQuint", style = "slide" })
    hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
    hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear", style = "fade" })
    hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
    hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })

    hl.layer_rule({
        name = "noctalia",
        match = {
            namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$",
        },
        no_anim     = true,
        ignore_alpha = 0.5,
        blur        = true,
        blur_popups = true,
    })

    hl.window_rule({
        match = { class = "dev.noctalia.Noctalia" },
        float = true,
        size  = {1080, 920},
    })

    local mainMod = "SUPER"

    hl.bind(mainMod .. " + SPACE",     hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"),  { description = "App launcher" })
    hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard"), { description = "Clipboard history" })
    hl.bind(mainMod .. " + X",         hl.dsp.exec_cmd("noctalia msg panel-toggle session"),   { description = "Session / power menu" })
    hl.bind(mainMod .. " + U",         hl.dsp.exec_cmd("noctalia msg panel-toggle noctalia/wallhaven:browser"),   { description = "Random wallpaper" })
    hl.bind(mainMod .. " + E",         hl.dsp.exec_cmd("noctalia msg panel-toggle ashur-d/wallpaper-widget:hub"), { description = "Select wallpaper" })

    hl.bind(mainMod .. " + SHIFT + W",   hl.dsp.exec_cmd("librewolf"),                         { description = "Open browser" })
    hl.bind(mainMod .. " + W",           hl.dsp.exec_cmd("qutebrowser"),                       { description = "Open browser" })

    hl.bind("Print",                     hl.dsp.exec_cmd("noctalia msg screenshot-region"),    { description = "Region screenshot" })
    hl.bind("SHIFT + Print",             hl.dsp.exec_cmd("noctalia msg screenshot-fullscreen"),{ description = "Fullscreen screenshot" })

    hl.bind(mainMod .. " + RETURN",      hl.dsp.exec_cmd(terminal),                            { description = "Open terminal" })
    hl.bind(mainMod .. " + N",           hl.dsp.exec_cmd(terminal .. " -e yazi"),              { description = "Yazi file manager" })

    hl.bind(mainMod .. " + Q",           hl.dsp.window.close(),                                { description = "Close window" })
    hl.bind(mainMod .. " + F",           hl.dsp.window.fullscreen({ action = "toggle" }),      { description = "Toggle fullscreen" })
    hl.bind(mainMod .. " + V",           hl.dsp.window.float({ action = "toggle" }),           { description = "Toggle floating" })
    hl.bind(mainMod .. " + T",           hl.dsp.window.pseudo(),                               { description = "Toggle pseudo-tiling" })
    hl.bind(mainMod .. " + O",           hl.dsp.layout("togglesplit"),                         { description = "Toggle split" })
    hl.bind(mainMod .. " + SHIFT + X",   hl.dsp.exit(),                                        { description = "Exit Hyprland" })

    hl.bind(mainMod .. " + H",           hl.dsp.focus({ direction = "left" }),                 { description = "Focus left" })
    hl.bind(mainMod .. " + L",           hl.dsp.focus({ direction = "right" }),                { description = "Focus right" })
    hl.bind(mainMod .. " + K",           hl.dsp.focus({ direction = "up" }),                   { description = "Focus up" })
    hl.bind(mainMod .. " + J",           hl.dsp.focus({ direction = "down" }),                 { description = "Focus down" })

    for i = 1, 10 do
        local key = i % 10
        hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }),  { description = "Workspace " .. i })
        hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }), { description = "Move window to workspace " .. i })
    end

    hl.bind(mainMod .. " + S",      hl.dsp.workspace.toggle_special("magic"),  { description = "Toggle special workspace" })
    hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }), { description = "Move window to special workspace" })

    hl.bind(mainMod .. " + mouse_down",   hl.dsp.focus({ workspace = "e+1" }))
    hl.bind(mainMod .. " + mouse_up",     hl.dsp.focus({ workspace = "e-1" }))

    hl.bind(mainMod .. " + mouse:272",    hl.dsp.window.drag(),   { mouse = true })
    hl.bind(mainMod .. " + mouse:273",    hl.dsp.window.resize(), { mouse = true })

    hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("noctalia msg volume-up"),    { locked = true, repeating = true })
    hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("noctalia msg volume-down"),  { locked = true, repeating = true })
    hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("noctalia msg volume-mute"),  { locked = true, repeating = true })
    hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("noctalia msg brightness-up"),   { locked = true, repeating = true })
    hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("noctalia msg brightness-down"), { locked = true, repeating = true })

    hl.on("hyprland.start", function()
        hl.exec_cmd("systemctl --user start graphical-session.target")
        hl.exec_cmd("systemctl --user start xdg-desktop-portal.service")
    end)
  '';
}
