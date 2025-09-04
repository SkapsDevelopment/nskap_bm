ESX = exports['es_extended']:getSharedObject()

local function sendLog(title, message)
    if not Config.Logs or not Config.Logs.enabled or not Config.Logs.webhook or Config.Logs.webhook == "" then return end
    PerformHttpRequest(Config.Logs.webhook, function() end, "POST", json.encode({
        username = "Blackmarket Logs",
        embeds = {{
            title = title,
            description = message,
            color = 16753920
        }}
    }), { ["Content-Type"] = "application/json" })
end

RegisterNetEvent('skap_blackmarket:buyItem', function(itemName)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local item

    local playerPed = GetPlayerPed(src)
    local playerCoords = GetEntityCoords(playerPed)
    local bmCoords = currentLocation
    if not bmCoords or #(playerCoords - vector3(bmCoords.x, bmCoords.y, bmCoords.z)) > 5.0 then
        local msg = ("Player %s (%s) tried to buy %s from too far!"):format(src, xPlayer and xPlayer.getName() or "unknown", itemName)
        print('[BLACKMARKET CHEAT ATTEMPT] ' .. msg)
        sendLog("Blackmarket Cheat Attempt", msg)
        return TriggerClientEvent('ox_lib:notify', src, {type='error', description='Neacheatuj a skus to znova'})
    end

    for _, v in pairs(currentItems) do
        if v.name == itemName then
            item = v
            break
        end
    end

    if not item then
        local msg = ("Player %s (%s) tried to buy invalid item: %s"):format(src, xPlayer and xPlayer.getName() or "unknown", tostring(itemName))
        print('[BLACKMARKET CHEAT ATTEMPT] ' .. msg)
        sendLog("Blackmarket Cheat Attempt", msg)
        return TriggerClientEvent('ox_lib:notify', src, {type='error', description='Tento item není dostupný!'})
    end

    if xPlayer.getMoney() < item.price then
        local msg = ("Player %s (%s) tried to buy %s but didn't have enough money."):format(src, xPlayer.getName(), itemName)
        sendLog("Blackmarket - Nedostatek peněz", msg)
        return TriggerClientEvent('ox_lib:notify', src, {type='error', description='Nemáš dost peněz!'})
    end

    local canCarry = exports.ox_inventory:CanCarryItem(src, item.name, 1)
    if not canCarry then
        local msg = ("Player %s (%s) tried to buy %s but didn't have enough inventory space."):format(src, xPlayer.getName(), itemName)
        sendLog("Blackmarket - Plný inventář", msg)
        return TriggerClientEvent('ox_lib:notify', src, {type='error', description='Nemáš dost místa v inventáři!'})
    end

    xPlayer.removeMoney(item.price)
    xPlayer.addInventoryItem(item.name, 1)
    local msg = ("Player %s (%s) bought %s for $%s."):format(src, xPlayer.getName(), item.label, item.price)
    sendLog("Blackmarket - Nákup", msg)
    TriggerClientEvent('ox_lib:notify', src, {type='success', description='Dostal jsi: '..item.label..' za $'..item.price})
end)

lib.callback = lib.callback or {}

lib.callback.register('ox_blackmarket:getLocation', function()
    return currentLocation
end)

lib.callback.register('ox_blackmarket:getItems', function()
    return currentItems
end)

local function updatePrices()
    currentItems = {}
    for _, item in pairs(Config.Items) do
        local finalPrice = item.basePrice
        currentItems[#currentItems+1] = {
            name = item.name,
            label = item.label,
            price = math.floor(finalPrice),
            rarity = item.rarity
        }
    end
end

local function rotateBlackmarket()
    local random = math.random(1, #Config.BlackmarketLocations)
    currentLocation = Config.BlackmarketLocations[random]
    updatePrices()
    print("[Blackmarket] Nová lokace: "..json.encode(currentLocation))
    print("[Blackmarket] Nové ceny: "..json.encode(currentItems))
end

CreateThread(function()
    rotateBlackmarket()
    while true do
        Wait(Config.ChangeTime * 60000)
        rotateBlackmarket()
    end
end)