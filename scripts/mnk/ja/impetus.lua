--[[
  Blueglenn Monk Macros
--]]

-- Impetus
windower.send_command(
  table.concat({
    'input /ja impetus <me>',
    'input /echo per consecutive hit: +2 attack | +1% crit rate | +1% crit damage | +2 accuracy | cap is +100 attack & +50% crit rate ',
  }, '\;')
)