--[[
  Blueglenn Paladin Macros
--]]

-- Divine Emblem
windower.send_command(
  table.concat({
    'input /ja "Divine Emblem" <me>',
    'input /echo Increases the Special Enmity Bonus of the next Divine Magic cast by 50%',
  }, '\;')
)