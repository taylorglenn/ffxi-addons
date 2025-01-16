--[[
  Blueglenn Dark Knight Macros
--]]

-- Consume Mana
windower.send_command(
  table.concat({
    'input /ws "Consume Mana" <me>',
    'input /echo Consume Mana: Consumes all MP upon the next attack or weaponskill after use.',
    'input /echo Adds 1 base damage to the attack for every 10mp consumed.',
  }, '\;')
)