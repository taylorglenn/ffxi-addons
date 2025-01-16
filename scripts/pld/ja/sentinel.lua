--[[
  Blueglenn Paladin Macros
--]]

-- Sentinel
windower.send_command(
  table.concat({
    'input /ja "Sentinel" <me>',
    'input /echo Sentinel grants a -% Physical Damage Taken for the duration of the ability, starting at -90% and decreasing by -8% every tick, ending at -50%, where it will remain until the effect wears off',
    'input /echo This ability gives +100 equipment enmity for its duration, and then creates a large hate spike (similar to Provoke)',
  }, '\;')
)