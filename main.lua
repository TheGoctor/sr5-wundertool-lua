-- Program entry point

require "rolls"
require "combat"
require "utils"
require "players"
require "npcs"

ENV_MODS = 0;
verbose = true;

local peeps = InitWave(
    {Albert, Tommy, George, Alex, Jason, Spazz},
    {}
);

-- Set attribute modifiers
Tommy.agi = Tommy.agi - 1;
Tommy.rea = Tommy.rea - 1;
Albert.agi = Albert.agi - 1;
Albert.rea = Albert.rea - 1;

-- Set players' wounds
Jason:TakeStunDamage(4);
Jason:TakePhysicalDamage(15);
Albert:TakeStunDamage(24);
Albert:TakePhysicalDamage(13);
Tommy:TakeStunDamage(17);
Alex:TakeStunDamage(18);
Alex:TakePhysicalDamage(21);
Spazz:TakePhysicalDamage(4);
Doctor:TakeStunDamage(1);
Doctor:TakePhysicalDamage(20);

--BeginTurn(peeps);

--local shedim = Character(Shedim);
-- Set for the shedim currently attacking/defending
--shedim:TakeStunDamage(0);
--shedim:TakePhysicalDamage(11);

--defender:Defend(attack_hits, attacker.weapon.name);
--Doctor:Defend(1, Tommy.weapon.taurus_omni6);
--Doctor:Defend(5, George.weapon.fnhar);
--shedim:Defend(4, Alex.weapon.katana);
--shedim:Defend(1, Alex.weapon.ares_predator_5);
--Doctor:Defend(7, Albert.weapon.unarmed);
--shedim:Defend(5, George.weapon.ruger_shawk);
--shedim:Defend(5, Jason.weapon.ares_alpha);
--shedim:Defend(2, Jason.weapon.mono_whip);

--TestCombat(shedim, "unarmed", Albert);
--TestCombat(Doctor, "unarmed", Albert);
--TestCombat(Spazz, "unarmed", shedim);
--TestCombat(Tommy, "taurus_omni6", shedim);

--Doctor:CastSpell("armor", 6);
--Doctor:CastSpell("ball_lightning", 9, {Albert, Alex, Jason, shedim});
--Doctor:CastSpell("death_touch", 6, {Albert});
--Doctor:CastSpell("detect_life", 6);
--Doctor:CastSpell("levitate", 6);
--Doctor:CastSpell("powerbolt", 12, {Tommy});
--Doctor:CastSpell("poltergeist", 6);
--Doctor:CastSpell("toxic_wave", 6, {Albert});

--Roll(shedim.mag + shedim.agi)
