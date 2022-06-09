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
    local INDENT = ' ':rep(3)
    local D_INDENT = INDENT..INDENT
    local help_lines = 
    {
      '-- SpellSpam (an addon by BlueGlenn) --',
      'Commands:',
      INDENT..'//ss spell <add/remove/clear> \"spell_name\":\n'..D_INDENT..'Set or remove your desired spell to/from the queue.',
      INDENT..'/ss target <me> or <t> or \"npc/player_name\":\n'..D_INDENT..'Set your desired target (default: <me>).',
      INDENT..'//ss autoheal:\n'..D_INDENT..'Toggle \\heal back to full when your MP runs out (default: false).',
      INDENT..'/ss food \"food name\":\n'..D_INDENT..'Set what food (if any) you\'d like to consume. You may clear this with //ss food clear.',
      INDENT..'//ss start:\n'..D_INDENT..'Start SpellSpam.  It\'ll run through each spell in the queue in order.',
      INDENT..'//ss stop:\n'..D_INDENT..'Stop SpellSpam.',
      INDENT..'//ss settings:\n'..D_INDENT..'Display your current settings.',
      'Example:\n'..INDENT..'//ss add \"Shell\"\n'..INDENT..'//ss add \"Protect\"\n'..INDENT..'//ss autoheal\n'..INDENT..'//ss target <me>\n'..INDENT..'//ss start'
    }
    notice(table.concat(help_lines,'\n'))
end

function handle_autoheal(autoheal_selection)
    autoheal = not autoheal
    notice('autoheal set to ' .. tostring(autoheal) .. '.')
end

function handle_spell(add_remove_clear, spell_name)
    local messages = {}

    if (add_remove_clear:lower() == 'add') then
        messages = table.append(messages, add_spell(spell_name))
    end

    if (add_remove_clear:lower() == 'remove') then
        messages = table.append(messages, remove_spell(spell_name))
    end

    if (add_remove_clear:lower() == 'clear') then
        messages = table.append(messages, clear_spell_queue())
    end

    if (#messages > 0) then
        for _,message in pairs(messages) do
            if (message ~= '') then error(message) end
        end
        return
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
    queue_index = 1
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
    -- get cooldown of NEXT spell.  wait until it is 0 to cast again.
    local recasts = windower.ffxi.get_spell_recasts()
    local next_queue_index = get_next_queue_index()

    local current_spell = spell_queue['data'][queue_index]
    local next_spell = spell_queue['data'][next_queue_index]

    if (current_spell ~= nil and next_spell ~= nil) then
        local next_recast = recasts[next_spell.recast_id]/60 -- not sure why, but the game values need to be divided by 60 get the the value in seconds
        --windower.add_to_chat(123, 'Next spell recast id: '..next_spell.recast_id)
        engine:schedule(current_spell.cast_time + next_recast + CONST_DELAY) -- schedule recursion
        --windower.add_to_chat(123, tostring(current_spell.cast_time)..' + '..tostring(next_recast)..' + '..tostring(CONST_DELAY)..' = '..tostring(current_spell.cast_time + next_recast + CONST_DELAY))
        increment_spell_queue_index() -- only increment the queue if the engine was properly rescheduled
        return
    end

    error('Rescheduling error...')
    handle_stop()
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

function get_next_queue_index()
    local queue_length = spell_queue:length()

    if queue_length == 0 then 
        return 0
    end

    local next_queue_index = queue_index + 1

    if next_queue_index > queue_length then
        return 1
    end

    return next_queue_index
end

function increment_spell_queue_index()
    local next_queue_index = get_next_queue_index()

    if (next_queue_index == 0) then
        handle_stop()
        return
    end

    queue_index = get_next_queue_index()
end

function print_spell_queue()
    if spell_queue:length() == 0 then return "Spell Queue is empty!" end
    notice('Spell Queue:')
    for k,v in pairs(spell_queue['data']) do 
        notice(tostring(k).." → "..tostring(v.name))
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
    spell_queue:push(spell)
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
        all_spells[string.lower(v.english)] = {
            id = k, 
            targets = v.targets, 
            recast_id = v.recast_id, 
            cast_time = v.cast_time, 
            name = v.english,
            mp_cost = v.mp_cost
        }
    end
    --for k,v in pairs(all_spells) do 
    --    windower.add_to_chat(123, 'k: '..tostring(k)..', v: '..tostring(v.recast_id))
    --end
end

function load_all_items()
    for k,v in pairs(res.items) do
        all_items[string.lower(v.english)] = {
            id = k, 
            targets = v.targets, 
            cast = v.cast_time, 
            name = v.english
        }
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