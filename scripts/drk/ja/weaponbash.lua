--[[
  Blueglenn Dark Knight Macros
--]]

-- Weapon bash
windower.send_command(
  table.concat({
    'input /ws "Weapon Bash" <t>,
    'input /echo Weapon Bash: Delivers an attack that can stun the target. Two-handed weapon required.',
  }, '\;')
)