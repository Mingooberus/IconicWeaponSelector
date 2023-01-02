local backupTheme = {
  slotColor = Color(0, 0, 0, 80),
  activeSlotColor = Color(100, 150, 0, 80),
  targetSlotColor = Color(255, 220, 0, 80),
  noAmmoSlotColor = Color(150, 0, 0, 80),
  validColor = Color(0, 255, 0, 255),
  invalidColor = Color(255, 0, 0, 255),
  drawSlotNumbers = true,
  drawWeaponInfo = true,
  compactDrawName = true,
  compactDrawIcon = false,
  compactDrawAmmo = true,
  targetColumnDrawName = true,
  targetColumnDrawIcon = false,
  targetColumnDrawAmmo = true,
  targetDrawName = true,
  targetDrawIcon = true,
  targetDrawAmmo = true,
  allowEmpty = false,
  verboseKey = KEY_LALT,
  dockToTop = false,
  alwaysWidest = false,
  headerFontName = 'HudHintTextLarge',
  ammo1FontName = 'HudHintTextLarge',
  ammo2FontName = 'HudHintTextLarge',
  slotNumberFontName = 'HudHintTextLarge',
  headerTextColor = Color(255, 220, 0, 255),
  ammo1TextColor = Color(255, 220, 0, 255),
  ammo2TextColor = Color(255, 220, 0, 255),
  slotNumberTextColor = Color(255, 220, 0, 255),
  defaultIconWidth = 256,
  defaultIconHeight = 128,
  padding = 8,
  cornerRadius = 8,
  showTime = 2,
  fadeTime = 1,
  animSpeed = 2,
  soundVolume = 0.2,
  tapSound = 'common/wpn_moveselect.wav',
  confirmSound = 'common/wpn_hudoff.wav',
  scrollSound = 'common/wpn_select.wav',
  denySound = 'common/wpn_denyselect.wav',
  loadingIconMat = 'gui/html/refresh'
}
backupTheme.__index = backupTheme

iconic.theme = setmetatable(iconic.theme or {}, backupTheme)
local theme = iconic.theme

iconic.gunIcons = iconic.gunIcons or {}
local gunIcons = iconic.gunIcons
iconic.icons = iconic.icons or {}
local icons = iconic.icons

file.CreateDir('iconic/payloads')
file.CreateDir('iconic/icons')

include('cl_capture.lua')
include('cl_iconlist.lua')

local slotColor = theme.slotColor
local activeSlotColor = theme.activeSlotColor
local targetSlotColor = theme.targetSlotColor
local noAmmoSlotColor = theme.noAmmoSlotColor
local headerTextColor = theme.headerTextColor
local ammo1TextColor = theme.ammo1TextColor
local ammo2TextColor = theme.ammo2TextColor
local slotNumberTextColor = theme.slotNumberTextColor
local drawSlotNumbers = theme.drawSlotNumbers
local drawWeaponInfo = theme.drawWeaponInfo
local compactDrawName = theme.compactDrawName
local compactDrawIcon = theme.compactDrawIcon
local compactDrawAmmo = theme.compactDrawAmmo
local targetColumnDrawName = theme.targetColumnDrawName
local targetColumnDrawIcon = theme.targetColumnDrawIcon
local targetColumnDrawAmmo = theme.targetColumnDrawAmmo
local targetDrawName = theme.targetDrawName
local targetDrawIcon = theme.targetDrawIcon
local targetDrawAmmo = theme.targetDrawAmmo
local dockToTop = theme.dockToTop
local centerHorizontal = theme.centerHorizontal
local alwaysWidest = theme.alwaysWidest
local padding = theme.padding
local cornerRadius = theme.cornerRadius
local headerFontName = theme.headerFontName
local ammo1FontName = theme.ammo1FontName
local ammo2FontName = theme.ammo2FontName
local slotNumberFontName = theme.slotNumberFontName
local defaultIconHeight = theme.defaultIconHeight
local defaultIconWidth = theme.defaultIconWidth
local animSpeed = theme.animSpeed
local loadingIconMat = Material(theme.loadingIconMat)
local showTime = theme.showTime
local fadeTime = theme.fadeTime
local tapSound = Sound(theme.tapSound)
local confirmSound = Sound(theme.confirmSound)
local denySound = Sound(theme.denySound)
local scrollSound = Sound(theme.scrollSound)
local soundVolume = theme.soundVolume
local allowEmpty = theme.allowEmpty
local verboseKey = theme.verboseKey

