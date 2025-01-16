---------------------------------
-- includes
---------------------------------
function get_sets()
  -- Load and initialize the include file.
  mote_include_version = 2
  include('Mote-Include.lua')
end

---------------------------------
-- lockstyle 
---------------------------------
function set_lockstyle(page)
  send_command('@wait 6;input /lockstyleset ' .. tostring(page))
end
set_lockstyle(18)

---------------------------------
-- macros 
---------------------------------
function set_macros(sheet, book)
  if book then
    send_command('@input /macro book ' .. tostring(book) .. ';wait .1;input /macro set ' .. tostring(sheet))
    return
  end
  send_command('@input / macro set ' .. tostring(sheet))
end
set_macros(1, 04)

---------------------------------
-- job setup
---------------------------------
function job_setup()
  --windower.raw_register_event('prerender', drawDisplay)
  windower.register_event('status change', handleStatusChange)
end

---------------------------------
-- globals
---------------------------------
res = require('resources')
all_items = {}
for k,v in pairs(res.items) do
    all_items[string.lower(v.english)] = {
        id = k, 
        name = v.english
    }
end

---------------------------------
-- dislpay globals
---------------------------------
-- for pet menu
petMenuDisplaySettings = 
{ 
  pos = 
  {
    x = -1200,
    y = 720
  },
  text = 
  {
    font = 'Consolas',
    size = 12
  },
  flags = 
  {
    right = true,
    draggable = true
  }
}
petMenuDisplayBox = texts.new('${value}', petMenuDisplaySettings)
-- for not pet menu :D
jobStateDisplaySettings = 
{ 
  pos = 
  {
    x = 0,
    y = 0

  },
  text = 
  {
    font = 'Consolas',
    size = 10
  },
  bg = 
  {
    alpha = 255
  },
  flags = 
  {
    draggable = false
  }
}
jobStateDisplayBox = texts.new('${value}', jobStateDisplaySettings)

