local resourceName = 'gast_karts'
local currentVersion = GetResourceMetadata(resourceName, 'version', 0)

-- Check if current version is outdated
local function CheckVersion()
    if not currentVersion then
        print("^1["..resourceName.."] Unable to determine current resource version for '" ..resourceName.. "' ^0")
        return
    end
    SetTimeout(1000, function()
        PerformHttpRequest('https://api.github.com/repos/GAST-Development/' ..resourceName.. '/releases/latest', function(status, response)
            if status ~= 200 then return end
            response = json.decode(response)
            local latestVersion = response.tag_name
            if not latestVersion or latestVersion == currentVersion then return end
            if latestVersion ~= currentVersion then
                print('^1['..resourceName..'] ^3An update is now available for ' ..resourceName.. '^0')
                print('^1['..resourceName..'] ^3Current Version: ^1' ..currentVersion.. '^0')
                print('^1['..resourceName..'] ^3Latest Version: ^2' ..latestVersion.. '^0')
                print('^1['..resourceName..'] ^3Download the latest release from https://github.com/GAST-Development/'..resourceName..'/releases^0')
                print('^1['..resourceName..'] ^3For more information about this update visit our https://discord.gg/D8cuU8r8WA^0')
            end
        end, 'GET')
    end)
end

if Config.VersionCheck then
    CheckVersion()
end