local wepInfoOverride = iconic.wepInfoOverride or {}

local loadingIcon = {
  mat = loadingIconMat,
  w = loadingIconMat:Width(),
  h = loadingIconMat:Height(),
  placeholder = true,
  rotSpeed = 360
}

local missingIcon = {
  w = defaultIconWidth,
  h = defaultIconHeight,
  placeholder = true,
  missing = true
}

local stockGunIcons = {
  weapon_357 = 'e',
  weapon_ar2 = 'l',
  weapon_bugbait = 'j',
  weapon_crossbow = 'g',
  weapon_crowbar = 'c',
  weapon_frag = 'k',
  weapon_physcannon = 'm',
  weapon_physgun = 'm',
  weapon_pistol = 'd',
  weapon_rpg = 'i',
  weapon_shotgun = 'b',
  weapon_slam = 'o',
  weapon_smg1 = 'a',
  weapon_stunstick = 'n',
}

local function doNothing() end

surface.CreateFont('iconic.wepIconBg', {
  font = 'halflife2',
  size = missingIcon.h * 1.3,
  scanlines = 4,
  blursize = 6
})

surface.CreateFont('iconic.wepIcon', {
  font = 'halflife2',
  size = missingIcon.h * 1.3
})

function iconic.setIcon(className, icon, w, h)
  net.Start('iconic.setIcon')
  net.WriteString(className)
  net.WriteString(icon)
  net.WriteUInt(w, 16)
  net.WriteUInt(h, 16)
  gunIcons[className] = loadingIcon
  net.SendToServer()
end

function iconic.resetIcon(className)
  net.Start('iconic.resetIcon')
  net.WriteString(className)
  gunIcons[className] = missingIcon
  net.SendToServer()
end

local function imgurDownload(id, callback)
  HTTP({
    url = 'https://i.imgur.com/' .. id .. '.png',
    method = 'get',
    success = function(_, data)
      local path = 'iconic/icons/' .. id .. '.png'
      if data then
        file.Write(path, data)
        timer.Simple(0.2, function()
          callback(not not data)
        end)
      else
        callback(false)
      end
    end,
    failed = function(error)
      callback(false, error)
    end
  })
end

local function requestIcon(className)
  gunIcons[className] = loadingIcon
  net.Start('iconic.requestIcon')
    net.WriteString(className)
  net.SendToServer()
end

local function exportIconData(fileName)
  net.Start('iconic.exportIconData')
  net.WriteString(fileName)
  net.SendToServer()
end

local function importIconData(fileName)
  local data = file.Read('iconic/payloads/' .. fileName .. '.json')
  if data then
    net.Start('iconic.importIconData')
      net.WriteString(fileName)
      net.WriteString(data)
    net.SendToServer()
  else
    MsgC(Color(255, 0, 0), 'Invalid import filename!\n')
  end
end

local function getIcon(className)
  if not gunIcons[className] then
    requestIcon(className)
  end
  return gunIcons[className]
end

local function loadIconMatFromDisk(id)
  if file.Exists('iconic/icons/' .. id .. '.png', 'DATA') then
      return Material('data/iconic/icons/' .. id .. '.png')
    end
end

local function loadIconFromImgur(className, id, w, h)
  imgurDownload(id, function(success)
    if success then
      local mat = loadIconMatFromDisk(id)
      if mat and not mat:IsError() then
        local icon = {
          mat = mat,
          w = w,
          h = h
        }
        icons[id] = icon
        if className then
          gunIcons[className] = icon
        end
        return
      end
    end
    if className then
      gunIcons[className] = missingIcon
    end
  end)
end

local function getGunSlot(wep)
  if IsValid(wep) then
    local className = wep:GetClass()
    local info = wepInfoOverride[className]
    return info and info.slot or wep:GetSlot() + 1
  end
end

local function getGunSlotPos(wep)
  if IsValid(wep) then
    local className = wep:GetClass()
    local info = wepInfoOverride[className]
    return info and info.slotPos or wep:GetSlotPos()
  end
end

local function getGunName(wep)
  if IsValid(wep) then
    local className = wep:GetClass()
    local info = wepInfoOverride[className]
    return info and info.name or wep:GetPrintName()
  end
end

local function fastSwitch()
  return GetConVar('hud_fastswitch'):GetBool()
