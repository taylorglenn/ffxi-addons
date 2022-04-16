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
set_lockstyle(12)

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
set_macros(1, 12)

---------------------------------
-- organizer 
---------------------------------
send_command('@input //gs org;wait6; input //gs validate')

---------------------------------
-- job setup
---------------------------------
function job_setup()
  -- List of pet weaponskills to check for
  petWeaponskills = GetPetWeaponSkills()

  -- Map automaton heads to combat roles
  petModes = GetPetModes()

  -- Subset of modes that use magic
  magicPetModes = GetMagicPetModes()

  -- Var to track the current pet mode.
  state.PetMode = GetDefaultPetStates()
end

---------------------------------
-- user setup
---------------------------------
function user_setup() 
  state.IdleMode:options('Normal')
  send_command('bind ^i gs c cycle IdleMode')

  state.OffenseMode:options('Normal', 'MasterTP', 'AutoTp', 'SubtleBlow')
  send_command('bind ^o gs c cycle OffenseMode')

  -- Default maneuvers 1, 2, 3 and 4 for each pet mode.
  defaultManeuvers = GetDefaultManeuvers()

  update_pet_mode()

  ---------------------------------
  -- jse setup
  ---------------------------------
  gear.blueglenn.pup = {
    capes = { 
      
    },
    
    neck = "Puppetmaster's collar +1",

    artifact = {  head  = "Foire Taj +1",
                  body  = "Foire Tobe +1",
                  hands = "Foire Dastanas +1",
                  legs  = "Foire Churidars +1",
                  feet  = "Foire Babouches +1" },

    relic = {     head  = "Pitre Taj +1",
                  body  = "Pitre Tobe +1",
                  hands = "Pitre Dastanas +1",
                  legs  = "Pitre Churidars +1",
                  feet  = "Pitre Babouches +1" },

    empyrean = {  head  = "Karagoz Capello +1",
                  body  = "Karagoz Farsetto +1",
                  hands = "Karagoz Guanti +1",
                  legs  = "Karagoz Pantaloni +1",
                  feet  = "Karagoz Scarpe +1" },
  }
end

