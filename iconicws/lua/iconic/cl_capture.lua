local theme = iconic.theme

local validColor = theme.validColor
local invalidColor = theme.invalidColor
local padding = theme.padding or backupTheme.padding
local headerFontName = theme.headerFontName or backupTheme.headerFontName
local captureTextColor = Color(200, 200, 200, 255)
local captureTintColor = Color(0, 0, 0, 220)

local gunIcons = iconic.gunIcons
local imgurAuth = iconic.imgurAuth

local imgurUpload = function(img, name, desc, callback)
  HTTP({
    url = 'https://api.imgur.com/3/image',
    method = 'post',
    headers = {
      Authorization = imgurAuth
    },
    parameters = {
      type = 'base64',
      title = name .. '.png',
      description = desc,
      image = util.Base64Encode(img)
    },
    success = function(_, data)
      data = util.JSONToTable(data)
      callback(data.success, data.data)
    end,
    failed = function(error)
      callback(false, error)
    end
  })
end

local function shouldDraw(ent)
  return ent.DrawModel and (ent:IsWeapon() or ent:IsScripted() or string.find(ent:GetClass(), 'prop'))
end

local function captureIcon(name, iconX, iconY, iconW, iconH, callback)
  cam.Start3D()
  render.Clear(0, 0, 0, 0, true, true)
  render.SetWriteDepthToDestAlpha(false)
  render.OverrideAlphaWriteEnable(true, true)
  render.SuppressEngineLighting(true)
  render.SetAmbientLight(0.5, 0.5, 0.5)
  render.SetLocalModelLights({
    {
      type = MATERIAL_LIGHT_DIRECTIONAL,
      dir = EyeAngles():Forward() - EyeAngles():Up(),
      color = Vector(1, 1, 1)
    }
  })
  render.SetStencilWriteMask(0xFF)
  render.SetStencilTestMask(0xFF)
  render.SetStencilReferenceValue(0)
  render.SetStencilCompareFunction(STENCIL_ALWAYS)
  render.SetStencilPassOperation(STENCIL_KEEP)
  render.SetStencilFailOperation(STENCIL_KEEP)
  render.SetStencilZFailOperation(STENCIL_KEEP)
  render.ClearStencil()
  render.SetStencilEnable(true)
  render.SetStencilReferenceValue(1)
  render.SetStencilCompareFunction(STENCIL_EQUAL)
  render.ClearStencilBufferRectangle(iconX, iconY, iconX + iconW, iconY + iconH, 1)
  for _, ent in pairs(ents.GetAll()) do
    if shouldDraw(ent) then
      ent:DrawModel()
    end
  end
  render.OverrideAlphaWriteEnable(false)
  render.SuppressEngineLighting(false)
  render.SetStencilEnable(false)
  cam.End3D()
  local pixels
  pixels = render.Capture({
    format = 'png',
    alpha = true,
    w = 512,
    h = 512,
    x = iconX,
    y = iconY
  })
  if not pixels then
    notification.AddLegacy(iconic.lang.failedToCapture, NOTIFY_ERROR, 3)
    return
  end
  gunIcons[name] = loadingIcon
  imgurUpload(pixels, name, iconW .. 'x' .. iconH, function(success, data)
    if success then
      notification.AddLegacy(iconic.lang.iconUploaded, NOTIFY_HINT, 3)
      callback(data.id, data.deletehash)
    else
      callback()
    end
  end)
end

local frameX, frameY, frameW, frameH = 0, 0, 0, 0
local hints = {
  iconic.lang.holdShift,
  iconic.lang.holdLmb,
  iconic.lang.scrollMouse,
  iconic.lang.holdAlt,
  iconic.lang.pressRmb,
  iconic.lang.pressE
}

