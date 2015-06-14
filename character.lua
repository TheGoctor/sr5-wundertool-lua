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

    -- Apply wound modifiers
    mods = (mods or 0) + self:GetWoundModifiers();

    local pool = self:GetSkillLevel( weapon.skill ) + mods + (ENV_MODS or 0);
    if verbose then
        print( self.name .. " is attacking with a pool of " .. pool );
    end
    local hits = Roll( pool );
    return math.min( hits, limit ), weapon;
end

function Character:Defend( attack_hits, attack_weapon, mods )
    -- Reaction + Intuition +/- Modifiers
    mods = (mods or 0) + self:GetWoundModifiers();
    local pool = self.rea + self.int + mods + (ENV_MODS or 0);

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

    local damage_type = (modified_damage >= modified_armor) and "P" or "S";

    -- Resist Damage
    local resist_pool = self.bod + math.max(modified_armor, 0);
    print( self.name .. " is resisting with a pool of " .. resist_pool );
    damage_taken = math.max(modified_damage - Roll(resist_pool), 0);
    print( self.name .. " took " .. damage_taken .. damage_type .. " damage!" );
    if damage_type == "P" then
        self:TakePhysicalDamage(damage_taken);
    elseif damage_type == "S" then
        self:TakeStunDamage(damage_taken);
    end
    print( self.name .. " has a max physical condition limit of " .. self:MaxPhysicalCondition() );
    print( self.name .. " will die when damage exceeds " .. self:MaxPhysicalCondition() + self.bod .. " points.");
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
    self.physicalDamage = (self.physicalDamage or 0) + (dmg or 0);
    if self.physicalDamage > self:MaxPhysicalCondition() then
        if self.physicalDamage > self:MaxPhysicalCondition() + self.bod then
            print(self.name .. " is dead :'(");
        else
            print(self.name .. " is dying!");
        end
    end
end

function Character:TakeStunDamage( dmg )
    self.stunDamage = (self.stunDamage or 0) + (dmg or 0);
    if self.stunDamage > self:MaxStunCondition() then
        local overflow = self.stunDamage - self:MaxStunCondition();
        local overflowDmg = math.floor(overflow / 2);
        self.stunDamage = self:MaxStunCondition() + (overflow - overflowDmg * 2);
        self:TakePhysicalDamage(overflowDmg);
    end
end

function Character:GetWoundModifiers()
    self.stunDamage = self.stunDamage or 0;
    self.physicalDamage = self.physicalDamage or 0;
    local mod =
        math.floor(math.min(self.stunDamage, self:MaxStunCondition()) / 3) +
        math.floor(math.min(self.physicalDamage, self:MaxPhysicalCondition()) / 3);
    return -mod;
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
    mods = (mods or 0) + self:GetWoundModifiers();
    local init = self.rea + self.int + sum + mods;
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

function Character:CastSpell(spellName, force, defenders)
    local spell = self.spells[spellName];
    local pool = self:GetSkillLevel("spellcasting");
    -- Apply wound modifiers
    pool = pool + self:GetWoundModifiers();
    local drainDamageType = ""
    if verbose then
      print( self.name .. " is casting " .. spellName .. " with a pool of " .. pool );
    end

    -- Max force is MAGIC * 2
    force = math.min(force, self.mag * 2);
    if verbose then
        print( "Force is " .. force );
    end

    local hits = Roll(pool);
    hits = math.min(hits, force);

    if hits > self.mag then
        drainDamageType = "P";
    else
        drainDamageType = "S";
    end

    -- Roll for Damage
    for i, defender in ipairs(defenders) do
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
            print( defender.name .. " resists " .. h .. " points of damage!" );
            damage = damage - h;
        end

        print( defender.name .. " takes " .. damage .. (spell.dmg or "") .. " damage!");
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
        print( "Resisting drain of " .. drain .. " with pool of " .. drainResist );
    end

    local dHits = Roll(drainResist);
    local drainDamage = math.max(drain - dHits, 0);
    if verbose then
        print( self.name .. " takes " .. drainDamage .. drainDamageType .. " damage from drain!" );
        if drainDamageType == "P" then
            self:TakePhysicalDamage(drainDamage);
        elseif drainDamageType == "S" then
            self:TakeStunDamage(drainDamage);
        end
        if spell.page then
            print( "Read more on page " .. spell.page )
        end
    end
end

function TestCombat( att, awep, def )
    local hits, wep = att:Attack( awep, 0 );
    local dmg = def:Defend( hits, wep, 0 );
end
