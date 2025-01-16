--[[
  Blueglenn Scholar Macros
--]]

local skillchain = 'Reverberation'
local opener = 'Stone'
local closer = 'Water'
local burstElement = 'Water'
windower.send_command(
  table.concat({
    'input /p Opening: '..skillchain..'!',
    'wait 1',
    'input /p Get ready to burst '..burstElement..'!',
    'input /ja Immanence <me>',
    'wait 1',
    'input /ma '..opener..' <t>',
    'wait 4',
    'input /ja Immanence <me>',
    'wait 1',
    'input /p Closing: '..skillchain..'!',
    'input /ma '..closer..' <t>'
  }, '\;')
)