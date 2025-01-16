--[[
  Blueglenn Monk Macros
--]]

-- Warrior Buffs
windower.send_command(
  table.concat({
    'input /ja Berserk <me>',
    'input /echo Berserk - +25% attack & ranged attack | -25% defense',
    'wait 2',
    'input /ja Aggressor <me>',
    'input /echo Aggressor - +25 accuracy | -25 evasion',
  }, '\;')
)