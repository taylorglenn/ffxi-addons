-- set up locals
local delay = 2
local itemToBuyCount=36 
local itemToBuy='Acheron Shield'

local inv = windower.ffxi.get_bag_info()['inventory'] 

-- check inventory space, eject if necessary
local freeSlots = inv.max - inv.count
if (freeSlots < itemToBuyCount) then 
  windower.chat.input('/echo you need '..tostring(itemToBuyCount)..' free inventory slots to run this script... exiting...') 
  return
end

-- do the thing
local buyCommand = ''
for i=1,itemToBuyCount do 
  buyCommand = buyCommand..'input /echo '..tostring(i)..'/'..tostring(itemToBuyCount)..';input //sparks buy '..itemToBuy..';wait '..delay..';'
  windower.chat.input('//sparks buy ' .. itemToBuy) 
end

windower.send_command(
  table.concat({
    'input //timers c "buying'..itemToBuyCount..' '..itemToBuy..'" '..(delay * itemToBuyCount)..' down',
    'input //lua l sparks',
    'input /echo Attempting to buy '..tostring(itemToBuyCount)..' '..itemToBuy..'(s).  Make sure you are standing next to the sparks guy and you have room in your inventory.',
    buyCommand,
    'input /echo Done buying'..itemToBuy..'(s).  Go man hay.',
    'input //lua u sparks',
    'input //lua l sellnpc',
    'input //sellnpc '..itemToBuy
  }, '\;')
)