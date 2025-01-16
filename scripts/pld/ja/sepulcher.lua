--[[
  Blueglenn Paladin Macros
--]]

-- Sepulcher
windower.send_command(
  table.concat({
    'input /ja Sepulcher <t>',
    'input /echo Target must be of the Undead family or else it will not work',
    'input /echo Provides a flat -20 to an enemy\'s accuracy, evasion, magic accuracy, magic evasion, and Store TP',
  }, '\;')
)