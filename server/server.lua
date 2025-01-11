if Config.Framework == "esx" then
    ESX = exports['es_extended']:getSharedObject()
elseif Config.Framework == "qbcore" then
    QBCore = exports['qb-core']:GetCoreObject()
end

function SendNotification(src, message, type)
    if Config.NotificationType == "ox_lib" then
        TriggerClientEvent('ox_lib:notify', src, {description = message, type = type})
    elseif Config.NotificationType == "esx" then
        TriggerClientEvent('esx:showNotification', src, message)
    elseif Config.NotificationType == "qbcore" then
        TriggerClientEvent('QBCore:Notify', src, message, type or 'primary')
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
            xPlayer.removeMoney(price)
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
