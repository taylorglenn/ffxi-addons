local slipsToGet = {
  23, -- Ambuscade Armor
  --28, -- Ambuscade Weapons

  --'04', -- geo af armor

  15, -- Reforged Artifact Armor
  16, -- Reforged Artifact Armor +1
  24, -- Reforged Artifact Armor +2
  25, -- Reforged Artifact Armor +3

  17, -- Reforged Relic Armor
  18, -- Reforged Relic Armor +1
  26, -- Reforged Relic Armor +2
  27, -- Reforged Relic Armor +3

  20, -- Reforged Empyrean Armor
  21, -- Reforged Empyrean Armor +1
  29, -- Reforged Empyrean Armor +2
}

local getStorageSlips = ''
for _,slip in pairs(slipsToGet) do
  getStorageSlips = getStorageSlips .. 'input //get storage slip ' .. tostring(slip) .. ' case;wait 0.5;'
end

local timeToWait = '20'
windower.send_command(
  table.concat({
    'input /echo +----------------------------------------------------------------+',
    'input /echo | You MUST have your slips stored in the mog case for this to work',
    'input /echo | You MUST have the itemizer and porter packer addons loaded for this to work',
    'input /echo +----------------------------------------------------------------+',
    'input //gs equip naked',
    'input /echo +---------------------+',
    'input /echo |  All gear removed',
    'input /echo +---------------------+',
    'input //gs disable all',
    'wait 1',
    'input /echo +-------------------------+',
    'input /echo |  Getting storage slips',
    'input /echo +-------------------------+',
    getStorageSlips,
    'input /echo +------------------------------+',
    'input /echo |  Done getting storage slips',
    'input /echo +------------------------------+',
    'wait 1',
    'input /echo +------------------------------------------------------------+',
    'input /echo |  Storing all items. wait '..timeToWait..' seconds. Do not move!',
    'input /echo +------------------------------------------------------------+',
    'input //timers c "Storing Items with Porter Moogle" '..timeToWait..' down',
    'input //po store',
    'wait '..timeToWait,
    'input /echo +------------------------------------------+',
    'input /echo |  Done storing items! Thanks for waiting!',
    'input /echo +------------------------------------------+',
    'input //put Storage Slip* case all',
    'input /echo +--------------------------------+',
    'input /echo |  Store all: all slips stored',
    'input /echo +--------------------------------+',
    'wait 1',
    'input //gs enable all',
  }, '\;')
)