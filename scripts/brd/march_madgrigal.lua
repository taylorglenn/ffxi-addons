---------------------------------
-- constants 
---------------------------------
local NIGHTINGALE_RECAST_ID = 109
local TROUBADOUR_RECAST_ID = 110
---------------------------------
-- variables
---------------------------------
local nightingaleCommand = ''
local troubadourCommand = ''
local waitTime = 8
local recasts = windower.ffxi.get_ability_recasts()
---------------------------------
-- set up nightingale
---------------------------------
if recasts[NIGHTINGALE_RECAST_ID] == 0 then 
  nightingaleCommand = table.concat({
    'input /echo <-- attempting to use nightingale -->',
    'input /ja "Nightingale" <me>',
    'wait 2',
  }, '\;')..';' -- table.concat doesn't put a trailing delimiter
  waitTime = 4
else
  windower.send_command('input /echo <-- nightingale on cooldown -->;')
end
---------------------------------
-- set up troubadour
---------------------------------
if recasts[TROUBADOUR_RECAST_ID] == 0 then 
  troubadourCommand = table.concat({
    'input /echo <-- attempting to use troubadour -->',
    'input /ja "Troubadour" <me>',
    'wait 4',
  }, '\;')..';' -- table.concat doesn't put a trailing delimiter
else
  windower.send_command('input /echo <-- troubadour on cooldown -->;')
end
---------------------------------
-- cast songs
---------------------------------
windower.send_command(
  'input /p <-- Songs going up. Please stay near me for the next '..(waitTime*4)..' seconds. -->;' ..
  nightingaleCommand ..
  troubadourCommand ..
  table.concat({
    'input //gs c set SongMode Normal',
    'input /ma "Sword Madrigal" <me>',
    'wait '..waitTime,
    'input /ma "Blade Madrigal" <me>',
    'wait '..waitTime,
    'input /ma "Honor March" <me>',
    'wait '..waitTime,
    'input /ma "Victory March" <me>',
    'wait '..waitTime,
    'input /p <-- Songs are sung. Please let me know if you don\'t have one. -->',
  }, '\;')
)