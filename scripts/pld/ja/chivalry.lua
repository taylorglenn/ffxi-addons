--[[
  Blueglenn Paladin Macros
--]]

-- Chivalry
windower.send_command(
  table.concat({
    'input /ja Chivalry <me>',
    'input /echo Converts TP to MP, MP recovered = TP×0.05 + TP×0.0015×MND',
  }, '\;')
)