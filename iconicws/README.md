# iconic

An extremely customizable replacement for the default weapon selection menu for Garry's Mod

Configuration

local themes = {

  -- These are all theme parameters that you can override
  -- You can add your own themes and override only the parameters you want
  -- Or you can change the default theme directly
  default = {

    -- Main colors used in the menu
    slotColor = Color(0, 0, 0, 80),
    activeSlotColor = Color(100, 150, 0, 80),
    targetSlotColor = Color(255, 220, 0, 80),
    noAmmoSlotColor = Color(150, 0, 0, 80),

    -- These two are only used in icon editor
    validColor = Color(0, 255, 0, 255),
    invalidColor = Color(255, 0, 0, 255),

    -- Set to false to hide slot numbers (1, 2, 3, ... on the top of
    -- the selector)
    drawSlotNumbers = true,

    -- Set to false to prevent weapon info tooltip (Author, controls,
    -- instructions, etc...) from drawing
    drawWeaponInfo = true,

    -- Compact (not selected) slot appearance
    compactDrawName = true,
    compactDrawIcon = false,
    compactDrawAmmo = true,

    -- Weapons that are in the same slot (column) as the target weapon
    targetColumnDrawName = true,
    targetColumnDrawIcon = false,
    targetColumnDrawAmmo = true,

    -- Target (selected) slot appearance
    targetDrawName = true,
    targetDrawIcon = true,
    targetDrawAmmo = true,

    -- Whether or not allow selecting weapons without ammo
    -- If set to false, empty weapons won't be displayed in
    -- the selector
    allowEmpty = false,

    -- When this key is held down when the selector is open, all icons
    -- and info are displayed for all weapons. Set to false to disable
    verboseKey = KEY_LALT,

    -- What fonts to use. You can create your own fonts and set their
    -- names here or set any of known font names
    headerFontName = 'HudHintTextLarge',
    ammo1FontName = 'HudHintTextLarge',
    ammo2FontName = 'HudHintTextLarge',
    slotNumberFontName = 'HudHintTextLarge',

    -- Font colors
    headerTextColor = Color(255, 220, 0, 255),
    ammo1TextColor = Color(255, 220, 0, 255),
    ammo2TextColor = Color(255, 220, 0, 255),
    slotNumberTextColor = Color(255, 220, 0, 255),

    -- Default icon sizes are used for displaying
    -- icons of weapons that don't have custom icons
    defaultIconWidth = 256,
    defaultIconHeight = 128,

    -- Set to true if you want the menu to dock to screen top
    dockToTop = false,

    -- The spacing between UI elements
    padding = 8,

    -- Corners roundness, set to 0 if you want them sharp
    cornerRadius = 8,

    -- How long to display the menu before it starts fading, seconds
    showTime = 2,

    -- How long the menu is fading, seconds
    fadeTime = 1,

    -- Animation speed in seconds, the higher the quicker
    animSpeed = 2,

    -- Selector sounds volume
    soundVolume = 0.2,

    -- What you hear when you tap slot numbers
    tapSound = 'common/wpn_moveselect.wav',

    -- What you hear when you confirm weapon selection with LMB
    confirmSound = 'common/wpn_hudoff.wav',

    -- What you hear when you scroll through slots
    scrollSound = 'common/wpn_select.wav',

    -- What you hear when you deny weapon selection (press RMB)
    denySound = 'common/wpn_denyselect.wav',

    -- Icon used for spinning preloader when the icon is loading
    loadingIconMat = 'gui/html/refresh'
  }
}

-- This table allows you to override slots, slot
-- positions and displayed names for any weapons.
-- Supported parameters are: name, slot, slotPos
iconic.wepInfoOverride = {}

-- The list of all phrases used in the addon.
-- Languages can be changed or added
local lang = {}