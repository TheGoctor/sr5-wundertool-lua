--------------------------------------------------------------------------------
-- Character class definition.
--
-- @author Mac Reichelt
-- @copyright Copyright (c) 2015 Mac Reichelt
--------------------------------------------------------------------------------

require "rolls"

-- Class initialization
Character = {};
Character.__index = Character;
Character.__registry = {};

setmetatable(Character, {
    __call = function (cls, ...)
        local self = setmetatable({}, cls)
        self:New(...);
        -- Save record of all characters
        table.insert(Character.__registry, self);
        return self;
    end,
})

--------------------------------------------------------------------------------
-- Constructor
--
-- @param args Table of arguments for Character initialization.
--------------------------------------------------------------------------------
function Character:New(args)
    for k,v in pairs(args or {}) do
        self[k] = v;
    end
end

--------------------------------------------------------------------------------
-- Performs an attack with the specified weapon. Calculates the total dice pool
-- for the attack, and rolls to determine the number of hits.
--
-- @param weapon_name The name of the weapon as stored in the character's weapon
-- table. I.e. self.weapon[weapon_name]
-- @param modifier Any additional modifier to apply to the dice pool for this
-- roll, outside of wound modifiers. Defaults to 0.
-- @return The number of hits scored, with a maximum of the appropriate limit.
-- @return A reference to the weapon that was used.
--------------------------------------------------------------------------------
function Character:Attack(weapon_name, modifier)
    local weapon = self.weapon[weapon_name];

    -- Special rules since the "unarmed" weapon is based on character stats.
    if weapon.skill == "unarmed" then
        weapon = self:GetUnarmed();
    end

    local limit = weapon.acc;

    -- Apply wound modifiers
    modifier = (modifier or 0) + self:GetWoundModifiers();

    local pool = self:GetSkillLevel(weapon.skill) + modifier;
    if verbose then
        print(self.name .. " is attacking with a pool of " .. pool);
    end
    local hits = Roll(pool);
    return math.min(hits, limit), weapon;
end

--------------------------------------------------------------------------------
-- Performs the rolls to defend against an attack, and rolls to resist damage,
-- if necessary.
--
-- @param attack_hits The number of hits scored by the attacker.
-- @param attack_weapon A reference to the weapon used by the attacker.
-- @param modifier Any additional modifier to apply to the dice pool for this
-- roll, outside of wound modifiers.
--------------------------------------------------------------------------------
function Character:Defend(attack_hits, attack_weapon, modifier)
    -- Reaction + Intuition +/- Modifiers
    modifier = (modifier or 0) + self:GetWoundModifiers();
    local pool = self.rea + self.int + modifier + (ENV_MODS or 0);

    if verbose then
        print(self.name .. " is defending with a pool of " .. pool);
    end
    local defend_hits = Roll(pool);

    local net_hits = attack_hits - defend_hits;
    if net_hits < 0 then
        -- Miss
        print("Miss!");
        return;
    elseif net_hits == 0 then
        -- Grazing Hit (No direct damage, but still effect damage)
        print("Grazing Hit!");
        return;
    else
        -- Hit!
        print("Hit with " .. net_hits .. " net hits!");
    end

    local modified_damage = attack_weapon.dmg + net_hits;
    local modified_armor = self.armor_rating - attack_weapon.ap;
    if verbose then
        print("Weapon Damage: " .. attack_weapon.dmg);
        print("Modified Damage: " .. modified_damage);
        print("Armor Rating: " .. self.armor_rating);
        print("Modified Armor: " .. modified_armor);
    end

    local damage_type = (modified_damage >= modified_armor) and "P" or "S";

    -- Resist Damage
    local resist_pool = self.bod + math.max(modified_armor, 0);
    print(self.name .. " is resisting with a pool of " .. resist_pool);
    damage_taken = math.max(modified_damage - Roll(resist_pool), 0);
    print(self.name .. " took " .. damage_taken .. damage_type .. " damage!");
    if damage_type == "P" then
        self:TakePhysicalDamage(damage_taken);
    elseif damage_type == "S" then
        self:TakeStunDamage(damage_taken);
    end
end

