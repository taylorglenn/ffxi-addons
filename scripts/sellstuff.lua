res = require('resources')

local allItems = {}
for k,v in pairs(res.items) do
  allItems[k] = {id = k, name = v.english:lower()}
end

local delay = 1
local itemList = {
    -- elemental geodes
    'Aqua Geode',
    'Breeze Geode',
    'Flame Geode',
    'Light Geode',
    'Shadow Geode',
    'Snow Geode',
    'Soil Geode',
    'Thunder Geode',
    -- avatar stones
    'Ifritite',
    'Leviatite',
    'Ramuite',
    'Garudite',
    'Titanite',
    'Shivite',
    'Carbite',
    'Fenrite',
    -- mob drops
    'Colibri Feather',
    'Colibri Beak',
    -- einherjar drops
    'adaman ingot',
    'damascus ingot',
    'ocl. sheet',
    'gold ingot',
    'platinum ingot',
    'angelstone',
    'behem. leather',
    'scintillant ingot',
    'khimaira horn',
    'platinum silk',
    -- misc
    'flint Stone',
    'durium sheet',
}
-- santitize item list
for index in pairs(itemList) do
  local item = itemList[index]
  itemList[item] = item:lower()
end

local itemsToSell = {}
local inventory = windower.ffxi.get_items(0) -- bag 0 is inventory
for index = 1, inventory.max do
  local itemId = inventory[index].id
  local itemName = ''
  if itemId ~= 0 and allItems[itemId] ~= nil then
    itemName = allItems[itemId].name:lower()
  end
  if 
    type(itemName) ~= 'table' and -- inventory table has subtables, so we need to filter them out
    itemList[itemName] ~= nil and -- item has to exist in itemName table
    itemName ~= '' and            -- item name can't be empty
    itemsToSell[itemName] == nil  -- item can't already be in itemsToSell table
  then
    itemsToSell[itemName] = itemName:lower()
  end
end


local counter = 0
local sellCommand = ''
for _,item in pairs(itemsToSell) do
    counter = counter + 1
    sellCommand = sellCommand..'input //sellnpc '..item..';wait '..delay..';'
end

local shopkeepWindow = '10' -- string representing seconds
windower.send_command(
  table.concat({
    'input //timers c "adding '..counter..' items to list" '..(delay * counter)..' down',
    'input /echo +---------------------------------------------+',
    'input /echo |  Loading items. Please wait for '..(delay * counter)..' seconds.  |',
    'input /echo +---------------------------------------------+',
    'input //lua l sellnpc',
    sellCommand,
    'input //timers c "selling window is open" '..shopkeepWindow..' down',
    'input /echo +--------------------------------------------------------+',
    'input /echo |  You have '..shopkeepWindow..' seconds to speak with a shopkeep NPC.   |',
    'input /echo +--------------------------------------------------------+',
    'wait '..shopkeepWindow,
    'input //lua u sellnpc',
    'input /echo +-------------------------------------+',
    'input /echo |  Sell NPC addon has been unloaded.  |',
    'input /echo +-------------------------------------+',
  }, '\;')
)