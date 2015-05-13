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

function InitWave1()
    dog1 = Character( Dog );
    dog1.name = "dog1";
    dog2 = Character( Dog );
    dog2.name = "dog2";
    dog3 = Character( Dog );
    dog3.name = "dog3";
    dog4 = Character( Dog );
    dog4.name = "dog4";
    dog5 = Character( Dog );
    dog5.name = "dog5";
    hound1 = Character( HellHound );
    hound1.name = "hound1";
    hound2 = Character( HellHound );
    hound2.name = "hound2";
    barghest = Character( Barghest );
    barghest.name = "barghest";
    mage = Character( Darrick );
    mage.name = "Darrick";
    owl = Character( EagleOwl );
    owl.name = "owl";
end

function InitWave2()
    local wave2 = {};
    scout1 = Character( NeoTribalScout );
    scout1.name = "scout1";
    table.insert(wave2, scout1);
    scout2 = Character( NeoTribalScout );
    scout2.name = "scout2";
    table.insert(wave2, scout2);
    scout3 = Character( NeoTribalScout );
    scout3.name = "scout3";
    table.insert(wave2, scout3);
    piasma = Character( Piasma );
    piasma.name = "piasma";
    table.insert(wave2, piasma);
    warrior1 = Character( NeoTribalWarrior );
    warrior1.name = "warrior1";
    table.insert(wave2, warrior1);
    warrior2 = Character( NeoTribalWarrior );
    warrior2.name = "warrior2";
    table.insert(wave2, warrior2);
    warrior3 = Character( NeoTribalWarrior );
    warrior3.name = "warrior3";
    table.insert(wave2, warrior3);
    warrior4 = Character( NeoTribalWarrior );
    warrior4.name = "warrior4";
    table.insert(wave2, warrior4);
    warrior5 = Character( NeoTribalWarrior );
    warrior5.name = "warrior5";
    table.insert(wave2, warrior5);
    warrior6 = Character( NeoTribalWarrior );
    warrior6.name = "warrior6";
    table.insert(wave2, warrior6);

    --BeginTurn(wave2);
end

function InitWave3(players, hardmode)
    local wave3 = players;
    warrior1 = Character( NeoTribalWarrior );
    warrior1.name = "warrior1";
    table.insert(wave3, warrior1);
    warrior2 = Character( NeoTribalWarrior );
    warrior2.name = "warrior2";
    table.insert(wave3, warrior2);
    warrior3 = Character( NeoTribalWarrior );
    warrior3.name = "warrior3";
    table.insert(wave3, warrior3);
    warrior4 = Character( NeoTribalWarrior );
    warrior4.name = "warrior4";
    table.insert(wave3, warrior4);
    piasma1 = Character( Piasma );
    piasma1.name = "piasma1";
    table.insert(wave3, piasma1);
    table.insert(wave3, Daughter);
    
    if hardmode then
      warrior5 = Character( NeoTribalWarrior );
      warrior5.name = "warrior5";
      table.insert(wave3, warrior5);
      warrior6 = Character( NeoTribalWarrior );
      warrior6.name = "warrior6";
      table.insert(wave3, warrior6);
      piasma2 = Character( Piasma );
      piasma2.name = "piasma2";
      table.insert(wave3, piasma2);
    end
    
    return wave3;
end

--InitWave1();
--InitWave2();
local hardmode = false;
local peeps = InitWave3({Albert,Tommy,George,Alex,Jason}, hardmode);

--BeginTurn(peeps);

--defender:Defend(attack_hits, attacker.weapon.name);
--piasma1:Defend(1, Tommy.weapon.taurus_omni6);
--piasma1:Defend(1, George.weapon.as7);
--piasma1:Defend(8, Alex.weapon.katana);
--warrior1:Defend(5, Albert.weapon.unarmed);
--warrior1:Defend(5, George.weapon.ruger_shawk);
--warrior1:Defend(5, Tommy.weapon.taurus_omni6);
--warrior1:Defend(5, Jason.weapon.ares_alpha);
--warrior1:Defend(3, Alex.weapon.katana);
Daughter:Defend(5, Albert.weapon.unarmed);


--TestCombat(piasma1, "bite", Alex);
--TestCombat(warrior1, "ak97", Albert);
--TestCombat(warrior1, "spear", Jason);
--TestCombat(Daughter, "bite", warrior1);