local capturePnlInstance
iconic.capturePanel = {
  Base = 'Panel',
  Init = function(p)
    if IsValid(capturePnlInstance) then
      capturePnlInstance:Remove()
    end
    capturePnlInstance = p
    p:SetPos(0, 0)
    p:SetSize(ScrW(), ScrH())
    p:SetMouseInputEnabled(true)
    p:MakePopup()
    p:SetKeyboardInputEnabled(false)
    hook.Add('PreDrawViewModel', 'iconic.capture', function()
      if IsValid(p) then
        return true
      else
        hook.Remove('PreDrawViewModel', 'iconic.capture')
      end
    end)
    hook.Add('HUDShouldDraw', 'iconic.capture', function()
      if IsValid(p) then
        return false
      else
        hook.Remove('HUDShouldDraw', 'iconic.capture')
      end
    end)
  end,
  SetWeaponClass = function(p, className)
    if iconic.isValidWeaponClass(className) then
      p.wepClass = className
    else
      notification.AddLegacy('Invalid weapon class', NOTIFY_ERROR, 3)
      p:Remove()
    end
  end,
  OnMousePressed = function(p, keyCode)
    if keyCode == MOUSE_LEFT then
      p.x1, p.y1 = p:LocalCursorPos()
      p.dragging = true
      p:MouseCapture(true)
    elseif keyCode == MOUSE_RIGHT then
      if p.x1 then
        p.x1, p.y1, p.x2, p.y2 = nil, nil, nil, nil
      else
        p:Remove()
      end
    end
  end,
  OnMouseReleased = function(p, keyCode)
    if keyCode == MOUSE_LEFT then
      p.dragging = nil
      p:MouseCapture(false)
    end
  end,
  OnMouseWheeled = function(p, delta)
    p.fov = math.Clamp((p.fov or LocalPlayer():GetFOV()) - delta * 3, 10, 90)
    hook.Add('CalcView', 'iconic.capture', function(ply, origin, angles, fov, znear, zfar)
      if IsValid(p) then
        return {
          origin = origin,
          angles = angles,
          fov = p.fov,
          znear = znear,
          zfar = zfar
        }
      else
        hook.Remove('CalcView', 'iconic.capture')
      end
    end)
  end,
  Paint = function(p, w, h)
    if not p.wepClass then
      p:Remove()
      return
    end
    if p.dragging then
      local x, y = p:LocalCursorPos()
      local dx, dy = x - p.x1, y - p.y1
      dx = dx < -512 and -512 or dx > 512 and 512 or dx
      dy = dy < -512 and -512 or dy > 512 and 512 or dy
      p.x2, p.y2 = p.x1 + dx, p.y1 + dy
      frameX, frameY = math.min(p.x1, p.x2), math.min(p.y1, p.y2)
      frameW, frameH = math.abs(p.x1 - p.x2), math.abs(p.y1 - p.y2)
    else
      if input.IsKeyDown(KEY_E) and p.valid then
        p:Remove()
        local className = p.wepClass
        captureIcon(className, frameX, frameY, frameW, frameH, function(id, deleteHash)
          iconic.setIcon(className, id, frameW, frameH)
        end)
        return
      end
      if input.IsKeyDown(KEY_LALT) then
        p:SetMouseInputEnabled(false)
      else
        p:SetMouseInputEnabled(true)
      end
    end
    if frameW <= 512 and frameW >= 16 and frameH <= 512 and frameH >= 16 then
      p.valid = true
    else
      p.valid = false
    end
    surface.SetDrawColor(input.IsKeyDown(KEY_LSHIFT) and Color(0, 0, 0, 0) or captureTintColor)
    if p.x1 then
      local fgColor = p.valid and validColor or invalidColor
      surface.DrawRect(0, 0, w, frameY)
      surface.DrawRect(0, frameY + frameH, w, h - frameH - frameY)
      surface.DrawRect(0, frameY, frameX, frameH)
      surface.DrawRect(frameX + frameW, frameY, w - frameW - frameX, frameH)
      surface.SetDrawColor(fgColor)
      surface.DrawOutlinedRect(frameX - 1, frameY - 1, frameW + 2, frameH + 2)
      draw.SimpleText(frameW .. 'x' .. frameH, headerFontName, frameX + frameW + padding, frameY, fgColor)
    else
      surface.DrawRect(0, 0, w, h)
    end
    surface.SetFont(headerFontName)
    local _tw, th = surface.GetTextSize('A')
    for i, hint in pairs(hints) do
      draw.SimpleText(hint, headerFontName, w - padding, (padding + th) * i, captureTextColor, TEXT_ALIGN_RIGHT)
    end
  end
}
