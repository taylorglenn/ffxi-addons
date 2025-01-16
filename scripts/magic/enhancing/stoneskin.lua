--[[
  Blueglenn Enhancing Magic Macros
--]]

-- Stoneskin
windower.send_command(
  table.concat({
    'input /ma "Stoneskin" <me>',
    'input /echo Stoneskin - Absorbs a certain amount of damage (as if you had more HP), which depends on MND and Enhancing Magic Skill.',
  }, '\;')
)