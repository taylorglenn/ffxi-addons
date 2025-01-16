--[[
  Blueglenn Monk Macros
--]]

-- Dodge
windower.send_command(
  table.concat({
    'input /ja Dodge <me>',
    'input /echo +179 evasion | +? guarding rate',
  }, '\;')
)