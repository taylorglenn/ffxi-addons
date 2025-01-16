--[[
  Blueglenn Monk Macros
--]]

-- Inner Strength
windower.send_command(
  table.concat({
    'input /ja "Inner Strength" <me>',
    'input /echo doubles max hp | +100% counter rate',
  }, '\;')
)