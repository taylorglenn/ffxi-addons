--[[
  Blueglenn Paladin Macros
--]]

-- Holy Circle
windower.send_command(
  table.concat({
    'input /ja "Holy Circle" <me>',
    'input /echo Grants 15% resistance against undead to party members within area of effect',
  }, '\;')
)