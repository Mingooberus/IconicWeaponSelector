local themes = {

  -- These are all theme parameters that you can override
  -- You can add your own themes and override only the parameters you want
  -- Or you can change the default theme directly
  default = {
    -- Main colors used in the menu
    slotColor = Color(0, 0, 0, 80),
    activeSlotColor = Color(100, 150, 0, 80),
    targetSlotColor = Color(255, 220, 0, 80),
    noAmmoSlotColor = Color(150, 0, 0, 80),

    -- These two are only used in icon editor
    validColor = Color(0, 255, 0, 255),
    invalidColor = Color(255, 0, 0, 255),

    -- Set to false to hide slot numbers (1, 2, 3, ... on the top of
    -- the selector)
    drawSlotNumbers = true,

    -- Set to false to prevent weapon info tooltip (Author, controls,
    -- instructions, etc...) from drawing
    drawWeaponInfo = true,

    -- Compact (not selected) slot appearance
    compactDrawName = true,
    compactDrawIcon = false,
    compactDrawAmmo = true,

    -- Weapons that are in the same slot (column) as the target weapon
    targetColumnDrawName = true,
    targetColumnDrawIcon = false,
    targetColumnDrawAmmo = true,

    -- Target (selected) slot appearance
    targetDrawName = true,
    targetDrawIcon = true,
    targetDrawAmmo = true,

    -- Whether or not allow selecting weapons without ammo
    -- If set to false, empty weapons won't be displayed in
    -- the selector
    allowEmpty = false,

    -- When this key is held down when the selector is open, all icons
    -- and info are displayed for all weapons. Set to false to disable
    verboseKey = KEY_LALT,

    -- What fonts to use. You can create your own fonts and set their
    -- names here or set any of known font names
    headerFontName = 'Exo-Regular',
    ammo1FontName = 'BAHNSCHRIFT',
    ammo2FontName = 'BAHNSCHRIFT',
    slotNumberFontName = 'Exo-Regular',

    -- Font colors
    headerTextColor = Color(255, 220, 0, 255),
    ammo1TextColor = Color(255, 220, 0, 255),
    ammo2TextColor = Color(255, 220, 0, 255),
    slotNumberTextColor = Color(255, 220, 0, 255),

    -- Default icon sizes are used for displaying
    -- icons of weapons that don't have custom icons
    defaultIconWidth = 256,
    defaultIconHeight = 128,

    -- Set to true if you want the menu to dock to screen top
    dockToTop = false,

    -- Set to false if you don't want the menu to center the current
    -- item horizontally
    centerHorizontal = true,

    -- Set to true if you want icons to have the width of
    -- the widest icon in the column
    alwaysWidest = false,

    -- The spacing between UI elements
    padding = 8,

    -- Corners roundness, set to 0 if you want them sharp
    cornerRadius = 8,

    -- How long to display the menu before it starts fading, seconds
    showTime = 2,

    -- How long the menu is fading, seconds
    fadeTime = 1,

    -- Animation speed in seconds, the higher the quicker
    animSpeed = 2,

    -- Selector sounds volume
    soundVolume = 0.2,

    -- What you hear when you tap slot numbers
    tapSound = 'common/wpn_moveselect.wav',

    -- What you hear when you confirm weapon selection with LMB
    confirmSound = 'common/wpn_hudoff.wav',

    -- What you hear when you scroll through slots
    scrollSound = 'common/wpn_select.wav',

    -- What you hear when you deny weapon selection (press RMB)
    denySound = 'common/wpn_denyselect.wav',

    -- Icon used for spinning preloader when the icon is loading
    loadingIconMat = 'gui/html/refresh'
  },

  -- Another example theme, notice that not all of parameters need to be set
  blue = {
    slotColor = Color(0, 0, 100, 80),
    activeSlotColor = Color(0, 100, 100, 80),
    targetSlotColor = Color(0, 0, 255, 80),
    noAmmoSlotColor = Color(180, 0, 0, 80),
    headerTextColor = Color(255, 255, 255, 255),
    slotNumberTextColor = Color(255, 255, 255, 255),
    headerFontName = 'TargetID',
    ammo1FontName = 'TargetIDSmall',
    ammo2FontName = 'TargetIDSmall',
    slotNumberFontName = 'Trebuchet24',
    compactDrawAmmo = false
  },

  -- Another example theme
  red = {
    slotColor = Color(50, 0, 0, 200),
    activeSlotColor = Color(100, 0, 0, 200),
    targetSlotColor = Color(100, 80, 0, 200),
    noAmmoSlotColor = Color(20, 0, 0, 200),
    headerTextColor = Color(255, 0, 0, 255),
    slotNumberTextColor = Color(255, 0, 0, 255),
    ammo1TextColor = Color(255, 100, 100, 255),
    ammo2TextColor = Color(255, 100, 100, 255),
    headerFontName = 'TargetID',
    ammo1FontName = 'TargetIDSmall',
    ammo2FontName = 'TargetIDSmall',
    slotNumberFontName = 'Trebuchet24',
    compactDrawIcon = false,
    compactDrawName = false,
    compactDrawAmmo = false,
    targetColumnDrawIcon = false,
    targetColumnDrawName = true,
    targetColumnDrawAmmo = false,
    padding = 16,
    cornerRadius = 16,
  },

  -- Another example theme
  black = {
    slotColor = Color(0, 0, 0, 230),
    activeSlotColor = Color(50, 50, 50, 230),
    targetSlotColor = Color(150, 150, 150, 230),
    noAmmoSlotColor = Color(150, 50, 50, 230),
    headerTextColor = Color(255, 255, 255, 255),
    slotNumberTextColor = Color(255, 255, 255, 255),
    ammo1TextColor = Color(255, 255, 255, 255),
    ammo2TextColor = Color(255, 255, 255, 255),
    headerFontName = 'Trebuchet24',
    ammo1FontName = 'Trebuchet24',
    ammo2FontName = 'Trebuchet24',
    slotNumberFontName = 'Trebuchet24',
    compactDrawIcon = false,
    compactDrawName = false,
    compactDrawAmmo = false,
    targetColumnDrawIcon = false,
    targetColumnDrawName = true,
    targetColumnDrawAmmo = false,
    cornerRadius = 4,
    padding = 16
  }
}

