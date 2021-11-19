--------------------------
--  Info                --
--------------------------
_addon.name = 'AutoWS'
_addon.version = '1.2'
_addon.author = 'BlueGlenn'
_addon.commands = { 'autows', 'aws' }

--------------------------------------------
--  Requireds                             --
--  These should be saved in addons/libs  --
--------------------------------------------
require('logger')
require('tables')
require('strings')
res = require('resources')

--------------------------
--  System Objects      --
--------------------------
all_weapon_skills = {}

--------------------------
--  User Settings       --
--------------------------
weapon_skill = {}
tp_threshold = 1000
run = false

----------------------------------
--  Command Handler Functions   --
----------------------------------
function handle_help()
    local INDENT = ' ':rep(3)
    local help_lines = 
    {
        '-- AutoWS (a simple addon by BlueGlenn) --',
        'Commands:',
        INDENT..'//aws ws \"weapon_skill_name\":'..INDENT..'Set your desired weapon skill',
        INDENT:rep(2)..'- no default, you MUST set this, and it MUST be in quotes',
        INDENT..'//aws tp 1000-3000:'..INDENT..'Set your desired tp threshold',
        INDENT:rep(2)..'- the tp at which your weapon skill will be used.  Default is 1000',
        INDENT..'//aws start:'..INDENT..'Once the above settings are in, start AutoWS',
        INDENT..'//aws stop:'..INDENT..'Stop AutoWS',
        INDENT..'//aws settings:'..INDENT..'Display your current settings'
    }
    notice(table.concat(help_lines,'\n'))
end

function handle_skill(skill_name)
    local new_weapon_skill = all_weapon_skills[string.lower(skill_name)]

    if new_weapon_skill == nil then
        return 'Invalid weapon skill → %s. Make sure you are entering the weapon skill name in \"double quotes\".':format(skill_name)
    end

    local available_weapon_skills = windower.ffxi.get_abilities().weapon_skills
    if available_weapon_skills[new_weapon_skill.id] == false then
        return 'You do not know that weapon skill yet.'
    end

    weapon_skill = new_weapon_skill
    notice('weapon skill set to ' .. skill_name)
end

function handle_threshold(threshold)
    local new_threshold = tonumber(threshold)

    if not new_threshold or new_threshold < 1000 or new_threshold > 3000 or not new_threshold == math.floor(new_threshold) then
        return "TP threshold must be an integer between 1000 and 3000."
    end

    tp_threshold = new_threshold
    notice('tp threshold set to ' .. tostring(new_threshold))
end

function handle_settings()
    local settings = {
        ['weapon skill'] = weapon_skill.name or 'no weapon skill set',
        ['tp threshold'] = tostring(tp_threshold),
        ['started'] = run
    }
    for key, value in pairs(settings) do
        notice(tostring(key) .. ' → ' .. tostring(value))
    end
end

function handle_start() 
    if weapon_skill.name == nil then
        return "No weapon skill is set.  Type '//aws help' for help."
    end

    if run then
        return "AutoWS is already running.  Type '//aws stop' to stop."
    end

    notice('Beginning AutoWS.')
    notice("You may type '//aws stop' to stop.")

    run = true
end

function handle_stop()
    if run == false then
        return "AutoWS is not running.  Type '//aws start' to start it."
    end

    run = false
    notice('Stopping AutoWS.')
end

--------------------------
--  Engine Functions    --
--------------------------
function do_ws()
    local player = windower.ffxi.get_player()

    local is_player_in_combat = player.status == 1
    local player_has_tp = player.vitals.tp >= tp_threshold
    local is_weapon_skill_valid = weapon_skill.name ~= nil

    if  run and is_player_in_combat and player_has_tp and is_weapon_skill_valid then
        target = windower.ffxi.get_mob_by_target('t')
        windower.chat.input('/ws "' .. weapon_skill.name .. '" <t>')
    end
end

--------------------------
--  Utility Functions   --
--------------------------
function load_all_weapon_skills()
    for k,v in pairs(res.weapon_skills) do
        all_weapon_skills[string.lower(v.english)] = { id = k, name = v.english }
    end
end

--------------------------
--  Command Handlers    --
--------------------------
handlers = {
    ['help'] = handle_help,
    ['h'] = handle_help,
    ['ws'] = handle_skill,
    ['weaponskill'] = handle_skill,
    ['threshold'] = handle_threshold,
    ['tp'] = handle_threshold,
    ['settings'] = handle_settings,
    ['start'] = handle_start,
    ['stop'] = handle_stop
}

function handle_command(cmd, ...)
    local cmd = cmd or 'help'
    if handlers[cmd] then
        local msg = handlers[cmd](unpack({...}))
        if msg then
            error(msg)
        end
    else
        error("Unknown command %s":format(cmd))
    end
end

--------------------------
--  Windower Events     --
--------------------------
windower.register_event('load', load_all_weapon_skills)
windower.register_event('addon command', handle_command)
windower.register_event('tp change', do_ws)