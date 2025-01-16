--[[
  Blueglenn Enhancing Magic Macros
--]]

-- Foil
windower.send_command(
  table.concat({
    'input /ma "Foil" <me>',
    'input /echo Foil - Provides a substantial amount of Evasion when facing "Special Attacks" (starting at 150 evasion). This effect decays at a rate of 3 evasion loss per tick.',
  }, '\;')
)