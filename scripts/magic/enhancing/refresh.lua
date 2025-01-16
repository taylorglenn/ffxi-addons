--[[
  Blueglenn Enhancing Magic Macros
--]]

-- Refresh
windower.send_command(
  table.concat({
    'input /ma "Refresh" <me>',
    'input /echo Refresh - Recovers 3 MP every tick.',
  }, '\;')
)