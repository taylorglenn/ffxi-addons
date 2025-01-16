--[[
  Blueglenn Ninjutsu Macros
--]]

-- Yurin: Ichi
windower.send_command(
  table.concat({
    'input /ma "Yurin: Ichi" <t>',
    'input /echo Yurin: Ichi - Inhibits monster TP gain by 10%.',
    'input /echo Yurin: Ichi - Applied separately from Subtle Blow, and is unaffected by the cap.',
  }, '\;')
)