---------------------------------
-- user unload
---------------------------------
function user_unload()
  -- unload keybinds
  send_command('unbind ^i') -- unbinds IdleMode from i key
  send_command('unbind ^o') -- unbinds OffenseMode from o key
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
    main  = "Godhands",
    range = "Animator P +1",
    ammo  = "Automat. Oil +3",
    head  = gear.blueglenn.rao.head,
    body  = gear.blueglenn.hizamaru.body,
    hands = gear.blueglenn.rao.hands,
    legs  = gear.blueglenn.nyame.legs,
    feet  = "Hermes' Sandals",
    neck  = "Bathy Choker +1",
    waist = "Moonbow Belt +1",
    ear1  = "Infused Earring",
    ear2  = "Etiolation Earring",
    ring1 = "Defending Ring",
    ring2 = "Gelatinous Ring +1",
    back  = "Moonbeam Cape", 
  }
  ---------------------------------
  -- melee
  ---------------------------------
  sets.engaged =  -- focus on dual TP
  {
    range = "Animator P +1",
    ammo  = "Automat. Oil +3",
    head = gear.blueglenn.mpaca.head, -- todo: su3 head
    body = gear.blueglenn.taliah.body,
    hands= gear.blueglenn.mpaca.hands,
    legs = gear.blueglenn.mpaca.legs, -- todo: su3 legs
    feet = gear.blueglenn.herculean.ta_att,
    neck = "Shulmanu Collar",
    waist= "Moonbow Belt +1",
    ear1 = "Telos Earring",
    ear2 = "Crep. Earring",
    ring1= "Epona's Ring", -- todo: Niqmaddu ring
    ring2= "Gere Ring",
    --back = "str/acc/atk/da", 
  }
  sets.engaged.MasterTP =
    set_combine(sets.engaged, 
    {
      --head = , -- todo: malignance head
      legs = gear.blueglenn.ryuo.legs,
      ear1 = "Mache Earring +1",
      ear2 = "Cessance Earring",
      --back = "str/acc/atk/da", 
    }
  )
  -- focus on auto TP
  sets.engaged.AutoTp = 
    set_combine(sets.engaged, 
      {
        main = "Ohtas", -- todo
        --head = gear.blueglenn.taeon.head.pet_acc_da_dt, -- todo
        body = gear.blueglenn.pup.relic.body,
        --hands= gear.blueglenn.taeon.hands.pet_acc_da_dt, -- todo
        --legs = gear.blueglenn.taeon.legs.pet_acc_da_dt, -- todo
        --feet = gear.blueglenn.taeon.feet.pet_acc_da_dt, -- todo
        waist= "Klouskap Sash +1", -- todo
        ear1 = "Enmerkar Earring",
        ear2 = "Domes. Earring",
        ring1= "Varar Ring +1",  -- todo
        ring2= "C. Palug Ring",  -- todo
        --back = "acc/att/pet:acc/r.acc/att/r.att/haste",  -- todo
      }
    )
  -- focus on capping SB
  sets.engaged.SubtleBlow = 
    set_combine(sets.engaged, 
      {
        main = "Xiucoatl",
        legs = gear.blueglenn.mpaca.legs,
        neck = "Bathy Choker +1",
        ring1= "Chirich Ring +1",
      }
    )

  ---------------------------------
  -- job abilities
  ---------------------------------
  sets.precast.JA.Maneuver = 
  {
    body = gear.blueglenn.pup.empyrean.body
  }

  ---------------------------------
  -- weapon skill sets
  ---------------------------------
  sets.precast.WS = 
  {
    head = gear.blueglenn.mpaca.head,
    feet = gear.blueglenn.herculean.feet.ta_att,
    neck = "Fotia Gorget",
    waist= "Fotia Belt",
    ear1 = "Cessance Earring",
    ear2 = gear.blueglenn.moonshade,
    ring1= "Niqmaddu Ring", -- todo
    ring2= "Gere Ring",
    --back = gear.blueglenn.pup.capes.wsd -- todo
  }
  -- Stringing Pummel - Physical - 32% STR / 32% VIT - 6x attack - Static fTP @ 1.0 - TP modifies crit chance: 15% / 30% / 45%
  sets.precast.WS['Stringing Pummel'] = 
    set_combine(sets.precast.WS,
      {
        head = "Blistering Sallet +1", -- todo -- gotta augment to get 10% crit chance
        body = "He. Harness +1", -- todo: su3
        hands= gear.blueglenn.ryuo.hands,
        legs = gear.blueglenn.hizamaru.legs,
      }
    )
  -- Victory Smite: 80% STR - Static fTP @ 1.5 - TP modifies critical hit rate - +10% / +25% / +45%
  sets.precast.WS['Victory Smite'] = 
    set_combine(sets.precast.WS['Stringing Pummel'],
      {
        belt = "Moonbo Belt",
      }
    )
  -- Shijin Spiral: 85% DEX - Static fTP @ 1.5 - TP modifies Plague (-50TP/tick @5-8 ticks) effect accuracy
  sets.precast.WS['Shijin Spiral'] = 
    set_combine(sets.precast.WS,
      {
        body = gear.blueglenn.taliah.body,
        ear1 = "Mache Earring +1",
        --back = "dex/acc/atk/da", -- todo
      }
    )
  -- Asuran Fists: 15% STR / 15% VIT - 8x attack - Static fTP @ 1.25 - TP modifies accuracy but bg-wiki doesn't know the parameters
  sets.precast.WS['Asuran Fists'] = 
    set_combine(sets.precast.WS, 
      {
        head = gear.blueglenn.pup.relic.head,
        body = gear.blueglenn.pup.relic.body,
        hands= gear.blueglenn.pup.relic.hands,
        legs = gear.blueglenn.pup.relic.legs,
        feet = gear.blueglenn.pup.relic.feet,
        ear1 = "Telos Earring",
      }
    )
  -- Howling Fist: 50% VIT / 20% STR - 2x attack - Dynamic fTP: 2.05 / 3.58 / 5.8
  sets.precast.WS['Howling Fist'] = 
    set_combine(sets.precast.WS,
      {
        body = gear.blueglenn.taliah.body,
        neck = gear.blueglenn.pup.neck,
        waist= "Moonbow Belt +1",
        --back = "str/acc/atk/da", -- todo
      }
    )
  -- Raging Fists: 30% STR / 30% DEX - 5x attack - Dynamic fTP: 1.0 / 2.19 / 3.75
  sets.precast.WS['Raging Fists'] = sets.precast.WS['Howling Fist']
