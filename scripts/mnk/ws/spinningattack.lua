--[[
  Blueglenn Monk Macros
--]]

-- Spinning Attack
windower.send_command(
  table.concat({
    'input /ws "Spinning Attack" <t>',
    'input /echo Spinning Attack: 100% STR - Static fTP @1.0 - TP modifies attack radius',
  }, '\;')
)