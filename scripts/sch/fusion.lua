--[[
  Blueglenn Scholar Macros
--]]

local skillchain = 'Fusion'
local spells = {'Thunder', 'Fire', 'Ionohelix'}
local burstElement = 'Light'
windower.send_command(
  table.concat({
    'input /p Opening: '..skillchain..'!',
    'input /p Get ready to burst '..burstElement..'!',
    'input /ja Immanence <me>',
    'wait 1',
    'input /ma '..spells[1]..' <t>',
    'wait 4',
    'input /ja Immanence <me>',
    'wait 1',
    'input /ma '..spells[2]..' <t>',
    'wait 4',
    'input /ja Immanence <me>',
    'wait 1',
    'input /ma '..spells[3]..' <t>',
    'input /p Closing: '..skillchain..'!',
  }, '\;')
)