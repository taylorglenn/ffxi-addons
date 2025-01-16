--[[
  Blueglenn Enhancing Magic Macros
--]]

-- Regen III
windower.send_command(
  table.concat({
    'input /ma "Regen III" <me>',
    'input /echo Regen III - Recovers 20 HP every tick.',
  }, '\;')
)