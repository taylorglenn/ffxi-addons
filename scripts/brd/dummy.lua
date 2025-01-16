---------------------------------
-- constants 
---------------------------------
local NIGHTINGALE_RECAST_ID = 109
---------------------------------
-- variables
---------------------------------
local nightingaleCommand = ''
local waitTime = 8
local recasts = windower.ffxi.get_ability_recasts()
---------------------------------
-- set up nightingale
---------------------------------
if recasts[NIGHTINGALE_RECAST_ID] == 0 then 
  nightingaleCommand = table.concat({
    'input /echo <-- attempting to use nightingale -->',
    'input /ja "Nightingale" <me>',
    'wait 4',
  }, '\;')..';' -- table.concat doesn't put a trailing delimiter
  waitTime = 4
else
  windower.send_command('input /echo <-- nightingale on cooldown -->')
end
---------------------------------
-- cast dummy songs
---------------------------------
windower.send_command(
  nightingaleCommand ..
  table.concat({
    'input /p <-- Dummy Songs going up.  Stand still, dummies. -->',
    'input //gs c set SongMode Dummy',
    'input /ma "Earth Carol" <me>',
    'wait '..waitTime,
    'input /ma "Wind Carol" <me>',
    'wait '..waitTime,
    'input /ma "Fire Carol" <me>',
    'wait '..waitTime,
    'input /ma "Ice Carol" <me>',
    'input //gs c set SongMode Normal',
    'input /p <-- Dummy Songs complete.  Stand by for big boy songs. -->',
  }, '\;')
)

