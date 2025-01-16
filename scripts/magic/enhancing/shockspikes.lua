--[[
  Blueglenn Enhancing Magic Macros
--]]

-- Shock Spikes
windower.send_command(
  table.concat({
    'input /ma "Shock Spikes" <me>',
    'input /echo Shock Spikes - Grants the player Lightning Armor which does damage to (and can stun) the foe.',
  }, '\;')
)