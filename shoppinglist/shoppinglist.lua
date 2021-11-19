--------------------------
--  Info                --
--------------------------
_addon.name = 'Shopping List'
_addon.version = '1.0'
_addon.author = 'BlueGlenn'
_addon.commands = { 'shoppipnglist', 'sl' }

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

--------------------------
--  System Objects      --
--------------------------
all_items = {}
watched_items = T{}

--------------------------
--  Configure Settings  --
--------------------------
local defaults = T{}
defaults.lists = T{}
settings = config.load('data\\settings.xml', defaults)

--------------------------
--  Box Setup           --
--------------------------
box = texts.new(settings.text_box_settings, settings)
box:text('')

--------------------------
--  Global Flags        --
-------------------------- 
is_hidden = false

----------------------------------
--  Command Handler Functions   --
----------------------------------
function handle_save(list_name)
  if list_name == '' then
    return 'You must enter a list name to save the current list.  Example: //sl save "craftingList"'
  end
  if watched_items:empty() then
    return 'Empty lists cannot be saved.'
  end
  if list_name:gsub( "%W", "" ) ~= list_name then
    return 'You may not have spaces, punctuation, or special characters in your list name.'
  end
  local save_items = {}
  for _,item in pairs(watched_items) do
    table.insert(save_items,1,item.name)
  end
  settings.lists[list_name] = table.concat(save_items,',')
  settings:save('all')

  notice('Current list saved as '..list_name)
end

function handle_load(list_name)
  if list_name == '' then
    return 'You must enter a list name to load.  Example: //sl load "craftingList"'
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

function handle_print()
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
    '-- ShoppingList (a simple addon by BlueGlenn) --',
    'Commands:',
    INDENT..'//sl add <item_name>:'..INDENT..'adds item by name to shopping list',
    INDENT:rep(2)..'- item name must be in double quotes and must be spelled correctly.',
    INDENT..'//sl remove <item_name>:'..INDENT..'removes item by name from shopping list',
    INDENT:rep(2)..'- item name must be in double quotes and must be spelled correctly.',
    INDENT:rep(2)..'- item must already be in shopping list.',
    INDENT..'//sl clear:'..INDENT..'removes all items from shopping list.',
    INDENT..'//sl hide:'..INDENT..'hides shopping list even if there are items on it.',
    INDENT..'//sl show:'..INDENT..'shows shopping list unless there are no items on it.',
    INDENT..'//sl save <list_name>:'..INDENT..'saves current list under <list_name>.',
    INDENT:rep(2)..'- You may not have spaces, punctuation, or special characters in your list name.',
    INDENT..'//sl load <list_name>:'..INDENT..'loads current saved list with name <list_name>.',
    INDENT..'//sl delete <list_name>:'..INDENT..'deletes current saved list with <list_name>.',
    INDENT..'//sl lists:'..INDENT..'shows all saved lists.'
  }
  notice(table.concat(help_lines,'\n'))
end

function handle_add(item_name)
  local found_item = all_items[item_name:lower()]
  if found_item == nil then
      return "%s is not the name of any item in FFXI.  Make sure you have enclosed the item name in \"double quotes\".  Example: //sl add \"Fire Crystal\".":format(item_name)
  end
  local item = {}
  item.id = all_items[item_name:lower()].id
  item.name = item_name
  item.have = false

  if is_item_in_table(watched_items, item.id) then
    return item.name..' is already being tracked! To remove it, you may type: //sl remove \"'..item.name..'\"'
  end

  table.insert(watched_items,1,item)

  draw_box()
end

function handle_remove(item_name)
  local found_item = all_items[item_name:lower()]
  if found_item == nil then
      return "%s is not the name of any item in FFXI.  Make sure you have enclosed the item name in \"double quotes\".  Example: //sl remove \"Fire Crystal\".":format(item_name)
  end
  local index = get_item_index(watched_items, found_item.id)
  if index > -1 then 
    table.remove(watched_items, index)
    notice('Removed '..item_name..' from watched list.')
  end
  draw_box()
end

function handle_clear()
  notice("Watched items cleared!")
  watched_items = T{}
  draw_box()
end

function handle_show() 
  is_hidden = false
end

function handle_hide()
  is_hidden = true
end

------------------------------
--  Box Drawing Functions   --
------------------------------
function draw_box()
  if watched_items:empty() or is_hidden then
    box:hide()
    return
  end

  local box_lines = L{}
  local inventory = windower.ffxi.get_items().inventory

  for _, watched_item in pairs(watched_items) do
    local item_count = get_item_in_inventory_quantity(watched_item.id)
    local list_item = 
    { 
      name = get_item_name(watched_item.id), 
      count = item_count
    }

    box_lines:append('['..list_item.count..'] '..list_item.name)
  end
  
  box:text(box_lines:concat('\n'))
  box:show()
end

--------------------------
--  Utility Functions   --
--------------------------
function get_item_in_inventory_quantity(item_id)
  local quantity = 0
  for _,item in pairs(windower.ffxi.get_items().inventory) do
    if type(item) == 'table' and item.id ~= nil and item.id == item_id then
      quantity = quantity + item.count
    end
  end

  return quantity
end

function get_item_index(table, item_id)
  for i,table_item in pairs(table) do
    if type(table_item) == 'table' and table_item.id ~= nil and table_item.id == item_id then
      return i
    end
  end
  return -1
end

function is_item_in_table(table, item_id)
  return get_item_index(table, item_id) > -1
end

function get_item_name(item_id)
  for k,v in pairs(all_items) do
    if v.id == item_id then
      return k
    end
  end
  return ''
end

function load_all_items()
  for k,v in pairs(res.items) do
    all_items[string.lower(v.english)] = {id = k, targets = v.targets, cast = v.cast_time, name = v.english}
  end
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
    ['show'] = handle_show,
    ['hide'] = handle_hide,
    ['save'] = handle_save,
    ['load'] = handle_load,
    ['delete'] = handle_delete,
    ['lists'] = handle_print
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
windower.register_event('load', load_all_items)
windower.register_event('prerender', draw_box)
windower.register_event('add item', draw_box)
windower.register_event('remove item', draw_box)