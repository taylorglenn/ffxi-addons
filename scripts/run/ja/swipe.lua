--[[
  Blueglenn Rune Fencer Macros
--]]

-- Swipe
windower.send_command(
  table.concat({
    'input /ja "Swipe" <t>',
    'input /echo Swipe - Expends a single (most recently activated) rune to deal damage to a target.',
  }, '\;')
)