---------------------------------
-- user setup
---------------------------------
function user_setup() 
  -- built-in state tables
  state.IdleMode:options('Normal')
  send_command('bind ^i gs c cycle IdleMode')

  state.OffenseMode:options('Me Me Me', 'Pikachu I choose you', 'Protect the baby', 'Gotta land it', 'The Power of Friendship')
  send_command('bind ^o gs c cycle OffenseMode')

  -- custom state tables
  state.PetMenuDisplayMode = M{ 'false', 'true' }
  send_command('bind ^q gs c cycle PetMenuDisplayMode')

  state.FightMode = M{ 'Manual', 'Auto' }
  send_command('bind ^f gs c cycle FightMode')
  
  state.PetMode = M{
    --['description'] = 'PetMode',
    'Fluffy Bredo',
    'Swooping Zhivago',
    'Generous Arthur',
    'Energized Sefina',
    'Daring Roland',
    'Jovial Edwin',
    'Rhyming Shizuna', 
    'Vivacious Gaston',
    'Vivacious Vickie', 
    'Bouncing Bertha',
    'Sultry Patrice',
    'Fatso Fargann',
    'Blackbeard Randy',
    'Warlike Patrick',
    'Pondering Peter'
  }
  send_command('bind ^p gs c cycle PetMode')
  send_command('bind !p gs c cycleback PetMode')

  drawJobStateDisplay()

  windower.register_event('remove item', drawJobStateDisplay)
  windower.register_event('add item', drawJobStateDisplay)

  ---------------------------------
  -- jse setup
  ---------------------------------
  gear.globals.bst = 
  {
    capes = 
    { 
      dex_stp  = { name="Artio's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+10','"Store TP"+10','Phys. dmg. taken-10%',}},
      wsd = { },
      str_da = { name="Artio's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','"Dbl.Atk."+10','Phys. dmg. taken-10%',}}, 
      pet_phys = { name="Artio's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+20 /Mag. Eva.+20','Pet: Attack+10 Pet: Rng.Atk.+10','Pet: Haste+10','Pet: "Regen"+5',}},
      pet_mag = { },
      pet_dt = { }
    },
    
    neck = "Bst. Collar +1",

    artifact = 
    {
      "Totemic Helm +2",
      "Totemic Jackcoat +2",
      "Totemic Gloves +2",
      "Totemic Trousers",
      "Totemic Gaiters",
    },

    relic = 
    {      
      "Ankusa Helm +3",
      "Ankusa Jackcoat +3",
      "Ankusa Gloves +3",
      "Ankusa Trousers +3",
      "Ankusa Gaiters +3",
    },

    empyrean = 
    {   
      "Nukumi Cabasset +1",
      "Nukumi Gausape +1",
      "Nukumi Manoplas +1",
      "Nukumi Quijotes +1",
      "Nukumi Ocreae +1",
    },
  }
end

---------------------------------
-- user unload
---------------------------------
function user_unload()
  -- unload keybinds
  send_command('unbind ^i') -- unbinds IdleMode from i key
  send_command('unbind ^o') -- unbinds OffenseMode from o key
  send_command('unbind ^f') -- unbinds FightMode from f key
  send_command('unbind ^p') -- unbinds PetMode from p key
  send_command('unbind !p') -- unbinds PetMode from p key
  send_command('unbind ^q') -- unbinds PetMenuDisplayMode from q key
end

---------------------------------
-- define gear sets
---------------------------------
function init_gear_sets()
  -- this is the order.  the order is arbitrary, but you should try to keep it consistent
    -- main
    -- sub
    -- range
    -- ammo
    -- head
    -- body
    -- hands
    -- legs
    -- feet
    -- neck 
    -- waist
    -- ear1
    -- ear2
    -- ring1
    -- ring2
    -- back

  ---------------------------------
  -- idle
  ---------------------------------
  sets.idle =
  {   
    ammo = "Staunch Tathlum",
    head = gear.globals.gleti.head,
    body = gear.globals.gleti.body,
    hands= gear.globals.gleti.hands,
    legs = gear.globals.gleti.legs,
    feet = gear.globals.gleti.feet,
    neck = "Bathy Choker +1",
    waist= "Flume Belt",
    ear1 = "Infused Earring",
    ear2 = "Etiolation Earring",
    ring1= "Defending Ring",
    ring2= "Gelatinous Ring +1",
    back = "Moonbeam Cape"
  }
  ---------------------------------
  -- melee
  ---------------------------------
  sets.engaged =
  {
    ammo = "Aurgelmir Orb",
    head = gear.globals.gleti.head,
    body = gear.globals.gleti.body,
    hands= "Emicho Gauntlets +1",
    legs = gear.globals.gleti.legs,
    feet = gear.globals.gleti.feet,
    neck = gear.globals.bst.neck,
    waist= "Sailfi Belt +1",
    ear1 = "Sherida Earring",
    ear2 = "Crep. Earring",
    ring1= "Gere Ring",
    ring2= "Chirich Ring +1",
    back = gear.globals.bst.capes.dex_stp
  }

  -- master tp only set
  sets.engaged['Me Me Me'] = set_combine(sets.engaged, {

  })

  -- pet tp only set
  sets.engaged['Pikachu I choose you'] = set_combine(sets.engaged, {
    
  })

  -- pet dt set
  sets.engaged['Protect the baby'] = set_combine(sets.engaged, {

  })

  -- pet macc set
  sets.engaged['Gotta land it'] = set_combine(sets.engaged, {
    
  })

  -- hybrid master/pet tp set
  sets.engaged['The Power of Friendship'] = set_combine(sets.engaged, {
    
  })
  
  ---------------------------------
  -- job abilities
  ---------------------------------
  sets.precast.Pet = { }
  sets.precast.Pet['Ready'] = 
  {
    legs = gear.globals.gleti.legs -- "Sic" and "Ready" ability delay -5 seconds
  }

  --sets.midcast.Pet['Ready'] = 
  sets.midcast.Pet.WS =
  {
    head = gear.globals.nyame.head,
    body = gear.globals.nyame.body,
    hands= gear.globals.bst.empyrean.hands,
    legs = gear.globals.nyame.legs,
    feet = gear.globals.nyame.feet,
    --neck = gear.globals.bst.neck,
    neck = "Shulmanu Collar",
    waist= "Klouskap Sash +1",
    ear1 = "Enmerkar Earring",
    ear2 = "Crep. Earring",
    ring1= "Varar Ring +1",  -- todo
    ring2= "C. Palug Ring",  -- todo
    back = gear.globals.bst.capes.pet_phys
  }

  sets.precast.Pet['Reward'] = -- 50% potency cap.
  {
    head = "Stout Bonnet", -- todo -- Reduces Reward recast time by -16 seconds
    body = gear.globals.bst.relic.body, -- Removes Paralysis, Poison, Blind, Silence, Weight, Slow, Amnesia
    legs = gear.globals.bst.relic.legs, -- Reward recast -21 seconds.
    feet = gear.globals.bst.relic.feet, -- Increases Reward potency by 41%. -- Enhances Beast Healer effect by giving another +1 HP/tick Regen per merit level.
    ear1 = "Pratik Earring", -- todo -- Reward + 10
  }

  sets.precast.JA['Call Beast'] =
  {
    hands = gear.globals.bst.relic.hands 
    -- Removes the chance of spawning pets with -2 or -1 level difference
    -- Increases each level of Beast Affinity to Pet Level+3 effect
  }

  sets.precast.JA['Bestial Loyalty'] = sets.precast.JA['Call Beast']

  sets.precast.JA['Feral Howl'] = 
  {
    body = gear.globals.bst.relic.body --Increases duration of Terror effect by +1 second per merit point.
  }

  sets.precast.JA['Killer Instinct'] = 
  {
    head = gear.globals.bst.relic.head -- Increases duration by +3 seconds per merit point.
  }

  sets.precast.JA['Spur'] = 
  {
    feet = gear.globals.bst.empyrean.feet -- Grants an additional "Store TP"+15 effect
  }

  ---------------------------------
  -- weapon skill sets
  ---------------------------------
  sets.precast.WS = 
  {
    head = gear.globals.bst.relic.head,
    body = gear.globals.gleti.body,
    hands= gear.globals.bst.artifact.hands,
    legs = gear.globals.gleti.legs,
    feet = gear.globals.gleti.feet,
    neck = "Fotia Gorget",
    waist= "Fotia Belt",
    ear1 = "Sherida Earring",
    ear2 = "Crep. Earring",
    ring1= "Gere Ring",
    ring2= "Epona's Ring",
    back = gear.globals.bst.capes.str_da
  }

  -- Decimation: 50% STR - Static fTP @ 1.75 - TP increases accuracy (though how much is unknown)
  sets.precast.WS['Decimation'] = set_combine(sets.precast.WS,
  {
    head = gear.globals.gleti.head,
    body = gear.globals.gleti.body,
    hands= gear.globals.gleti.hands,
    legs = gear.globals.gleti.legs,
    feet = gear.globals.gleti.feet,
    neck = "Fotia Gorget",
    waist= "Fotia Belt",
    ear1 = "Sherida Earring",
    ear2 = "Brutal Earring",
    ring1= "Gere Ring",
    ring2= "Epona's Ring",
    back = gear.globals.bst.capes.str_da
  })
  
end

---------------------------------
-- gearswap hooks
---------------------------------
function job_precast(spell, action, spellMap, eventArgs)
  if spell.name:lower() == 'bestial loyalty' or spell.name:lower() == 'call beast' then
    handleBestialLoyalty()
  end

  if spell.name:lower() == 'reward' then
    handleReward()
  end
end

function job_midcast(spell, action, spellMap, eventArgs)
  -- handle ready
  if spell.type == 'Monster' then
    equip(sets.midcast.Pet.Ready)
  end
end

-- Called when a player gains or loses a pet.
-- pet == pet gained or lost
-- gain == true if the pet was gained, false if it was lost.
function job_pet_change(pet, gain)

end

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)

end

function job_state_change(field, newValue, oldValue)
  -- Always redraw Job State display
  drawJobStateDisplay()
  -- DisplayMode Changed
  if (state.PetMenuDisplayMode:contains(newValue) and newValue == 'true') then
    drawPetMenuDisplay()
  end
  -- PetMode changed
  if (state.PetMode:contains(newValue) and newValue ~= oldValue) then
    drawPetMenuDisplay()
  end
end

---------------------------------
-- display stuff
---------------------------------
function drawPetMenuDisplay()
  if (state.PetMenuDisplayMode.value ~= 'true') then
    petMenuDisplayBox:hide()
    return
  end

  local INDENT = ' ':rep(3)
  local displayLines = L{}

  local currentPetMode = state.PetMode.value
  local prevPetMode = tablePrev(state.PetMode, currentPetMode)
  local prevPrevPetMode = tablePrev(state.PetMode, prevPetMode)
  local nextPetMode = tableNext(state.PetMode, currentPetMode)
  local nextNextPetMode = tableNext(state.PetMode, nextPetMode)

  local foundPet = getPetFromTable(currentPetMode)
  local matchups = getPetmatchups(foundPet.type)

  displayLines:append('\\cs(74,74,74)'..'prev: '..prevPrevPetMode..'')
  displayLines:append('\\cs(125,125,125)'..'prev: '..prevPetMode..'')
  displayLines:append('PetMode: '..currentPetMode..' - Type: '..foundPet.type..' | Strong: '..matchups.strong..' | Weak: '..matchups.weak..'')
  displayLines:append('\\cs(125,125,125)'..'next: '..nextPetMode..'')
  displayLines:append('\\cs(74,74,74)'..'next: '..nextNextPetMode..'')

  petMenuDisplayBox:text(displayLines:concat('\\cr\n'))
  petMenuDisplayBox:show()
end

function drawJobStateDisplay()
  local INDENT = ' ':rep(3)
  local displayLines = L{}

  -- Modes
  displayLines:append('[I]dle: '..state.IdleMode.value)
  displayLines:append('[O]ffense: '..state.OffenseMode.value)
  displayLines:append('[F]ight: '..tostring(state.FightMode.value))

  local foundPet = getPetFromTable(state.PetMode.value)
  if(foundPet == nil or foundPet.item == nil) then
    displayLines:append('Error: pet data not found in pet table.')
  else
    displayLines:append('[P]et: '..state.PetMode.value..' ('..foundPet.type..')')

    displayLines:append(' - ')
    -- Show Pet Jugs for current PetMode
    displayLines:append(foundPet.item..': '..count_item(foundPet.item))
  end
  -- Show number of Pet Foods
  displayLines:append('Pet Food Theta: '..count_item('pet food theta'))

  jobStateDisplayBox:text(displayLines:concat(' | '))
  jobStateDisplayBox:show()
end

---------------------------------
-- table methods
---------------------------------
function tableIndexOf(t, e)
  for k,v in pairs(t) do
    if v == e then
      return k
    end
  end
  return -1
end

function tableNext(t, e)
  local currentIndex = tableIndexOf(t, e)
  if (currentIndex == -1) then return -1 end

  local nextIndex = (currentIndex + 1 <= table.getn(t)) and (currentIndex + 1) or 1
  return t[nextIndex]
end

function tablePrev(t, e)
  local currentIndex = tableIndexOf(t, e)
  if (currentIndex == -1) then return -1 end

  local prevIndex = (currentIndex - 1 < 1) and (table.getn(t)) or (currentIndex - 1)
  return t[prevIndex]
end

---------------------------------
-- my functions
---------------------------------
function dumpPetTable()
  local pet = windower.ffxi.get_mob_by_target('pet')

  if (not pet) then return warning('No pet') end

  for k,v in pairs(pet) do
    warning('["'..tostring(k)..'"] = '..tostring(v))
  end
end

function warning(text)
  -- just a wrapper to keep my nice red color consistent
  windower.add_to_chat(123, text)
end

function handleStatusChange(new_status_id, old_status_id)
  -- supported statuses: 0 - Idle; 1 - Combat; 33 - Resting; 2 - Dead; ? - Zoning

  -- if status is chaning to combat
  if (getCurrentPet() ~= nil and new_status_id == 1 and state.FightMode.value == 'Auto') then 
    send_command('@input /pet "Fight" <t>')
  end
end

function handleBestialLoyalty()
  -- check if pet is out, if it is, gtfo
  if (getCurrentPet() ~= nil) then return end

  local currentPetMode = state.PetMode.value;

  -- try to find the pet that matches the current petMode
  local foundPet = getPetFromTable(currentPetMode)
  if (not foundPet) then 
    warning('No pet named '..currentPetMode..' found.')
    return 
  end

  -- if we found a pet, equip it's summon item
  local foundItem = foundPet.item
  if (foundItem) then
    warning('Attempting to call '..currentPetMode..' using '..foundItem..'.')
    equip({ ammo = foundItem })
    return
  end

  -- fuck off
  warning('No jug found for pet '..currentPetMode..'.')
end

function handleReward() 
  local food = 'Pet Food Theta'
  -- check if pet is out, if it is not, gtfo
  if (getCurrentPet() == nil or count_item(food) == '0') then return end
  equip({ ammo = food })
end

function getCurrentPet()
  local pet = windower.ffxi.get_mob_by_target('pet')
  -- we gotta check a few flags to make sure this doesn't id a trust or Kyra's water spirit as our pet
  if (pet ~= nil and pet.valid_target and pet.charmed) then
    return getPetFromTable(pet.name)
  end
  return nil
end

function getPetFromTable(petName)
  -- remove spaces from name if there are any
  local scrubbedName = string.gsub(petName, "%s+", "")

  return getPetTable()[scrubbedName]
end

function getPetmatchups(typeToCheck)
  -- vermin < plantoid < beast < lizard < vermin
  -- amorph < bird < aquan < amorph
  local relationships = {
    ['Vermin'] = {
      ['strong'] = "Plantoid",
      ['weak'] = "Lizard"
    },
    ['Plantoid'] = {
      ['strong'] = "Beast",
      ['weak'] = "Vermin"
    },
    ['Beast'] = {
      ['strong'] = "Lizard",
      ['weak'] = "Plantoid"
    },
    ['Lizard'] = {
      ['strong'] = "Vermin",
      ['weak'] = "Beast"
    },
    ['Bird'] = {
      ['strong'] = "Aquan",
      ['weak'] = "Amorph"
    },
    ['Aquan'] = {
      ['strong'] = "Amorph",
      ['weak'] = "Bird"
    },
    ['Amorph'] = {
      ['strong'] = "Bird",
      ['weak'] = "Aquan"
    }
  }
  return relationships[typeToCheck]
end

function getPetTable()
  return {
    ['FluffyBredo'] = {
      name = 'Fluffy Bredo',
      type = 'Amorph',
      item = 'Venomous Broth',
      ready = {
        ['Foul Waters'] = {
          ['Charge Cost'] = 2
        },
        ['Pestilent Plume'] = {
          ['Charge Cost'] = 2
        }
      }
    },
    ['SwoopingZhivago'] = {
      name = 'Swooping Zhivago',
      type = 'Bird',
      item = 'Windy Greens',
      ready = {
        ['Molting Plumage'] = {
          ['Charge Cost'] = 1
        },
        ['Swooping Frenzy'] = {
          ['Charge Cost'] = 2
        },
        ['Pentapeck'] = {
          ['Charge Cost'] = 3
        }
      }
    },
    ['GenerousArthur'] = {
      name = 'Generous Arthur',
      type = 'Amorph',
      item = 'Dire Broth',
      ready = {
        ['Purulent Ooze'] = {
          ['Charge Cost'] = 2
        },
        ['Corrosive Ooze'] = {
          ['Charge Cost'] = 3
        }
      }
    },
    ['EnergizedSefina'] = {
      name = 'Energized Sefina',
      type = 'Vermin',
      item = 'Gassy Sap',
      ready = {
        ['Power Attack	'] = {
          ['Charge Cost'] = 1
        },
        ['High-Frequency Field	'] = {
          ['Charge Cost'] = 2
        },
        ['Rhino Attack	'] = {
          ['Charge Cost'] = 1
        },
        ['Rhino Guard	'] = {
          ['Charge Cost'] = 1
        },
        ['Spoil'] = {
          ['Charge Cost'] = 1
        }
      }
    },
    ['DaringRoland'] = {
      name = 'Daring Roland',
      type = 'Bird',
      item = 'Feculent Broth',
      ready = {
        ['Back Heel'] = {
          ['Charge Cost'] = 1
        },
        ['Jettatura'] = {
          ['Charge Cost'] = 3
        },
        ['Choke Breath'] = {
          ['Charge Cost'] = 1
        },
        ['Fantoid'] = {
          ['Charge Cost'] = 2
        },
        ['Hoof Volley'] = {
          ['Charge Cost'] = 3
        },
        ['Nihility Song'] = {
          ['Charge Cost'] = 1
        }
      }
    },
    ['JovialEdwin'] = {
      name = 'Jovial Edwin',
      type = 'Aquan',
      item = 'Pungent Broth',
      ready = {
        ['Bubble Curtain'] = {
          ['Charge Cost'] = 3
        },
        ['Scissor Guard'] = {
          ['Charge Cost'] = 2
        },
        ['Metallic Body'] = {
          ['Charge Cost'] = 1
        },
        ['Venom Shower'] = {
          ['Charge Cost'] = 2
        },
        ['Mega Scissors'] = {
          ['Charge Cost'] = 2
        }
      }
    },
    ['RhymingShizuna'] = {
      name = 'Rhyming Shizuna',
      type = 'Beast',
      item = 'Lyrical Broth',
      ready = {
        ['Lamb Chop'] = {
          ['Charge Cost'] = 1
        },
        ['Rage'] = {
          ['Charge Cost'] = 2
        },
        ['Sheep Charge'] = {
          ['Charge Cost'] = 1
        },
        ['Sheep Song'] = {
          ['Charge Cost'] = 2
        }
      }
    },
    ['VivaciousGaston'] = {
      name = 'Vivacious Gaston',
      type = 'Beast',
      item = 'Spumante Broth',
      ready = {
        ['Chaotic Eye'] = {
          ['Charge Cost'] = 1
        },
        ['Blaster'] = {
          ['Charge Cost'] = 2
        }
      }
    },
    ['VivaciousVickie'] = {
      name = 'Vivacious Vickie',
      type = 'Beast',
      item = 'Tant. Broth',
      ready = {
        ['Sweeping Gouge'] = {
          ['Charge Cost'] = 1
        },
        ['Zealous Snort'] = {
          ['Charge Cost'] = 3
        }
      }
    },
    ['BouncingBertha'] = {
      name = 'Bouncing Bertha',
      type = 'Vermin',
      item = 'Bubbly Broth',
      ready = {
        ['Sensilla Blades'] = {
          ['Charge Cost'] = 1
        },
        ['Tegmina Buffet'] = {
          ['Charge Cost'] = 2
        }
      }
    },
    ['SultryPatrice'] = {
      name = 'Sultry Patrice',
      type = 'Amorph',
      item = 'Putrescent Broth',
      ready = {
        ['Fluid Toss'] = {
          ['Charge Cost'] = 1
        },
        ['Fluid Spread'] = {
          ['Charge Cost'] = 2
        },
        ['Digest'] = {
          ['Charge Cost'] = 1
        }
      }
    },
    ['FatsoFargann'] = {
      name = 'Fatso Fargann',
      type = 'Amorph',
      item = 'C. Plamsa Broth',
      ready = {
        ['Suction'] = {
          ['Charge Cost'] = 1
        },
        ['Drainkiss'] = {
          ['Charge Cost'] = 1
        },
        ['Acid Mist'] = {
          ['Charge Cost'] = 2
        },
        ['TP Drainkiss'] = {
          ['Charge Cost'] = 3
        }
      }
    },
    ['BlackbeardRandy'] = {
      name = 'Blackbeard Randy',
      type = 'Beast',
      item = 'Meaty Broth',
      ready = {
        ['Roar'] = {
          ['Charge Cost'] = 2
        },
        ['Razor Fang'] = {
          ['Charge Cost'] = 1
        },
        ['Claw Cyclone'] = {
          ['Charge Cost'] = 1
        },
        ['Crossthrash'] = {
          ['Charge Cost'] = 2
        },
        ['Preadatory Glare'] = {
          ['Charge Cost'] = 2
        }
      }
    },
    ['WarlikePatrick'] = {
      name = 'Warlike Patrick',
      type = 'Lizard',
      item = 'Livid Broth',
      ready = {
        ['Tail Blow'] = {
          ['Charge Cost'] = 1
        },
        ['Fireball'] = {
          ['Charge Cost'] = 1
        },
        ['Blockhead'] = {
          ['Charge Cost'] = 1
        },
        ['Brain Crush'] = {
          ['Charge Cost'] = 1
        },
        ['Infrasonics'] = {
          ['Charge Cost'] = 2
        },
        ['Secretion'] = {
          ['Charge Cost'] = 1
        }
      }
    },
    ['PonderingPeter'] = {
      name = 'Pondering Peter',
      type = 'Beast',
      item = 'Vis. Broth',
      ready = {
        ['Foot Kick'] = {
          ['Charge Cost'] = 1
        },
        ['Dust Cloud'] = {
          ['Charge Cost'] = 1
        },
        ['Whirl Claws'] = {
          ['Charge Cost'] = 1
        },
        ['Wild Carrot'] = {
          ['Charge Cost'] = 2
        },
      }
    }
  }
end

function count_item(item_name)
  local found_item = all_items[string.lower(item_name)]
  if (found_item) == null then return 'invalid item name' end

  local player = windower.ffxi.get_player()
  local bags_to_check = { --res/bags.lua
    0,  -- Inventory
    5,  -- Satchel
    6,  -- Sack
    7,  -- Case
    8,  -- Wardrobe
    10, -- Wardrobe 2
    11, -- Wardrobe 3
    12, -- Wardrobe 4
    13, -- Wardrobe 5
    14, -- Wardrobe 6
    15, -- Wardrobe 7
    16  -- Wardrobe 8
  }

  local count = 0
  for _,bag in pairs(bags_to_check) do 
    local items = windower.ffxi.get_items(bag)
    if (items == nil) then return '?' end

    for _,item in pairs(items) do
      if (type(item) == 'table' and item.id == found_item.id) then
        count = count + item.count
      end
    end
  end

  return tostring(count)
end
