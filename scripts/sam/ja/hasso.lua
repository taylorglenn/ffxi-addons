--[[
  Blueglenn Samurai Macros
--]]

-- Hasso
windower.send_command(
  table.concat({
    'input /ja "Hasso" <me>',
    'input /echo Hasso: Grants +STR, +10 Accuracy and +10% haste for melee attacks.',
    'input /echo Hasso: Increases recast and casting times.',
  }, '\;')
)