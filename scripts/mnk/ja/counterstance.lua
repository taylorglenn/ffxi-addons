--[[
  Blueglenn Monk Macros
--]]

-- Counterstance
windower.send_command(
  table.concat({
    'input /ja counterstance <me>',
    'input /echo +66% counter rate | -50% defense | +40% counter damage',
  }, '\;')
)