--[[
  Blueglenn Rune Fencer Macros
--]]

-- Embolden
windower.send_command(
  table.concat({
    'input /ja Embolden <me>',
    'input /echo Embolden - Increases Enhancing Magic potency by 50% and decreases duration by 50% for spells cast on yourself.',
  }, '\;')
)