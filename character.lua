-- Character Table Creator

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

function Character:New( args )
    for k,v in pairs( args or {}) do
        self[k] = v;
    end
end

function Character:Attack( weapon_name, mods )
    local weapon = self.weapon[ weapon_name ];
    if weapon.skill == "unarmed" then
        weapon = self:GetUnarmed();
    end
    local limit = weapon.acc;
    local pool = self:GetSkillLevel( weapon.skill ) + (mods or 0) + (ENV_MODS or 0);
    if verbose then
      print( self.name .. " is attacking with a pool of " .. pool );
    end
    local hits = Roll( pool );
    return math.min( hits, limit ), weapon;
end

function Character:Defend( attack_hits, attack_weapon, mods )
    -- Reaction + Intuition +/- Modifiers
    local pool = self.rea + self.int + (mods or 0) + (ENV_MODS or 0);

    if verbose then
      print( self.name .. " is defending with a pool of " .. pool );
    end
    local defend_hits = Roll( pool );

    local net_hits = attack_hits - defend_hits;
    if net_hits < 0 then
        -- Miss
        print( "Miss!" );
        return;
    elseif net_hits == 0 then
        -- Grazing Hit (No direct damage, but still effect damage)
        print( "Grazing Hit!" );
        return;
    else
        -- Hit!
        print( "Hit with " .. net_hits .. " net hits!" );
    end

    local modified_damage = attack_weapon.dmg + net_hits;
    local modified_armor = self.armor_rating - attack_weapon.ap;
    if verbose then
      print( "Weapon Damage: " .. attack_weapon.dmg );
      print( "Modified Damage: " .. modified_damage );
      print( "Armor Rating: " .. self.armor_rating );
      print( "Modified Armor: " .. modified_armor );
    end

    local damage_type = (modified_damage >= modified_armor) and "Physical" or "Stun";
    print( damage_type .. " Damage!" );

    -- Resist Damage
    local resist_pool = self.bod + math.max(modified_armor, 0);
    print( self.name .. " is resisting with a pool of " .. resist_pool );
    damage_taken = math.max(modified_damage - Roll(resist_pool), 0);
    print( self.name .. " took " .. damage_taken .. " " .. damage_type .. " damage!" );
    print( self.name .. " has a max physical condition limit of " .. self:MaxPhysicalCondition() );
end

function Character:GetSkillLevel( skill_name )
    local skill = self.skills[ skill_name ];
    local level = skill.pool or (skill.rating + skill.mod + self[ skill.att ]);
    -- Handle untrained skills
    if skill.rating == 0 then
      return self[ skill.att ] - 1;
    end
    return level;
end

function Character:GetUnarmed()
    -- See if the character already has an unarmed weapon
    local weapon = self.weapon["unarmed"] or self.weapon["bite"] or self.weapon["claws"] or {};
    weapon.acc = weapon.acc or self:GetLimit( "physical" );
    weapon.dmg = weapon.dmg or self.str;
    weapon.ap = weapon.ap or 0;
    weapon.reach = weapon.reach or 0;
    weapon.skill = "unarmed";
    return weapon;
end

function Character:GetLimit( limit_type )
    local limit = 0;
    if limit_type == "physical" then
        limit = math.ceil(( self.str * 2 + self.bod + self.rea ) / 3); -- Round up
    elseif limit_type == "mental" then
        limit = math.ceil(( self.log * 2 + self.int + self.wil ) / 3); -- Round up
    elseif limit_type == "social" then
        limit = math.ceil(( self.cha * 2 + self.wil + self.ess ) / 3); -- Round up
    elseif limit_type == "astral" then
        limit = math.max( self:GetLimit( "mental" ), self:GetLimit( "social" ) );
    end
    return limit;
end

function Character:TakePhysicalDamage( dmg )
    self.physicalDamage = (self.physicalDamage or 0) - (dmg or 0);
end

function Character:TakeStunDamage( dmg )
    self.stunDamage = (self.stunDamage or 0) - (dmg or 0);
end

function Character:MaxPhysicalCondition()
    return math.ceil(self.bod / 2) + 8;
end

function Character:MaxStunCondition()
    return math.ceil(self.wil / 2) + 8;
end

function Character:RollInit( mods )
    local pool = self.init_dice;
    local h, m, sum = Roll( pool );
    local init = self.rea + self.int + sum + (mods or 0);
    print( self.name .. " rolled initiative of " .. init );
    return init;
end

function Character:ListSkills()
    print( "Listing " .. self.name .. "'s skills:" );
    for k,v in pairs( self.skills ) do
        print( "  " .. k );
    end
end

function Character:ListWeapons()
    print( "Listing " .. self.name .. "'s weapons:" );
    for k,v in pairs( self.weapon ) do
        print( "  " .. k );
    end
end

function TestCombat( att, awep, def )
    local hits, wep = att:Attack( awep, 0 );
    local dmg = def:Defend( hits, wep, 0 );
end
