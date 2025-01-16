--[[
  Blueglenn Rune Fencer Macros
--]]

-- Swordplay
windower.send_command(
  table.concat({
    'input /ja Swordplay <me>',
    'input /echo Swordplay - Acc. & Eva. +6/tick (caps at 60) until ~75% of max HP in damage taken.',
  }, '\;')
)