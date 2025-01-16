--[[
  Blueglenn Ninjutsu Macros
--]]

-- Doton: Ni
windower.send_command(
  table.concat({
    'input /ma "Doton: Ni" <t>',
    'input /echo Doton: Ni - Deals earth damage.  Lowers resistance to wind.',
  }, '\;')
)