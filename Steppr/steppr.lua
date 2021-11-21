--------------------------
--  Info                --
--------------------------
_addon.name = 'Steppr'
_addon.version = '1.0'
_addon.author = 'BlueGlenn'
_addon.commands = { 'steppr', 'st' }

--------------------------------------------
--  Requireds                             --
--  These should be saved in addons/libs  --
--------------------------------------------
config = require('config')
packets = require('packets')
res = require('resources')
texts = require('texts')
require('tables')
require('logger')
require('queues')
require('coroutine')

--------------------------
--  Constants           --
--------------------------
COMBAT_STATUS = 1
TP_THRESHOLD = 1000
DELAY = 3

--------------------------
--  System Objects      --
--------------------------
all_weapon_skills = {}
ws_queue = Q{}
ws_queue_index = 1
stop = true
busy = false

--------------------------
--  Configure Settings  --
--------------------------
local defaults = T{}
defaults.lists = T{}
settings = config.load('data\\settings.xml', defaults)

----------------------------------
--  Command Handler Functions   --
----------------------------------
function handle_save(list_name)
  list_name = list_name or ''
  if list_name == '' then
    return 'You must enter a list name to save the current list.  Example: //st save "sam4step"'
  end
  if ws_queue:empty() then
    return 'Empty lists cannot be saved.'
  end
  if list_name:gsub( "%W", "" ) ~= list_name then
    return 'You may not have spaces, punctuation, or special characters in your list name.'
  end
  local save_items = {}
  for _,item in pairs(ws_queue.data) do
    table.insert(save_items,1,item)
  end
  settings.lists[list_name] = table.concat(save_items,',')
  settings:save('all')

  notice('Current list saved as '..list_name)
end

function handle_load(list_name)
  if list_name == '' then
    return 'You must enter a list name to load.  Example: //sl load "sam4step"'
  end
  if settings.lists[list_name] == nil then
    return list_name..' is not the name of a saved list.'
  end
  local load_list = settings.lists[list_name]:split(',')
  for _,item in ipairs(load_list) do
    handle_add(item)
  end
  notice('Successfully loaded list: '..list_name)
end

function handle_delete(list_name)
  if settings.lists[list_name] == nil then
    return list_name..' is not the name of a saved list.'
  end
  settings.lists[list_name] = nil 
  settings:save('all')

  notice('Deleted list: '..list_name)
end

function handle_print_lists()
  if settings.lists:empty() then
    return 'There are no saved lists.'
  end
  notice('Saved Lists:')
  for list_name,list_contents in pairs(settings.lists) do
    notice(list_name..': '..list_contents)
  end
end

function handle_help()
  local INDENT = ' ':rep(3)
  local help_lines = 
  {
      '-- Steppr (a simple addon by BlueGlenn) --',
      'WS Queue Commmands:',
      INDENT..'//st add \"weapon_skill_name\":'..INDENT..'Add desired weapon skill to queue',
      INDENT:rep(2)..'- the weapon skill name must be in quotes, and you must know it',
      INDENT..'//st remove \"weapon_skill_name\":'..INDENT..'Remove weapon skill from queue',
      INDENT:rep(2)..'- must be in quotes, and must be in queue already',
      INDENT..'//st clear:'..INDENT..'Clears entire weapon skill queue',
      INDENT..'//st queue:'..INDENT..'Prints entire queue for you to see',
      'Control Commmands:',
      INDENT..'//st start:'..INDENT..'Starts Steppr',
      INDENT..'//st stop:'..INDENT..'Stop Steppr',
      'Memory Commmands:',
      INDENT..'//st save:'..INDENT..'Saves current queue as a list in ~/addons/Steppr/data/settings.xml',
      INDENT:rep(2)..'- You may not use spaces, punctuation, or special characters',
      INDENT..'//st load:'..INDENT..'Loads a queue from a list in ~/addons/Steppr/data/settings.xml',
      INDENT..'//st delete:'..INDENT..'Deletes a saved list from ~/addons/Steppr/data/settings.xml',
  }
  notice(table.concat(help_lines,'\n'))
end

