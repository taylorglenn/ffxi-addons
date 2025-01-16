--[[
  Blueglenn Rune Fencer Macros
--]]

-- Vivacious Pulse
windower.send_command(
  table.concat({
    'input /ja "Vivacious Pulse" <me>',
    'input /echo Vivacious Pulse - Restores HP (or MP) based on current runes and stats.',
    'input /echo Vivacious Pulse - Does not consume runes.',
    'input /echo Vivacious Pulse - Tenebrae restores MP.',
  }, '\;')
)