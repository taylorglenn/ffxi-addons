--[[
  Blueglenn Enhancing Magic Macros
--]]

-- Regen
windower.send_command(
  table.concat({
    'input /ma "Regen" <me>',
    'input /echo Regen - Recovers 5 HP every tick.',
  }, '\;')
)