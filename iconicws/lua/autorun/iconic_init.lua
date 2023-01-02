AddCSLuaFile()
AddCSLuaFile('iconic_config.lua')
AddCSLuaFile('iconic/shared.lua')
AddCSLuaFile('iconic/cl_init.lua')
AddCSLuaFile('iconic/cl_capture.lua')
AddCSLuaFile('iconic/cl_iconlist.lua')
AddCSLuaFile('iconic/cl_binpack.lua')

iconic = iconic or {}

include('iconic_config.lua')
include('iconic/shared.lua')

if SERVER then
  include('iconic/init.lua')
else
  include('iconic/cl_init.lua')
end
