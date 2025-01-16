--[[
  Blueglenn Dark Knight Macros
--]]

-- Blood Weapon
windower.send_command(
  table.concat({
    'input /ws "Blood Weapon" <me>',
    'input /echo Blood Weapon: Drains target HP with melee attacks. Amount drained is same as damage dealt.',
  }, '\;')
)