end

local allWeapons = {}
local weaponGrid = {}
local activeWep, targetWep
local visibility
local lastTouch, lifetime = -1000, showTime + fadeTime

iconic.weaponGrid = weaponGrid

local function onWeaponEquipped(wep)
  local className = wep:GetClass()
  local targetSlot, targetSlotPos = getGunSlot(wep), getGunSlotPos(wep)
  local col = weaponGrid[targetSlot]
  if not col then
    col = {}
    weaponGrid[targetSlot] = col
  end
  local slotPos = 1
  for _, otherWep in SortedPairs(col) do
    local otherSlotPos = getGunSlotPos(otherWep)
    if otherSlotPos < targetSlotPos or otherSlotPos == targetSlotPos and className > otherWep:GetClass() then
      slotPos = slotPos + 1
    end
  end
  table.insert(col, slotPos, wep)
end

local function onWeaponLost(wep)
  for x, col in pairs(weaponGrid) do
      for y, otherWep in pairs(col) do
        if wep == otherWep then
          table.remove(col, y)
          if #col == 0 then
            weaponGrid[x] = nil
          end
          goto found
        end
      end
  end
  ::found::
  if targetWep == wep then
    targetWep = nil
  end
end

local function hide()
  targetWep = nil
  lastTouch = -1000
end

local lastWep
local function selectTarget()
  if IsValid(targetWep) then
    if IsValid(activeWep) then
      lastWep = activeWep:GetClass()
    end
    input.SelectWeapon(targetWep)
  end
  hide()
end

local function postTargetChanged()
  if fastSwitch() then
    selectTarget()
  else
    lastTouch = CurTime()
  end
end

local function onSlotTap(slotNum)
  local col = weaponGrid[slotNum]
  if not col then return end
  local curTargetSlotPos = table.KeyFromValue(col, fastSwitch() and activeWep or targetWep) or 0
  targetWep = col[curTargetSlotPos + 1] or col[1]
  if not fastSwitch() then
    LocalPlayer():EmitSound(tapSound, 75, 100, soundVolume)
  end
  postTargetChanged()
end

