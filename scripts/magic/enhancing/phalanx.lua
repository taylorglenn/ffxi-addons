--[[
  Blueglenn Enhancing Magic Macros
--]]

-- Phalanx
windower.send_command(
  table.concat({
    'input /ma "Phalanx" <me>',
    'input /echo Phalanx - Reduces damage by a set amount, which depends on Enhancing Magic skill (caps at 500, which gives -35 damage).',
  }, '\;')
)