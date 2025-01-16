--[[
  Blueglenn Enhancing Magic Macros
--]]

-- Ice Spikes
windower.send_command(
  table.concat({
    'input /ma "Ice Spikes" <me>',
    'input /echo Ice Spikes - Grants the player Ice Armor which does damage to (and can paralyze) the foe.',
  }, '\;')
)