--------------------------------------------------------------------------------
-- Gets the dice pool size for performing a skill test. The untrained
-- penalty is applied.
--
-- @param skill_name The name of the skill as it is stored in the character's
-- skills table. I.e self.skills[skill_name].
-- @return The pool size for the specified skill.
--------------------------------------------------------------------------------
function Character:GetSkillLevel(skill_name)
    local skill = self.skills[skill_name];
    local level = skill.pool or (skill.rating + skill.mod + self[skill.att]);

    -- Handle untrained skills
    if skill.rating == 0 then
      return self[skill.att] - 1;
    end

    return level;
end

--------------------------------------------------------------------------------
-- Creates a Weapon table to describe the character's unarmed attacks.
--
-- @return Table of the character's unarmed weapon.
--------------------------------------------------------------------------------
function Character:GetUnarmed()
    -- See if the character already has an unarmed weapon
    local weapon = self.weapon["unarmed"] or self.weapon["bite"] or self.weapon["claws"] or {};
    weapon.acc = weapon.acc or self:GetLimit("physical");
    weapon.dmg = weapon.dmg or self.str;
    weapon.ap = weapon.ap or 0;
    weapon.reach = weapon.reach or 0;
    weapon.skill = "unarmed";
    return weapon;
end

--------------------------------------------------------------------------------
-- Gets the specified limit.
--
-- @param limit_type ["physical"|"mental"|"social"|"astral"]
-- @return The requested limit.
--------------------------------------------------------------------------------
function Character:GetLimit(limit_type)
    local limit = 0;

    if limit_type == "physical" then
        limit = math.ceil((self.str * 2 + self.bod + self.rea) / 3); -- Round up
    elseif limit_type == "mental" then
        limit = math.ceil((self.log * 2 + self.int + self.wil) / 3); -- Round up
    elseif limit_type == "social" then
        limit = math.ceil((self.cha * 2 + self.wil + self.ess) / 3); -- Round up
    elseif limit_type == "astral" then
        limit = math.max(self:GetLimit("mental"), self:GetLimit("social"));
    end

    return limit;
end

--------------------------------------------------------------------------------
-- Applies damage to the character as physical damage, and will print out
-- whether the character is dead or dying.
--
-- @param damage The amount of physical damage to be taken.
--------------------------------------------------------------------------------
function Character:TakePhysicalDamage(damage)
    -- Initialize physicalDamage if necessary
    self.physicalDamage = (self.physicalDamage or 0) + (damage or 0);
    local overflow = self.physicalDamage - self:MaxPhysicalCondition();
    if overflow > 0 then
        if overflow > self.bod then
            print(self.name .. " is dead :'(");
        else
            print(self.name .. " is dying!");
        end
    end
end

--------------------------------------------------------------------------------
-- Applies damage to the character as stun damage. Overflow stun damage will be
-- converted to physical damage at the rate of 2:1.
--
-- @param damage The amount of stun damage to be taken.
--------------------------------------------------------------------------------
function Character:TakeStunDamage(damage)
    -- Initialize stunDamage if necessaary
    self.stunDamage = (self.stunDamage or 0) + (dmg or 0);
    local overflow = self.stunDamage - self:MaxStunCondition();
    if overflow > 0 then
        local overflowDamage = math.floor(overflow / 2);
        self.stunDamage = self:MaxStunCondition() + (overflow - overflowDmg * 2);
        self:TakePhysicalDamage(overflowDamage);
    end
end

--------------------------------------------------------------------------------
-- Calculates the total penalty to a character's rolls suffered by physical and
-- stun wounds.
--
-- @return The negative modifier to apply to all applicable rolls.
--------------------------------------------------------------------------------
function Character:GetWoundModifiers()
    -- Initialize if necessary
    self.stunDamage = self.stunDamage or 0;
    self.physicalDamage = self.physicalDamage or 0;

    local mod =
        math.floor(math.min(self.stunDamage, self:MaxStunCondition()) / 3) +
        math.floor(math.min(self.physicalDamage, self:MaxPhysicalCondition()) / 3);
    return -mod;
end

--------------------------------------------------------------------------------
-- Gets the number of boxes in the character's Physical Condition Monitor.
--
-- @return The number of boxes in the Physical Condition Monitor.
--------------------------------------------------------------------------------
function Character:MaxPhysicalCondition()
    return math.ceil(self.bod / 2) + 8;
end

--------------------------------------------------------------------------------
-- Gets the number of boxes in the character's Stun Condition Monitor.
--
-- @return The number of boxes in the Stun Condition Monitor.
--------------------------------------------------------------------------------
function Character:MaxStunCondition()
    return math.ceil(self.wil / 2) + 8;
