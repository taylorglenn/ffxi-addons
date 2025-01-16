--[[
  Blueglenn Monk Macros
--]]

-- Malignance Pole
windower.send_command(
  table.concat({
    'input /echo Equipping Malignance Pole & Bloodrain Strap',
    'input /equip Main "Malignance Pole"',
    'wait 1',
    'input /equip Sub "Bloodrain Strap"',
    'wait 1',
    'input /ja "Boost" <me>'
  }, '\;')
)