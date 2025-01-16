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
-- dislpay globals
---------------------------------
displaySettings = 
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
displayBox = texts.new('${value}', displaySettings)

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

  state.OffenseMode:options('Normal', '5% DW', '20% DW', 'Meva', 'Acc', 'TH')
  send_command('bind ^o gs c cycle OffenseMode')

  drawDisplay() -- make sure this is directly after any state declarations
  ---------------------------------
  -- jse setup
  ---------------------------------
  gear.globals.thf = { 
    capes = 
    { 
      tp  = { name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','"Store TP"+10','Phys. dmg. taken-10%',}},
      wsd = { name="Toutatis's Cape", augments={'DEX+20','Accuracy+20 Attack+20','DEX+10','Weapon skill damage +10%',}} 
    },

    neck = "Asn. Gorget +1",

    artifact = 
    {  
      head  = "Pillager's Bonnet +1",
      body  = "Pillager's Vest +3",
      legs  = "Pillager's Culottes +2",
      feet  = "Pillager's Poulaines +1" 
    },

    relic = 
    {     
      head  = "Plun. Bonnet +1",
      hands = { name="Plun. Armlets +1", augments={'Enhances "Perfect Dodge" effect',}},
      feet  = "Plun. Poulaines +3" 
    },

    empyrean = 
    {  
      feet  = "Skulk. Poulaines +1" 
    },
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
    head  = gear.globals.meghanada.head, -- PDT-5
    body  = gear.globals.meghanada.body, -- PDT-7
    hands = gear.globals.meghanada.hands, -- PDT-4
    legs  = gear.globals.meghanada.legs, -- PDT-5
    feet  = gear.globals.thf.artifact.feet, -- Movement Speed +12
    neck  = "Bathy Choker +1", -- regen+3
    waist = "Flume Belt", -- PDT-4
    ear1  = "Genmei Earring", -- PDT-2
    ear2  = "Infused Earring", -- regen+1
    ring1 = "Defending Ring", -- DT-10
    ring2 = "Shneddick Ring",
    back  = "Moonbeam Cape", -- DT-5
  } 

  sets.idle.Regain = 
    set_combine(sets.idle, 
      {
        head = gear.globals.gleti.head,
        body = gear.globals.gleti.body,
        hands= gear.globals.gleti.hands,
        legs = gear.globals.gleti.legs,
        feet = gear.globals.gleti.feet,
      }
    )

  ---------------------------------
  -- Melee
  ---------------------------------
  sets.engaged =    
  { 
    ammo  = "Aurgelmir Orb",
    head  = gear.globals.adhemar.head,
    body  = gear.globals.thf.artifact.body,
    hands = gear.globals.adhemar.hands,
    legs  = "Samnuha Tights",
    feet  = gear.globals.thf.relic.feet,
    neck  = gear.globals.thf.neck,
    waist = "Windbuffet Belt +1",
    ear1  = "Sherida Earring",
    ear2  = "Dedition Earring",
    ring1 = "Gere Ring",
    ring2 = "Hetairoi Ring",
    back  = gear.globals.thf.capes.tp, 
  }

  sets.engaged['5% DW'] = -- extra 5%
    set_combine(sets.engaged, 
    {
      ear2 = "Suppanomimi", -- 5
    }
  )

  sets.engaged['20% DW'] = -- extra 20%
    set_combine(sets.engaged, 
    {
      ear1 = "Eabani Earring", -- 4
      ear2 = "Suppanomimi", -- 5
      body = gear.globals.adhemar.body, -- 6
      waist= "Reiki Yotai" -- 7
    }
  )

  sets.engaged.Acc = sets.engaged

  sets.engaged.Meva = 
    set_combine(sets.engaged,
    {
      head = gear.globals.gleti.head,
      body = gear.globals.gleti.body,
      hands= gear.globals.gleti.hands,
      feet = gear.globals.gleti.feet
    }
  )

  sets.engaged.TH = 
    set_combine(sets.engaged,   
    { 
      --sub   = "Sandung", -- TH+1
      ammo  = "Per. Lucky Egg", -- TH+1
      head  = "Wh. Rarab Cap +1", -- TH+1
      hands = gear.globals.thf.relic.hands, -- TH+4
      feet  = gear.globals.thf.empyrean.feet,  -- TH+3
    }
  )
  ---------------------------------
  -- Job Abilities
  ---------------------------------
  sets.precast.JA["Treasure Hunter"] = { feet = gear.globals.thf.artifact.feet }
  ---------------------------------
  -- Weapon Skills
  ---------------------------------
  sets.precast.WS =   
  { 
    ammo  = "Seething Bomblet +1",
    head  = gear.globals.mummu.head, -- swap to thf.relic.head when it's got more than 39 dex
    body  = gear.globals.meghanada.body, -- swap to thf.relic.body when you get the +3
    hands = gear.globals.meghanada.hands,
    legs  = gear.globals.thf.artifact.legs,
    feet  = gear.globals.thf.relic.feet,
    neck  = gear.globals.thf.neck,
    waist = "Fotia Belt", -- Kentarch Belt +1 is better.  Comes from a UNM.
    ear1  = "Mache Earring +1",
    ear2  = gear.globals.moonshade,
    ring1 = "Petrov Ring",
    ring2 = "Apate Ring",
    back  = gear.globals.thf.capes.wsd, 
  }

  -- Aeolian Edge: 40% DEX / 40% INT - Dynamic fTP: 2.0 / 3.0 / 4.5
  sets.precast.WS["Aeolian Edge"] = 
    set_combine(sets.precast.WS,
      {
        head = gear.globals.nyame.head,
        body = gear.globals.nyame.body,
        hands= gear.globals.nyame.hands,
        legs = gear.globals.nyame.legs,
        feet = gear.globals.nyame.feet,
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
        ammo = "Yetshila +1",
        head = gear.globals.thf.artifact.head,
        body = gear.globals.gleti.body,
        hands= gear.globals.meghanada.hands,
        legs = gear.globals.lustratio.legs,
        feet = gear.globals.lustratio.feet,
        neck = gear.globals.thf.neck,
        waist= "Grunfeld Rope",
        ear1 = "Sherida Earring",
        ear2 = gear.globals.moonshade,
        ring1= gear.globals.mummu.ring,
        ring2= "Ilabrat Ring",
        back = gear.globals.thf.capes.wsd
      }
    )

  -- Evisceration: Dagger - Physical - 50% DEX - Static fTP @ 1.25 - Crit Rate @ 1k/2k/3k = 10%/25%/50%
  sets.precast.WS['Evisceration'] = set_combine(sets.precast.WS,
  { 
    ammo = "Yetshila +1",
    head = gear.globals.adhemar.head,
    body = gear.globals.gleti.body, -- todo: relic body +3
    hands= gear.globals.adhemar.hands,
    legs = gear.globals.meghanada.legs, -- todo: artifact legs +3
    feet = gear.globals.lustratio.feet,
    neck = "Fotia Gorget",
    waist= "Fotia Belt",
    ear1 = "Mache Earring +1",
    ear2 = gear.globals.moonshade,
    ring1= gear.globals.mummu.ring,
    ring2= "Ilabrat Ring",
    back = gear.globals.thf.capes.wsd
    --back = "dex30 acc/att20 10critrate"
  })

  sets.precast.WS["Mandalic Stab"] = sets.precast.WS["Rudra's Storm"]

  -- Savage Blade: Sword - Physical - 50% STR / 50% MND - Dynamic fTP: 4.0 / 10.25 / 13.75
  sets.precast.WS["Savage Blade"] =
    set_combine(sets.precast.WS, 
      { 
        head  = gear.globals.lustratio.head, 
        body  = "Nyame Mail",
        legs  = "Nyame Flanchard",
        ring1 = "Gere Ring",
        feet  = gear.globals.lustratio.feet
      }
    )
  
end

---------------------------------
-- gearswap hooks 
---------------------------------
function job_state_change(field, newValue, oldValue)
  -- any mode changed
  drawDisplay()
end

---------------------------------
-- display stuff
---------------------------------
function drawDisplay()
  local INDENT = ' ':rep(3)
  local displayLines = L{}

  displayLines:append('[I]dle: '..state.IdleMode.value)
  displayLines:append('[O]ffense: '..state.OffenseMode.value)

  displayBox:text(displayLines:concat(' | '))
  displayBox:show()
end