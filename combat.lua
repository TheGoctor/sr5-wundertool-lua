-- Functions for managing combat turns

require "character"

-- critters = { blue = Critter, red = Dog, etc }
function InitWave(players, critters)
    local wave = players;

    for id, class in pairs(critters) do
        local critter = Character(class);
        critter.name = critter.name .. "_" .. id;
        table.insert(wave, critter);
    end

    return wave;
end

function BeginTurn(players)
    init_table = {};
    --init_table[1] = {};
    players = players or Character.__registry;

    for i,v in pairs(players) do
        table.insert(init_table, {c=v,i=v:RollInitiative()});
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

    print("Initiative Order:");
    for i,v in ipairs(init_table) do
        print(i .. " " .. v.c.name .. " : " .. v.i);
    end
end

function NextPlayer()
    local pass = 1;
    while init_table[pass] == {} do
        pass = pass + 1;
    end

    if not init_table[pass] then
        print("Turn has ended. Re-roll initiatives.");
        return;
    end

    local player = init_table[pass][1];
end

function QuickCombat( attacker, weapon_name, defender )
    local hits, weapon = attacker:Attack(weapon_name, 0);
    local damage = defender:Defend(hits, weapon, 0);
end
