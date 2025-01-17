if GetResourceState('es_extended') == 'started' then
    ESX = exports['es_extended']:getSharedObject()
    Config.Framework = "esx"
elseif GetResourceState('qb-core') == 'started' then
    QBCore = exports['qb-core']:GetCoreObject()
    Config.Framework = "qbcore"
else
    print("^1ERROR: Neither ESX nor QBCore detected!^0")
end

function SendNotification(src, message, type)
    if Config.NotificationType == "ox_lib" then
        TriggerClientEvent('ox_lib:notify', src, {description = message, type = type})
    elseif Config.NotificationType == "esx" then
        TriggerClientEvent('esx:showNotification', src, message)
    elseif Config.NotificationType == "qbcore" then
        TriggerClientEvent('QBCore:Notify', src, message, type or 'primary')
    elseif Config.Notifications == "ps-ui" then
        TriggerClientEvent('ps-ui:Notify', src, {
            title = "Go-Karts",
            description = message,
            type = type
        })
    else
        print("^1[ERROR]: Invalid notification type set in Config.lua!")
    end
end

RegisterNetEvent('gast_karts:checkMoney')
AddEventHandler('gast_karts:checkMoney', function(price)
    local src = source
    if Config.Framework == "esx" then
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer.getMoney() >= price then
            TriggerClientEvent('gast_karts:spawnVehicle', src)
        else
            SendNotification(src, Lang['not_enough_money'], 'error')
        end
    elseif Config.Framework == "qbcore" then
        local Player = QBCore.Functions.GetPlayer(src)
        if Player.Functions.GetMoney('cash') >= price then
            TriggerClientEvent('gast_karts:spawnVehicle', src)
        else
            SendNotification(src, Lang['not_enough_money'], 'error')
        end
    end
end)

RegisterNetEvent('gast_karts:payMoney')
AddEventHandler('gast_karts:payMoney', function(price)
    local src = source
    local societyAccount = Config.SocietyAccount
    if Config.Framework == "esx" then
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer.getMoney() >= price then
            xPlayer.removeAccountMoney('money', price)
            TriggerEvent('esx_addonaccount:getSharedAccount', societyAccount, function(account)
                if account then
                    account.addMoney(price)
                else
                    print("^1[ERROR]: Society account not found!")
                end
            end)
        end
    elseif Config.Framework == "qbcore" then
        local Player = QBCore.Functions.GetPlayer(src)
        if Player.Functions.RemoveMoney('cash', price) then
            local accountExists = exports['qb-management']:GetAccount(societyAccount)
            if accountExists then
                exports['qb-management']:AddMoney(societyAccount, price)
            else
                print("^1[ERROR]: Society account not found for QBCore!")
            end
        end
    end
end)

RegisterNetEvent('gast_karts:applyFine')
AddEventHandler('gast_karts:applyFine', function(amount)
    local src = source
    if Config.Framework == "esx" then
        local xPlayer = ESX.GetPlayerFromId(src)
        if xPlayer then
            xPlayer.removeAccountMoney('bank', amount)
        else
            print("^1[ERROR]: Player not found for ESX in applyFine!")
        end
    elseif Config.Framework == "qbcore" then
        local Player = QBCore.Functions.GetPlayer(src)
        if Player then
            Player.Functions.RemoveMoney('bank', amount)
        else
            print("^1[ERROR]: Player not found for QBCore in applyFine!")
        end
    else
        print("^1[ERROR]: Invalid framework set in Config.lua!")
    end
end)
