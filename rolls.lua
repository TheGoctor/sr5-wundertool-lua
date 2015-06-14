-- Lua functions for SR5 rolls

local current_time = os.time();
print("Seed: " .. current_time);
math.randomseed(current_time);

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
        table.insert(dice, die);
    end

    if misses > num / 2 then
        if hits == 0 then
            print("Critical Glitch!");
        else
            print("Glitch!");
        end
    end

    if verbose then
        table.sort(dice);
        print(table.concat(dice, ' '));
        print(hits .. " hits!");
    end

    return hits, misses, sum;
end
