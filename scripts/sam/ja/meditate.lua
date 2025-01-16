--[[
  Blueglenn Samurai Macros
--]]

-- Meditate
windower.send_command(
  table.concat({
    'input /ja "Meditate" <me>',
    'input /echo Meditate: SAM/_: 200tp/tick - _/SAM: 120tp/tick.',
  }, '\;')
)