---------------------------------
-- includes
---------------------------------
function get_sets()
  -- Load and initialize the include file.
  mote_include_version = 2
  include('Mote-Include.lua')
  include('organizer-lib')
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
-- organizer 
---------------------------------
send_command('@input //gs org;wait6; input //gs validate')

---------------------------------
-- job setup
---------------------------------
function job_setup()
  windower.raw_register_event('prerender', drawDisplay)
end

---------------------------------
-- dislpay globals
---------------------------------
displaySettings = 
{ 
  pos = 
  {
    x = -1400,
    y = 720
  },
  text = 
  {
    font = 'Consolas',
    size = 12
  },
  flags = 
  {
    right = true
  }
}
displayBox = texts.new('${value}', displaySettings)

---------------------------------
-- user setup
---------------------------------
function user_setup() 
  -- built-in state tables
  state.IdleMode:options('Normal')
  send_command('bind ^i gs c cycle IdleMode')

  state.OffenseMode:options('Normal', 'CP')
  send_command('bind ^o gs c cycle OffenseMode')

  -- custom state tables
  state.DisplayMode = M{['description'] = 'DisplayMode', 'false', 'true'}
  send_command('bind ^q gs cycle DisplayMode')
  
  state.PetMode = M{
    ['description'] = 'PetMode',
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

  ---------------------------------
  -- jse setup
  ---------------------------------
  gear.blueglenn.bst = 
  {
    capes = 
    { 
      tp  = {  },
      wsd = { name="Artio's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
      str_da = {  }, 
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
      "Ankusa Helm +1",
      "Ankusa Jackcoat +1",
      "Ankusa Gloves +3",
      "Ankusa Trousers +3",
      "Ankusa Gaiters +1",
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
  send_command('unbind ^p') -- unbinds PetMode from p key
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
    head = gear.blueglenn.gleti.head,
    body = gear.blueglenn.gleti.body,
    hands= gear.blueglenn.gleti.hands,
    legs = gear.blueglenn.gleti.legs,
    feet = gear.blueglenn.gleti.feet,
    neck = "Bathy Choker +1",
    waist= "Flume Belt",
    ear1 = "Infused Earring",
    ear2 = "Etiolation Earring",
    ring1= "Defending Ring",
    ring2= "Gelatinous Ring +1",
    --back = "Moonbeam Cape"
    back = "Aptitude Mantle +1"
  }
  ---------------------------------
  -- melee
  ---------------------------------
  sets.engaged =
  {
    ammo = "Aurgelmir Orb",
    head = gear.blueglenn.gleti.head,
    body = gear.blueglenn.gleti.body,
    hands= "Emicho Gauntlets +1",
    legs = gear.blueglenn.gleti.legs,
    feet = gear.blueglenn.gleti.feet,
    neck = gear.blueglenn.bst.neck,
    waist= "Sailfi Belt +1",
    ear1 = "Sherida Earring",
    ear2 = "Crep. Earring",
    ring1= "Gere Ring",
    ring2= "Chirich Ring +1",
    back = gear.blueglenn.bst.capes.tp
  }

  sets.engaged.CP = set_combine(sets.engaged, {
    back = "Aptitude Mantle +1"
  })
  
  ---------------------------------
  -- job abilities
  ---------------------------------
  sets.midcast.Pet["Ready"] = 
  {
    head = gear.blueglenn.nyame.head,
    body = gear.blueglenn.nyame.body,
    hands= gear.blueglenn.bst.empyrean.hands,
    legs = gear.blueglenn.nyame.legs,
    feet = gear.blueglenn.nyame.feet,
    --neck = gear.blueglenn.bst.neck,
    neck = "Shulmanu Collar",
    waist= "Klouskap Sash +1",
    ear1 = "Enmerkar Earring",
    ear2 = "Crep. Earring",
    ring1= "Varar Ring +1",  -- todo
    ring2= "C. Palug Ring",  -- todo
  }

  ---------------------------------
  -- weapon skill sets
  ---------------------------------
  sets.precast.WS = 
  {
    head = gear.blueglenn.bst.relic.head,
    body = gear.blueglenn.gleti.body,
    hands= gear.blueglenn.bst.artifact.hands,
    legs = gear.blueglenn.gleti.legs,
    feet = gear.blueglenn.gleti.feet,
    neck = "Fotia Gorget",
    waist= "Fotia Belt",
    ear1 = "Sherida Earring",
    ear2 = "Crep. Earring",
    ring1= "Gere Ring",
    ring2= "Epona's Ring",
    back = gear.blueglenn.bst.capes.wsd
  }

  -- Decimation: 50% STR - Static fTP @ 1.75 - TP increases accuracy (though how much is unknown)
  sets.precast.WS['Decimation'] = set_combine(sets.precast.WS,
  {
    head = gear.blueglenn.gleti.head,
    body = gear.blueglenn.gleti.body,
    hands= gear.blueglenn.gleti.hands,
    legs = gear.blueglenn.gleti.legs,
    feet = gear.blueglenn.gleti.feet,
    neck = "Fotia Gorget",
    waist= "Fotia Belt",
    ear1 = "Sherida Earring",
    ear2 = "Brutal Earring",
    ring1= "Gere Ring",
    ring2= "Epona's Ring",
    back = gear.blueglenn.bst.capes.str_da
  })
  
end

---------------------------------
-- gearswap hooks
---------------------------------
function job_precast(spell, action, spellMap, eventArgs)
  if spell.name:lower() == 'bestial loyalty' or spell.name:lower() == 'call beast' then
    handleBestialLoyalty()
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

---------------------------------
-- display stuff
---------------------------------
function drawDisplay()
  if (state.DisplayMode.value == 'false') then
    displayBox:hide()
    return
  end

  if (state.DisplayMode.value == 'true') then
    local INDENT = ' ':rep(3)
    local displayLines = L{}
    displayLines:append('PetMode: '..state.PetMode.value..'')
    -- get current pet
    local pet = getCurrentPet()
    if (pet ~= nil) then
      -- display it's jams
      displayLines:append('Current Pet: '..pet.name..'')
      local matchups = getPetmatchups(pet.type)
      if (matchups ~= nil) then
        displayLines:append(INDENT..'Strong: '..matchups.strong..'')
        displayLines:append(INDENT..'Weak: '..matchups.weak..'')
      end


    end

    
    displayBox:text(displayLines:concat('\\cr\n'))
    displayBox:show()
  end
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

  local petTable = getPetTable()
  local foundPet = petTable[scrubbedName]
  if (foundPet ~= nil) then
    return foundPet
  end

  return nil
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
      type = 'Beast',
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
        ['Bubble Shower'] = {
          ['Charge Cost'] = 1
        },
        ['Bubble Curtain'] = {
          ['Charge Cost'] = 3
        },
        ['Big Scissors'] = {
          ['Charge Cost'] = 1
        },
        ['Scissor Guard'] = {
          ['Charge Cost'] = 2
        },
        ['Metallic Body'] = {
          ['Charge Cost'] = 1
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
    ['Blackbeard Randy'] = {
      name = 'BlackbeardRandy',
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
    ['Warlike Patrick'] = {
      name = 'WarlikePatrick',
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
    ['Pondering Peter'] = {
      name = 'PonderingPeter',
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
