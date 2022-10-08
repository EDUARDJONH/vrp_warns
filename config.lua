Config = {}

Config.Framework = 'vRP' -- 'vRP' / 'Standalone are the only options ( standalone is still in development )'

Config.WarnCommand = 'warn' -- sets the warn command

Config.ClearWarnCmd = 'clearwarns' -- sets the clear warns command

Config.AdminClearWarn = 'aclearwarn' -- sets the free warn removal command - if a warn is given by mistake 

Config.CheckWarnCmd = 'checkwarn' -- sets the check warnings command 

Config.CheckWarnPermission = 'admin.checkwarn' -- sets the check warnings permission, found in @vRP/cfg/groups.lua

Config.AdminClearWarnPermission = 'admin.clearwarn' -- sets the permmission required, found in @vRP/cfg/groups.lua

Config.Database = 'oxmysql' -- 'oxmysql' / 'ghmattimysql'

Config.MaxWarns = '4' -- warn number when the player gets banned

Config.BanTime = 7 -- ban time after the user reach 4 warns, in days

Config.WarnRemovalPrice = 5 -- number of coins needed to pay for EACH warn

Config.BanMessage = 'You have been banned for 7 days for the following reason: Warn accumulation' -- change the ban message

Config.Webhook = '' -- set your discord weebhook for warn logging

Config.AutoBanPlayer = true -- set to false if you want to ban manually a user when they reach 4 warns, keep to true if you want the system to auto ban the user.

Config.AdminGroups = {
    'superadmin',
    'saadmin',
    'admin',
    'moderator',
    'helper'
}
