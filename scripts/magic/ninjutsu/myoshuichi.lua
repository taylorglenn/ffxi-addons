--[[
  Blueglenn Ninjutsu Macros
--]]

-- Myoshu: Ichi
windower.send_command(
  table.concat({
    'input /ma "Myoshu: Ichi" <me>',
    'input /echo Myoshu: Ichi - Grants the caster Subtle Blow +10.',
    'input /echo Myoshu: Ichi - This is affected by the 50 Subtle Blow cap.',
  }, '\;')
)