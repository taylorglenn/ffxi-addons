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
set_lockstyle(17)

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
set_macros(1, 11)

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

  state.OffenseMode:options('Normal', 'Acc', 'Meva', 'Dt')
  send_command('bind ^o gs c cycle OffenseMode')

  ---------------------------------
  -- jse setup
  ---------------------------------
  gear.blueglenn.sam = {
    capes = {
      tp = { name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+4','"Dbl.Atk."+10',}},
      ws = { },
    },
    
    neck = "Sam. Nodowa +2",

    artifact = {  head = "Wakido Kabuto +1",
                  body = "Wakido Domaru +1",
                  hands= "Wakido Kote +1",
                  legs = "Wakido Haidate +1",
                  feet = "Wakido Sune-Ate" },

    relic = { head = "Sakonji Kabuto",
              body = "Sakonji Domaru +3",
              hands= "Sakonji Kote +3",
              legs = "Sakonji Haidate +1",
              feet = "Sakonji Sune-Ate" },

    empyrean = {  head = "Kasuga Kabuto",
                  body = "Kasuga Domaru +1",
                  hands= "Kasuga Kote +1",
                  legs = "Kasuga Haidate +1",
                  feet = "Kasuga Sune-Ate +1" },
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
    ammo  = "Staunch Tathlum", -- 2 dt
    head  = gear.blueglenn.nyame.head, --7 dt
    body  = gear.blueglenn.hizamaru.body, -- regen +12
    hands = gear.blueglenn.nyame.hands, --7 dt
    legs  = gear.blueglenn.nyame.legs, --8 dt
    feet  = gear.blueglenn.nyame.feet, --7 dt
    neck  = "Bathy Choker +1", -- regen +3
    ear1  = "Etiolation Earring", --3 mdt
    ear2  = "Infused Earring", -- regen +1
    ring1 = "Chirich ring +1", -- regen +2
    ring2 = "Defending ring", --10 dt
    back  = "Moonbeam Cape", --5 dt
    waist = "Flume Belt", --4 pdt
  } -- 46/50 dt, 50/50 pdt, 49/50 mdt, 18 regen
  ---------------------------------
  -- engaged
  ---------------------------------
  sets.engaged =
  {
    --sub  = "Bloodrain Strap", -- todo: Utu Grip
    ammo = "Aurgelmmir Orb", -- todo: +1
    head = gear.blueglenn.flamma.head, 
    body = gear.blueglenn.sam.empyrean.body,
    hands= gear.blueglenn.sam.artifact.hands,
    legs = gear.blueglenn.ryuo.legs,
    feet = gear.blueglenn.ryuo.feet,
    neck = gear.blueglenn.sam.neck,
    ear1 = "Dedition Earring",
    ear2 = "Telos Earring",
    ring1= "Chirich Ring +1", -- todo: "Niqmaddu Ring",
    ring2= "Ilabrat Ring", -- todo: "Flamma Ring",
    back = gear.blueglenn.sam.capes.tp,
    waist = "Ioskeha Belt"
  }

  sets.engaged.Acc = 
    set_combine(sets.engaged, 
      {
        sub = "Khonsu", -- todo: Utu Grip
        body = gear.blueglenn.kendatsuba.body,
        legs = gear.blueglenn.kendatsuba.legs,
        feet = gear.blueglenn.flamma.feet,
        ear2 = "Crep. Earring",
      }
    )

  sets.engaged.Dt = 
    set_combine(sets.engaged, 
      {
        ammo = "Staunch Tathlum",
        head = gear.blueglenn.kendatsuba.head,
        body = gear.blueglenn.sam.artifact.body,
        legs = gear.blueglenn.kendatsuba.legs,
        feet = gear.blueglenn.kendatsuba.feet,
        neck = "Loricate Torque +1",
        ear1 = "Etiolation Earring",
        ear2 = "Genmei Earring",
        ring1= "Defending Ring",
        ring2= "Gelatinous Ring +1",
        waist= "Flume Belt"
      }
    )

  sets.engaged.Meva = 
    set_combine(sets.engaged, 
      {
        head = gear.blueglenn.kendatsuba.head,
        body = gear.blueglenn.kendatsuba.body,
        legs = gear.blueglenn.kendatsuba.legs,
        feet = gear.blueglenn.kendatsuba.feet,
        neck = "Moonbeam Nodowa",
        ring2= "Ilabrat Ring",
        waist= "Windbuffet Belt +1",
      }
    )

  sets.engaged.SubtleBlow = 
    set_combine(sets.engaged, 
      {
        head = gear.blueglenn.kendatsuba.head, --8
        body = "Dagon Breastplate", --10(II)
        legs = gear.blueglenn.mpaca, --5(II)
        feet = gear.blueglenn.ryuo.feet, --8
        neck = "Bathy Choker +1", --11

      }
    )
  ---------------------------------
  -- weapon skills
  ---------------------------------
  -- General use set for Fudo/Kasha/Gekko/Yukikaze/Koki/Enpi
  sets.precast.WS = 
  {
    sub  = "Knobkierrie",
    head = gear.blueglenn.mpaca.head,
    body = gear.blueglenn.sam.relic.body,
    hands= gear.blueglenn.valorous.hands.wsd,
    legs = gear.blueglenn.hizamaru.legs, -- todo: gear.blueglenn.sam.artifact.legs when +3 (af +2 does not beat hizamaru +2)
    feet = gear.blueglenn.valorous.feet.wsd,
    neck = "Fotia Gorget", -- todo: gear.blueglenn.sam.neck when r25
    ear1 = gear.blueglenn.moonshade,
    ear2 = "Telos Earring", -- todo: Ishvara or Thrud earring
    ring1= "Petrov Ring",
    ring2= "Apate Ring",
    back = gear.blueglenn.sam.capes.ws,
    waist= "Fotia Belt", -- todo: sailfi belt +1 when r15
  }

  sets.precast.WS['Ageha'] = 
    set_combine(sets.precast.WS, 
    {
      head = gear.blueglenn.flamma.head,
      body = gear.blueglenn.mpaca.body,
      hands= gear.blueglenn.mpaca.hands,
      legs = gear.blueglenn.mpaca.legs,
      feet = gear.blueglenn.flamma.feet,
      ear1 = "Crep. Earring",
      ring1= "Stikini Ring +1",
      ring2= "Stikini Ring",
    }
  )
  ---------------------------------
  -- job abilities
  ---------------------------------
  sets.precast.JA['Meditate'] = 
  { 
    head = gear.blueglenn.sam.artifact.head, -- 2-3 more ticks
    hands= gear.blueglenn.sam.relic.hands,   -- 2-3 more ticks
    back = gear.blueglenn.sam.capes.tp       -- 2-3 more ticks 
  }
  sets.precast.JA['Hasso'] = 
  {
    hands= gear.blueglenn.sam.artifact.hands,
    legs = gear.blueglenn.sam.empyrean.legs
  }
  sets.precast.JA['Warding Circle'] = 
  {
    body = gear.blueglenn.sam.artifact.head
  }
  sets.precast.JA['Third Eye'] = 
  {
    legs = gear.blueglenn.sam.relic.legs
  }
  sets.precast.JA['Sekkanoki'] = 
  {
    hands = gear.blueglenn.sam.empyrean.hands
  }
  sets.precast.JA['Shikikoyo'] = 
  {
    legs = gear.blueglenn.sam.relic.legs
  }
  sets.precast.JA['Sengikori'] = 
  {
    feet = gear.blueglenn.sam.empyrean.feet
  }
end