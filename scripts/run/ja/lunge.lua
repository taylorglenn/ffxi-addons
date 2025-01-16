--[[
  Blueglenn Rune Fencer Macros
--]]

-- Lunge
windower.send_command(
  table.concat({
    'input /ja "Lunge" <t>',
    'input /echo Lunge - Expends all runes to deal damage to a target.',
  }, '\;')
)