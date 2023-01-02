local theme = iconic.theme

local padding = 16
local cornerRadius = theme.cornerRadius
local headerFontName = theme.headerFontName

local iconListBgColor = Color(128, 128, 128, 200)
local iconListButtonColor = Color(50, 50, 50, 255)
local iconListHoveredButtonColor = Color(80, 80, 80, 255)
local iconListCloseButtonColor = Color(200, 80, 80, 255)
local iconListHoveredCloseButtonColor = Color(255, 80, 80, 255)
local iconListTextColor = Color(200, 200, 200, 255)

local icons = iconic.icons

local binpack = include('cl_binpack.lua')

local iconPanel = {
  Base = 'Panel',
  SetIcon = function(p, icon)
    p.icon = icon
    p:SetSize(icon.w + padding * 2, icon.h + padding * 2)
  end,
  Paint = function(p, w, h)
    local icon = p.icon
    if not icon then return end
    local itemW, itemH = icon.w + padding * 2, icon.h + padding * 2
    if p:IsHovered() then
      draw.RoundedBox(cornerRadius, w / 2 - itemW / 2, h / 2 - itemH / 2, itemW, itemH, iconListHoveredButtonColor)
    end
    surface.SetDrawColor(255, 255, 255, 255)
    surface.SetMaterial(icon.mat)
    surface.DrawTexturedRect(padding, padding, icon.placeholder and icon.w or 512, icon.placeholder and icon.h or 512)
  end
}

local function requestAllIcons()
  net.Start('iconic.requestAllIcons')
  net.SendToServer()
end

local colorMat = Material('vgui/white')

iconic.iconListPanel = {
  Base = 'Panel',
  Init = function(p)
    p.headerText = 'Select existing icon'
    surface.SetFont(headerFontName)
    local _, th = surface.GetTextSize(p.headerText)
    local header = p:Add('Panel')
    header:SetTall(th + padding * 2)
    header:DockMargin(0, 0, 0, padding)
    header.Paint = function(hdr, w, h)
      draw.RoundedBoxEx(cornerRadius, 0, 0, w, h, iconListButtonColor, true, true, false, false)
      draw.SimpleText(p.headerText, headerFontName, padding, h / 2, iconListTextColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
    end
    local closeButton = header:Add('Panel')
    closeButton:SetWide(header:GetTall())
    closeButton:Dock(RIGHT)
    closeButton:SetCursor('hand')
    closeButton.Paint = function(btn, w, h)
      draw.RoundedBoxEx(cornerRadius, 0, 0, w, h, btn:IsHovered() and iconListHoveredCloseButtonColor or iconListCloseButtonColor, false, true, false, false)
      surface.SetDrawColor(iconListTextColor)
      surface.SetMaterial(colorMat)
      surface.DrawTexturedRectRotated(w / 2, h / 2, w * 0.5, 2, 45)
      surface.DrawTexturedRectRotated(w / 2, h / 2, w * 0.5, 2, 135)
    end
    closeButton.OnMouseReleased = function(btn, mcode)
      if mcode == MOUSE_LEFT then
        p:Remove()
      end
    end
    header:Dock(TOP)
    local footer = p:Add('Panel')
    footer:SetTall(header:GetTall())
    footer:Dock(BOTTOM)
    footer:DockMargin(padding, padding, padding, padding)
    local resetButton = footer:Add('Panel')
    resetButton.Paint = function(btn, w, h)
      draw.RoundedBox(cornerRadius, 0, 0, w, h, btn:IsHovered() and iconListHoveredButtonColor or iconListButtonColor)
      draw.SimpleText(iconic.lang.resetToDefault, headerFontName, w / 2, h / 2, iconListTextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    resetButton.OnMouseReleased = function(btn, mcode)
      if mcode == MOUSE_LEFT then
        iconic.resetIcon(p.wepClass)
        p:Remove()
      end
    end
    local addButton = footer:Add('Panel')
    addButton.Paint = function(btn, w, h)
      draw.RoundedBox(cornerRadius, 0, 0, w, h, btn:IsHovered() and iconListHoveredButtonColor or iconListButtonColor)
      draw.SimpleText(iconic.lang.createNewIcon, headerFontName, w / 2, h / 2, iconListTextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
    end
    addButton.OnMouseReleased = function(btn, mcode)
      if mcode == MOUSE_LEFT then
        local capturePnl = vgui.CreateFromTable(iconic.capturePanel)
        capturePnl:SetWeaponClass(p.wepClass)
        p:Remove()
      end
    end
    footer.PerformLayout = function(ftr, w, h)
      resetButton:SetPos(0, 0)
      resetButton:SetSize(w / 2 - padding / 2, h)
      addButton:SetPos(w / 2 + padding / 2, 0)
      addButton:SetSize(w / 2 - padding / 2, h)
    end
    p.content = p:Add('DScrollPanel')
    p.content:SetTall(512)
    p.content:DockMargin(padding, 0, padding, 0)
    p.content:Dock(FILL)
    p.content.VBar:SetHideButtons(true)
    p.content.VBar:SetWide(padding)
    p.content.VBar.Paint = function() end
    p.content.VBar.btnGrip.Paint = function(grip, w, h)
      draw.RoundedBox(cornerRadius, 0, 0, w, h, grip:IsHovered() and iconListHoveredButtonColor or iconListButtonColor)
    end
    p:SetSize(ScrW() - 200, ScrH() - 200)
    p:Center()
    p:MakePopup()
    p:SetKeyboardInputEnabled(false)
    p.icons = {}
    requestAllIcons()
  end,
  SetWeaponClass = function(p, className)
    p.wepClass = className
    p.headerText = iconic.lang.selectIconFor .. ' ' .. className
  end,
  LayoutIcons = function(p)
    local canvas = p.content:GetCanvas()
    local area = binpack(canvas:GetWide() - padding * 2, 1000000)
    for i, child in pairs(canvas:GetChildren()) do
      local rect = area:insert(child:GetWide(), child:GetTall())
      child:SetPos(rect.x, rect.y)
    end
  end,
  AddIcon = function(p, id, icon)
    local iconPnl = p.content:Add(iconPanel)
    p.icons[id] = iconPnl
    iconPnl:SetIcon(icon)
    if p.wepClass then
      iconPnl.OnMouseReleased = function(icn, mcode)
        if mcode == MOUSE_LEFT then
          iconic.setIcon(p.wepClass, id, icon.w, icon.h)
          p:Remove()
        end
      end
    end
    p:LayoutIcons()
  end,
  Paint = function(p, w, h)
    draw.RoundedBox(cornerRadius, 0, 0, w, h, iconListBgColor)
    for id, icon in pairs(icons) do
      if not IsValid(p.icons[id]) then
        p:AddIcon(id, icon)
      end
    end
  end
}
