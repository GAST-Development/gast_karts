function SetupNPCInteraction()
    if Config.InteractionType == "ox_target" then
        if exports['ox_target'] and exports['ox_target'].addBoxZone then
            exports['ox_target']:addBoxZone({
                coords = Config.TargetPosition,
                size = vec3(2.0, 2.0, 2.0),
                rotation = 0,
                debugPoly = false,
                options = {
                    {
                        event = "gast_karts:openMenu",
                        icon = "fas fa-car",
                        label = Lang['target'],
                        canInteract = function()
                            return true
                        end
                    }
                },
                distance = 3.0
            })
        else
            print("^1[ERROR]: ox_target export 'addBoxZone' not found. Ensure ox_target is properly installed.")
        end
    elseif Config.InteractionType == "qb-target" then
        if exports['qb-target'] and exports['qb-target'].AddBoxZone then
            exports['qb-target']:AddBoxZone("vehicle_rental_target", Config.TargetPosition, 2.0, 2.0, {
                name = "vehicle_rental_target",
                useZ = true
            }, {
                options = {
                    {
                        event = "gast_karts:openMenu",
                        icon = "fas fa-car",
                        label = Lang['target']
                    }
                },
                distance = 3.0
            })
        else
            print("^1[ERROR]: qb-target export 'AddBoxZone' not found. Ensure qb-target is properly installed.")
        end       
    elseif Config.InteractionType == "textui" then
        Citizen.CreateThread(function()
            while true do
                local sleep = 1000
                local playerCoords = GetEntityCoords(PlayerPedId())
                if #(playerCoords - Config.TargetPosition) < 2.0 then
                    sleep = 0
                    ESX.ShowHelpNotification(Lang['npc_prompt'])
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent("gast_karts:openMenu")
                    end
                end
                Wait(sleep)
            end
        end)
    elseif Config.InteractionType == "ox_lib" then
        Citizen.CreateThread(function()
            while true do
                local sleep = 1000
                local playerCoords = GetEntityCoords(PlayerPedId())
                if #(playerCoords - Config.TargetPosition) < 2.0 then
                    sleep = 0
                    lib.showTextUI(Lang['npc_prompt_lib'])
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent("gast_karts:openMenu")
                    end
                else
                    lib.hideTextUI()
                end
                Wait(sleep)
            end
        end)
    elseif Config.InteractionType == "ps-ui" then
        Citizen.CreateThread(function()
            while true do
                local sleep = 1000
                local playerCoords = GetEntityCoords(PlayerPedId())
                if #(playerCoords - Config.TargetPosition) < 2.0 then
                    sleep = 0
                    exports['ps-ui']:DisplayText(Lang['npc_prompt_lib'], "primary")
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent("gast_karts:openMenu")
                    end
                else
                    exports['ps-ui']:HideText()
                end
                Wait(sleep)
            end
        end)
    elseif Config.InteractionType == "gast_lib" then
        Citizen.CreateThread(function()
            while true do
                local sleep = 1000
                local playerCoords = GetEntityCoords(PlayerPedId())
                if #(playerCoords - Config.TargetPosition) < 2.0 then
                    sleep = 0
                    exports['gast_lib']:DisplayText(Lang['npc_prompt_lib'], "primary")
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent("gast_karts:openMenu")
                    end
                else
                    exports['gast_lib']:HideText()
                end
                Wait(sleep)
            end
        end)
    end   
end

function SetFullFuel(vehicle)
    if Config.UseFuelSystem and GetResourceState('LegacyFuel') == 'started' then
        exports['LegacyFuel']:SetFuel(vehicle, 100.0)
    elseif Config.UseFuelSystem and GetResourceState('ox_fuel') == 'started' then
        Entity(vehicle).state.fuel = Config.MaxFuel
    elseif Config.UseFuelSystem and GetResourceState('gast_fuel') == 'started' then

    else
        print("^2[INFO]: No fuel system detected. Skipping fuel adjustment.")
    end
end

function Notify(msg, type)
    if Config.NotificationType == "ox_lib" then
        lib.notify({title = msg, type = type})
    elseif Config.NotificationType == "qb" and Config.Framework == "qbcore" then
        QBCore.Functions.Notify(msg, type)
    elseif Config.NotificationType == "esx" and Config.Framework == "esx" then
        ESX.ShowNotification(msg)
    elseif Config.Notifications == "ps-ui" then
        exports['ps-ui']:Notify({
            title = "Go-Karts",
            description = msg,
            type = type
        })
    elseif Config.Notifications == "gast_lib" then
        exports['gast_lib']:Notify({
            title = Lang['title_lib'],
            description = msg,
            type = type
        })
    else
        print("^1[ERROR]: Invalid notification type set in Config.lua!")
    end
end