-- That's where you actually set the theme to be used
-- If you want to use blue theme from above, for example
-- You should change the next line to
-- iconic.theme = themes.blue
iconic.theme = themes.default

-- This table allows you to override slots, slot
-- positions and displayed names for any weapons.
-- Supported parameters are: name, slot, slotPos
iconic.wepInfoOverride = {
  weapon_test_crowbar = {
    name = 'Test Crowbar',
    slot = 7,
    slotPos = 100
  },
  weapon_another_example = {
    name = 'Another Weapon Name',
  },
}

-- This function decides who can edit weapon icons.
-- If you want to define some custom permissions, do it here
-- Restricted to admins by default
function iconic.canEditIcons(ply)
  return ply:IsAdmin()
end

-- The list of all phrases used in the addon.
-- Languages can be changed or added
local lang = {
  en = {
    wepIcon = 'Weapon icon',
    selectIconFor = 'Select icon for',
    resetToDefault = 'Reset to default',
    createNewIcon = 'Create new icon',
    holdShift = 'Hold SHIFT to hide the dark tint',
    holdLmb = 'Hold LMB to define icon bounds',
    scrollMouse = 'Scroll mouse wheel to zoom',
    holdAlt = 'Hold ALT to rotate the camera',
    pressRmb = 'Press RMB to cancel',
    pressE = 'Press E to capture',
    failedToCapture = 'Failed to capture the icon',
    iconUploaded = 'Icon successfully uploaded',
    importedFrom = 'Successfully imported icon data from',
    exportedTo = 'Saved icon data to',
    notAllowed = 'You are not allowed to edit weapon icons!'
  },
  fr = {
    wepIcon = 'Icônes d\'armes',
    selectIconFor = 'Sélectionner l\'icône pour',
    resetToDefault = 'Réinitialiser par défaut',
    createNewIcon = 'Créer une nouvelle icône',
    holdShift = 'Maintenez SHIFT pour masquer la teinte foncée',
    holdLmb = 'Maintenez LMB pour définir la capture de l\'icône',
    scrollMouse = 'Faites défiler la molette de la souris pour zoomer',
    holdAlt = 'Maintenez ALT pour faire pivoter la caméra',
    pressRmb = 'Appuyez sur RMB pour annuler',
    pressE = 'Appuyez sur E pour capturer',
    failedToCapture = 'Impossible de capturer l\'icône',
    iconUploaded = 'Icône téléchargée avec succès',
    importedFrom = 'Donnée de l\'icône importée avec succès depuis',
    exportedTo = 'Données de l\'icône sauvegardées',
    notAllowed = 'Vous n\'êtes pas autorisé à modifier les icônes d\'armes!'
  },
  ru = {
    wepIcon = 'Иконка оружия',
    selectIconFor = 'Выбрать иконку для',
    resetToDefault = 'Вернуть по умолчанию',
    createNewIcon = 'Создать новую иконку',
    holdShift = 'Удерживайте SHIFT чтобы скрыть тёмный фон',
    holdLmb = 'Удерживайте ЛКМ чтобы задать границы иконки',
    scrollMouse = 'Прокручивайте колесо мыши для приближения',
    holdAlt = 'Удерживайте ALT чтобы вращать камеру',
    pressRmb = 'Нажмите ПКМ для отмены',
    pressE = 'Нажмите E для захвата',
    failedToCapture = 'Не удалось захватить иконку',
    iconUploaded = 'Иконка успешно загружена',
    importedFrom = 'Успешно импортированы данные из',
    exportedTo = 'Данные сохранены в',
    notAllowed = 'Вы не можете редактировать иконки!'
  },
  tr = {
    wepIcon = 'Silah ikonu',
    selectIconFor = 'Sunun icin bir ikon sec',
    resetToDefault = 'Varsayilana Sifirla',
    createNewIcon = 'Yeni bir ikon olustur',
    holdShift = 'Koyu renk tonunu gizlemek icin SHIFT tusuna basili tutun',
    holdLmb = 'Simge sinirlarini tanimlamak icin LMB tusuna basili tutun',
    scrollMouse = 'Fare tekerlegini kullanarak yakinlastirin',
    holdAlt = 'ALT tusuna basili tutarak kamerayi dondurun',
    pressRmb = 'RMB tusu ile iptal edin',
    pressE = 'E ile ele gecirin',
    failedToCapture = 'Ikonu ele gecirirken hata olustu',
    iconUploaded = 'Ikon basariyla yuklendi',
    importedFrom = 'Ikon verisi basariyla sundan getirildi',
    exportedTo = 'Ikon verisi basariyla suna kaydedildi',
    notAllowed = 'Silah ikonlarini duzenlemeye yetkin yok!'
  },
  de = {
    wepIcon = 'Waffen icon',
    selectIconFor = 'Wähle ein icon für',
    resetToDefault = 'Standart wiederherstellen',
    createNewIcon = 'Erstelle neues icon',
    holdShift = 'Halte SHIFT um den dunklen Hintergrund auszublenden',
    holdLmb = 'Halte Linke-Maus-Taste um die icon größe zu definieren',
    scrollMouse = 'Mausrad drehen zum zoomen',
    holdAlt = 'Halte ALT um die kamera zu drehen',
    pressRmb = 'Drücke Rechte-Maus-Taste um abzubrechen',
    pressE = 'Halte E um aufzunehmen',
    failedToCapture = 'Aufnahme fehlgeschlagen',
    iconUploaded = 'Icon erfolgreich hochgeladen',
    importedFrom = 'Icon erfolgreich importiert von',
    exportedTo = 'Speichere icon daten in',
    notAllowed = 'Du hast keine Berechtigung icons zu bearbeiten!'
  },
  dk = {
    wepIcon = 'Våben ikon',
    selectIconFor = 'Vælg ikon for',
    resetToDefault = 'Nulstil til standard',
    createNewIcon = 'Opret nyt ikon',
    holdShift = 'Hold SHIFT for at skulje den mørke farvetone',
    holdLmb = 'Hold LMB for at definere ikongrænser',
    scrollMouse = 'Brug scroll wheel for at zoome ind',
    holdAlt = 'Hold ALT for at rotere kamaraet',
    pressRmb = 'Tryk RMB for at annullere',
    pressE = 'Tryk E for at optage',
    failedToCapture = 'Kunne ikke optage ikonet',
    iconUploaded = 'Ikonet blev uploadet',
    importedFrom = 'Ikondata blev importeret fra',
    exportedTo = 'Ikondata blev gemt til',
    notAllowed = 'Du har ikke tilladelse til at redigere våben ikoner!'
  },
  pl = {
    wepIcon = 'Ikona broni',
    selectIconFor = 'Wybierz ikonę dla',
    resetToDefault = 'Przywróć ustawienia domyślne',
    createNewIcon = 'Stwórz nową ikonę',
    holdShift = 'Przytrzymaj SHIFT, aby ukryć ciemny odcień',
    holdLmb = 'Przytrzymaj LMB, aby zdefiniować granice ikon',
    scrollMouse = 'Przeskroluj aby powiększyć',
    holdAlt = 'Przytrzymaj ALT, aby obrócić kamerę',
    pressRmb = 'Naciśnij przycisk RMB, aby anulować',
    pressE = 'Wciśnij E w celu przechwycenia',
    failedToCapture = 'Nie udało się uchwycić ikony',
    iconUploaded = 'Ikona pomyślnie przesłana',
    importedFrom = 'Udało się wgrać ikone',
    exportedTo = 'Zapisane dane ikon do',
    notAllowed = 'Nie wolno ci edytować ikon broni!'
 },
 es = {
    wepIcon = 'Iconos de armas',
    selectIconFor = 'Seleccionar icono para',
    resetToDefault = 'Restablecen a los predeterminados',
    createNewIcon = 'Crea un nuevo icono',
    holdShift = 'Mantener SHIFT para ocultar el tinte oscuro',
    holdLmb = 'Mantenga presionado LMB para configurar la captura de iconos',
    scrollMouse = 'Desplace la rueda del mouse para hacer zoom',
    holdAlt = 'Mantenga presionada la tecla ALT para girar la cámara',
    pressRmb = 'Presione RMB para cancelar',
    pressE = 'Presione E para capturar',
    failedToCapture = 'No se pudo capturar el icono',
    iconUploaded = 'Icono descargado correctamente',
    importedFrom = 'Datos de icono importados correctamente desde',
    exportedTo = 'Datos de icono guardados',
    notAllowed = '¡No puedes editar iconos de armas!'
  },
}

-- Here you specify the language from the table above to use
iconic.lang = lang.en

-- You can create your own imgur accout and register your own
-- imgur application to get your own ClientID and set it here
iconic.imgurAuth = 'Client-ID a75acae7c4937c6'