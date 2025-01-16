--[[
  Blueglenn Enhancing Magic Macros
--]]

-- Regen IV
windower.send_command(
  table.concat({
    'input /ma "Regen IV" <me>',
    'input /echo Regen IV - Recovers 30 HP every tick.',
  }, '\;')
)