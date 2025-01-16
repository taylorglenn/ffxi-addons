--[[
  Blueglenn Great Sword Macros
--]]

-- Ground Strike
windower.send_command(
  table.concat({
    'input /ws "Ground Strike" <t>',
    'input /echo Ground Strike: 50% STR / 50% INT - Attack Modifier: 1.75 - Dynamic fTP: 1.5 / 1.75 / 3.0',
  }, '\;')
)