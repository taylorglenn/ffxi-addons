--[[
  Blueglenn Trust Macros
--]]

-- Default Trusts
windower.send_command(
  table.concat({
    'input /echo Summoning default trusts.',
    'input /ma "Cornelia" <me>',
    'wait 6',
    'input /ma "Yoran-Oran (UC)" <me>',
    'wait 6',
    'input /ma "Koru-Moru" <me>',
    'wait 6',
    'input /ma "Monberaux" <me>',
    'wait 6',
    'input /ma "Qultada" <me>',
    'wait 6',
    'input /echo Trusts are summoned.  Good luck.'
  }, '\;')
)