local function onScroll(prev)
  if input.IsMouseDown(MOUSE_LEFT) or input.IsMouseDown(MOUSE_RIGHT) then return end
  local colCount = table.Count(weaponGrid)
  if colCount == 0 then return end
  local scroll = prev and -1 or 1
  if not targetWep then targetWep = activeWep end
  if not targetWep then return end
  for slotNum, col in pairs(weaponGrid) do
    local curTargetSlotPos = table.KeyFromValue(col, targetWep)
    if curTargetSlotPos then
      targetWep = col[curTargetSlotPos + scroll]
      if not targetWep then
        repeat
          slotNum = ((slotNum + scroll - 1) % 9) + 1
          col = weaponGrid[slotNum]
        until col
        targetWep = col[prev and #col or 1]
      end
      break
    end
  end
  if not fastSwitch() then
    LocalPlayer():EmitSound(scrollSound, 75, 100, soundVolume)
  end
  postTargetChanged()
end

local function onLastWep()
  local wep = lastWep and LocalPlayer():GetWeapon(lastWep)
  if wep then
    local curWep = LocalPlayer():GetActiveWeapon()
    local curWepClass = curWep and curWep:GetClass()
    if curWepClass and curWepClass ~= lastWep then
      lastWep = curWepClass
    end
    input.SelectWeapon(wep)
    lastClick = 0
  end
  return true
end

local function onAttack()
  if visibility > 0 then
    LocalPlayer():EmitSound(confirmSound, 75, 100, soundVolume)
    selectTarget()
    return true
  end
end

local function onAttack2()
  if visibility > 0 then
    LocalPlayer():EmitSound(denySound, 75, 100, soundVolume)
    hide()
    return true
  end
end

local function canUseSelector(ply)
  return ply:Alive() and (not IsValid(ply:GetVehicle()) or ply:GetAllowWeaponsInVehicle())
end

local function getAmmoInfo1(wep)
  local clip, ammo
  local ammoType = wep:GetPrimaryAmmoType()
  local ammoData = game.GetAmmoData(ammoType)
  local text
  if ammoData then
    clip = wep:Clip1()
    ammo = LocalPlayer():GetAmmoCount(ammoType)
    text = clip == -1 and ammo or clip .. '/' .. ammo
  end
  return text
end

local function getAmmoInfo2(wep)
  local clip, ammo
  local ammoType = wep:GetSecondaryAmmoType()
  local ammoData = game.GetAmmoData(ammoType)
  local text
  if ammoData then
    clip = wep:Clip2()
    ammo = LocalPlayer():GetAmmoCount(ammoType)
    text = clip == -1 and ammo or clip .. '/' .. ammo
  end
  return text
end

local function lerpColor(t, c1, c2)
  return Color(Lerp(t, c1.r, c2.r), Lerp(t, c1.g, c2.g), Lerp(t, c1.b, c2.b), Lerp(t, c1.a, c2.a))
end

local gridX, gridY = 0, 0
local wepIconFonts = {
  'iconic.wepIconBg',
  'iconic.wepIcon'
}

local drawOnTop

local function drawStockIcon(wep, shouldDrawInfo, x, y, w, h)
  if wep.DrawWeaponSelection then
    local oldDrawInfo = wep.PrintWeaponInfo
    wep.PrintWeaponInfo = doNothing
    wep:DrawWeaponSelection(x, y, w, h, 255)
    wep.PrintWeaponInfo = oldDrawInfo
  else
    local iconChar = stockGunIcons[wep:GetClass()]
    if iconChar then
      for _, fnt in pairs(wepIconFonts) do
        draw.SimpleText(
          iconChar,
          fnt,
          x + w / 2,
          y + h / 2,
          headerTextColor,
          TEXT_ALIGN_CENTER,
          TEXT_ALIGN_CENTER
        )
      end
    end
  end
end

local function drawSelector()
  if not LocalPlayer():Alive() then
    hide()
    return
  end
  local t = CurTime()
  local verbose = verboseKey and input.IsKeyDown(verboseKey)
  local slotNumH = padding
  for _, wep in pairs(allWeapons) do
    local info = {}
    local target = wep == targetWep
    local targetCol = getGunSlot(wep) == getGunSlot(targetWep)
    info.target = target
    local active = wep == activeWep
    info.active = active
    local drawName = compactDrawName
    local drawIcon = compactDrawIcon
    local drawAmmo = compactDrawAmmo
    if target then
      drawName = targetDrawName
      drawIcon = targetDrawIcon
      drawAmmo = targetDrawAmmo
    elseif targetCol then
      drawName = targetColumnDrawName
      drawIcon = targetColumnDrawIcon
      drawAmmo = targetColumnDrawAmmo
    end
    info.drawName = drawName or verbose
    info.drawIcon = drawIcon or verbose
    info.drawAmmo = drawAmmo or verbose
    if info.drawName then
      info.name = getGunName(wep)
      surface.SetFont(headerFontName)
      info.nameW, info.nameH = surface.GetTextSize(info.name)
    end
    info.icon = getIcon(wep:GetClass())
    if info.drawAmmo then
      info.ammo1, info.ammo2 = getAmmoInfo1(wep), getAmmoInfo2(wep)
      if info.ammo1 or info.ammo2 then
        info.ammo1W, info.ammo1H, info.ammo2W, info.ammo2H = 0, 0, 0, 0
        if info.ammo1 then
          surface.SetFont(ammo1FontName)
          info.ammo1W, info.ammo1H = surface.GetTextSize(info.ammo1)
        end
        if info.ammo2 then
          surface.SetFont(ammo2FontName)
          info.ammo2W, info.ammo2H = surface.GetTextSize(info.ammo2)
        end
        info.ammoW = info.ammo1W + info.ammo2W + (info.ammo1 and info.ammo2 and padding or 0)
        info.ammoH = math.max(info.ammo1H, info.ammo2H)
      else
        info.drawAmmo = false
      end
    end
    local iconW = 0
    if info.drawIcon or alwaysWidest and targetCol then
      iconW = info.icon.w
    end
    info.slotW = padding * 2 + math.max(iconW, info.nameW or 0, info.ammoW or 0)
    wep.iconicInfo = info
  end
  local dx = 0
  local colsW = {}
  local menuW = -padding
  for slotNum, col in SortedPairs(weaponGrid) do
    local colW = 0
    for _, wep in pairs(col) do
      colW = math.max(colW, wep.iconicInfo.slotW)
    end
    colsW[col] = colW
    menuW = menuW + colW + padding
  end
  for slotNum, col in SortedPairs(weaponGrid) do
    local colW = colsW[col]
    local dy = 0
    if drawSlotNumbers then
      local _, th = draw.SimpleText(slotNum, slotNumberFontName, gridX + dx + colW / 2, gridY - padding, slotNumberTextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
      slotNumH = th + padding * 2
    end
    for slotPos, wep in SortedPairs(col) do
      local info = wep.iconicInfo
      local target = info.target
      local active = info.active
      local drawName = info.drawName
      local drawIcon = info.drawIcon
      local drawAmmo = info.drawAmmo
      local slotW = colW
      local slotH = padding * 2
      if drawName then
        slotH = slotH + info.nameH + ((drawIcon or drawAmmo) and padding or 0)
      end
      if drawIcon then
        slotH = slotH + (info.icon and info.icon.h or 0) + (drawAmmo and padding or 0)
      end
      if drawAmmo then
        slotH = slotH + info.ammoH
      end
      local slotX, slotY = dx + (colW - slotW) / 2, dy
      local baseSlotColor = not wep:HasAmmo() and noAmmoSlotColor or active and activeSlotColor or slotColor
      local c = lerpColor((t - (wep.iconicWasTarget or 1)) * animSpeed, targetSlotColor, baseSlotColor)
      draw.RoundedBox(
        cornerRadius,
        gridX + slotX,
        gridY + slotY,
        slotW,
        slotH,
        c
      )
      if drawName then
        draw.SimpleText(info.name, headerFontName, gridX + slotX + slotW / 2, gridY + slotY + padding, headerTextColor, TEXT_ALIGN_CENTER)
      end
      if drawIcon then
        local icon = info.icon
        local iconW, iconH = icon.w, icon.h
        local iconX, iconY = gridX + slotX + (slotW - iconW) / 2, gridY + slotY + padding + (drawName and (info.nameH + padding) or 0)
        local iconTextureW, iconTextureH = icon.placeholder and iconW or 512, icon.placeholder and iconH or 512
        local iconRotSpeed = icon.rotSpeed
        surface.SetDrawColor(255, 255, 255, 255)
        if icon.missing then
          drawStockIcon(wep, drawWeaponInfo and target, iconX, iconY, iconW, iconH)
        else
          surface.SetMaterial(icon.mat)
          if iconRotSpeed then
            surface.DrawTexturedRectRotated(
              iconX + iconW / 2,
              iconY + iconH / 2,
              iconTextureW,
              iconTextureH,
              -CurTime() * iconRotSpeed
            )
          else
            surface.DrawTexturedRect(
              iconX,
              iconY,
              iconTextureW,
              iconTextureH
            )
          end
        end
        if drawWeaponInfo and target and wep.PrintWeaponInfo then
          drawOnTop = function()
            wep:PrintWeaponInfo(iconX + iconW, iconY + iconH, 255)
          end
        end
      end
      if drawAmmo then
        if info.ammo1 then
          draw.SimpleText(
            info.ammo1,
            ammo1FontName,
            gridX + slotX + padding,
            gridY + slotY + slotH - padding - info.ammoH / 2,
            ammo1TextColor,
            TEXT_ALIGN_LEFT,
            TEXT_ALIGN_CENTER
          )
        end
        if info.ammo2 then
          draw.SimpleText(
            info.ammo2,
            ammo2FontName,
            gridX + slotX + slotW - padding,
            gridY + slotY + slotH - padding - info.ammoH / 2,
            ammo2TextColor,
            TEXT_ALIGN_RIGHT,
            TEXT_ALIGN_CENTER
          )
        end
      end
      if target then
        wep.iconicWasTarget = t
        local dt = (t - lastTouch) * animSpeed
        local targetX, targetY
        targetX = -(slotX + slotW / 2)
        if dockToTop then
          targetY = -ScrH() / 2 + math.min(ScrH() / 2 -(slotY + slotH / 2), slotNumH)
        else
          targetY = -(slotY + slotH / 2)
        end
        gridX = centerHorizontal and Lerp(dt, gridX, targetX) or -menuW / 2
        gridY = Lerp(dt, gridY, targetY)
      end
      dy = dy + slotH + padding
    end
    dx = dx + colW + padding
  end
  if drawOnTop then
    drawOnTop()
    drawOnTop = nil
  end
end

local defaultSettings = {
  enabled = 1,
  scale = 1
}
local settings = {}

sql.Query('create table if not exists cookies(key not null primary key, value text)')

local function saveSettings()
  sql.Query(string.format(
    [[replace into cookies(key, value) values('iconic_settings', %s)]],
    SQLStr(util.TableToJSON(settings))
  ))
end

local res = sql.Query([[select value from cookies where key = 'iconic_settings']])
if res then
  settings = util.JSONToTable(res[1].value)
end

for k, v in pairs(defaultSettings) do
  if settings[k] == nil then
    settings[k] = defaultSettings[k]
  end
end

saveSettings()

hook.Add('PostDrawHUD', 'iconic.think', function()
  if not settings.enabled then return end
  local ply = LocalPlayer()
  if not canUseSelector(ply) then return end
  visibility = lastTouch - CurTime() + lifetime
  local oldWeapons = allWeapons
  allWeapons = {}
  for _, wep in pairs(ply:GetWeapons()) do
    if wep:HasAmmo() or allowEmpty or wep == activeWep then
      table.insert(allWeapons, wep)
    end
  end
  activeWep = ply:GetActiveWeapon()
  for _, wep in pairs(oldWeapons) do
    if not IsValid(wep) or not table.HasValue(allWeapons, wep) then
      onWeaponLost(wep)
    end
  end
  for _, wep in pairs(allWeapons) do
    if not table.HasValue(oldWeapons, wep) then
      onWeaponEquipped(wep)
    end
  end
  if visibility > 0 then
    local alpha = math.Clamp(visibility / fadeTime, 0, 1)
    cam.Start2D()
      local oldAlpha = surface.GetAlphaMultiplier()
      surface.SetAlphaMultiplier(alpha)
      local scale = settings.scale
      local scaleMatrix = Matrix()
      scaleMatrix:Scale(Vector(scale, scale, scale))
      scaleMatrix:Translate(Vector(ScrW() / scale / 2, ScrH() / scale / 2, 0))
      cam.PushModelMatrix(scaleMatrix)
      drawSelector()
      cam.PopModelMatrix()
      surface.SetAlphaMultiplier(oldAlpha)
    cam.End2D()
  end
end)

local binds = {
  lastinv = onLastWep,
  invprev = function() onScroll(true) end,
  invnext = function() onScroll(false) end,
  slot0 = function() end,
  slot1 = function() onSlotTap(1) end,
  slot2 = function() onSlotTap(2) end,
  slot3 = function() onSlotTap(3) end,
  slot4 = function() onSlotTap(4) end,
  slot5 = function() onSlotTap(5) end,
  slot6 = function() onSlotTap(6) end,
  slot7 = function() onSlotTap(7) end,
  slot8 = function() onSlotTap(8) end,
  slot9 = function() onSlotTap(9) end,
  ['+attack'] = onAttack,
  ['+attack2'] = onAttack2,
}

hook.Add('PlayerBindPress', 'iconic', function(ply, bind, pressed)
  if not settings.enabled then return end
  if iconic.suppressHook then return end
  if not canUseSelector(ply) then return end
  if not pressed then return end
  if binds[bind] then
    iconic.suppressHook = true
    local prevent = hook.Run('PlayerBindPress', ply, bind, pressed)
    iconic.suppressHook = false
    if not prevent then return binds[bind]() end
  end
end)

hook.Add('HUDShouldDraw', 'iconic', function(name)
  if not settings.enabled then return end
  if name == 'CHudWeaponSelection' then return false end
end)

net.Receive('iconic.setIcon', function(len)
  local className = net.ReadString()
  local present = net.ReadBool()
  if not present then
    gunIcons[className] = missingIcon
    return
  end
  local id = net.ReadString()
  local w = net.ReadUInt(16)
  local h = net.ReadUInt(16)
  local icon = icons[id]
  if icon then
    gunIcons[className] = icon
  else
    local mat = loadIconMatFromDisk(id)
    if mat then
      icon = {
        mat = mat,
        w = w,
        h = h
      }
      icons[id] = icon
      gunIcons[className] = icon
    else
      loadIconFromImgur(className, id, w, h)
    end
  end
end)

net.Receive('iconic.sendAllIcons', function(len)
  local iconCount = net.ReadUInt(16)
  for i = 1, iconCount do
    local id = net.ReadString()
    local w = net.ReadUInt(16)
    local h = net.ReadUInt(16)
    if not icons[id] then
      loadIconFromImgur(nil, id, w, h)
    end
  end
end)

net.Receive('iconic.exportIconData', function(len)
  local fileName = net.ReadString()
  local data = net.ReadString()
  local filePath = 'iconic/payloads/' .. fileName .. '.json'
  file.Write(filePath, data)
  notification.AddLegacy(string.format(iconic.lang.exportedTo .. ' garrysmod/data/' .. filePath), NOTIFY_HINT, 3)
end)

net.Receive('iconic.importIconData', function(len)
  local fileName = net.ReadString()
  local filePath = 'iconic/payloads/' .. fileName .. '.json'
  notification.AddLegacy(string.format(iconic.lang.importedFrom .. ' ' .. filePath), NOTIFY_HINT, 3)
end)

concommand.Add('iconic_enabled', function(ply, cmd, args)
  local enabled = args[1] and tonumber(args[1]) and tonumber(args[1]) ~= 0 or false
  settings.enabled = enabled
end, function(cmd, args)
  if string.Trim(args) == '' then
    return { 'iconic_enabled ' .. (settings.enabled and 1 or 0) }
  end
end)

concommand.Add('iconic_scale', function(ply, cmd, args)
  local s = args[1]
  if s and tonumber(s) then
    settings.scale = tonumber(s)
    saveSettings()
  else
    MsgC(Color(255, 0, 0), 'Specify valid scale!\n')
  end
end, function(cmd, args)
  if string.Trim(args) == '' then
    return { 'iconic_scale ' .. settings.scale }
  end
end)

concommand.Add('iconic_icon', function(ply, cmd, args)
  if not iconic.canEditIcons(ply) then
    notification.AddLegacy(iconic.lang.notAllowed, NOTIFY_GENERIC, 3)
    return
  end
  local className = args[1]
  if not className then
    local wep = LocalPlayer():GetActiveWeapon()
    className = wep and wep:GetClass()
  end
  local iconList = vgui.CreateFromTable(iconic.iconListPanel)
  iconList:SetWeaponClass(className)
end)

concommand.Add('iconic_flushicons', function(ply, cmd, args)
  for _, icon in pairs(file.Find('iconic/icons/*.png', 'DATA')) do
    file.Delete('iconic/icons/' .. icon)
  end
  table.Empty(gunIcons)
  table.Empty(icons)
end)

concommand.Add('iconic_export', function(ply, cmd, args)
  if not iconic.canEditIcons(ply) then
    notification.AddLegacy(iconic.lang.notAllowed, NOTIFY_GENERIC, 3)
    return
  end
  local fileName = args[1]
  if not fileName then
    MsgC(Color(255, 0, 0), 'Specify filename to export!\n')
    return
  end
  exportIconData(fileName)
end)

concommand.Add('iconic_import', function(ply, cmd, args)
  if not iconic.canEditIcons(ply) then
    notification.AddLegacy(iconic.lang.notAllowed, NOTIFY_GENERIC, 3)
    return
  end
  local fileName = args[1]
  if not fileName then
    MsgC(Color(255, 0, 0), 'Specify export name!\n')
    return
  end
  importIconData(fileName)
end, function(cmd, args)
  local options = {}
  for _, payload in pairs(file.Find('iconic/payloads/*.json', 'DATA')) do
    local fileName = string.Left(payload, #payload - 5)
    if string.StartWith(fileName, string.Trim(args)) then
      table.insert(options, 'iconic_import ' .. fileName)
    end
  end
  return options
end)

local function formatWepName(wep)
  return string.format('%s [%s]', language.GetPhrase(getGunName(wep)), wep:GetClass())
end

list.Set( 'DesktopWindows', 'iconic', {
  title = iconic.lang.wepIcon,
  icon = 'icon64/tool.png',
  width = 1,
  height = 1,
  onewindow = true,
  init = function(icon, window)
    window:Remove()
    local function editWep(wep)
      return function()
        concommand.Run(LocalPlayer(), 'iconic_icon', { wep:GetClass() })
      end
    end
    local m = vgui.Create('DMenu')
    if IsValid(activeWep) then
      m:AddOption(formatWepName(activeWep), editWep(activeWep))
    end
    for _, wep in pairs(allWeapons) do
      if wep ~= activeWep then
        m:AddOption(formatWepName(wep), editWep(wep))
      end
    end
    m:Open()
  end
})
