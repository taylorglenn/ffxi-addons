--[[
  Blueglenn Paladin Macros
--]]

-- Intervene
windower.send_command(
  table.concat({
    'input /ja Intervene <t>',
    'input /echo Strikes the target with your shield and decreases its attack and accuracy',
    'input /echo Sets the enemy\'s accuracy and attack to 1 for the duration',
  }, '\;')
)