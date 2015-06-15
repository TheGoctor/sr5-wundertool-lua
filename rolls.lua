--------------------------------------------------------------------------------
-- Functions for performing dice rolls in Shadowrun 5th Edition.
-- @author Mac Reichelt
-- @copyright Copyright (c) 2015 Mac Reichelt
--------------------------------------------------------------------------------

-- Seed random by the current time
local current_time = os.time();
print("Seed: " .. current_time);
math.randomseed(current_time);

--------------------------------------------------------------------------------
-- Performs a dice roll for any test in Shadowrun.
-- @param dice_count The number of dice to roll.
-- @param is_exploding Whether sixes cause additional dice to be rolled.
-- @return The number of hits
-- @return The number of misses
-- @return The sum of all dice rolled
--------------------------------------------------------------------------------
function Roll(dice_count, is_exploding)
    local hits, misses, sum = 0, 0, 0;
    local dice = {};

    for i = 1, dice_count do
        local die = math.random(6);
        if die >= 5 then
            hits = hits + 1;

            if is_exploding and die == 6 then
                dice_count = dice_count + 1;
            end
        elseif die == 1 then
            misses = misses + 1;
        end

        sum = sum + die;
        table.insert(dice, die);
    end

    if misses > dice_count / 2 then
        if hits == 0 then
            print("Critical Glitch!");
        else
            print("Glitch!");
        end
    end

    if verbose then
        -- Sort the dice to make it easier to look at
        table.sort(dice);
        print(table.concat(dice, ' '));
        print(hits .. " hits!");
    end

    return hits, misses, sum;
end
