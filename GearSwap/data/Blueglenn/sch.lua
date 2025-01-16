---------------------------------
-- required includes
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
set_lockstyle(9)

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
set_macros(1, 19)

---------------------------------
-- dislpay globals
---------------------------------
displaySettings = 
{ 
    pos = { x = 0, y = 0 },
    text = { font = 'Consolas', size = 10 },
    bg = { alpha = 255 },
    flags = { draggable = false }
}
displayBox = texts.new('${value}', displaySettings)

---------------------------------
-- user globals
---------------------------------
spells = S{}
enhancing_magic = S{'Protect V','Protect IV','Protect III','Protect II','Protect','Shell V','Shell IV','Shell III','Shell II','Shell','Blink','Stoneskin','Aquaveil','Haste','Flurry','Regen V','Regen IV','Regen III','Regen II','Regen','Invisible','Sneak','Deodorize','Phalanx','Barfire','Barblizzard','Baraero','Barstone','Barthunder','Barwater','Barsleep','Barpoison','Barparalyze','Barblind','Barsilence','Barpetrify','Barvirus','Enfire','Enblizzard','Enaero','Enstone','Enthunder','Enwater','Refresh','Sandstorm','Rainstorm','Windstorm','Firestorm','Hailstorm','Thunderstorm','Voidstorm','Aurorastorm','Animus Augeo','Animus Minuo','Adloquium','Embrava','Blaze Spikes','Ice Spikes','Shock Spikes','Klimaform'}

---------------------------------
-- job setup
---------------------------------
function job_setup()
  state.Buff['dark arts'] = buffactive['dark arts'] or false


end

