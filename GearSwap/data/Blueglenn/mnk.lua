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
set_lockstyle(01)

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
set_macros(1, 1)

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
  state.Buff['Footwork'] = buffactive['Footwork'] or false
  state.Buff['Impetus'] = buffactive['Impetus'] or false
	state.Buff['Boost'] = buffactive['Boost'] or false

  info.impetus_hit_count = 0
  windower.raw_register_event('action', on_action_for_impetus)
end

---------------------------------
-- user setup
---------------------------------
function user_setup() 
  state.IdleMode:options('Normal')
  send_command('bind ^i gs c cycle IdleMode')

  state.OffenseMode:options('Normal', 'Acc', 'Counter', 'SubtleBlow')
  send_command('bind ^o gs c cycle OffenseMode')

  ---------------------------------
  -- jse setup
  ---------------------------------
  gear.blueglenn.mnk = {
    capes = 
    { 
      dex_acc_att_double_attack_counter = { name="Segomo's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','System: 1 ID: 640 Val: 4',}},
      str_crit = { name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','STR+5','Crit.hit rate+10','Phys. dmg. taken-10%',}},
      str_da = { name="Segomo's Mantle", augments={'STR+20','Accuracy+20 Attack+20','"Dbl.Atk."+10','Phys. dmg. taken-10%',}},
      vit_wsd = { }
    },
  
    neck = "Monk's nodowa +1",
  
    artifact = {  head  = "Anchorite's crown +1",
                  body  = "Anchorite's cyclas +2",
                  hands = "Anchorite's gloves +2",
                  legs  = "Anchorite's hose +2",
                  feet  = "Anchorite's gaiters +3" },
  
    relic = {     head  = "Hesychast's crown +1",
                  body  = "Hesychast's cyclas +1",
                  hands = "Hesychast's gloves +2",
                  legs  = "Hesychast's hose +3",
                  feet  = "Hesychast's gaiters +2" },
  
    empyrean = {  head  = "Bhikku crown +1",
                  body  = "Bhikku cyclas +1",
                  hands = "Bhikku gloves +1",
                  legs  = "Bhikku hose +1",
                  feet  = "Bhikku gaiters +1" }, 
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
  sets.idle = { 
    ammo  = "Staunch Tathlum",
    head  = gear.blueglenn.rao.head, -- regen +3
    body  = gear.blueglenn.hizamaru.body, -- regen +12
    hands = gear.blueglenn.rao.hands, -- regen +2
    legs  = gear.blueglenn.nyame.legs,
    feet  = "Hermes' Sandals", -- 12% movement speed
    neck  = "Bathy Choker +1", -- regen +3
    ear1  = "Etiolation Earring",
    ear2  = "Infused Earring", -- regen +1
    ring1 = "Chirich ring +1", -- regen +2
    ring2 = "Defending ring",
    back  = gear.blueglenn.mnk.capes.dex_acc_att_double_attack_counter, -- pdt cape when/if you get one
    waist = "Moonbow Belt +1", 
  }
  
  ---------------------------------
  -- Melee
  ---------------------------------
  sets.engaged = {  
    ammo  = "Aurgelmir orb",
    head  = "Mpaca's Cap",
    body  = "Mpaca's Doublet",
    hands = "Mpaca's Gloves",
    legs  = "Mpaca's Hose",
    feet  = gear.blueglenn.kendatsuba.feet,
    neck  = gear.blueglenn.mnk.neck,
    ear1  = "Mache Earring +1",
    ear2  = "Sherida earring",
    ring1 = "Epona's Ring",
    ring2 = "Gere Ring",
    back  = gear.blueglenn.mnk.capes.dex_acc_att_double_attack_counter,
    waist = "Moonbow Belt +1" 
  }

  sets.engaged.Acc = set_combine(
    sets.engaged, {  
      ammo = "Falcon Eye",
      head = gear.blueglenn.mummu.head,
      ear2 = "Mache Earring +1", 
    }
  ) 

  -- 35 from job traits and gifts
  sets.engaged.SubtleBlow = set_combine(
    sets.engaged, {
      ammo = "Expeditious Pinion", -- 7
      head = gear.blueglenn.adhemar.head, -- 8
      legs = gear.blueglenn.mpaca.legs, -- 5 (II)
      ear2 = "Sherida Earring", -- 5 (II)
      ring1= "Niqmaddu Ring", -- 5 (II) -- todo
      waist= "Moonbow Belt +1", -- 15 (II)
    }
  ) -- 50/50 (I) + 25/50 (II) = 75/75 (tot)

  -- 22% from job traits and gifts
  sets.engaged.Counter = set_combine(
    sets.engaged, {
      ammo = "Amar Cluster", -- todo --2
      head = "Rao Kabuto", --todo path d --4
      body = gear.blueglenn.mpaca.body,  --10
      hands= gear.blueglenn.rao.hands, --5
      legs = gear.blueglenn.mnk.artifact.legs, --6
      feet = gear.blueglenn.mnk.relic.feet, --(no chance, but counter attack +24)
      neck = "Bathy Choker +1", --10
      ear1 = "Cryptic Earring", --3
      ear2 = "Sherida Earring",
      ring1= "Defending Ring",
      ring2= "Niqmaddu Ring", -- todo
      back  = gear.blueglenn.mnk.capes.dex_acc_att_double_attack_counter, --10
      waist = "Moonbow Belt +1" 
    }
  ) -- 62/80 (Spharai: +14, 76/80)


  ---------------------------------
  -- Job Abilities
  ---------------------------------
  sets.precast.JA['Chakra']           = { body = gear.blueglenn.mnk.artifact.body, hands = gear.blueglenn.mnk.relic.hands }
  sets.precast.JA['Hundred Fists']    = { legs = gear.blueglenn.mnk.relic.legs }
  sets.precast.JA['Boost']            = { hands= gear.blueglenn.mnk.artifact.hands, waist = "Ask Sash" }
  sets.precast.JA['Dodge']            = { feet = gear.blueglenn.mnk.artifact.feet }
  sets.precast.JA['Focus']            = { head = gear.blueglenn.mnk.artifact.head }
  sets.precast.JA['Counterstance']    = { feet = gear.blueglenn.mnk.relic.feet }
  sets.precast.JA['Footwork']         = { feet = "Shukuyu Sune-Ate" }
  sets.precast.JA['Formless Strikes'] = { body = gear.blueglenn.mnk.relic.body }
  sets.precast.JA['Mantra']           = { feet = gear.blueglenn.mnk.relic.feet }
  sets.precast.JA['Boost'].OutOfCombat= sets.precast.JA['Boost']
	
	sets.engaged.HF = set_combine(sets.engaged, {}) -- do i need this set?  maybe ditch haste for accuracy and damage?

	sets.buff.Impetus  = { body = gear.blueglenn.mnk.empyrean.body }
	sets.buff.Footwork = { feet = gear.blueglenn.mnk.artifact.feet }
	sets.buff.Boost    = { waist = "Ask Sash" }
	
  ---------------------------------
  -- Weapon Skills
  ---------------------------------
  sets.precast.WS = { 
    ammo = "Knobkierrie",
    head = gear.blueglenn.mpaca.head,
    body = gear.blueglenn.mpaca.body,
    hands= gear.blueglenn.mpaca.hands,
    legs = gear.blueglenn.hizamaru.legs,
    feet = gear.blueglenn.kendatsuba.feet,
    neck = "Fotia Gorget",
    ear1 = "Sherida Earring",
    ear2 = gear.blueglenn.moonshade,
    ring1= "Chirich ring +1",
    ring2= "Gere Ring",
    back = gear.blueglenn.mnk.capes.str_da,
    waist= "Fotia Belt", 
  }

  -- Ascetic's Fury: 50% STR / 50% VIT - Static fTP @1.0 - TP modifies critical hit rate - +20% / +30% / +50%
  sets.precast.WS["Ascetic's Fury"] = set_combine(
    sets.precast.WS, {
      body = gear.blueglenn.mnk.artifact.body,
      hands= gear.blueglenn.ryuo.hands,
      legs = gear.blueglenn.kendatsuba.legs,
      feet = gear.blueglenn.herculean.feet.ta_att,
      ring1= "Niqmaddu Ring", -- todo
      waist= "Moonbow Belt +1",
    }
  )

  -- Victory Smite: 80% STR - Static fTP @ 1.5 - TP modifies critical hit rate - +10% / +25% / +45%
  sets.precast.WS['Victory Smite'] = set_combine(
    sets.precast.WS, { 
      ammo  = "Knobkierrie",
      head  = gear.blueglenn.adhemar.head,
      body  = gear.blueglenn.kendatsuba.body,
      hands = gear.blueglenn.ryuo.hands,
      neck  = gear.blueglenn.mnk.neck,
      body  = gear.blueglenn.kendatsuba.body,
      legs  = gear.blueglenn.kendatsuba.legs,
      feet  = gear.blueglenn.kendatsuba.feet,
      ear1  = "Sherida Earring",
      ring1 = "Epona's Ring",
      waist = "Moonbow Belt +1", 
      back  = gear.blueglenn.mnk.capes.str_crit
    }
  )

  -- Howling Fist: 50% VIT / 20% STR - Dynamic fTP: 2.05 / 3.58 / 5.8
  sets.precast.WS["Howling Fist"] = set_combine(
    sets.precast.WS, { 
      ammo  = "Knobkierrie",
      head  = gear.blueglenn.mpaca.head,
      body  = gear.blueglenn.mpaca.body,
      hands = gear.blueglenn.mpaca.gloves,
      legs  = gear.blueglenn.hizamaru.legs,
      feet  = gear.blueglenn.mpaca.boots,
    }
  )
                    
  -- Final Heaven: 80% VIT - Static fTP @ 3.0 - TP increases aftermath duration 20s per 1kTP (aftermath gives +10 Subtle Blow)
  sets.precast.WS["Final Heaven"] = sets.precast.WS["Howling Fist"]

  -- Tornado Kick: 40% STR / 40% VIT - Dynamic fTP: 1.68 / 2.8 / 4.575 - During footwork, uses foot base damage instead of h2h
  sets.precast.WS["Tornado Kick"] = set_combine(
    sets.precast.WS, {
      ammo  = "Knobkierrie",
      head  = gear.blueglenn.mpaca.head,
      legs  = gear.blueglenn.mpaca.legs,
      feet  = gear.blueglenn.mnk.artifact.feet,
      neck  = gear.blueglenn.mnk.neck,
      ring2 = "Gere Ring" 
    }
  )

  -- Raging Fists: 30% STR / 30% DEX - Dynamic fTP: 1.0 / 2.19 / 3.75
  sets.precast.WS["Raging Fists"] = set_combine(
    sets.precast.WS, { 
      head = gear.blueglenn.adhemar.head,
      body = gear.blueglenn.adhemar.body,
      hands= gear.blueglenn.adhemar.hands,
      legs = gear.blueglenn.kendatsuba.legs,
      feet = gear.blueglenn.herculean.feet.ta_att,
      ear1 = "Sherida Earring",
      ring1= "Niqmaddu Ring", -- todo
      waist= "Moonbow Belt +1",
    }
  )

  -- Shijin Spiral: 85% DEX - Static fTP @1.5 - TP modifies Plague (-50TP/tick @5-8 ticks) effect accuracy
  sets.precast.WS["Shijin Spiral"] = set_combine(
    sets.precast.WS, { 
      head  = gear.blueglenn.mummu.head,
      body  = gear.blueglenn.adhemar.body,
      hands = gear.blueglenn.adhemar.hands,
      legs  = gear.blueglenn.mnk.relic.legs,
      feet  = gear.blueglenn.kendatsuba.feet,
      neck  = gear.blueglenn.mnk.neck,
      ear1  = "Sherida Earring",
      ear2  = "Mache Earring +1",
      ring1 = "Niqmaddu Ring", -- todo
      ring2 = "Gere Ring",
      waist = "Moonbow Belt +1",
      back  = gear.blueglenn.mnk.capes.dex_acc_att_double_attack_counter
    }
  )

  -- Spinning Attack: 100% STR - Static fTP @1.0 - TP modifies attack radius
  sets.precast.WS["Spinning Attack"] = set_combine(sets.precast.WS, { })

  -- Shell Crusher: 100% STR - Static fTP @1.0 - TP modifies -25% defense debuff duration - 180s / 360s / 540s 
  sets.precast.WS["Shell Crusher"] = 
  {
    ammo = "Hydrocera", -- 6 macc
    body = "Cohort Cloak", -- 100 macc (no head)
    hands= gear.blueglenn.mummu.hands, -- 43 macc
    legs = gear.blueglenn.nyame.legs, -- 40 macc
    feet = gear.blueglenn.mummu.feet, -- 42 macc
    neck = "Sanctity Necklace", -- 10 macc
    ear1 = "Hermetic Earring", -- 7 macc
    ear2 = "Enchntr. Earring", -- 6 macc
    ring1= "Stikini Ring", -- 8 macc
    ring2= "Stikini Ring +1", -- 11 macc
    waist= "Eschan Stone", -- 7 macc
  } -- 280 macc
end

---------------------------------
-- built-in gearswap functions
---------------------------------
function job_buff_change(buff, gain) 
  -- Is triggered every time you either recieve a buff, or one wears off
  -- buff is the name of the buff, and gain is true if you are getting the buff, and false if the buff is wearing off
  handleBuffGear(buff, gain)
end 

function job_update(cmdParams, eventArgs)
  
end

function job_precast(spell, action, spellMap, eventArgs)
  if spell.english:lower() == "victory smite" and buffactive["Impetus"] then
    equip({ back = gear.blueglenn.mnk.capes.str_da })
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

function increment_impetus_counter(by)
  if info.impetus_hit_count < 50 then -- impetus can't benefit from more than 50 consecutive hits
    local old_count = info.impetus_hit_count
    local old_milestone = tostring(old_count):sub(1,1) -- converts count into string and grabs first char - this gives us the decade

    info.impetus_hit_count = info.impetus_hit_count + by

    local new_count = info.impetus_hit_count
    local new_milestone = tostring(new_count):sub(1,1)

    -- report every 10
    if new_milestone ~= old_milestone and new_count > 9 then -- new_count > 9 so we don't report 1-9
      chat('Impetus hit counter: ' .. tostring(new_count))
    end

  end
end

function reset_impetus_counter()
  local count_before_reset = info.impetus_hit_count
  if count_before_reset > 0 then
    info.impetus_hit_count = 0
    chat('Impetus hit counter reset to 0')
  end
end

function on_action_for_impetus(action)
  -- function taken from here: https://github.com/Kinematics/GearSwap-Jobs/blob/master/MNK.lua with some very minor tweaks for readability
  -- Keep track of the current hit count while Impetus is up.
  if state.Buff.Impetus then
    -- count melee hits by player
    if action.actor_id == player.id then -- if the action was taken by the player
      if action.category == 1 then -- 1 is autoattack
        for _,target in pairs(action.targets) do
          for _,action in pairs(target.actions) do
            -- Reactions (bitset):
            -- 1 = evade
            -- 2 = parry
            -- 4 = block/guard
            -- 8 = hit
            -- 16 = JA/weaponskill?
            -- If action.reaction has bits 1 or 2 set, it missed or was parried. Reset count.
            if (action.reaction % 4) > 0 then
              reset_impetus_counter()
            else
              increment_impetus_counter(1)
            end
          end
        end
      elseif action.category == 3 then -- 3 is weapon skill
        -- Missed weaponskill hits will reset the counter.  Can we tell?
        -- Reaction always seems to be 24 (what does this value mean? 8=hit, 16=?)
        -- Can't tell if any hits were missed, so have to assume all hit.
        -- Increment by the minimum number of weaponskill hits: 2.
        for _,target in pairs(action.targets) do
          for _,action in pairs(target.actions) do
            -- This will only be if the entire weaponskill missed or was parried.
            if (action.reaction % 4) > 0 then
              reset_impetus_counter()
            else
              increment_impetus_counter(2)
            end
          end
        end
      end
    elseif action.actor_id ~= player.id and action.category == 1 then -- if the action was taken by a mob
      -- If mob hits the player, check for counters.
      for _,target in pairs(action.targets) do
        if target.id == player.id then
          for _,action in pairs(target.actions) do
            -- Spike effect animation:
            -- 63 = counter
            -- 592 = missed counter
            if action.has_spike_effect then
              if action.spike_effect_message == 592 then -- counter was missed
                reset_impetus_counter()
              elseif action.spike_effect_animation == 63 then -- counter landed
                increment_impetus_counter(1)
              end
            end
          end
        end
      end
    end

   else
    reset_impetus_counter()
  end
  
end