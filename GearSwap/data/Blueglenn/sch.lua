---------------------------------
-- required includes
---------------------------------
function get_sets()
  -- Load and initialize the include file.
  mote_include_version = 2
  include('Mote-Include.lua')
  include('organizer-lib')
end

---------------------------------
-- user globals
---------------------------------
spells = S{}
enhancing_magic = S{'Protect V','Protect IV','Protect III','Protect II','Protect','Shell V','Shell IV','Shell III','Shell II','Shell','Blink','Stoneskin','Aquaveil','Haste','Flurry','Regen V','Regen IV','Regen III','Regen II','Regen','Invisible','Sneak','Deodorize','Phalanx','Barfire','Barblizzard','Baraero','Barstone','Barthunder','Barwater','Barsleep','Barpoison','Barparalyze','Barblind','Barsilence','Barpetrify','Barvirus','Enfire','Enblizzard','Enaero','Enstone','Enthunder','Enwater','Refresh','Sandstorm','Rainstorm','Windstorm','Firestorm','Hailstorm','Thunderstorm','Voidstorm','Aurorastorm','Animus Augeo','Animus Minuo','Adloquium','Embrava','Blaze Spikes','Ice Spikes','Shock Spikes','Klimaform'}

---------------------------------
-- user setup
---------------------------------
function user_setup() 
  state.IdleMode:options('Normal', 'KyraSpecial')
  send_command('bind ; gs equip naked')
end

---------------------------------
-- user unload
---------------------------------
function user_unload()
  -- unload keybinds
  send_command('unbind ;') -- unbinds IdleMode from i key
end

---------------------------------
-- define gearsets
---------------------------------
function init_gear_sets()
	sets.template = {	
    head="",	
    neck="", 	
    ear1="", 	
    ear2="",
    body="",	
    hands="", 	
    ring1="", 	
    ring2="",
    back="",	
    waist="", 	
    legs="", 	
    feet=""  
  }	

  sets.idle = {
    main="Vadose Rod",
    sub="Sors Shield",
    ammo="Kalboron Stone",
    head="Gende. Caubeen",
    body="Gendewitha Bliaut",
    hands={ name="Telchine Gloves", augments={'Enh. Mag. eff. dur. +10',}},
    legs={ name="Telchine Braconi", augments={'Enh. Mag. eff. dur. +10',}},
    feet={ name="Telchine Pigaches", augments={'Enh. Mag. eff. dur. +10',}},
    neck="Healing Torque",
    waist="Embla Sash",
    left_ear="Influx Earring",
    right_ear="Astral Earring",
    left_ring="Fenrir Ring",
    right_ring="Bifrost Ring",
    back={ name="Lugh's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
  }
  
  sets.naked = { -- do we need this set?  we're just overriding gearswap's built-in sets.naked.  
    main="Vadose Rod",
    sub=empty,
    ammo="Kalboron Stone",
    head="Gende. Caubeen",
    body="Gendewitha Bliaut",
    hands={ name="Telchine Gloves", augments={'Enh. Mag. eff. dur. +10',}},
    legs={ name="Telchine Braconi", augments={'Enh. Mag. eff. dur. +10',}},
    feet={ name="Telchine Pigaches", augments={'Enh. Mag. eff. dur. +10',}},
    neck="Chocobo Whistle",
    waist="Embla Sash",
    left_ear="Influx Earring",
    right_ear="Astral Earring",
    left_ring="Fenrir Ring",
    right_ring="Bifrost Ring",
    back={ name="Lugh's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
  }

  sets.precast.FC = { } -- put your fast cast stuff in here

	sets.midcast['Enhancing Magic'] = {
    main="Vadose Rod",
    sub="Sors Shield",
    ammo="Kalboron Stone",
    head= { name="Telchine Cap", augments={'Enh. Mag. eff. dur. +10',}},
    body={ name="Telchine Chas.", augments={'Enh. Mag. eff. dur. +10',}},
    hands={ name="Telchine Gloves", augments={'Enh. Mag. eff. dur. +10',}},
    legs={ name="Telchine Braconi", augments={'Enh. Mag. eff. dur. +10',}},
    feet={ name="Telchine Pigaches", augments={'Enh. Mag. eff. dur. +10',}},
    neck="Healing Torque",
    waist="Embla Sash",
    left_ear="Influx Earring",
    right_ear="Astral Earring",
    left_ring="Fenrir Ring",
    right_ring="Bifrost Ring",
    back={ name="Lugh's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
  }

	sets.midcast.Cure = {
    main="Vadose Rod",
    sub="Sors Shield",
    ammo="Kalboron Stone",
    head="Gende. Caubeen",
    body="Gendewitha Bliaut",
    hands={ name="Telchine Gloves", augments={'Enh. Mag. eff. dur. +10',}},
    legs={ name="Telchine Braconi", augments={'Enh. Mag. eff. dur. +10',}},
    feet={ name="Telchine Pigaches", augments={'Enh. Mag. eff. dur. +10',}},
    neck="Healing Torque",
    waist="Embla Sash",
    left_ear="Influx Earring",
    right_ear="Astral Earring",
    left_ring="Fenrir Ring",
    right_ring="Bifrost Ring",
    back={ name="Lugh's Cape", augments={'MP+60','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Fast Cast"+10','Phys. dmg. taken-10%',}},
  }

  sets.buff.Perpetuance = { hands = "Arbatel Bracers" }
end 

---------------------------------
-- gearswap hooks
---------------------------------
function job_buff_change(buff, gain) 
  -- Is triggered every time you either recieve a buff, or one wears off
  -- buff is the name of the buff, and gain is true if you are getting the buff, and false if the buff is wearing off
  handleBuffGear(buff, gain)
end

function job_precast(spell, action, spellMap, eventArgs)
  -- this hook happens every time you cast a spell or use a job ability, but does not get called for simple engagement
end

function job_midcast(spell, action, spellMap, eventArgs)
  local skill = spell.skill
  if skill ~= nil and sets.midcast[skill] ~= nil then
    equip(sets.midcast[skill])
  end
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