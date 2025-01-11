if Config.Framework == "esx" then
    ESX = exports['es_extended']:getSharedObject()
elseif Config.Framework == "qbcore" then
    QBCore = exports['qb-core']:GetCoreObject()
end

require('Client/editable')

local npcSpawned = false
local rentedVehicle = nil
local rentalTimer = nil
local timeRemaining = 0
local displayTextActive = false
local currentDisplayText = ""

function Notify(msg, type)
    if Config.NotificationType == "ox_lib" then
        lib.notify({title = msg, type = type})
    elseif Config.NotificationType == "qb" and Config.Framework == "qbcore" then
        QBCore.Functions.Notify(msg, type)
    elseif Config.NotificationType == "esx" and Config.Framework == "esx" then
        ESX.ShowNotification(msg)
    else
        print("^1[ERROR]: Invalid notification type set in Config.lua!")
    end
end

Citizen.CreateThread(function()
    local model = GetHashKey(Config.NPC.model)
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(1) end

    local npc = CreatePed(4, model, Config.NPC.position.x, Config.NPC.position.y, Config.NPC.position.z, Config.NPC.heading, false, true)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    FreezeEntityPosition(npc, true)
    TaskStartScenarioInPlace(npc, "WORLD_HUMAN_CLIPBOARD", 0, true)
    npcSpawned = true

    SetupNPCInteraction(npc)
end)

RegisterNetEvent('gast_karts:openMenu')
AddEventHandler('gast_karts:openMenu', function()
    local elements = {}
    for _, vehicle in ipairs(Config.RentalVehicles) do
        table.insert(elements, {
            label = vehicle.displayName,
            value = vehicle
        })
    end

    if Config.MenuType == "ox_lib" then
        local options = {}
        for _, vehicle in ipairs(Config.RentalVehicles) do
            table.insert(options, {
                title = vehicle.displayName,
                event = "gast_karts:selectVehicle",
                args = vehicle
            })
        end
        lib.registerContext({
            id = "gast_karts_vehicle_menu",
            title = Lang['menu_choose_vehicle'],
            options = options
        })
        lib.showContext("gast_karts_vehicle_menu")
    elseif Config.MenuType == "qb" and Config.Framework == "qbcore" then
        local menuItems = {}
        for _, vehicle in ipairs(Config.RentalVehicles) do
            table.insert(menuItems, {
                header = vehicle.displayName,
                params = {
                    event = "gast_karts:selectVehicle",
                    args = vehicle
                }
            })
        end
        exports['qb-menu']:openMenu(menuItems)
    elseif Config.MenuType == "esx" then
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gast_karts_vehicle_menu',
            {title = Lang['menu_choose_vehicle'], elements = elements},
            function(data, menu)
                SelectRentalTime(data.current.value)
                menu.close()
            end,
            function(data, menu)
                menu.close()
            end
        )
    else
        print("^1[ERROR]: Invalid menu type set in Config.lua!")
    end
end)

RegisterNetEvent('gast_karts:selectVehicle')
AddEventHandler('gast_karts:selectVehicle', function(vehicle)
    SelectRentalTime(vehicle)
end)

function SelectRentalTime(vehicle)
    local elements = {}
    for _, rentalTime in ipairs(Config.RentalTimes) do
        local rentalPrice = rentalTime.price
        table.insert(elements, {
            label = rentalTime.time .. " minutes",
            value = {model = vehicle.model, time = rentalTime.time, price = rentalPrice}
        })
    end

    if Config.MenuType == "ox_lib" then
        local options = {}
        for _, rentalTime in ipairs(Config.RentalTimes) do
            local rentalPrice = rentalTime.price
            table.insert(options, {
                title = rentalTime.time .. " minutes",
                event = "gast_karts:confirmRental",
                args = {model = vehicle.model, time = rentalTime.time, price = rentalPrice}
            })
        end
        lib.registerContext({
            id = "gast_karts_time_menu",
            title = Lang['menu_choose_time'],
            options = options
        })
        lib.showContext("gast_karts_time_menu")
    elseif Config.MenuType == "qb" and Config.Framework == "qbcore" then
        local menuItems = {}
        for _, rentalTime in ipairs(Config.RentalTimes) do
            local rentalPrice = rentalTime.price
            table.insert(menuItems, {
                header = rentalTime.time .. " minutes",
                params = {
                    event = "gast_karts:confirmRental",
                    args = {model = vehicle.model, time = rentalTime.time, price = rentalPrice}
                }
            })
        end
        exports['qb-menu']:openMenu(menuItems)
    else
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'gast_karts_time_menu',
            {title = Lang['menu_choose_time'], elements = elements},
            function(data, menu)
                ConfirmRental(data.current.value)
                menu.close()
            end,
            function(data, menu)
                menu.close()
            end
        )
    end
