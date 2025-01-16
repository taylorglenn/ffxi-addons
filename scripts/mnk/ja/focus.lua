--[[
  Blueglenn Monk Macros
--]]

-- Focus
windower.send_command(
  table.concat({
    'input /ja Focus <me>',
    'input /echo +140 accuracy | +20% crit rate',
  }, '\;')
)