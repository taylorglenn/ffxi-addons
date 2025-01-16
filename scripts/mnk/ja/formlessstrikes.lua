--[[
  Blueglenn Monk Macros
--]]

-- Formless Strikes
windower.send_command(
  table.concat({
    'input /ja "Formless Strikes" <me>',
    'input /echo auto attacks become spirit damage | -40% damage',
  }, '\;')
)