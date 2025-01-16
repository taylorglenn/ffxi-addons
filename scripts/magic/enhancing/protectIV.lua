--[[
  Blueglenn Enhancing Magic Macros
--]]

-- Protect IV
windower.send_command(
  table.concat({
    'input /ma "Protect IV" <me>',
    'input /echo Protect IV - Increases defense by 140.',
  }, '\;')
)