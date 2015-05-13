Weapon = {};
Weapon_mt = { __index = Weapon };

AmmoTypes = { "" };
FireModes = { SA = "Semi-Auto", BF = "Burst-Fire", FA = "Full-Auto" };
DamageTypes = { P = "Physical", S = "Stun" };
DeviceRatings = {
  [1] = { type = "Simple", Examples = "General appliances, public terminals, entertainment systems" },
  [2] = { type = "Average", Examples = "Standard personal electronics, basic cyberware, vehicles, drones, weapons, residential security devices" },
  [3] = { type = "Smart", Examples = "Security vehicles, alphaware, corporate security devices" },
  [4] = { type = "Advanced", Examples = "High-end devices, betaware, military vehicles, and mil-spec security devices" },
  [5] = { type = "Cutting Edge", Examples = "Deltaware, credsticks, black-ops vehicles and security devices" },
  [6] = { type = "Bleeding Edge", Examples = "Billion-nuyen experiemental devices, space craft" },
};

function Weapon:New( args )
    --self.name = args.name;
    self.skill = args.skill;
    self.accuracy = args.accuracy or args.acc;
    self.reach = args.reach;
    self.damage = args.damage or args.dmg;
    self.damage_type = args.damage_type or args.dmg_type;
    self.armor_penetration = args.armor_penetration or args.ap;
    self.mode = args.mode;
    self.recoil_compensation = args.recoil_compensation or args.rc;
    self.ammo = args.ammo;
    self.ammo_type = args.ammo_type;
end

Weapons = {
    ["Combat Axe"] = Weapon:New{ skill = "blades", acc = 4, reach = 2, dmg_att = "str", dmg_mod = 5, dmg_type = "P", ap = 4, avail = 12, r = true, cost = 4000 },
    ["Combat Knife"] = Weapon:New{ skill = "blades", acc = 6, reach = 0, dmg_att = "str", dmg_mod = 2, dmg_type = "P", ap = 3, avail = 4, r = false, cost = 300 },
};