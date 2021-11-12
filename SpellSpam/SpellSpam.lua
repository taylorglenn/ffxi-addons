--------------------------
--  Info                --
--------------------------
_addon.name = 'SpellSpam'
_addon.version = '1.2'
_addon.author = 'BlueGlenn'
_addon.commands = { 'spellspam', 'ss' }

--------------------------------------------
--  Requireds                             --
--  These should be saved in addons/libs  --
--------------------------------------------
require('coroutine')
require('lists')
require('logger')
require('queues')
require('tables')
require('strings')
res = require('resources')

--------------------------
--  Constants           --
--------------------------
CONST_DELAY = 2
CONST_FOOD_DELAY = 2

--------------------------
--  System Objects      --
--------------------------
all_items = {}
all_spells = {}
handlers = {}
recasts = {}

--------------------------
--  User Settings       --
-------------------------- 
autoheal = false
target = '<me>'
run = false
food = {}
command = 'ma'
spell_queue = Q{}
queue_index = 1

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
		['//ss spell \"spell_name\"'] = "Set your desired spell (no default, you MUST set this, and it MUST be in quotes).",
		['//ss target <me> or <t> or \"npc_name\"'] = "Set your desired target (default: <me>).",
		['//ss autoheal'] = "Toggle whether you'd like to automatically heal when your MP runs out (default: false).",
		['//ss food \"food name\"'] = "Set what food (if any) you'd like to consume.  New food will be consumed when the buff wears if there is any in your inventory.  You may clear your food choice with '//ss food clear'.",
		['//ss start'] = "Once the above settings are in, start SpellSpam.",
		['//ss stop'] = "Stop SpellSpam.",
		['//ss settings'] = "Display your current settings.",
    }
	
	windower.add_to_chat(CONST_TITLE_COLOR, '.' .. CONST_NEWLINE)
	windower.add_to_chat(CONST_TITLE_COLOR, '=========== SpellSpam Help =================================' .. CONST_NEWLINE)
	windower.add_to_chat(CONST_TITLE_COLOR, 'Valid Commands:' .. CONST_NEWLINE)
	for key, value in pairs(instruction_lines) do
		windower.add_to_chat(CONST_COMMAND_COLOR, tostring(key))
		windower.add_to_chat(CONST_TEXT_COLOR, '-- ' .. tostring(value) .. CONST_NEWLINE)
    end
	windower.add_to_chat(CONST_HELPER_COLOR, "If you want to change a setting, you must stop SpellSpam first with '//ss stop'.")
	windower.add_to_chat(CONST_TITLE_COLOR, '=========================================================' .. CONST_NEWLINE)
	windower.add_to_chat(CONST_TITLE_COLOR, '.' .. CONST_NEWLINE)
end

function handle_autoheal(autoheal_selection)
    if run then 
        return "Cannot update autoheal while SpellSpam is running.  Stop it first by typing '//ss stop'."
    end

    autoheal = not autoheal
    notice('autoheal set to ' .. tostring(autoheal) .. '.')
end

function handle_spell(add_remove_clear, spell_name)
    if run then 
        return "Cannot change spell while SpellSpam is running.  Stop it first by typing '//ss stop'."
    end

    if (add_remove_clear:lower() == 'add') then
        add_spell(spell_name)
    end

    if (add_remove_clear:lower() == 'remove') then
        remove_spell(spell_name)
    end

    if (add_remove_clear:lower() == 'clear') then
        clear_spell_queue()
    end

    print_spell_queue()
end

function handle_target(target_selection)
    if run then 
        return "Cannot update target while SpellSpam is running.  Stop it first by typing '//ss stop'."
    end

    target_selection = tostring(target_selection)
    
    --local patterns = { '<', '>' }
    --for i, v in pairs(patterns) do 
    --    target_selection = string.gsub(target_selection, v, '')
    --end

    if target_selection == '<me>' or target_selection == '<t>' or windower.ffxi.get_mob_by_name(target_selection) ~= nil then
        target = target_selection
        notice('target set to ' .. target_selection)
    else
        return "%s is not a valid target. Valid syntax is '//ss target <me> or <t> or \"npc_name\"'.  If using an npc_name, make sure you are near enough to the npc, the npc name is spelled correctly, and that the npc name is enclosed in \"double quotes\".":format(target_selection)
    end
end

function handle_food(food_name) 
    if string.lower(food_name) == 'clear' then
        food = {}
        notice('food cleared.')
        return
    end

    local new_food = {}
    new_food.name = food_name
    local found_food = all_items[string.lower(new_food.name)]
    if found_food == nil then
        return "%s is not the name of any food in FFXI.  Make sure you have enclosed the food name in \"double quotes\".  Example: //ss food \"B.E.W. Pitaru\".":format(food_name)
    end

    new_food.id = found_food.id
    if count_food(new_food) > 0 then
        new_food.delay = found_food.cast + CONST_FOOD_DELAY
        food = new_food
        notice('food set to ' .. food.name)
    else
        return "You do not have %s in your main inventory, or it is not a food item.":format(food_name)
    end
end

function handle_queue()
    print_spell_queue()
end

function handle_settings()
    local settings = {
        ['autoheal'] = autoheal,
        ['target'] = target,
        ['started'] = run,
        ['food'] = food.name or 'no food set',
    }
    for key, value in pairs(settings) do
        notice(tostring(key) .. ' → ' .. tostring(value))
    end
    print_spell_queue()