end

RegisterNetEvent('gast_karts:confirmRental')
AddEventHandler('gast_karts:confirmRental', function(data)
    TriggerServerEvent('gast_karts:checkMoney', data.price)
    TriggerServerEvent('gast_karts:payMoney', data.price)
    SpawnVehicle(data.model, data.time)
end)

function SpawnVehicle(model, rentalTime)
    if Config.Framework == "esx" then
        ESX.Game.SpawnVehicle(model, Config.VehicleSpawn.position, Config.VehicleSpawn.heading, function(vehicle)
            TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
            rentedVehicle = vehicle
            StartRentalTimer(rentalTime, vehicle)
            Notify(Lang['vehicle_rented']:format(rentalTime), "success")
        end)
    elseif Config.Framework == "qbcore" then
        QBCore.Functions.SpawnVehicle(model, function(vehicle)
            SetEntityCoords(vehicle, Config.VehicleSpawn.position.x, Config.VehicleSpawn.position.y, Config.VehicleSpawn.position.z)
            SetEntityHeading(vehicle, Config.VehicleSpawn.heading)
            TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
            rentedVehicle = vehicle
            StartRentalTimer(rentalTime, vehicle)
            Notify(Lang['vehicle_rented']:format(rentalTime), "success")
        end, Config.VehicleSpawn.position, true)
    else
        print("^1[ERROR]: Invalid framework set in Config!")
    end
end

function StartRentalTimer(minutes, vehicle)
    timeRemaining = minutes * 60
    displayTextActive = true
    Citizen.CreateThread(function()
        while timeRemaining > 0 do
            Wait(1000)
            timeRemaining = timeRemaining - 1

            if displayTextActive then
                ShowTimeRemaining(timeRemaining)
            end

            if IsPlayerOutsideRadius(vehicle) then
                if Config.Framework == "esx" then
                    ESX.Game.DeleteVehicle(vehicle)
                elseif Config.Framework == "qbcore" then
                    QBCore.Functions.DeleteVehicle(vehicle)
                end
                Notify(Lang['vehicle_returned']:format(Config.FineAmount), "error")
                HideTimeText()
                break
            end
        end

        if timeRemaining <= 0 then
            if Config.Framework == "esx" then
                ESX.Game.DeleteVehicle(vehicle)
            elseif Config.Framework == "qbcore" then
                QBCore.Functions.DeleteVehicle(vehicle)
            end
            Notify(Lang['vehicle_despawned'], "success")
            HideTimeText()
        end
    end)
end

function IsPlayerOutsideRadius(vehicle)
    if not vehicle or not Config.RadiusCenter or not Config.MaxRadius then
        print("Error: Missing vehicle or config data!")
        return false
    end

    local playerCoords = GetEntityCoords(PlayerPedId())
    local distance = #(playerCoords - Config.RadiusCenter)

    if distance > Config.MaxRadius then
        displayTextActive = false 
        return true
    else
        displayTextActive = true 
        return false
    end
end

function ShowTimeRemaining(time)
    local minutes = math.floor(time / 60)
    local seconds = time % 60
    currentDisplayText = ("Time Left: %02d:%02d"):format(minutes, seconds)
    
    if displayTextActive then
        Citizen.CreateThread(function()
            while displayTextActive do
                Wait(0)
                SetTextFont(4)
                SetTextProportional(1)
                SetTextScale(1.2, 1.2)
                SetTextColour(255, 255, 255, 255)
                SetTextOutline()
                SetTextCentre(true)
                SetTextEntry("STRING")
                AddTextComponentString(currentDisplayText)
                DrawText(0.5, 0.1)
            end
        end)
    end
end

function HideTimeText()
    displayTextActive = false
    currentDisplayText = ""
end
