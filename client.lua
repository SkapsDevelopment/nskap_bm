local currentPed = nil

local function spawnBlackmarketPed(coords)
    if DoesEntityExist(currentPed) then DeleteEntity(currentPed) end

    lib.requestModel(Config.NPCModel, 5000)
    currentPed = CreatePed(4, joaat(Config.NPCModel), coords.x, coords.y, coords.z-1, 0.0, false, true)
    SetEntityInvincible(currentPed, true)
    FreezeEntityPosition(currentPed, true)
    SetBlockingOfNonTemporaryEvents(currentPed, true)

    exports.ox_target:addLocalEntity(currentPed, {
        {
            name = 'blackmarket_menu',
            label = 'Otevřít Blackmarket',
            icon = 'fa-solid fa-skull-crossbones',
            onSelect = openBlackmarketMenu
        }
    })
end

function openBlackmarketMenu()
    lib.callback('skap_blackmarket:getItems', false, function(items)
        local options = {}
        for _, item in ipairs(items) do
            local chance = (6 - item.rarity) * 20
            options[#options+1] = {
                title = item.label,
                description = ("Cena: $%s | Šance: %s%%"):format(item.price, chance),
                onSelect = function()
                    TriggerServerEvent('skap_blackmarket:buyItem', item.name)
                end
            }
        end

        lib.registerContext({
            id = 'blackmarket_menu',
            title = 'Blackmarket',
            options = options
        })
        lib.showContext('blackmarket_menu')
    end)
end

