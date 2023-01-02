sql.Query('create table if not exists iconic_icons(className text primary key, icon text, w integer, h integer)')

local function getIcon(className)
  local res = sql.Query(string.format(
    [[select icon, w, h from iconic_icons where className = %s]],
    SQLStr(className)
  ))
  local data = res and res[1]
  if data then
    return data.icon, data.w, data.h
  end
end

local function setIcon(className, icon, w, h)
  sql.Query(string.format(
    [[replace into iconic_icons(className, icon, w, h) values(%s, %s, %d, %d)]],
    SQLStr(className),
    SQLStr(icon),
    w,
    h
  ))
  net.Start('iconic.setIcon')
  net.WriteString(className)
  net.WriteBool(true)
  net.WriteString(icon)
  net.WriteUInt(w, 16)
  net.WriteUInt(h, 16)
  net.Broadcast()
end

local function resetIcon(className)
  sql.Query(string.format(
    [[delete from iconic_icons where className = %s]],
    SQLStr(className)
  ))
  net.Start('iconic.setIcon')
  net.WriteString(className)
  net.WriteBool(false)
  net.Broadcast()
end

local function getJsonData()
  local res = sql.Query([[select * from iconic_icons]])
  if res then
    return util.TableToJSON(res, true)
  end
end

local function importJsonData(data)
  local dataTable = util.JSONToTable(data)
  for _, icon in ipairs(dataTable) do
    if icon.className and icon.icon and icon.w and icon.h then
      setIcon(icon.className, icon.icon, icon.w, icon.h)
    end
  end
end

util.AddNetworkString('iconic.requestIcon')
util.AddNetworkString('iconic.setIcon')
util.AddNetworkString('iconic.resetIcon')
util.AddNetworkString('iconic.requestAllIcons')
util.AddNetworkString('iconic.sendAllIcons')
util.AddNetworkString('iconic.exportIconData')
util.AddNetworkString('iconic.importIconData')

net.Receive('iconic.requestIcon', function(len, ply)
  local className = net.ReadString()
  local icon, w, h = getIcon(className)
  local present = not not icon
  net.Start('iconic.setIcon')
    net.WriteString(className)
    net.WriteBool(present)
    if present then
      net.WriteString(icon)
      net.WriteUInt(w, 16)
      net.WriteUInt(h, 16)
    end
  net.Send(ply)
end)

net.Receive('iconic.requestAllIcons', function(len, ply)
  if not iconic.canEditIcons(ply) then return end
  local res = sql.Query(string.format(
    [[select distinct icon, w, h from iconic_icons]]
  )) or {}
  net.Start('iconic.sendAllIcons')
    net.WriteUInt(#res, 16)
    for i = 1, #res do
      local icon = res[i]
      net.WriteString(icon.icon)
      net.WriteUInt(icon.w, 16)
      net.WriteUInt(icon.h, 16)
    end
  net.Send(ply)
end)

net.Receive('iconic.setIcon', function(len, ply)
  if not iconic.canEditIcons(ply) then return end
  local className = net.ReadString()
  local icon = net.ReadString()
  local w = net.ReadUInt(16)
  local h = net.ReadUInt(16)
  setIcon(className, icon, w, h)
end)

net.Receive('iconic.resetIcon', function(len, ply)
  if not iconic.canEditIcons(ply) then return end
  local className = net.ReadString()
  resetIcon(className)
end)

net.Receive('iconic.exportIconData', function(len, ply)
  if not iconic.canEditIcons(ply) then return end
  local fileName = net.ReadString()
  local data = getJsonData()
  net.Start('iconic.exportIconData')
    net.WriteString(fileName)
    net.WriteString(data)
  net.Send(ply)
end)

net.Receive('iconic.importIconData', function(len, ply)
  if not iconic.canEditIcons(ply) then return end
  local fileName = net.ReadString()
  local data = net.ReadString()
  importJsonData(data)
  net.Start('iconic.importIconData')
    net.WriteString(fileName)
  net.Send(ply)
end)
