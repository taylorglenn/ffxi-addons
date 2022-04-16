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
set_lockstyle(15)

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
set_macros(1, 10)

---------------------------------
-- dressup 
---------------------------------
function dressup(race, gender, face)
  send_command('@input //lua l dressup')
  if not race or not gender or not face then send_command('@input //du clear self') return end
  send_command('@input //du self race ' .. race .. ' ' .. gender)
  send_command('@wait 2; input //du self face ' .. tostring(face))
end
dressup()

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
  state.IdleMode:options('Normal')
  send_command('bind ^i gs c cycle IdleMode')

  state.OffenseMode:options('Normal', 'Acc')
  send_command('bind ^o gs c cycle OffenseMode')

  ---------------------------------
  -- jse setup
  ---------------------------------
  --gear.blueglenn.
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
    -- ear1
    -- ear2
    -- ring1
    -- ring2
    -- back
    -- waist

  ---------------------------------
  -- idle
  ---------------------------------
  sets.idle = 
  {  
    legs = gear.blueglenn.carmine.legs,
    feet = "Hermes' sandals", 
  }

  ---------------------------------
  -- Melee
  ---------------------------------
  sets.engaged = 
  {  
    ammo = "Aurgelmir Orb",
    head = gear.blueglenn.adhemar.head,
    body = gear.blueglenn.adhemar.body,
    hands= gear.blueglenn.adhemar.hands,
    legs = gear.blueglenn.nyame.legs,
    feet = gear.blueglenn.herculean.feet.ta_att,
    neck = "Anu Torque", 
    ear1 = "Sherida Earring",
    ear2 = "Telos Earring",
    ring1= "Chirich Ring +1",
    ring2= "Epona's Ring",
    waist= "Windbuffet Belt +1"
  }

  sets.engaged.Acc = set_combine(sets.engaged, {  }) 

  ---------------------------------
  -- Job Abilities
  ---------------------------------
	
  ---------------------------------
  -- Weapon Skills
  ---------------------------------
  sets.precast.WS = 
  {
    ear1 = "Sherida Earring",
    ear2 = gear.blueglenn.moonshade,
    neck = "Fotia Gorget",
    waist= "Fotia Belt",
  }

  sets.precast.WS["Dimidiation"] = 
    set_combine(sets.precast.WS,
    { 
      ammo = "Knobkierrie",
      head = gear.blueglenn.lustratio.head,
      body = gear.blueglenn.adhemar.body,
      hands= gear.blueglenn.meghanada.hands,
      legs = gear.blueglenn.lustratio.legs,
      feet = gear.blueglenn.lustratio.feet,
      ring1= "Chirich Ring +1",
      ring2= "Ilabrat Ring",
    })

  sets.precast.WS["Resolution"] = 
    set_combine(sets.precast.WS,
    { 
      ammo = "Seeth. Bomblet +1",
      head = gear.blueglenn.lustratio.head,
      body = gear.blueglenn.adhemar.body,
      hands= gear.blueglenn.herculean.hands.waltz,
      legs = gear.blueglenn.meghanada.legs,
      feet = gear.blueglenn.lustratio.feet,
      ring1= "Chirich Ring +1",
      ring2= "Epona's Ring",
    })

  -- Victory Smite: 80% STR - Static fTP @ 1.5 - TP modifies critical hit rate

  ---------------------------------
  -- Magic Precast
  ---------------------------------
  sets.precast.FC = 
  {
    ammo = "Staunch Tathlum",
    head = gear.blueglenn.nyame.head,
    body = gear.blueglenn.adhemar.body,
    hands= "Leyline gloves",
    legs = gear.blueglenn.ayanmo.legs,
    feet = gear.blueglenn.carmine.feet,
    ear1 = "Etiolation Earring",
    ear1 = "Loquac. Earring",
    ring1= "Kishar Ring",
    ring2= "Gelatenous Ring +1",
    waist= "Siegel Sash"

  }

  ---------------------------------
  -- Magic Midcast
  ---------------------------------
  sets.midcast["Enhancing Magic"] = 
  {
    head = gear.blueglenn.carmine.head,
    legs = gear.blueglenn.carmine.legs,
    ear1 = "Andoaa Earring",
    ring1= "Stikini Ring +1",
    ring2= "Stikini Ring",
    waist= "Olympus Sash",
  }
end

---------------------------------
-- built-in gearswap functions
---------------------------------
function job_buff_change(buff, gain) 
  -- Is triggered every time you either recieve a buff, or one wears off
  -- buff is the name of the buff, and gain is true if you are getting the buff, and false if the buff is wearing off

end 

function job_update(cmdParams, eventArgs)

end
---------------------------------
-- user defined functions 
---------------------------------
