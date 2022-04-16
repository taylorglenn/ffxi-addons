--------------------------
--  Info                --
--------------------------
_addon.name = 'Bstmon'
_addon.version = '1.0'
_addon.author = 'BlueGlenn'
_addon.commands = { 'bstmon', 'bst' }

--------------------------------------------
--  System Requireds                      --
--  These should be saved in addons/libs  --
--------------------------------------------
config = require('config')
packets = require('packets')
res = require('resources')
texts = require('texts')
require('tables')
require('logger')

-------------------------------------------------------
--  Local Requireds                                  --
--  These should be saved in the root of this addon  --
-------------------------------------------------------
require('petTable')

--------------------------
--  Color Constants     --
--------------------------
colors = 
{
  ['white'] = '\\cs(255,255,255) ',
  ['red'] = '\\cs(255,0,0) ',
  ['green'] = '\\cs(0,255,0) ',
  ['yellow'] = '\\cs(255,255,0) ',
}

--------------------------
--  Configure Settings  --
--------------------------
local defaults = T{}
settings = config.load('data\\settings.xml', defaults)

--------------------------
--  Box Setup           --
--------------------------
box = texts.new(settings.text_box_settings, settings)
box:text('')

--------------------------
--  Global Jams         --
-------------------------- 
isHidden = false
verbose = false
petTp = 0 -- this is a hack
-- constants
MAX_READY_CHARGES = 3
READY_COOLDOWN = 15 -- you may need to adjust for gear
SIC_READY_RECAST_ID = 102 -- 102 is Sic/Ready according to ~/res/ability_recasts.lua

----------------------------------
--  Command Handler Functions   --
----------------------------------
function handleHelp()
  local INDENT = ' ':rep(3)
  local help_lines = 
  {
    '-- Bstmon (an addon by BlueGlenn) --',
    'Commands:',
    INDENT..'//bst show:'..INDENT..'shows the addon',
    INDENT..'//bst hide:'..INDENT..'hides the addon',
    INDENT..'//bst verbose:'..INDENT..'shows or hides the names of ready moves',
  }
  notice(table.concat(help_lines,'\n'))
end

function handleShow() 
  isHidden = false
end

function handleHide()
  isHidden = true
end

function handleVerbose()
  verbose = not verbose
end

------------------------------
--  Box Drawing Functions   --
------------------------------
function drawBox()
  if (isHidden or not isPlayerBst()) then
    box:hide()
    return
  end

  local currentPet = getCurrentPet()
  if (currentPet == nil) then return end

  local boxLines = L{}
  local INDENT = ' ':rep(3)

  -- Your ready charges
  local readyCharges = getReadyCharges()
  local readyColor = ter(readyCharges > 0, colors.white, colors.red)
  boxLines:append('Ready charges: '..readyColor..readyCharges..'\\cr')

  -- Current Pet Name
  boxLines:append('Current Pet: '..currentPet.name..'\\cr')
  
  -- Pet HP
  local hpp = currentPet.hpp
  if (hpp ~= nil and hpp > 0) then
    boxLines:append(INDENT..'hpp: '..hpp..'\\cr')
  end

  -- Pet TP
  boxLines:append(INDENT..'tp: '..petTp..'\\cr')

  -- Pet Ready Moves
  for _,v in pairs(currentPet.ready) do
    local readyMoveColor = ter(v.cost > readyCharges, colors.red, colors.white)
    boxLines:append(readyMoveColor..INDENT..'['..v.cost..'] '..v.name..'\\cr')
  end
  
  box:text(boxLines:concat('\n'))
  box:show()
end

------------------------------
--  BST Specific Functions  --
------------------------------
function isPlayerBst()
  local player = ffxi.windower.get_player()
  return player.main_job == 'BST'
end

function getReadyCharges()
  local charges = MAX_READY_CHARGES
  local readyRecast = getRecastTime(SIC_READY_RECAST_ID)
  if (readyRecast ~= 0) then
    charges = MAX_READY_CHARGES - math.ceil(readyRecast/READY_COOLDOWN)
  end
  return ter(charges < 0, 0, charges) -- this should probably never happen, but idk fuck you it's my program
end

function updatePetTp(id,original,modified,injected,blocked)
  -- packet 0x067 is 'Pet Info' and packet 0x068 is 'Pet Status' - ~addons/libs/packets/data.lua
  if (not injected and (id == 0x067 or id == 0x068)) then  
    local packet = packets.parse('incoming', original)
    local messageType = packet['Message Type']
    if (messageType == 0x04) then -- 0x04 is a personal message about your pet
      petTp = packet['Pet TP'] -- update global petTp
    end
  end
end

function getCurrentPet()
  local pet = windower.ffxi.get_mob_by_target('pet')
  -- we gotta check a few flags to make sure this doesn't id a luopan or Kyra's water spirit as our pet
  if (pet ~= nil and pet.valid_target and pet.charmed) then
    return getPetFromTable(pet.name, pet.hpp)
  end
  return nil
end

function getPetFromTable(petName, hpp) -- hpp is optional
  -- remove spaces from name if there are any
  local scrubbedName = string.gsub(petName, "%s+", "")

  local foundPet = petTable[scrubbedName]
  if (foundPet ~= nil) then
    foundPet.hpp = hpp
    return foundPet
  end

  return nil
end

--------------------------
--  Utility Functions   --
--------------------------
function ter(cond, t, f)
  if cond then return t else return f end
end

function getRecastTime(recastId)
  local recastTimer = windower.ffxi.get_ability_recasts()[recastId]
  if recastTimer == nil then return 0 end
  return recastTimer
end

--------------------------
--  Command Handlers    --
--------------------------
handlers = {
  ['help'] = handleHelp,
  ['h'] = handleHelp,
  ['show'] = handleShow,
  ['hide'] = handleHide,
  ['verbose'] = handleVerbose
}

function handleCommand(cmd, ...)
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
windower.register_event('addon command', handleCommand)
windower.register_event('prerender', drawBox)
windower.register_event('incoming chunk', updatePetTp)
