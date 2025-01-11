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
                    if Config.NotificationType == "ox_lib" then
                        lib.showTextUI(Lang['npc_prompt'])
                    else
                        ESX.ShowHelpNotification(Lang['npc_prompt'])
                    end
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent("gast_karts:openMenu")
                    end
                else
                    lib.hideTextUI()
                end
                Wait(sleep)
            end
        end)
    end
end