end

---------------------------------
-- gearswap hooks
---------------------------------
function job_midcast(spell, action, spellMap, eventArgs)
  local spellName = spell.english:lower()
  -- Heady Artifice
  if (spellName == "heady artifice") then headyArtificeReminder() end
end

-- Called when a player gains or loses a pet.
-- pet == pet gained or lost
-- gain == true if the pet was gained, false if it was lost.
function job_pet_change(pet, gain)
  update_pet_mode()
end

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)
  update_pet_mode()
end

---------------------------------
-- my functions
---------------------------------
function job_self_command(cmdParams, eventArgs)
  if cmdParams[1] == 'maneuver' then
    if pet.isvalid then
      local maneuver = defaultManeuvers[state.PetMode.value]
      if maneuver and tonumber(cmdParams[2]) then
        maneuver = maneuver[tonumber(cmdParams[2])]
      end

      if maneuver then
        send_command('input /pet "'..maneuver..'" <me>')
      end
    else
      add_to_chat(123,'No valid pet.')
    end
  end
end

-- Get the pet mode value based on the equipped head of the automaton.
-- Returns nil if pet is not valid.
function get_pet_mode()
  if pet.isvalid then
    return petModes[pet.head] or 'None'
  end
  return 'None'
end

-- Update state.PetMode, as well as functions that use it for set determination.
function update_pet_mode()
  state.PetMode:set(get_pet_mode())
end

function headyArtificeReminder()
  local petHead = pet.head
  local hArtificeDesc = 
    {
      ['harlequin head'] = 'phys. accuracy +2 -- M. Strikes',
      ['valoredge head'] = 'enmity +100 -- Invincible',
      ['sharpshot head'] = 'damage +3% -- Eagle Eye Shot',
      ['stormwalker head'] = 'magic damage +2% -- Chainspell',
      ['soulsoother head'] = 'refresh +1% -- Benediction',
      ['spiritreaver head'] = 'magic damage +5% -- Manafont',
    }
  windower.send_command('@input /echo -- '..petHead..' -- '..hArtificeDesc[petHead:lower()]..' --')
end

function GetDefaultPetStates()
  return 
    M{
      ['description']='Pet Mode', 
      'None', 
      'Melee', 
      'Ranged', 
      'Tank', 
      'Magic', 
      'Heal', 
      'Nuke'
    }
end

function GetPetModes()
  return 
    {
      ['Harlequin Head'] = 'Melee',
      ['Sharpshot Head'] = 'Ranged',
      ['Valoredge Head'] = 'Tank',
      ['Stormwaker Head'] = 'Magic',
      ['Soulsoother Head'] = 'Heal',
      ['Spiritreaver Head'] = 'Nuke'
    }
end

function GetMagicPetModes()
  return 
    S{
      'Nuke',
      'Heal',
      'Magic'
    }
end

function GetPetWeaponSkills() 
  return 
    S{
      "Slapstick", 
      "Knockout", 
      "Magic Mortar",
      "Chimera Ripper", 
      "String Clipper",  
      "Cannibal Blade", 
      "Bone Crusher", 
      "String Shredder",
      "Arcuballista", 
      "Daze", 
      "Armor Piercer", 
      "Armor Shatterer"
    }
end

function GetDefaultManeuvers()
  return
    {
      ['Melee']  = {'Fire Maneuver', 'Thunder Maneuver', 'Wind Maneuver', 'Light Maneuver'},
      ['Ranged'] = {'Wind Maneuver', 'Fire Maneuver', 'Thunder Maneuver', 'Light Maneuver'},
      ['Tank']   = {'Earth Maneuver', 'Dark Maneuver', 'Light Maneuver', 'Wind Maneuver'},
      ['Magic']  = {'Ice Maneuver', 'Light Maneuver', 'Dark Maneuver', 'Earth Maneuver'},
      ['Heal']   = {'Light Maneuver', 'Dark Maneuver', 'Water Maneuver', 'Earth Maneuver'},
      ['Nuke']   = {'Ice Maneuver', 'Dark Maneuver', 'Light Maneuver', 'Earth Maneuver'}
    }
end