---------------------------------
-- user setup
---------------------------------
function user_setup() 
  state.IdleMode:options('Refresh')
  send_command('bind ^i gs c cycle IdleMode')

  state.OffenseMode:options('Normal')
  send_command('bind ^o gs c cycle OffenseMode')

  state.CastingMode:options('Free', 'Immanence', 'Burst')
  send_command('bind ^c gs c cycle CastingMode')

  state.HelixMode = M{ 'Free', 'Burst' }
  send_command('bind ^h gs c cycle HelixMode')

  state.RegenMode = M{ 'Potency', 'Duration' }
  send_command('bind ^r gs c cycle RegenMode')

  drawDisplay()

  windower.register_event('prerender', drawDisplay)
  ---------------------------------
  -- jse setup
  ---------------------------------
  gear.globals.sch = 
  {
    capes = 
    { 
      int_macc_matt_sird = { name="Lugh's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','"Mag.Atk.Bns."+10','Spell interruption rate down-10%',}},
      regen_pot_helix_dur = { name="Bookworm's Cape", augments={'INT+1','MND+4','Helix eff. dur. +18','"Regen" potency+10',}},
    },

    neck = "Argute stole +1",

    artifact = 
    {  
      head  = "Academic's Mortarboard +1",
      body  = "Academic's Gown +2",
      hands = "Academic's Bracers +1",
      legs  = "Academic's Pants +1",
      feet  = "Academic's Loafers +1" 
    },

    relic = 
    {     
      head  = "Pedagogy Mortarboard +3",
      body  = "Pedagogy Gown +3",
      hands = "Pedagogy Bracers +3",
      legs  = "Pedagogy Pants +3",
      feet  = "Pedagogy Loafers +3" 
    },

    empyrean = 
    {  
      head = "Arbatel Bonnet +2",
      body = "Arbatel Gown +1",
      hands= "Arbatel Bracers +2",
      legs = "Arbatel Pants +1",
      feet = "Arbatel Loafers +2",
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
  send_command('unbind ^c') -- unbinds CastingMode from c key
  send_command('unbind ^h') -- unbinds HelixMode from the h key
  send_command('unbind ^r') -- unbinds RegenMode from r key
end

---------------------------------
-- define gearsets
---------------------------------
function init_gear_sets()
  ----------------
  -- idle
  ----------------
  sets.idle = { -- just stacking refresh
    main = "Mpaca's Staff",
    sub  = "Khonsu",
    ammo = "Homiliary",
    head = gear.globals.nyame.head,	
    neck = "Bathy Choker +1", 	
    ear1 = "Etiolation Earring", 	
    ear2 = "Eabani Earring",
    body = gear.globals.sch.empyrean.body,	
    hands= gear.globals.nyame.hands, 	
    ring1= "Stikini Ring +1", 	
    ring2= "Shneddick Ring",
    back = "Moonbeam Cape",	
    waist= "Embla Sash", 	
    legs = "Assid. Pants +1", 	
    feet = "Herald's Gaiters"
  }

  ----------------
  -- fastcast
  ----------------
  sets.precast.FC = { 
    main = gear.globals.grioavolr.fast_cast, -- 10
    head = "Nahtirah Hat",	 -- 10
    neck = "Voltsurge Torque", -- 4 	
    ear1 = "Loquac. Earring", 	-- 2
    ear2 = "Malignance Earring", -- 4
    body = "Pinga Tunic", -- 13	
    hands= "Gende. Gages +1", -- 7 	
    ring1= "Prolix Ring",  -- 2 	
    ring2= "Kishar Ring",  -- 4
    back = "Fi Follet Cape +1", -- 10	
    waist= "Witful Belt",  -- 3 	
    legs = gear.globals.psycloth.legs.fc, 	-- 7
    feet = gear.globals.merlinic.feet.fc -- 9
  } -- 85

  ----------------
  -- midcast
  ----------------
	sets.midcast['Enhancing Magic'] = { 
    main = "Pedagogy Staff",
    head = gear.globals.telchine.head.enhancing_duration,	
    body = gear.globals.telchine.body.enhancing_duration,
    hands= gear.globals.telchine.hands.enhancing_duration_sird, 	
    ring1= "Stikini Ring +1", 	
    ring2= "Stikini Ring",
    back = "Fi Follet Cape +1",	
    waist= "Embla Sash", 	
    legs = gear.globals.telchine.legs.enhancing_duration, 	
    feet = gear.globals.telchine.feet.enhancing_duration_sird 
  }

	sets.midcast.Cure = { 
    main = "Chatoyant Staff",
    ammo = "Pemphredo Tathlum",
    head = gear.globals.kaykaus.head,	
    neck = "Nodens Gorget", 	
    ear1 = "Mendi. Earring", 	
    ear2 = "Calamitous Earring",
    body = gear.globals.kaykaus.body,	
    hands= gear.globals.kaykaus.hands, 	
    ring1= "Stikini Ring +1", 	
    ring2= "Lebeche Ring",
    back = "Fi Follet Cape +1",	
    waist= "Hachirin-no-Obi", 	
    legs = gear.globals.kaykaus.legs, 	
    feet = gear.globals.kaykaus.feet 
  }

  sets.midcast.Regen = set_combine(sets.midcast.cure, { 
    main = "Pedagogy Staff",
    waist= "Embla Sash", 	
    back = gear.globals.sch.capes.int_macc_matt_sird,
  })
  sets.midcast.Regen.Potency = set_combine(sets.midcast.Regen, { 
    head = gear.globals.sch.empyrean.head,	
    body = gear.globals.telchine.body.cure_regen_pot,	
    hands= gear.globals.telchine.hands.regen_pot, 	
    legs = gear.globals.telchine.legs.cure_regen_pot, 	
    feet = gear.globals.telchine.feet.regen_pot
  })
  sets.midcast.Regen.Duration = set_combine(sets.midcast.Regen, {
    head = gear.globals.telchine.head.enhancing_duration,
    body = gear.globals.telchine.body.enhancing_duration,	
    hands= gear.globals.telchine.hands.enhancing_duration_sird, 	
    legs = gear.globals.telchine.legs.enhancing_duration, 	
    feet = gear.globals.telchine.feet.enhancing_duration_sird
  })

  sets.midcast['Dark Magic'] = {
    ammo  = "Staunch Tathlum",
    head  = "Pixie Hairpin +1",
    body  = gear.globals.merlinic.body.drain_aspir,
    hands = gear.globals.merlinic.hands.drain_aspir,
    legs  = gear.globals.sch.relic.legs,
    feet  = gear.globals.merlinic.feet.fc,
    neck  = "Erra Pendant",
    waist = "Fucho-no-Obi",
    ring1 = "Evanescence Ring",
    ring2 = "Archon Ring",
    back  = gear.globals.sch.capes.regen_pot_helix_dur,
  }

  sets.midcast.Elemental = { 
    main = "Akademos",
    sub  = "Enki Strap",
    ammo = "Ghastly Tathlum +1",
    head = gear.globals.sch.relic.head,
    neck  = gear.globals.sch.neck,
    ear1 = "Barkaro. Earring",
    ear2 = "Malignance Earring",
    body = gear.globals.amalric.body,
    hands= gear.globals.amalric.hands,
    ring1= "Acumen Ring",
    ring2= "Freke Ring",
    back = gear.globals.sch.capes.int_macc_matt_sird,
    waist = "Hachirin-no-Obi",
    legs = gear.globals.sch.relic.legs,
    feet = gear.globals.sch.empyrean.feet
  }
  sets.midcast.Elemental.Burst = set_combine(sets.midcast.Elemental, {
    main = "Mpaca's Staff",
    ring1= "Mujin Band"
  })
  sets.midcast.Elemental.Free = set_combine(sets.midcast.Elemental, {
  
  })
  sets.midcast.Elemental.Immanence = set_combine(sets.midcast.Elemental, {
    head = gear.globals.nyame.head,
    body = gear.globals.nyame.body,
    hands= gear.globals.sch.empyrean.hands,
    neck = "Warder's charm +1",
    back = gear.globals.sch.capes.int_macc_matt_sird
  })

  sets.midcast.Helix = sets.midcast.Elemental
  sets.midcast.Helix.Free = set_combine(sets.midcast.Helix, {

  })
  sets.midcast.Helix.Burst = set_combine(sets.midcast.Helix, {

  })

  ----------------
  -- buffs
  ----------------
  sets.buff.Rapture = { head = gear.globals.sch.empyrean.head }
  --sets.buff.Klimaform = { feet = gear.globals.sch.empyrean.feet }
  sets.buff.Perpetuance = { hands = gear.globals.sch.empyrean.hands }
  sets.buff.Immanence = { hands = gear.globals.sch.empyrean.hands }
  sets.buff.Ebullience = { head = gear.globals.sch.empyrean.head }
end 

---------------------------------
-- display stuff
---------------------------------
function drawDisplay()
  local displayLines = L{}

  local stratagemsAvailable = getStratagemsAvilable()

  -- Modes
  displayLines:append('[I]dle: '..state.IdleMode.value)
  displayLines:append('[O]ffense: '..state.OffenseMode.value)
  displayLines:append('[C]asting: '..state.CastingMode.value)
  displayLines:append('[H]elix: '..state.HelixMode.value)
  displayLines:append('[R]egen: '..state.RegenMode.value)

  displayLines:append(' - ')
  displayLines:append('Stratagems: '..tostring(stratagemsAvailable))

  displayBox:text(displayLines:concat(' | '))
  displayBox:show()
end

---------------------------------
-- gearswap hooks
---------------------------------
function job_buff_change(buff, gain) 
  -- Is triggered every time you either recieve a buff, or one wears off
  -- buff is the name of the buff, and gain is true if you are getting the buff, and false if the buff is wearing off
  handleBuffGear(buff, gain)
  drawDisplay()
end

function job_buff_refresh(name, buff_details)
  drawDisplay()
end

function job_precast(spell, action, spellMap, eventArgs)
  local self = windower.ffxi.get_player()

  -- Cure
  if string.find(spell.name, 'Cure') then
    if not buffactive['Aurorastorm'] then
      windower.add_to_chat(028, 'WARNING: Curing without Aurorastorm active')
    end
  end

  -- Immanence
  if (state.CastingMode.value == 'Immanence' and spell.type == 'BlackMagic' and not buffActive['Immanence']) then
    local isSpellT1Nuke = elemental.tier1:contains(spell.name)
    local hasStratagems = getStratagemsAvilable() > 0
    local inDarkArts = getArtsState() == arts.Dark
    if (isSpellT1Nuke and hasStratagems and inDarkArts) then 
      windower.add_to_chat(123, "Auto Immanence: Attempting to use Immanence")
      cast_delay(1.1)
      send_command('@input /ja "Immanence" <me>')
    else 
      if (not isSpellT1Nuke) then windower.add_to_chat(123, 'Auto Immanence: Spell is not a T1 Nuke.') end
      if (not hasStratagems) then windower.add_to_chat(123, 'Auto Immanence: No Strategems availible.') end
      if (not inDarkArts) then windower.add_to_chat(123, 'Auto Immanence: Not in Dark Arts.') end
    end
  end
end

function job_midcast(spell, action, spellMap, eventArgs)
  -----------------
  -- WHITE MAGIC --
  -----------------
  if (spell.type == 'WhiteMagic') then
    -- Regen 
    if (string.find(spell.name, 'Regen')) then 
      equip(sets.midcast.Regen[state.RegenMode.value])
      return
    end
  end

  -----------------
  -- BLACK MAGIC --
  -----------------
  if (spell.type == 'BlackMagic') then
    -- Elemental Spells
    if (elemental:contains(spell.name)) then
      equip(sets.midcast.Elemental[state.CastingMode.value])
      return
    end

    -- Helix
    if (helixes:contains(spell.name)) then 
      equip(sets.midcast.Helix[state.HelixMode.value])
      return
    end
  end

  -------------
  -- DEFAULT --
  ------------- 
  local skill = spell.skill
  if skill ~= nil and sets.midcast[skill] ~= nil then
    equip(sets.midcast[skill])
    return
  end
end

function job_aftercast(spell, action, spellMap, eventArgs) 
  drawDisplay()
end

function job_state_change(field, newValue, oldValue)
  -- any mode changed
  drawDisplay()
end

---------------------------------
-- user defined functions 
---------------------------------
function chat(message)
  add_to_chat(123, message)
end

function handleBuffGear(buffName, gain)
  local buffSet = sets.buff[buffName]
  if buffSet == nil then return end 

  for slot,_ in pairs(buffSet) do
    toggleSlotForBuff(buffName, gain, slot)
  end
end

function toggleSlotForBuff(buffName, gain, slot)
  if gain then
    equip(sets.buff[buffName])
    disable(slot)
    chat('Slot disabled: ' .. slot .. ' - because ' .. buffName .. ' was activated.')
  else
    enable(slot)
    chat('Slot enabled: ' .. slot .. ' - because ' .. buffName .. ' has worn.')
  end
end

function getStratagemsAvilable() 
  -- get max possible
  local maxStrategems = math.floor(player.main_job_level + 10) / 20
  -- returns recast in seconds
  local allRecasts = windower.ffxi.get_ability_recasts()
  local stratsRecast = allRecasts[231]
  if stratsRecast == nil then
    return maxStrategems
  end
  -- assuming level 90+ and if not 550JP replace 5*33 by 5*48 below
  local fullRechargeTime = maxStrategems * 33
  local currentCharges = math.floor(maxStrategems - maxStrategems * stratsRecast / fullRechargeTime)

  return currentCharges
end

function getArtsState() 
  local self = windower.ffxi.get_player()
  for _,v in pairs(self.buffs) do
    if v == 359 then return arts.Dark end   --359 is Dark Arts
    if v == 358 then return arts.Light end  -- 358 is Light Arts
  end
end

---------------------------------
-- data
---------------------------------
elemental = S{
  'Stone',    'Stone II',     'Stone III',    'Stone IV',     'Stone V',
  'Water',    'Water II',     'Water III',    'Water IV',     'Water V',
  'Aero',     'Aero II',      'Aero III',     'Aero IV',      'Aero V',
  'Fire',     'Fire II',      'Fire III',     'Fire IV',      'Fire V',
  'Blizzard', 'Blizzard II',  'Blizzard III', 'Blizzard IV',  'Blizzard V',
  'Thunder',  'Thunder II',   'Thunder III',  'Thunder IV',   'Thunder V',
  tier1 = S{
    'Stone', 'Water', 'Aero', 'Fire', 'Blizzard', 'Thunder'
  }
}
helixes = S{
  "Geohelix II", "Hydrohelix II", "Anemohelix II", "Pyrohelix II", "Cryohelix II", "Ionohelix II", "Luminohelix II", "Noctohelix II"
}
storms = S{
 "Sandstorm II", "Rainstorm II", "Windstorm II", "Firestorm II", "Hailstorm II", "Thunderstorm II", "Aurorastorm II", "Voidstorm II"
}
arts = {['Dark']=0, ['Light']=1}