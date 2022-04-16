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
set_lockstyle(07)

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
set_macros(1, 5)

---------------------------------
-- dressup 
---------------------------------
function dressup(race, gender, face)
  send_command('@input //lua l dressup')
  if not race or not gender or not face then send_command('@input //du clear self') return end
  send_command('@input //du self race ' .. race .. ' ' .. gender)
  send_command('@wait 2; input //du self face ' .. tostring(face))
end
dressup("mithra", "female", 1)

---------------------------------
-- organizer 
---------------------------------
send_command('@input //gs org;wait6; input //gs validate')

---------------------------------
-- job setup
---------------------------------
function job_setup()
  
end

---------------------------------
-- user setup
---------------------------------
function user_setup() 
  state.IdleMode:options('Normal', 'Regain')
  send_command('bind ^i gs c cycle IdleMode')

  state.OffenseMode:options('Normal', 'Meva', 'Acc', 'TH')
  send_command('bind ^o gs c cycle OffenseMode')

  ---------------------------------
  -- jse setup
  ---------------------------------
  gear.blueglenn.thf = { 
    capes = { tp  = { name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},
              wsd = { name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}} },

    neck = "Asn. Gorget +1",

    artifact = {  head  = "Pillager's Bonnet + 1",
                  body  = "Pillager's Vest +2",
                  legs  = "Pillager's Culottes +1",
                  feet  = "Pillager's Poulaines +1" },

    relic = {     head  = "Plun. Bonnet +1",
                  hands = { name="Plun. Armlets +1", augments={'Enhances "Perfect Dodge" effect',}},
                  feet  = "Plun. Poulaines +3" },

    empyrean = {  feet  = "Skulk. Poulaines +1" },
  }
end

