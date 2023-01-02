local sourceWeapons = {
  weapon_crowbar = true,
  weapon_pistol = true,
  weapon_smg1 = true,
  weapon_frag = true,
  weapon_physcannon = true,
  weapon_crossbow = true,
  weapon_shotgun = true,
  weapon_357 = true,
  weapon_rpg = true,
  weapon_ar2 = true,
  gmod_tool = true,
  gmod_camera = true,
  weapon_physgun = true,
  weapon_slam = true,
  weapon_bugbait = true,
  weapon_stunstick = true,
}

function iconic.isValidWeaponClass(className)
  return sourceWeapons[className] or weapons.GetStored(className)
end
