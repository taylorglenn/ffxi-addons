--[[
  Blueglenn Monk Macros
--]]

-- Dragon Kick
windower.send_command(
  table.concat({
    'input /ws "Dragon Kick" <t>',
    'input /echo Dragon Kick: 50% STR / 50% VIT - Dynamic fTP: 1.7 / 3 / 5 - During footwork, uses foot base damage instead of h2h',
  }, '\;')
)