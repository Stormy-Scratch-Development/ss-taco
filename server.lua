local QBCore = exports['qb-core']:GetCoreObject()

TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)

QBCore.Functions.CreateCallback('ss-taco:server:get:Taco', function(source, cb)
    local src = source
    local Ply = QBCore.Functions.GetPlayer(src)
    local meat = Ply.Functions.GetItemByName("cooked-minced-meat")
    local salad = Ply.Functions.GetItemByName("salad")
    local tortilla = Ply.Functions.GetItemByName("tortilla")
    if meat ~= nil and salad ~= nil and tortilla ~= nil then
        cb(true)
    else
        cb(false)
    end
end)

--Food
QBCore.Functions.CreateUseableItem("taco", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Eat", src, item.name)
    end
end)

--Drinks
QBCore.Functions.CreateUseableItem("taco-shake", function(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
	if Player.Functions.RemoveItem(item.name, 1, item.slot) then
        TriggerClientEvent("consumables:client:Drink", src, item.name)
    end
end)
