--[[
  Blueglenn Enhancing Magic Macros
--]]

-- Blink
windower.send_command(
  table.concat({
    'input /ma "Blink" <me>',
    'input /echo Blink - Creates 2 shadow images per cast.',
  }, '\;')
)