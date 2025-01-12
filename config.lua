Config = {}

Config.Framework = "esx" -- "esx", "qbcore"
Config.Language = "cs" -- "cs", "en"

Config.UseFuelSystem = true

Config.NPC = {
    model = "s_m_m_highsec_01",
    position = vector3(-153.3912, -2151.4944, 15.7050),
    heading = 15.0
}

Config.TargetPosition = vector3(-153.3912, -2151.4944, 16.7050)

Config.InteractionType = "ox_target" -- "ox_target", "textui", "qb-target"
Config.MenuType = "ox_lib" -- "esx", "ox_lib", "qb"
Config.NotificationType = "ox_lib" -- "esx", "ox_lib", "qb"

Config.RentalVehicles = {
    {model = "veto", displayName = "Veto"},
    {model = "veto2", displayName = "Veto2"}
}

Config.RentalTimes = {
    {time = 5, price = 55},
    {time = 10, price = 110},
    {time = 20, price = 220}
}

Config.VehicleSpawn = {
    position = vector3(-134.2643, -2146.5012, 16.7050),
    heading = 290.0
}

Config.MaxRadius = 200.0
Config.RadiusCenter = vector3(-88.4605, -2065.7456, 35.2422)
Config.FineAmount = 1000
Config.SocietyAccount = "society_government"

Config.EnableBlip = true
Config.Blip = {
    sprite = 735, 
    color = 1,  
    scale = 0.8, 
    label = "Požičovňa motokár" 
}

if Config.Language == "cs" then
    Lang = {
        ['npc_prompt'] = "Stisknete ~INPUT_CONTEXT~ pro pujceni motokary.",
        ['target'] = "Půjčovňa motokár.",
        ['vehicle_rented'] = "Půjčil jste si motokáru na %s minut.",
        ['vehicle_returned'] = "Byl jste pokutováni %s$ za opuštění oblasti.",
        ['vehicle_despawned'] = "Motokára byla vrácena. Děkujeme za návštěvu.",
        ['not_enough_money'] = "Nemáte dostatek peněz.",
        ['menu_choose_vehicle'] = "Vyberte si motokaru",
        ['menu_choose_time'] = "Zvolte dobu pronájmu",
        ['menu_rent_button'] = "Půjčit",
        ['menu_cancel_button'] = "Zrušit",
        ['menu_title'] = "Půjčovna motokár",
        ['minutes'] = " minút",
    }
elseif Config.Language == "en" then
    Lang = {
        ['npc_prompt'] = "Press ~INPUT_CONTEXT~ to rent a Go kart.",
        ['target'] = "Rent a Go kart.",
        ['vehicle_rented'] = "You rented a Go kart for %s minutes.",
        ['vehicle_returned'] = "You have been fined $%s for leaving the area.",
        ['not_enough_money'] = "You don't have enough money.",
        ['menu_choose_vehicle'] = "Choose your Go Kart",
        ['menu_choose_time'] = "Choose rental duration",
        ['menu_rent_button'] = "Rent",
        ['menu_cancel_button'] = "Cancel",
        ['menu_title'] = "Go Kart Rental",
        ['minutes'] = " minutes"
    }
else
    print("^1[ERROR]: Invalid language configured in Config.lua")
end
