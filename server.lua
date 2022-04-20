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
