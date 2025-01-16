--[[
  Blueglenn Monk Macros
--]]

-- Chi Blast
windower.send_command(
  table.concat({
    'input /ja "Chi Blast" <t>',
    'input /echo does spirit damage | inhibit target tp gain by 25%',
  }, '\;')
)