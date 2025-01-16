--[[
  Blueglenn Scholar Macros
--]]

local skillchain = 'Induration'
local opener = 'Water'
local closer = 'Blizzard'
local burstElement = 'Ice'
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