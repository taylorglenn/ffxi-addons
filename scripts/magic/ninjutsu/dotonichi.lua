--[[
  Blueglenn Ninjutsu Macros
--]]

-- Doton: Ichi
windower.send_command(
  table.concat({
    'input /ma "Doton: Ichi" <t>',
    'input /echo Doton: Ichi - Deals earth damage.  Lowers resistance to wind.',
  }, '\;')
)