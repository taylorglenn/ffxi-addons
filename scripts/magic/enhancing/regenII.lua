--[[
  Blueglenn Enhancing Magic Macros
--]]

-- Regen II
windower.send_command(
  table.concat({
    'input /ma "Regen II" <me>',
    'input /echo Regen II - Recovers 12 HP every tick.',
  }, '\;')
)