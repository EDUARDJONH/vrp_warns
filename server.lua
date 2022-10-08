local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vrp","vRP_chatroles")
BMclient = Tunnel.getInterface("vRP_basic_menu","vRP_basic_menu")

function vRP.warnUser(user_id)
    local tmp = vRP.getUserTmpTable(user_id)
    if tmp then
        user_warns = tmp.warns + 1
    end
    if Config.Database == 'overheat_sql' then 
        exports:overheat_sql.execute("UPDATE vrp_users SET warns = @user_warns where id = @user_id")
    elseif Config.Database == 'ghmattimysql' then
        exports:ghmattimysql.query("UPDATE vrp_users SET warns = @user_warns where id = @user_id")
    elseif Config.Database == 'oxmysql' then
        exports:oxmysql.execute("UPDATE vrp_users SET warns = @user_warns where id = @user_id")
    end
end

function vRP.cleanWarn(user_id)
    local tmp = vRP.getUserTmpTable(user_id)
    if tmp then
        user_warns = tmp.warns
    end
    local needCoins = user_warns * Config.WarnRemovalPrice
    if vRP.getUserCoins(user_id) >= needCoins then
        vRP.removeUserCoins({user_id,needCoins})
        if Config.Database == 'overheat_sql' then
            exports:overheat_sql.execute("UPDATE vrp_users SET warns = 0 where id = @user_id")
        elseif Config.Database == 'ghmattimysql' then
            exports:ghmattimysql.query("UPDATE vrp_users SET warns = 0 where id = @user_id")
        elseif Config.Database == 'oxmysql' then
            exports:oxmysql.execute("UPDATE vrp_users SET warns = 0 where id = @user_id")
        end
    else
        vRPclient.notify(user_id,{"Eroare: Nu ai suficienti Overheat Coins!"})
    end
end

function vRP.getUserWarns(user_id)
    local tmp = vRP.getUserTmpTable(user_id)
    if tmp then
        user_warns = tmp.warns
    end
    return user_warns or 0
end


