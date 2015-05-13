-- Utility functions

table.deepcopy = function ( tbl )
    local ret = {};
    for k, v in pairs( tbl ) do
        if type(v) == "table" then
            ret[k] = table.deepcopy(tbl);
        else
            ret[k] = v;
        end
    end
    return ret;
end

table.print = function ( tbl, level, tab_size )
    level = level or 0;
    tab_size = tab_size or 2;
    for k, v in pairs( tbl ) do
        print( string.rep(' ', tab_size * level) .. "[ " .. k .. " ] = " .. (type(v)~="table" and v .. ',' or "{") );
        if type(v) == "table" then
            v:print( level + 1 );
            print( string.rep(' ', tab_size * level) .. "}," );
        end
    end
end

table.reduce = function (list, fn) 
    local acc
    for k, v in ipairs(list) do
        if 1 == k then
            acc = v
        else
            acc = fn(acc, v)
        end 
    end 
    return acc 
end
