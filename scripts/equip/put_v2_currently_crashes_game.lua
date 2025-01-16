local slipsToGet = {
  23, -- Ambuscade Armor
  --28, -- Ambuscade Weapons

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
}

-- local setList = {
--   -- war
--   "Pummeler's",
--   "Agoge",
--   "Boii",
--   -- mnk
--   "Anchorite's",
--   "Hesychast's",
--   "Bhikku",
--   -- whm
--   "Theophany",
--   "Piety",
--   "Ebers",
--   -- blm
--   "Spaekona's",
--   "Archmage's",
--   "Wicce",
--   -- rdm
--   "Atrophy",
--   "Vitiation",
--   "Lethargy",
--   -- thf
--   "Pillager's",
--   "Plunderer's",
--   "Skulker's",
--   -- pld
--   "Reverence",
--   "Caballarius",
--   "Chevalier's",
--   -- drk
--   "Ignominy",
--   "Fallen's",
--   "Heathen's",
--   -- bst
--   "Totemic",
--   "Ankusa",
--   "Nukumi",
--   --brd
--   "Brioso",
--   "Bihu",
--   "Fili",
--   -- rng
--   "Orion",
--   "Arcadian",
--   "Amini",
--   -- sam
--   "Wakido",
--   "Sakonji",
--   "Kasuga",
--   -- nin
--   "Hachiya",
--   "Mochizuki",
--   "Hattori",
--   -- drg
--   "Vishap",
--   "Pteroslaver",
--   "Peltast's",
--   -- smn
--   "Convoker's",
--   "Glyphic",
--   "Beckoner's",
--   -- blu
--   "Assimilator's",
--   "Luhlaza",
--   "Hashishin",
--   -- cor
--   "Laksamana's",
--   "Lanun",
--   "Chasseur's",
--   -- pup
--   "Foire",
--   "Pitre",
--   "Karagoz",
--   -- dnc
--   "Maxixi",
--   "Horos",
--   "Maculele",
--   -- sch
--   "Academic's",
--   "Pedagogy",
--   "Arbatel",
--   -- geo
--   "Geomancy",
--   "Bagua",
--   "Azimuth",
--   -- run
--   "Runeist",
--   "Futhark",
--   "Erilaz"
-- }

-- local moveGearCommand = ''
-- for _,setName in pairs(setList) do
--   moveGearCommand = moveGearCommand .. 'input //get ' .. setName .. ' wardrobe4 all;wait 0.5;'
-- end

local getStorageSlips = ''
for _,slip in pairs(slipsToGet) do
  getStorageSlips = getStorageSlips .. 'input //get storage slip ' .. tostring(slip) .. ' case;wait 0.5;'
end

print('storing all equpment')
windower.send_command(
  table.concat({
    'input /echo store all: you MUST have your slips stored in the mog case for this to work',
    'input /echo store all: you MUST have itemizer, porter packer, and timer addons loaded for this to work',
    'input //gs equip naked',
    'input /echo store all: all gear removed',
    'input //gs disable all',
    'wait 1',
    -- 'input /echo store all: pulling gear from wardrobe 4 to be stored with porter moogle',
    -- moveGearCommand,
    -- 'wait 1',
    'input /echo store all: getting storage slips',
    getStorageSlips,
    'input /echo store all: done getting storage slips',
    'wait 1',
    'input /echo store all: storing all items. wait 30 seconds. do not move!',
    'input //timers c "Storing Items with Porter Moogle" 30 down',
    'input //po store',
    'wait 30',
    'input /echo store all: done storing items! thanks for waiting!',
    'input //put Storage Slip* case all',
    'input /echo store all: all slips stored',
    'wait 1',
    'input //gs enable all',
  }, '\;')
)