function handle_add(skill_name)
  local new_weapon_skill = all_weapon_skills[string.lower(skill_name)]

  if new_weapon_skill == nil then
      return 'Invalid weapon skill → '..skill_name..'. Make sure you are entering the weapon skill name in \"double quotes\".'
  end

  local available_weapon_skills = windower.ffxi.get_abilities().weapon_skills
  if available_weapon_skills[new_weapon_skill.id] == false then
      return 'You do not know that weapon skill yet.'
  end

  ws_queue:push(new_weapon_skill.name)
  handle_print_queue()
end

function handle_remove(skill_name)
  local found_ws = all_weapon_skills[skill_name:lower()]
  if found_ws == nil then
      return skill_name..' is not the name of any weapon skill in FFXI.  Make sure you have enclosed the item name in \"double quotes\".'
  end
  local index = get_ws_index(found_ws.name)
  if index > -1 then 
    table.remove(ws_queue.data, index)
    notice('Removed '..skill_name..' from queue.')
    return
  end
  return skill_name..' is not the name of any skill in the current weapon skill queue.'
end

function handle_clear()
  notice("Queue cleared!")
  ws_queue = Q{}
end

function handle_print_queue()
  if ws_queue:length() == 0 then return "Weapon Skill Queue is empty!" end
  notice('Weapon Skill Queue:')
  for k,v in pairs(ws_queue.data) do
    notice(tostring(k).." → "..tostring(v))
  end
end

function handle_start() 
  if not stop then return end
  notice('Starting Steppr. To stop, type: //st stop')
  stop = false
  do_ws(true)
end

function handle_stop()
  if stop then return end
  notice('Stopping Steppr.  To start, type: //st start')
  stop = true
  reset()
end

--------------------------
--  Event functions     --
--------------------------
function tp_change()
  do_ws()
end

function load() 
  load_all_weapon_skills()
end

function status_change(new, old)
  -- detect transition from combat (status 1) to idle (status 0)
  if old == 1 and new == 0 then
    reset()
  end 
end

function target_change(index)
  reset()
end

--------------------------
--  Utility Functions   --
--------------------------
function do_ws(once)
  once = once or false
  if busy or stop then return end

  local player = windower.ffxi.get_player()
  local next_weapon_skill = ws_queue[ws_queue_index]

  if can_player_ws() then
    busy = true
    target = windower.ffxi.get_mob_by_target('t')
    notice('Using '..next_weapon_skill..' with '..tostring(player.vitals.tp)..' TP.')
    windower.chat.input('/ws "' .. next_weapon_skill .. '" <t>')

    -- eject if last ws in queue or just need to run once
    if ws_queue_index >= ws_queue:length() or once then
      reset()
      return
    end

    coroutine.sleep(DELAY) -- 3 second lockout before you can skillchain
    ws_queue_index = ws_queue_index + 1
    busy = false
  end
end

function can_player_ws()
  local player = windower.ffxi.get_player()
  return 
    not stop and
    not busy and
    player.status == COMBAT_STATUS and
    player.vitals.tp >= TP_THRESHOLD and
    ws_queue[ws_queue_index] ~= nil
end

function load_all_weapon_skills()
  for k,v in pairs(res.weapon_skills) do
      all_weapon_skills[string.lower(v.english)] = { id = k, name = v.english }
  end
end

function reset()
  busy = false
  ws_queue_index = 1
end

function get_ws_index(ws_name)
  for i,ws in pairs(ws_queue.data) do
    if ws == ws_name then 
      return i
    end
  end
  return -1
end

--------------------------
--  Command Handlers    --
--------------------------
handlers = {
    ['help'] = handle_help,
    ['h'] = handle_help,
    ['add'] = handle_add,
    ['remove'] = handle_remove,
    ['clear'] = handle_clear,
    ['save'] = handle_save,
    ['load'] = handle_load,
    ['delete'] = handle_delete,
    ['lists'] = handle_print_lists,
    ['queue'] = handle_print_queue,
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
windower.register_event('addon command', handle_command)
windower.register_event('load', load)
windower.register_event('tp change', tp_change)
windower.register_event('status change', status_change)
windower.register_event('target change', target_change)