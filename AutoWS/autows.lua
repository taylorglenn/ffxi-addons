--------------------------
--  Info                --
--------------------------
_addon.name = 'AutoWS'
_addon.version = '1.1'
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
file = require('files')
packets = require('packets')

--------------------------
--  Constants           --
--------------------------
CONST_DELAY = 2

--------------------------
--  System Objects      --
--------------------------
all_weapon_skills = {}
last_weapon_skill_damage = 0
weapon_skill_useage_count = 0

--------------------------
--  User Settings       --
--------------------------
weapon_skill = {}
tp_threshold = 1000
execute = false
run = false

----------------------------------
--  Command Handler Functions   --
----------------------------------
function handle_help()
	local CONST_TITLE_COLOR = 16 -- pink
	local CONST_COMMAND_COLOR = 222 -- cyan
	local CONST_HELPER_COLOR = 220 -- blue
	local CONST_TEXT_COLOR = 100 -- yellow
	local CONST_NEWLINE = '\n'
	
    local instruction_lines = {
		['//aws ws \"weapon_skill_name\"'] = "Set your desired weapon skill (no default, you MUST set this, and it MUST be in quotes).",
		['//aws tp 1000-3000'] = "Set your desired tp threshold (the tp at which your weapon skill will be used.  Default is 1000).",
		['//aws execute on/off'] = "Set whether or not you want to use execute mode (only use your weapon skill to finish off an enemy WARNING: will use WS one time permaturely in order to gauge how much damage your WS is doing. Default is off).",
		['//aws start'] = "Once the above settings are in, start AutoWS.",
		['//aws stop'] = "Stop AutoWS.",
		['//aws settings'] = "Display your current settings."
    }
	
	windower.add_to_chat(CONST_TITLE_COLOR, '.' .. CONST_NEWLINE)
	windower.add_to_chat(CONST_TITLE_COLOR, '=========== AutoWS Help =================================' .. CONST_NEWLINE)
	windower.add_to_chat(CONST_TITLE_COLOR, 'Valid Commands:' .. CONST_NEWLINE)
	for key, value in pairs(instruction_lines) do
		windower.add_to_chat(CONST_COMMAND_COLOR, tostring(key))
		windower.add_to_chat(CONST_TEXT_COLOR, '-- ' .. tostring(value) .. CONST_NEWLINE)
    end
	windower.add_to_chat(CONST_HELPER_COLOR, "If you want to change a setting, you must stop AutoWS first with '//aws stop'.")
	windower.add_to_chat(CONST_TITLE_COLOR, '=========================================================' .. CONST_NEWLINE)
	windower.add_to_chat(CONST_TITLE_COLOR, '.' .. CONST_NEWLINE)
end

function handle_skill(skill_name)
    if run then 
        return "Cannot change weapon skill while AutoWS is running.  Stop it first by typing '//aws stop'."
    end

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
    if run then 
        return "Cannot change tp threshold while AutoWS is running.  Stop it first by typing '//aws stop'."
    end

    local new_threshold = tonumber(threshold)

    if not new_threshold or new_threshold < 1000 or new_threshold > 3000 or not new_threshold == math.floor(new_threshold) then
        return "TP threshold must be an integer between 1000 and 3000."
    end

    tp_threshold = new_threshold
    notice('tp threshold set to ' .. tostring(new_threshold))
end

function handle_count(clear)
	if string.lower(clear) == 'clear' then
		weapon_skill_useage_count = 0
		notice('weapon skill usage count reset to 0')
	else
		notice('this is not a valid command.  the only valid command for the \"count\" setting is \"clear\"')
	end
end

function handle_execute(onOrOff) 
    execute =  string.lower(onOrOff) == 'on'
    notice('execute set to ' .. tostring(execute))
end

function handle_settings()
    local settings = {
        ['weapon skill'] = weapon_skill.name or 'no weapon skill set',
        ['tp threshold'] = tostring(tp_threshold),
        ['execute'] = tostring(execute),
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

    notice('Beginning AutoWS.  Will check for target and TP every ' .. CONST_DELAY .. ' seconds.')
    notice("You may type '//aws stop' to stop.")

    run = true
    engine()
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
function engine()
    local player = windower.ffxi.get_player()

    local is_player_in_combat = player.status == 1
    local player_has_tp = player.vitals.tp >= tp_threshold
    local is_weapon_skill_valid = weapon_skill.name ~= nil

    if run and is_player_in_combat and player_has_tp and is_weapon_skill_valid then
        target = windower.ffxi.get_mob_by_target('t')

        local target_pre_ws_hpp = target.hpp
        if ((execute == true) and (last_weapon_skill_damage > 0) and (target_pre_ws_hpp - last_weapon_skill_damage < 0)) or (execute == false) then
            windower.chat.input('/ws "' .. weapon_skill.name .. '" <t>')
			--weapon_skill_useage_count = weapon_skill_useage_count + 1
			--notice('count → ' .. tostring(weapon_skill_useage_count))
        end

        local target_post_ws_hpp = target.hpp

        if target_pre_ws_hpp ~= target_post_ws_hpp then
            last_weapon_skill_damage = target_pre_ws_hpp - target_post_ws_hpp
        end

        if (execute == true) then
            notice('last weapon skill damage logged at: ' .. tostring(last_weapon_skill_damage) .. '%')
        end
    end

    reschedule_engine()
end

function reschedule_engine()
    engine:schedule(CONST_DELAY) -- schedule recursion
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
    ['skill'] = handle_skill,
    ['threshold'] = handle_threshold,
    ['tp'] = handle_threshold,
	['count'] = handle_count,
    ['execute'] = handle_execute,
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