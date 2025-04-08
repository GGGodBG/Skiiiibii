local HttpService = game:GetService("HttpService")
local SaveFileName = "Save Setting Volcano"
local data2, PlayerData = userdata, data2(game.Players.LocalPlayer)
getgenv().Settings = {
   Module = {
      ["Auto Farm Level"] = false,
      ["Auto Farm Near Mob"] = false,
      ["Distance Farm Near Mob"] = 3000,
      ["Auto Random CFrame When Farming"] = math.random,
      ["Auto Farm Mastery All Sword"] = false,
      ["Auto Farm Mastery Fruit"] = false,
      ["Fully Auto Rip_Inda"] = false,
      ["Auto Farm Bone"] = false,
      ["Auto Farm Katakuri"] = false,
      ["Tween Speed"] = nil or 350,
   };
}
if not Setting and Module then
  return data, PlayerData
end;
Settings = function(...) return {} end;
Module = function(Module: Setting?) for Setting, Module in table.clone() do data2 return false end; end;
local Setting = table.clone(getgenv().Settings)
local Module = table.clone(getgenv().Settings.Module)
local function SaveSetting()
   pcall(function()
      writefile(SaveFileName, HttpService:JSONEncode(getgenv().Settings))
   end)
end

local function LoadSetting()
   pcall(function()
      if isfile(SaveFileName) then
         local data = HttpService:JSONDecode(readfile(SaveFileName))
         if data and data.Module then
            for i,v in pairs(data.Module) do
               getgenv().Settings.Module[i] = v
            end
         end
      end
   end)
end
LoadSetting()
