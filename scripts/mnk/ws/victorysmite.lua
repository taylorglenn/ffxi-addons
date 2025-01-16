--[[
  Blueglenn Monk Macros
--]]

-- Victory Smite
windower.send_command(
  table.concat({
    'input /ws "Victory Smite" <t>',
    'input /echo Victory Smite: 80% STR - Static fTP @ 1.5 - TP modifies critical hit rate - +10% / +25% / +45%',
  }, '\;')
)