end

function handle_start() 
    if spell_queue:length() == 0 then
        return "Spell queue is empty.  Type '//SpellSpam help' for help."
    end

    if run then
        return "SpellSpam is already running.  Type '//ss stop' to stop."
    end

    notice('Beginning SpellSpam.')
    notice("You may type '//ss stop' to stop.")

    run = true
    queue_index = 1
    engine()
end

function handle_stop()
    if run == false then
        return "SpellSpam is not running.  Type '//ss start' to start it."
    end

    run = false
    notice('Stopping SpellSpam.')
end

--------------------------------
--  Status Based Functions    --
--------------------------------
function status_idle(player) 
    if player.vitals.mp < spell.mp_cost then
        if autoheal then
            toggle_healing(true)
        else
            handle_stop()
        end
    elseif recasts[spell.id] == 0 then
        cast_spell()
        increment_spell_queue_index()
    end
end

function status_combat(player)
    status_idle(player)
end

function status_healing(player)
    if player.vitals.mp == player.vitals.max_mp then
        toggle_healing(false) -- stop healing, your mp is max
    end
end

function toggle_healing(toggle)
    local status = windower.ffxi.get_player().status
    if (status == 33 and toggle == true) or (status ~= 33 and toggle ~= true) then
        return
    end
    windower.chat.input('/heal')
end

--------------------------
--  Engine Functions    --
--------------------------
function engine()
    recasts = windower.ffxi.get_spell_recasts()

    if run then
        use_food()
        local player = windower.ffxi.get_player();
        local handle_status = {
            [0] = status_idle,
            [1] = status_combat,
            [33] = status_healing
        }
        if handle_status[player.status] ~= nil then
            handle_status[player.status](player)
            if run then 
                reschedule_engine() 
                return
            end
        end
        
        handle_stop()
    end
end

function reschedule_engine()
    engine:schedule(spell.cast_time + CONST_DELAY) -- schedule recursion
end

function use_food()
    if count_food(food) == 0 then
        return
    end
    local player = windower.ffxi.get_player()
    if S(player.buffs):contains(251) then -- 251 is the food buff
        return
    end
    windower.chat.input('/item \"%s\" <me>':format(food.name))
    coroutine.sleep(3.5)
end

--------------------------
--  Utility Functions   --
--------------------------
function cast_spell()
    local spell = spell_queue['data'][queue_index]
    if spell == nil then 
        handle_stop()
        return 
    end
    windower.chat.input('/ma "' .. spell.name .. '" ' .. target)
end

function increment_spell_queue_index()
    local queue_length = spell_queue:length()

    if queue_length == 0 then 
        handle_stop() 
        return 
    end

    if queue_index + 1 > queue_length then
        queue_index = 1
        return
    end

    queue_index = queue_index + 1 
end

function print_spell_queue()
    if spell_queue:length() == 0 then return "Spell Queue is empty!" end
    notice('Spell Queue:')
    for k,v in pairs(spell_queue['data']) do 
        notice(tostring(k).." → "..tostring(v))
    end
end

function add_spell(spell_name) 
    local new_spell = all_spells[string.lower(spell_name)]

    if new_spell == nil then
        return 'Invalid spell → %s. Make sure you are entering the spell name in \"double quotes\".':format(spell_name)
    end

    local available_spells = windower.ffxi.get_spells()
    if available_spells[new_spell.id] == false then
        return 'You do not know that spell yet.'
    end

    spell = new_spell
    spell_queue:push(spell_name)
    notice("Spell added to queue → " .. spell_name)
end

function remove_spell(spell_name)
    local found_index = -1
    for index,value in pairs(spell_queue['data']) do
        if value:lower() == spell_name:lower() then 
            found_index = index
        end
    end
    if (found_index == -1) then
        return 'Spell %s. Not found in spell queue. Do //ss queue to see the queue.':format(spell_name)
    end
    spell_queue:remove(found_index)
    notice("Spell removed from queue → " .. spell_name)
end

function clear_spell_queue()
    spell_queue:clear()
    notice("Cleared spell queue!")
end

function load_all_spells()
    for k,v in pairs(res.spells) do
        all_spells[string.lower(v.english)] = {id = k, targets = v.targets, cast_time = v.cast_time, name = v.english, mp_cost = v.mp_cost}
    end
end

function load_all_items()
    for k,v in pairs(res.items) do
        all_items[string.lower(v.english)] = {id = k, targets = v.targets, cast = v.cast_time, name = v.english}
    end
end

function load_main()
    load_all_spells()
    load_all_items()
end

function count_food(food_item)
    if food_item.id == nil or food_item.name == nil then
        return 0
    end
    local count = 0
    for key, value in ipairs(windower.ffxi.get_items(0)) do 
        if value.id == food_item.id and all_items[string.lower(food_item.name)].targets.Self == true then
            count = count + value.count
        end
    end
    return count
end

--------------------------
--  Command Handlers    --
--------------------------
handlers = {
    ['help'] = handle_help,
    ['h'] = handle_help,
    ['autoheal'] = handle_autoheal,
    ['spell'] = handle_spell,
    ['target'] = handle_target,
    ['food'] = handle_food,
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
windower.register_event('load', load_main)
windower.register_event('addon command', handle_command)