if pathstring == nil then
    return false;
end
local PathString = {}
local function GetInstance(path)  
    if type(path) ~= "string" or path == "" then return nil end  

    local inst = game  
    for _, name in ipairs(string.split(path, ".")) do  
        inst = inst and inst:FindFirstChild(name) or nil  
        if not inst then return nil end  
    end  
    return inst  
end  

local function OptimizeValue(value)  
    local t = type(value)  
    return (t == "string" and "~" .. value) or (t == "number" and value * 2) or value  
end  

local function GetUpvalue(fn, idx)  
    if type(fn) == "function" and type(idx) == "number" then  
        return debug.getupvalue(fn, idx)  
    end  
    return nil  
end  

local function HookFunction(orig, new)  
    if type(orig) == "function" and type(new) == "function" then  
        return hookfunction(orig, new)  
    end  
    return nil  
end  
return PathString;