RegisterCommand(Config.WarnCommand, function(source, args)
    if Config.Framework == 'vRP' then
        local user_id = vRP.getUserId({source})
        local target_id = parseInt(args[1])
        local reason = parseInt(args[2])
        local target_src = vRP.getUserSource({target_id})
        if target_src
            if args[1] ~= "" and args[1] ~= nil then
                if args[1] > 0 and args[1] ~= "0" then
                    if args[2] ~= "" and args[2] ~= nil then
                        if vRP.isUserHelper({user_id}) then
                            vRP.request(user_id,"Esti sigur ca vrei sa ii dai WARN jucatorului " .. vRP.getPlayerName({target_src}) .. " [" .. target_id .. "] ?", 15, function(user_id, ok)
                                if ok then
                                    vRP.warnUser({target_id})
                                    local tmp = vRP.getUserTmpTable({target_id})
                                    local user_warns = tmp.warns
                                    if user_warns == Config.MaxWarns then
                                        if Config.AutoBanPlayer then
                                            TriggerClientEvent("vrp_warns:autoBan", target_id)
                                            TriggerClientEvent("chatMessage", -1, "^1BAN^0: Jucatorul ^1" .. vRP.getPlayerName({target_id}) .. "^0 [^1" .. target_id .."^0] a fost banat de catre admin-ul ^1" .. vRP.getPlayerName({user_id}) .. "^0[^1" .. user_id .."^0] pentru ^9" .. Config.BanTime .. " zile^0")
                                            TriggerClientEvent("chatMessage", -1, "^1MOTIV^0: Acumulare warn-uri")
                                            local embed = {
                                                {
                                                    ["color"] = 0xcf0000,
                                                    ["title"] = "**WARN OVERHEAT**",
                                                    ["desciption"] = {
                                                        "Admin-ul: **" .. vRP.getPlayerName({user_id}) .." [" .. user_id .. "]** i-a dat warn lui: **" .. vRP.getPlayerName({target_id}) .." [" .. target_id .. "]**",
                                                        "Motiv: **" .. reason.. "**",
                                                        "Warn-uri: **" .. vRP.getUserWarns({target_id}) .. "/" .. Config.MaxWarns .."** *(Ban Provizoriu " .. Config.BanTime .. " zile)*",
                                                    },
                                                    ["thumbnail"] = {},
                                                    ["footer"] = {
                                                        ["text"] = "",
                                                    },
                                                }
                                            }
                                            PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({embeds = embed}), { ['Content-Type'] = 'application/json' })
                                        else
                                            vRP.sendStaffMessage({"[^9STAFF^0] Jucatorul ^9" .. vRP.getPlayerName({target_id}) .. "^0 [^9" .. target_id .. "^0] a acumulat ^9" .. Config.MaxWarns .."/" .. Config.MaxWarns .. "^0 warn-uri!"})
                                        end
                                    else
                                        vRPclient.notify(user_id, {"Succes: I-ai dat warn lui " .. vRP.getPlayerName({target_id}) .. " [" .. target_id .."] pentru motivul " .. reason .. " "})
                                        vRPclient.notify(user_id, {"Info: " .. vRP.getPlayerName({target_id}) .. " [" .. target_id .."] are acum " .. user_warns .."/" .. Config.MaxWarns .." warn-uri!"})
                                        vRPclient.notify(target_id, {"Info: Ai primit warn de la admin-ul " .. vRP.getPlayerName({user_id}) .. " [" .. user_id .."] pe motiv " .. reason .. " "})
                                        vRPclient.notify(target_id, {"Info: Ai acumulat " .. user_warns .. "/" .. Config.MaxWarns .. " warn-uri!"})
                                        TriggerClientEvent("chatMessage", -1, "^1WARN^0: Admin-ul ^1" .. vRP.getPlayerName({user_id}) .. "^0 [^1" .. user_id.."^0] i-a dat ^9 WARN^0 lui ^1" .. vRP.getPlayerName({target_id}) .."^0 [^1" .. target_id .."^0] ")
                                        TriggerClientEvent("chatMessage", -1, "^1MOTIV^0: " .. reason .. " ")
                                        local second_embed = {
                                            {
                                                ["color"] = 0xcf0000,
                                                ["title"] = "**WARN OVERHEAT**",
                                                ["desciption"] = {
                                                    "Admin-ul: **" .. vRP.getPlayerName({user_id}) .." [" .. user_id .. "]** i-a dat warn lui: **" .. vRP.getPlayerName({target_id}) .." [" .. target_id .. "]**",
                                                    "Motiv: **" .. reason.. "**",
                                                    "Warn-uri: **" .. vRP.getUserWarns({target_id}) .. "/" .. Config.MaxWarns .."**",
                                                },
                                                ["thumbnail"] = {},
                                                ["footer"] = {
                                                    ["text"] = "",
                                                },
                                            }
                                        }
                                        PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({embeds = second_embed}), { ['Content-Type'] = 'application/json' })
                                    end
                                else
                                    vRPclient.notify(user_id,{"Info: Ai ales sa nu ii dai warn jucatorului!"})
                                end
                            end)
                        else
                            TriggerClientEvent("chatMessage", source, "^1WARN^0: Nu ai acces la aceasta comanda!")
                        end
                    else
                        TriggerClientEvent("chatMessage", source, "^1WARN^0: Trebuie ca motivul sa nu fie null!")
                    end
                else
                    TriggerClientEvent("chatMessage", source, "^1WARN^0: @user_id este invalid!")
                end
            else
                TriggerClientEvent("chatMessage", source, "^1WARN^0: /" .. Config.WarnCommand .." <@user_id> <@reason>")
            end
        else
            TriggerClientEvent("chatMessage", source, "^1WARN^0: Jucatorul a primit ^9WARN Offline^0!")
        end
    else
        print("At the moment vrp_warns only works for the Config.Framework == 'vRP', our standalone version is still in progess, if you want to use our vRP version please change Config.Framework to 'vRP'!")
    end
end)

RegisterCommand(Config.ClearWarnCmd, function(source)
    local user_id = vRP.getUserId({source})
    if vRP.getUserSource({user_id}) then
        TriggerClientEvent("vrp_warns:clearWarns", user_id)
    end
end)

RegisterCommand(Config.AdminClearWarn, function(source, args)
    local user_id = vRP.getUserId({source})
    local target_id = parseInt(args[1])
    if args[1] ~= nil and args[1] ~= "" then
        if args[1] > 0 and args[1] ~= "0" then
            if vRP.hasPermission({user_id,Config.AdminClearWarnPermission}) then
                TriggerClientEvent("vrp_warns:clearWarns", target_id)
            else
                TriggerClientEvent("chatMessage", source, "^1WARN^0: Nu ai acces la aceasta comanda!")
            end
        else
            TriggerClientEvent("chatMessage", source, "^1WARN^0: @user_id este invalid!")
        end
    else
        TriggerClientEvent("chatMessage", source, "^1WARN^0: /" .. Config.AdminClearWarn .." <@user_id>")
    end
end)





    
