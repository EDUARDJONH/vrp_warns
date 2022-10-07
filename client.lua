RegisterNetEvent("vrp_warns:autoBan")
AddEventHandler("vrp_warns:autoBan", user_id)
    vRP.setBannedTemp({user_id, true, Config.BanMessage, "AUTO-WARN SYSTEM", Config.BanTime})
end

RegisterNetEvent("vrp_warns:clearWarns")
AddEventHandler("vrp_warns:clearWarns", user_id)
    vRP.cleanWarn({user_id})
end
