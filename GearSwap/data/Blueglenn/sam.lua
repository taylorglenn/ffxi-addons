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
  gear.globals.sam = {
    capes = 
    {
      tp = { name="Smertrios's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','Accuracy+4','"Dbl.Atk."+10',}},
      ws = { },
    },
    
    neck = "Sam. Nodowa +2",

    artifact = 
    {  
      head = "Wakido Kabuto +1",
      body = "Wakido Domaru +1",
      hands= "Wakido Kote +1",
      legs = "Wakido Haidate +1",
      feet = "Wakido Sune-Ate" 
    },

    relic = 
    { 
      head = "Sakonji Kabuto",
      body = "Sakonji Domaru +3",
      hands= "Sakonji Kote +3",
      legs = "Sakonji Haidate +1",
      feet = "Sakonji Sune-Ate" 
    },

    empyrean = 
    {  
      head = "Kasuga Kabuto",
      body = "Kasuga Domaru +1",
      hands= "Kasuga Kote +1",
      legs = "Kasuga Haidate +1",
      feet = "Kasuga Sune-Ate +1" 
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
end

---------------------------------
-- define gear sets
---------------------------------
function init_gear_sets()
  ---------------------------------
  -- idle
  ---------------------------------
  sets.idle = 
  { 
    ammo  = "Staunch Tathlum", -- 2 dt
    head  = gear.globals.nyame.head, --7 dt
    body  = gear.globals.hizamaru.body, -- regen +12
    hands = gear.globals.nyame.hands, --7 dt
    legs  = gear.globals.nyame.legs, --8 dt
    feet  = gear.globals.nyame.feet, --7 dt
    neck  = "Bathy Choker +1", -- regen +3
    ear1  = "Etiolation Earring", --3 mdt
    ear2  = "Infused Earring", -- regen +1
    ring1 = "Shneddick Ring",
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
    head = gear.globals.flamma.head, 
    body = gear.globals.sam.empyrean.body,
    hands= gear.globals.sam.artifact.hands,
    legs = gear.globals.ryuo.legs,
    feet = gear.globals.ryuo.feet,
    neck = gear.globals.sam.neck,
    ear1 = "Dedition Earring",
    ear2 = "Telos Earring",
    ring1= "Chirich Ring +1", -- todo: "Niqmaddu Ring",
    ring2= "Ilabrat Ring", -- todo: "Flamma Ring",
    back = gear.globals.sam.capes.tp,
    waist = "Ioskeha Belt"
  }

  sets.engaged.Acc = 
    set_combine(sets.engaged, 
      {
        sub = "Khonsu", -- todo: Utu Grip
        body = gear.globals.kendatsuba.body,
        legs = gear.globals.kendatsuba.legs,
        feet = gear.globals.flamma.feet,
        ear2 = "Crep. Earring",
      }
    )

  sets.engaged.Dt = 
    set_combine(sets.engaged, 
      {
        ammo = "Staunch Tathlum",
        head = gear.globals.kendatsuba.head,
        body = gear.globals.sam.artifact.body,
        legs = gear.globals.kendatsuba.legs,
        feet = gear.globals.kendatsuba.feet,
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
        head = gear.globals.kendatsuba.head,
        body = gear.globals.kendatsuba.body,
        legs = gear.globals.kendatsuba.legs,
        feet = gear.globals.kendatsuba.feet,
        neck = "Moonbeam Nodowa",
        ring2= "Ilabrat Ring",
        waist= "Windbuffet Belt +1",
      }
    )

  sets.engaged.SubtleBlow = 
    set_combine(sets.engaged, 
      {
        head = gear.globals.kendatsuba.head, --8
        body = "Dagon Breastplate", --10(II)
        legs = gear.globals.mpaca, --5(II)
        feet = gear.globals.ryuo.feet, --8
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
    head = gear.globals.mpaca.head,
    body = gear.globals.sam.relic.body,
    hands= gear.globals.valorous.hands.wsd,
    legs = gear.globals.hizamaru.legs, -- todo: gear.globals.sam.artifact.legs when +3 (af +2 does not beat hizamaru +2)
    feet = gear.globals.valorous.feet.wsd,
    neck = gear.globals.sam.neck,
    ear1 = gear.globals.moonshade,
    ear2 = "Telos Earring", -- todo: Ishvara or Thrud earring
    ring1= "Petrov Ring",
    ring2= "Apate Ring",
    back = gear.globals.sam.capes.ws,
    waist= "Sailfi Belt +1"
  }

  -- Tachi: Fudo - 80% STR - Dynamic fTP - 3.75 / 5.75 / 8.0 
  -- Empyrean aftermath - Occasioinally triples damage - 30% 60s / 40% 120s / 50% 180s
  sets.precast.WS['Tachi: Fudo'] = sets.precast.WS

  -- Tachi: Kasha - 75% STR - Attack modifier @ 1.65 - Dynamic fTP - 1.5625 / 2.6875 / 4.125
  sets.precast.WS['Tachi: Kasha'] = sets.precast.WS

  -- Tachi: Gekko - 75% STR - Attack modifier @ 2.0 - Dynamic fTP - 1.5625 / 2.6875 / 4.125
  sets.precast.WS['Tachi: Gekko'] = sets.precast.WS

  -- Tachi: Yukikaze - 75% STR - Attack modifier @ 1.5 - Dynamic fTP - 1.5625 / 2.6875 / 4.125
  sets.precast.WS['Tachi: Yukikaze'] = sets.precast.WS

  -- Tachi: Enpi - 60% STR - Dynamic fTP - 1.0 / 1.5 / 2.0
  sets.precast.WS['Tachi: Enpi'] = sets.precast.WS

  -- Tachi: Koki - 50% STR / 30% MND - Dynamic fTP - 0.5 / 1.5 / 2.5
  sets.precast.WS['Tachi: Koki'] = sets.precast.WS

  -- Tachi: Ageha - 60% CHR / 40% STR - Static fTP @ 2.625 - TP modifies accuracy (though how much is unknown)
  sets.precast.WS['Tachi: Ageha'] = 
    set_combine(sets.precast.WS, 
      {
        head = gear.globals.flamma.head,
        body = gear.globals.mpaca.body,
        hands= gear.globals.mpaca.hands,
        legs = gear.globals.mpaca.legs,
        feet = gear.globals.flamma.feet,
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
    head = gear.globals.sam.artifact.head, -- 2-3 more ticks
    hands= gear.globals.sam.relic.hands,   -- 2-3 more ticks
    back = gear.globals.sam.capes.tp       -- 2-3 more ticks 
  }
  sets.precast.JA['Hasso'] = 
  {
    hands= gear.globals.sam.artifact.hands,
    legs = gear.globals.sam.empyrean.legs
  }
  sets.precast.JA['Warding Circle'] = 
  {
    body = gear.globals.sam.artifact.head
  }
  sets.precast.JA['Third Eye'] = 
  {
    legs = gear.globals.sam.relic.legs
  }
  sets.precast.JA['Sekkanoki'] = 
  {
    hands = gear.globals.sam.empyrean.hands
  }
  sets.precast.JA['Shikikoyo'] = 
  {
    legs = gear.globals.sam.relic.legs
  }
  sets.precast.JA['Sengikori'] = 
  {
    feet = gear.globals.sam.empyrean.feet
  }
end