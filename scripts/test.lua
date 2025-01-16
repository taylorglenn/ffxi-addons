--local playerJob = windower.ffxi.get_player().main_job

local setList = {
  -- war
  "Pummeler's",
  "Agoge",
  "Boii",
  -- mnk
  "Anchorite's",
  "Hesychast's",
  "Bhikku",
  -- whm
  "Theophany",
  "Piety",
  "Ebers",
  -- blm
  "Spaekona's",
  "Archmage's",
  "Wicce",
  -- rdm
  "Atrophy",
  "Vitiation",
  "Lethargy",
  -- thf
  "Pillager's",
  "Plunderer's",
  "Skulker's",
  -- pld
  "Reverence",
  "Caballarius",
  "Chevalier's",
  -- drk
  "Ignominy",
  "Fallen's",
  "Heathen's",
  -- bst
  "Totemic",
  "Ankusa",
  "Nukumi",
  --brd
  "Brioso",
  "Bihu",
  "Fili",
  -- rng
  "Orion",
  "Arcadian",
  "Amini",
  -- sam
  "Wakido",
  "Sakonji",
  "Kasuga",
  -- nin
  "Hachiya",
  "Mochizuki",
  "Hattori",
  -- drg
  "Vishap",
  "Pteroslaver",
  "Peltast's",
  -- smn
  "Convoker's",
  "Glyphic",
  "Beckoner's",
  -- blu
  "Assimilator's",
  "Luhlaza",
  "Hashishin",
  -- cor
  "Laksamana's",
  "Lanun",
  "Chasseur's",
  -- pup
  "Foire",
  "Pitre",
  "Karagoz",
  -- dnc
  "Maxixi",
  "Horos",
  "Maculele",
  -- sch
  "Academic's",
  "Pedagogy",
  "Arbatel",
  -- geo
  "Geomancy",
  "Bagua",
  "Azimuth",
  -- run
  "Runeist",
  "Futhark",
  "Erilaz"
}

local moveGearCommand = ''
for _,setName in pairs(setList) do
  moveGearCommand = moveGearCommand .. 'input //get ' .. setName .. ' wardrobe4 all;wait 0.5;'
end

windower.send_command(
  table.concat({
    'input /echo store all: pulling gear from wardrobe 4 to be stored with porter moogle',
    moveGearCommand,
    'input /echo store all: done moving gear from wardrobe 4.  Now storing with porter moogle.'
  }, '\;')
)
