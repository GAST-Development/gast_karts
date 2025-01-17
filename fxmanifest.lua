fx_version 'cerulean'

game 'gta5'

author 'G.A.S.T. Development'

lua54 'yes'

description 'NPC Go-Karts rental system for ESX and QB-Core frameworks'

version '1.1.1'

shared_script {
    '@es_extended/imports.lua', 
    '@ox_lib/init.lua',  
    'config.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}


