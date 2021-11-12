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
--  Constants           --
--------------------------
COLORS_WATCHED  = '255,255,255' -- R,G,B
COLORS_ACQUIRED = '0,255,0'

--------------------------
--  System Objects      --
--------------------------
all_items = {}
watched_items = T{}

--------------------------
--  Box Setup           --
--------------------------
settings = config.load('data\\settings.xml', default_settings)
box = texts.new(settings.text_box_settings, settings)
box:text('')

--------------------------
--  Global Flags        --
-------------------------- 
is_hidden = false

----------------------------------
--  Command Handler Functions   --
----------------------------------
function handle_help()
  local INDENT = '   '
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
    INDENT..'//sl show:'..INDENT..'shows shopping list unless there are no items on it.'
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
  item.color = COLORS_WATCHED
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
    local inv_item = get_item_in_inventory(watched_item.id)
    local item_count = 0

    if inv_item ~= nil then 
      item_count = inv_item.count
    end

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
function get_item_in_inventory(item_id)
  for _,item in pairs(windower.ffxi.get_items().inventory) do
    if type(item) == 'table' and item.id ~= nil and item.id == item_id then
      return item
    end
  end
  return nil
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