end

--------------------------------------------------------------------------------
-- Calculates the character's Initiative Score.
--
-- @param score_modifier Any additional modifier to apply directly to the
-- initiative score, outside of wound modifiers.
-- @param dice_modifier Any modifier to apply to the dice pool for calculating
-- the initiative score.
--------------------------------------------------------------------------------
function Character:RollInitiative(score_modifier, dice_modifier)
    local pool = self.init_dice + (dice_modifier or 0);
    local _, _, sum = Roll(pool);

    score_modifier = (score_modifier or 0) + self:GetWoundModifiers();

    -- TODO: Roll initiatives for different combat spaces (e.g. astral, matrix)
    local init = self.rea + self.int + sum + modifier;
    print(self.name .. " rolled initiative of " .. init);

    return init;
end

--------------------------------------------------------------------------------
-- Prints all the names of each skill known by the character.
--------------------------------------------------------------------------------
function Character:ListSkills()
    print("Listing " .. self.name .. "'s skills:");
    for k,v in pairs(self.skills) do
        print("  " .. k);
    end
end

--------------------------------------------------------------------------------
-- Prints all the names of each weapon in the character's inventory.
--------------------------------------------------------------------------------
function Character:ListWeapons()
    print("Listing " .. self.name .. "'s weapons:");
    for k,v in pairs(self.weapon) do
        print("  " .. k);
    end
end

--------------------------------------------------------------------------------
-- Performs all the rolls associated with this character casting a spell. If the
-- spell targets another character, that player's defensive rolls are also
-- handled here.
--
-- @param spell_name The name of the spell as stored in the character's spell
-- list. I.e. self.spells[spell_name]
-- @param force The force of the spell.
-- @param defenders An array of all the targets of the spell. I.e. { defender1 }
--------------------------------------------------------------------------------
function Character:CastSpell(spell_name, force, defenders)
    local spell = self.spells[spell_name];
    local pool = self:GetSkillLevel("spellcasting");
    -- Apply wound modifiers
    pool = pool + self:GetWoundModifiers();
    local drain_damage_type = ""
    if verbose then
        print(self.name .. " is casting " .. spell_name .. " with a pool of " .. pool);
    end

    -- Max force is MAGIC * 2
    force = math.min(force, self.mag * 2);
    if verbose then
        print("Force is " .. force);
    end

    local hits = Roll(pool);
    hits = math.min(hits, force);

    if hits > self.mag then
        drain_damage_type = "P";
    else
        drain_damage_type = "S";
    end

    -- Roll for Damage
    for i, defender in ipairs(defenders or {}) do
        local defPool = 0;
        local damage = 0;
        if spell.direct == true then
            if spell.type == "P" then
                defPool = defender.bod;
            elseif spell.type == "M" then
                defPool = defender.wil;
            end
        elseif spell.direct == false then
            defPool = defender.rea + defender.int;
            damage = force;
        end
        if verbose then
            --print( defender.name .. " is defending with " .. defPool );
        end
        defPool = defPool + defender:GetWoundModifiers();
        local defHits = Roll(defPool);
        damage = damage + hits - defHits;

        -- If indirect, defender can resist Damage
        if spell.direct == false then
            local h = Roll(defender.bod + defender.armor_rating - force);
            print(defender.name .. " resists " .. h .. " points of damage!");
            damage = damage - h;
        end

        print(defender.name .. " takes " .. damage .. (spell.dmg or "") .. " damage!");
        if spell.dmg == "P" then
            defender:TakePhysicalDamage(damage);
        elseif spell.dmg == "S" then
            defender:TakeStunDamage(damage);
        end
    end

    -- Drain can't be lower than 2
    local drain = math.max(force + spell.drain, 2);
    local drainResist = self.log + self.wil;
    if verbose then
        print("Resisting drain of " .. drain .. " with pool of " .. drainResist);
    end

    local dHits = Roll(drainResist);
    local drainDamage = math.max(drain - dHits, 0);
    if verbose then
        print(self.name .. " takes " .. drainDamage .. drain_damage_type .. " damage from drain!");
        if drain_damage_type == "P" then
            self:TakePhysicalDamage(drainDamage);
        elseif drain_damage_type == "S" then
            self:TakeStunDamage(drainDamage);
        end
        if spell.page then
            print("Read more on page " .. spell.page);
        end
    end
end
