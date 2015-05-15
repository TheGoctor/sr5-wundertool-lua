-- Lua functions for SR5 rolls

print "Begin!";

require "utils"
require "character"
require "players"
require "npcs"

print( os.time() );
math.randomseed(os.time());

ENV_MODS = 0;
verbose = true;

function Roll(num, sides)
    local hits, misses, sum = 0, 0, 0;
    local dice = {};

    for i = 1, num do
        local die = math.random(sides or 6);
        if die >= 5 then
            hits = hits + 1;
        elseif die == 1 then
            misses = misses + 1;
        end
        sum = sum + die;
        table.insert( dice, die );
    end

    if misses > num / 2 then
        if hits == 0 then
            print( "Critical Glitch!" );
        else
            print( "Glitch!" );
        end
    end

    if verbose then
        table.sort( dice );
        print( table.concat( dice, ' ' ) );
        print( hits .. " hits!" );
    end

    return hits, misses, sum;
end

function SetWind( wind )

end

function GetRangeMod( dist_meters )

end

function BeginTurn(players)
    init_table = {};
    --init_table[1] = {};
    players = players or Character.__registry;

    for i,v in pairs(players) do
        table.insert(init_table, {c=v,i=v:RollInit()});
    end

    table.sort(init_table, function(a,b)
        if a.i ~= b.i then
            return a.i > b.i;
        elseif a.c.edg ~= b.c.edg then
            return a.c.edg > b.c.edg;
        elseif a.c.rea ~= b.c.rea then
            return a.c.rea > b.c.rea;
        elseif a.c.int ~= b.c.int then
            return a.c.int > b.c.int;
        else
            -- Determine by coin toss
            return (math.random(2) == 1);
        end
    end);

    print( "Initiative Order:" );
    for i,v in ipairs( init_table ) do
        print(i .. " " .. v.c.name .. " : " .. v.i);
    end
end

function NextPlayer()
    local pass = 1;
    while init_table[pass] == {} do
        pass = pass + 1;
    end

    if not init_table[pass] then
        print( "Turn has ended. Re-roll initiatives.");
        return;
    end

    local player = init_table[pass][1];
end

function InitWave1(players, minionCount)
    local wave = players;

    for i = 1, minionCount or 0 do
        local shedim = Character( Shedim );
        shedim.name = "shedim" .. i;
        table.insert(wave, shedim);
    end

    --table.insert(wave, Doctor);

    return wave;
end

local peeps = InitWave1({Albert,Tommy,George,Alex,Jason}, 6);
--BeginTurn(peeps);

local shedim = Character(Shedim);

--defender:Defend(attack_hits, attacker.weapon.name);
--shedim:Defend(1, Tommy.weapon.taurus_omni6);
--shedim:Defend(1, George.weapon.as7);
--shedim:Defend(8, Alex.weapon.katana);
--shedim:Defend(5, Albert.weapon.unarmed);
--shedim:Defend(5, George.weapon.ruger_shawk);
--shedim:Defend(5, Jason.weapon.ares_alpha);

--TestCombat(shedim, "unarmed", Alex);
--TestCombat(Doctor, "unarmed", Albert);
--TestCombat(Spazz, "unarmed", Albert);

--Doctor:CastSpell("armor", 6);
--Doctor:CastSpell("ball_lightning", 6, {Albert, Alex});
--Doctor:CastSpell("death_touch", 6, {Albert});
--Doctor:CastSpell("detect_life", 6);
--Doctor:CastSpell("levitate", 6);
--Doctor:CastSpell("powerbolt", 6, {Albert});
--Doctor:CastSpell("poltergeist", 6);
--Doctor:CastSpell("toxic_wave", 6, {Albert});