---------------------------------
-- user unload
---------------------------------
function user_unload()
  -- unload keybinds
  send_command('unbind ^i')
  send_command('unbind ^o')
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
  -- DT-24, PDT-27, regen+4, Movement Speed +12
  sets.idle = 
  { 
    ammo  = "Staunch Tathlum", -- DT-2
    head  = gear.blueglenn.meghanada.head, -- PDT-5
    body  = gear.blueglenn.meghanada.body, -- PDT-7
    hands = gear.blueglenn.meghanada.hands, -- PDT-4
    legs  = gear.blueglenn.meghanada.legs, -- PDT-5
    feet  = gear.blueglenn.thf.artifact.feet, -- Movement Speed +12
    neck  = "Bathy Choker +1", -- regen+3
    waist = "Flume Belt", -- PDT-4
    ear1  = "Genmei Earring", -- PDT-2
    ear2  = "Infused Earring", -- regen+1
    ring1 = "Defending Ring", -- DT-10
    ring2 = "Gelatinous Ring +1", -- DT-7
    back  = "Moonbeam Cape", -- DT-5
  } 

  sets.idle.Regain = 
    set_combine(sets.idle, 
      {
        head = gear.blueglenn.gleti.head,
        body = gear.blueglenn.gleti.body,
        hands= gear.blueglenn.gleti.hands,
        legs = gear.blueglenn.gleti.legs,
        feet = gear.blueglenn.gleti.feet,
      }
    )

  ---------------------------------
  -- Melee
  ---------------------------------
  sets.engaged =    
  { 
    ammo  = "Aurgelmir Orb",
    head  = gear.blueglenn.adhemar.head,
    body  = gear.blueglenn.thf.artifact.body,
    hands = gear.blueglenn.adhemar.hands,
    legs  = gear.blueglenn.meghanada.legs,
    feet  = gear.blueglenn.thf.relic.feet,
    neck  = gear.blueglenn.thf.neck,
    waist = "Windbuffet Belt +1",
    ear1  = "Sherida Earring",
    ear2  = "Dedition Earring",
    ring1 = "Gere Ring",
    ring2 = "Hetairoi Ring",
    back  = gear.blueglenn.thf.capes.tp, 
  }

  sets.engaged.Acc = sets.engaged

  sets.engaged.Meva = 
    set_combine(sets.engaged,
    {
      head = gear.blueglenn.gleti.head,
      body = gear.blueglenn.gleti.body,
      hands= gear.blueglenn.gleti.hands,
      feet = gear.blueglenn.gleti.feet
    }
  )

  sets.engaged.TH = 
    set_combine(sets.engaged,   
      { 
        --sub   = "Sandung", -- TH+1
        ammo  = "Per. Lucky Egg", -- TH+1
        --head  = "Wh. Rarab Cap +1", -- TH+1
        hands = gear.blueglenn.thf.relic.hands, -- TH+4
        feet  = gear.blueglenn.thf.empyrean.feet,  -- TH+2
      }
    )
  ---------------------------------
  -- Job Abilities
  ---------------------------------
  sets.precast.JA["Treasure Hunter"] = { feet = gear.blueglenn.thf.artifact.feet }
  ---------------------------------
  -- Weapon Skills
  ---------------------------------
  sets.precast.WS =   
  { 
    ammo  = "Seething Bomblet +1",
    head  = gear.blueglenn.mummu.head, -- swap to thf.relic.head when it's got more than 39 dex
    body  = gear.blueglenn.meghanada.body, -- swap to thf.relic.body when you get the +3
    hands = gear.blueglenn.meghanada.hands,
    legs  = gear.blueglenn.thf.artifact.legs,
    feet  = gear.blueglenn.thf.relic.feet,
    neck  = gear.blueglenn.thf.neck,
    waist = "Fotia Belt", -- Kentarch Belt +1 is better.  Comes from a UNM.
    ear1  = "Mache Earring +1",
    ear2  = gear.blueglenn.moonshade,
    ring1 = "Petrov Ring",
    ring2 = "Apate Ring",
    back  = gear.blueglenn.thf.capes.wsd, 
  }

  -- Aeolian Edge: 40% DEX / 40% INT - Dynamic fTP: 2.0 / 3.0 / 4.5
  sets.precast.WS["Aeolian Edge"] = 
    set_combine(sets.precast.WS,
      {
        head = gear.blueglenn.nyame.head,
        body = gear.blueglenn.nyame.body,
        hands= gear.blueglenn.nyame.hands,
        legs = gear.blueglenn.nyame.legs,
        feet = gear.blueglenn.nyame.feet,
        neck = "Stoicheion Medal",
        waist= "Eschan Stone",
        ring1= "Shiva Ring +1",
        ring2= "Acumen Ring",
        ear1 = "Hermetic Earring",
      }
    )

  -- Rudra's Storm: 80% DEX - Dynamic fTP: 5.0 / 10.19 / 13.0
  sets.precast.WS["Rudra's Storm"] = 
    set_combine(sets.precast.WS, 
      { 
        legs = gear.blueglenn.lustratio.legs,
        feet = gear.blueglenn.lustratio.feet 
      }
    )

  -- Evisceration: Dagger - Physical - 50% DEX - Static fTP @ 1.25 - Crit Rate @ 1k/2k/3k = 10%/25%/50%
  sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS,
  { 
    ammo = "Yetshila +1",
    head = gear.blueglenn.adhemar.head,
    body = gear.blueglenn.meghanada.body, -- todo: relic body +3
    hands= gear.blueglenn.mummu.hands,
    legs = gear.blueglenn.meghanada.legs, -- todo: artifact legs +3
    feet = gear.blueglenn.thf.relic.feet, -- todo: adhemar feet +1
    neck = "Fotia Gorget",
    waist= "Fotia Belt",
    ear1 = "Sherida Earring",
    ear2 = "Brutal Earring", -- todo: Odr Earring
    ring1= gear.blueglenn.mummu.ring,
    ring2= "Ilabrat Ring",

    --back = "dex30 acc/att20 10critrate"
  })

  sets.precast.WS["Mandalic Stab"] = sets.precast.WS["Rudra's Storm"]

  -- Savage Blade: Sword - Physical - 50% STR / 50% MND - Dynamic fTP: 4.0 / 10.25 / 13.75
  sets.precast.WS["Savage Blade"] =
    set_combine(sets.precast.WS, 
      { 
        head  = gear.blueglenn.lustratio.head, 
        body  = "Nyame Mail",
        legs  = "Nyame Flanchard",
        ring1 = "Gere Ring",
        feet  = gear.blueglenn.lustratio.feet
      }
    )
  
end