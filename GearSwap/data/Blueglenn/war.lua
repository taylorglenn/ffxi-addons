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
set_lockstyle(08)

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
set_macros(1, 2)

---------------------------------
-- organizer 
---------------------------------
send_command('@input //gs org;wait6; input //gs validate')

---------------------------------
-- job setup
---------------------------------
--function job_setup()
  
--end

---------------------------------
-- user setup
---------------------------------
function user_setup() 
  ---------------------------------
  -- jse setup
  ---------------------------------
  gear.blueglenn.war = 
  {
    capes = 
    { 
      tp = { name="Cichol's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+9','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
      ws_vit = { name="Cichol's Mantle", augments={'VIT+20','Accuracy+20 Attack+20','VIT+10','Weapon skill damage +10%',}},
    },
    
    neck = "War. Beads +1",

    artifact = 
    {  
      body  = "Pumm. Lorica +2",
      legs  = "Pumm. Cuisses +2",
      feet  = "Pumm. Calligae +2" 
    },
  
    relic = 
    { 
      head  = "Agoge Mask +2" 
    },
  
    empyrean = 
    { 

    },
  }

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
    head = gear.blueglenn.nyame.head,
    body = gear.blueglenn.nyame.body,
    hands= gear.blueglenn.nyame.hands,
    legs = gear.blueglenn.nyame.legs, 
    feet = "Hermes' Sandals",
    neck = "Bathy Choker +1",
    waist= "Flume Belt",
    ear1 = "Infused Earring",
    ear2 = "Etiolation Earring",
    ring1= "Defending Ring",
    ring2= "Chirich Ring +1",
    back = "Moonbeam Cape",
  }

  ---------------------------------
  -- Melee
  ---------------------------------
  sets.engaged =
  {
    ammo = "Aurgelmir Orb",
    head = "Hjarrandi Helm",
    body = "Dagon Breast.",
    hands= gear.blueglenn.sakpata.hands,
    legs = gear.blueglenn.war.artifact.legs,
    feet = gear.blueglenn.war.artifact.feet,
    neck = gear.blueglenn.war.neck,
    waist= "Ioskeha Belt",
    ear1 = "Telos Earring",
    ear2 = "Cessance Earring",
    ring1= "Chirich Ring +1",
    ring2= "Petrov Ring",
    back = gear.blueglenn.war.capes.tp,
  }

  sets.engaged.sword = set_combine(
    sets.engaged, 
    {
      main = "Naegling",
      sub  = "Blurred Shield +1",
      body = "Hjarrandi Breast.",
      hands= gear.blueglenn.sulevia.hands,
    }
  )

  ---------------------------------
  -- Job Abilities
  ---------------------------------
  sets.precast.JA["Berserk"] = 
  {
    body = gear.blueglenn.war.artifact.body,
    --feet = gear.blueglenn.war.relic.feet, --todo
    back = gear.blueglenn.war.capes.tp
  }

  sets.precast.JA["Blood Rage"] = 
  {
    --body = gear.blueglenn.war.empyrean.body -- todo
  }

  sets.precast.JA["Restraint"] = 
  {
    --hands= gear.blueglenn.war.empyrean.hands -- todo
  }

  sets.precast.JA["Retaliation"] = 
  {
    --hands= gear.blueglenn.war.artifact.hands, -- todo
    --feet = gear.blueglenn.war.empyrean.feet -- todo
  }

  sets.precast.JA["Warcry"] = 
  {
    head = gear.blueglenn.war.relic.head
  }

  ---------------------------------
  -- Weapon Skills
  ---------------------------------
  sets.precast.WS = 
  {
    ammo = "Knobkierrie",
    head = gear.blueglenn.war.relic.head,
    body = gear.blueglenn.war.artifact.body,
    hands= gear.blueglenn.valorous.hands.wsd,
    legs = gear.blueglenn.war.artifact.legs,
    feet = gear.blueglenn.sulevia.feet,
    neck = "Fotia Gorget",
    waist= "Fotia Belt",
    ear1 = gear.blueglenn.moonbeam,
    back = gear.blueglenn.war.capes.ws_vit
  } 

  -- Upheaval: 85% VIT - Dynamic fTP: 1.0 / 3.5 / 6.5
  sets.precast.WS["Upheaval"] = set_combine(
    sets.precast.WS,
    {
      legs = gear.blueglenn.sakpata.legs,
      waist= "Sailfi Belt +1",
      ear2 = "Thrud Earring",
      ring1= "Supershear Ring",
      ring2= "Petrov Ring",
      back = gear.blueglenn.war.capes.ws_vit
    }
  )
end