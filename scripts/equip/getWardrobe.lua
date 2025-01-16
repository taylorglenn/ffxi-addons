local playerJob = windower.ffxi.get_player().main_job:lower()
local setList = {
  -- war
  war = { 
    "Pummeler's",
    "Agoge",
    "Boii", 
    "Flam.",
    "Sulev.",
  },
  -- mnk
  mnk = { 

    "Anchorite's",
    "Hesychast's",
    "Bhikku", 
  },
  -- whm
  whm = { 
    "Theophany",
    "Piety",
    "Ebers", 
  },
  -- blm
  blm = { 
    "Spaekona's",
    "Archmage's",
    "Wicce", 
  },
  -- rdm
  rdm = { 
    "Atrophy",
    "Vitiation",
    "Lethargy", 
    "Sucellos's",
  },
  -- thf
  thf = { 
    "Pillager's",
    "Plunderer's",
    "Skulker's", 
  },
  -- pld
  pld = { 
    "Reverence",
    "Caballarius",
    "Chevalier's", 
  },
  -- drk
  drk = { 
    "Ignominy",
    "Fallen's",
    "Heathen's", 
  },
  -- bst
  bst = { 
    "Totemic",
    "Ankusa",
    "Nukumi", 
  },
  --brd
  brd = { 
    "Brioso",
    "Bihu",
    "Fili", 
  },
  -- rng
  rng = { 
    "Orion",
    "Arcadian",
    "Amini", 
  },
  -- sam
  sam = { 
    "Wakido",
    "Sakonji",
    "Kasuga", 
    "Flam.",
  },
  -- nin
  nin = { 
    "Hachiya",
    "Mochizuki",
    "Hattori", 
  },
  -- drg
  drg = { 
    "Vishap",
    "Pteroslaver",
    "Peltast's", 
  },
  -- smn
  smn = { 
    "Convoker's",
    "Glyphic",
    "Beckoner's", 
  },
  -- blu
  blu = { 
    "Assimilator's",
    "Luhlaza",
    "Hashishin", 
  },
  -- cor
  cor = { 
    "Laksamana's",
    "Lanun",
    "Chasseur's", 
  },
  -- pup
  pup = { 
    "Foire",
    "Pitre",
    "Karagoz", 
    "Tali'ah",
  },
  -- dnc
  dnc = { 
    "Maxixi",
    "Horos",
    "Maculele", 
  },
  -- sch
  sch = { 
    "Academic's",
    "Pedagogy",
    "Arbatel", 
  },
  -- geo
  geo = { 
    "Geomancy",
    "Bagua",
    "Azimuth", 
  },
  -- run
  run = { 
    "Runeist",
    "Futhark",
    "Erilaz" 
  },
}
local currentJobSets = setList[playerJob]
if currentJobSets == nil then
  windower.add_to_chat(123, "Set for player job: "..playerJob.." was not found.")
  return
end

local moveGearCommand = ''
for _,setName in pairs(currentJobSets) do
  moveGearCommand = moveGearCommand .. 'input //get ' .. setName .. '* wardrobe4 all;wait 0.5;'
end

windower.send_command(
  table.concat({
    'input /echo get wardrobe4: pulling gear from wardrobe 4 to be stored with porter moogle',
    moveGearCommand,
    'input /echo get wardrobe4: done moving gear from wardrobe 4.'
  }, '\;')
)