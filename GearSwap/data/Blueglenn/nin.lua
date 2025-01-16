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
set_lockstyle(14)

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
set_macros(1, 17)

---------------------------------
-- globals
---------------------------------
res = require('resources')
latency = 0.7 -- adjust this as necessary
spell_latency = (latency * 60) + 18 -- these figures are from the gs library

---------------------------------
-- dislpay globals
---------------------------------
displaySettings = 
{ 
  pos = 
  {
    x = 0,
    y = 0
    --x = 810,
    --y = 1065
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
  info.shadowCount = '0'
  info.isMigawariUp = false
end

---------------------------------
-- user setup
---------------------------------
function user_setup() 
  state.IdleMode:options('Normal')
  send_command('bind ^i gs c cycle IdleMode')

  state.OffenseMode:options('Normal', 'March', 'Haste', 'Haste & March')
  send_command('bind ^o gs c cycle OffenseMode')

  state.CastingMode:options('Normal', 'Burst')
  send_command('bind ^c gs c cycle CastingMode')

  state.AutoShadowMode = M(false, 'Auto Shadow Mode')
  send_command('bind ^s gs c cycle AutoShadowMode')

  drawDisplay()

  windower.register_event('remove item', drawDisplay)
  windower.register_event('add item', drawDisplay)

  ---------------------------------
  -- jse setup
  ---------------------------------
  gear.globals.nin = 
  {
    capes = 
    { 
      tp = { name="Andartia's Mantle", augments={'DEX+20','Accuracy+20 Attack+20','"Dbl.Atk."+10',}}, -- DEX + 20, ACC./ATT. + 30, DA + 10
      wsd = { name="Andartia's Mantle", augments={'STR+20','Accuracy+18 Attack+18','Weapon skill damage +10%',}}, -- DEX + 30, ACC./ATT. + 20, WSD + 10
      fc = { }, -- HP + 60, FC + 10, EVA./MEVA. + 20, MEVA. + 10, MEVA. + 15
      mab = { }, -- INT + 20, MAB + 10, MACC./MDMG + 20, MACC. + 10
    },

    neck = "Ninja Nodowa +2",

    artifact = 
    {  
      head  = "Hachiya Hatsu. +3",
      body  = "Hachi. Chain. +1",
      hands = "Hachiya Tekko +1",
      legs  = "Hachi. Hakama +1",
      feet  = "Hachi. Kyahan +1" 
    },

    relic = 
    {     
      head  = "Mochi. Hatsuburi +3",
      body  = "Mochi. Chainmail +1",
      hands = "Mochizuki Tekko +1",
      legs  = "Mochi. Hakama +3",
      feet  = "Mochizuki Kyahan +1" 
    },

    empyrean = 
    {  
      head = "Hattori Zukin +1",
      body = "Hattori Ningi +1",
      hands= "Hattori Tekko +1",
      legs = "Hattori Hakama +1",
      feet = "Hattori Kyahan +1",
    },
  }
end

---------------------------------
-- user unload
---------------------------------
function user_unload()
  -- unload keybinds
  send_command('unbind ^i') -- unbinds IdleMode from i key
  send_command('unbind ^o') -- unbinds EngagedMode from o key
  send_command('unbind ^c') -- unbinds CastingMode from c key
  send_command('unbind ^s') -- unbinds Auto Shadow Mode from s key
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
    -- waist
    -- back

  ---------------------------------
  -- idle
  ---------------------------------
  sets.idle = { 
    --ammo  = "Staunch Tathlum",
    head  = gear.globals.rao.head, -- regen +3
    body  = gear.globals.hizamaru.body, -- regen +12
    hands = gear.globals.rao.hands, -- regen +2
    legs  = gear.globals.nyame.legs,
    feet  = gear.globals.nin.artifact.feet,
    neck  = "Bathy Choker +1", -- regen +3
    ear1  = "Etiolation Earring",
    ear2  = "Infused Earring", -- regen +1
    ring1 = "Shneddick Ring",
    ring2 = "Defending ring",
    back  = "Moonbeam Cape",
    waist = "Flume Belt", 
  }

  ---------------------------------
  -- Melee
  ---------------------------------
  --0% haste from magic - ~39DW in gear needed to reach cap 
  sets.engaged = {                                    -- | haste - DW - TA - STP |
    ammo = "Happo Shuriken +1", -- swap: Seki Shuriken
    head = gear.globals.ryuo.head,                  -- |  7 -  9 -  0 -  7 |
    body = gear.globals.adhemar.body,               -- |  4 -  6 -  4 -  0 |
    hands= gear.globals.adhemar.hands,              -- |  5 -  0 -  4 -  7 |
    legs = "Samnuha Tights",                          -- |  6 -  0 -  3 -  7 |
    feet = gear.globals.hizamaru.feet,              -- |  3 -  8 -  0 -  0 |
    neck = gear.globals.nin.neck,                   -- |  0 -  0 -  0 -  7 |
    ear1 = "Eabani Earring",                          -- |  0 -  4 -  0 -  0 |
    ear2 = "Suppanomimi",                             -- |  0 -  5 -  0 -  0 |
    ring1= "Hetairoi Ring",                           -- |  0 -  0 -  2 -  0 |
    ring2= "Epona's Ring",                            -- |  0 -  0 -  3 -  0 |
    waist= "Reiki Yotai",                             -- |  0 -  7 -  0 -  0 |
    back = gear.globals.nin.capes.tp
  }                                                   -- | 25 - 39 - 16 - 28 |

  --15% haste from marches - ~32DW in gear needed to reach cap
  sets.engaged.March = set_combine( 
    sets.engaged, {
      feet = gear.globals.herculean.feet.ta_att,
    }
  )
  
  --30% haste from haste II - ~21DW in gear needed to reach cap
  sets.engaged.Haste = set_combine(  
    sets.engaged.March, {
      ear1 = "Brutal Earring",
      ear2 = "Telos Earring"
    }
  )

  --assuming magic haste cap - ~1DW in gear needed to reach cap
  sets.engaged['Haste & March'] = set_combine( 
    sets.engaged.Haste, {
      body = gear.globals.kendatsuba.body,
      ear1 = "Dedition Earring",
      ring1= "Gere Ring",
      waist= "Windbuffet Belt +1"
    }
  )

  ---------------------------------
  -- Job Abilities
  ---------------------------------
  sets.precast.JA['Innin'] = { head = gear.globals.nin.empyrean.head }
	
  ---------------------------------
  -- Buff Locks
  ---------------------------------
	sets.buff.Innin  = { head = gear.globals.nin.empyrean.head }
  sets.buff.Migawari = { body = gear.globals.nin.empyrean.body }
  sets.buff.Futae = { hands = gear.globals.nin.empyrean.hands }
  sets.buff.Yonin = { legs = gear.globals.nin.empyrean.legs }

  ---------------------------------
  -- Weapon Skills
  ---------------------------------
  -- physical WS
  sets.precast.WS = 
  {
    head = gear.globals.mpaca.head,
    legs = gear.globals.nin.relic.legs,
    ear2 = gear.globals.moonshade,
    neck = "Fotia Gorget",
    waist= "Fotia Belt",
    back = gear.globals.nin.capes.wsd
  }

  sets.precast.WS['Blade: Shun'] = set_combine(sets.precast.WS, {
    body = gear.globals.kendatsuba.body,
    hands= gear.globals.adhemar.hands,
    feet = gear.globals.kendatsuba.feet,
    ear1 = "Brutal Earring",
    ring1= "Ilabrat Ring",
    ring2= "Apate Ring"
  })

  sets.precast.WS['Blade: Hi'] = set_combine(sets.precast.WS, {
    head = gear.globals.mummu.head,
    body = gear.globals.mummu.body,
    hands= gear.globals.mummu.hands,
    legs = gear.globals.mummu.legs,
    feet = gear.globals.mummu.feet,
    ear1 = "Brutal Earring",
    ring1= "Ilabrat Ring",
    ring2= "Apate Ring"
  })

  -- magical WS
  sets.precast.WS['Magic'] = {
    head = gear.globals.nin.relic.head,
    body = gear.globals.nyame.body,
    hands= gear.globals.nyame.hands,
    legs = gear.globals.nyame.legs,
    feet = gear.globals.nyame.feet,
    neck = "Sanctity Necklace",
    ear1 = "Novio Earring",
    ear2 = "Friomisi Earring",
    waist= "Eschan Stone",
    back = gear.globals.nin.capes.mab
  }

  sets.precast.WS['Blade: Ei'] = set_combine(sets.precast.WS.Magic, {

  })

  sets.precast.WS['Aeolian Edge'] = set_combine(sets.precast.WS.Magic, {

  })


  -- hybrid WS

  ---------------------------------
  -- Spells
  ---------------------------------
  -- precast
  sets.precast.FC = {
    head = gear.globals.herculean.head.fc,
    body = gear.globals.nin.relic.body,
    hands= "Leyline Gloves",
    legs = gear.globals.herculean.legs.fc,
    feet = gear.globals.herculean.feet.fc,
    ear1 = "Enchntr. Earring +1",
    ear2 = "Loquac. Earring",
    ring1= "Rahab Ring",
    ring2= "Kishar Ring",
    back = gear.globals.nin.capes.tp -- swap to fc when you make it
  }

  -- midcast (genearal for enfeebles)
  sets.midcast = { }
  sets.midcast.Ninjutsu = {
    head = gear.globals.nin.artifact.head,
    feet = gear.globals.nin.artifact.feet,
    ear1 = "Digni. Earring",
    ring1= "Stikini Ring",
    ring2= "Stikini Ring +1",
    waist= "Eschan Stone",
    back = gear.globals.nin.capes.tp -- swap to macc/mab when you make it
  }
  -- elemental
  sets.midcast.Ele = set_combine(sets.midcast.Ninjutsu, {
    head = gear.globals.nin.relic.head,
    feet = gear.globals.nin.relic.feet,
    ear1 = "Friomisi Earring",
    ring1= "Shiva Ring +1",
    waist= "Skrymir Cord +1"
  })
  -- katon
  sets.midcast["Katon: Ichi"] = sets.midcast.Ele
  sets.midcast["Katon: Ni"] = sets.midcast["Katon: Ichi"]
  sets.midcast["Katon: San"] = sets.midcast["Katon: Ichi"]
  -- suiton
  sets.midcast["Suiton: Ichi"] = sets.midcast.Ele
  sets.midcast["Suiton: Ni"] = sets.midcast["Suiton: Ichi"]
  sets.midcast["Suiton: San"] = sets.midcast["Suiton: Ichi"]
  -- doton
  sets.midcast["Doton: Ichi"] = sets.midcast.Ele
  sets.midcast["Doton: Ni"] = sets.midcast["Doton: Ichi"]
  sets.midcast["Doton: San"] = sets.midcast["Doton: Ichi"]
  -- hyoton
  sets.midcast["Hyoton: Ichi"] = sets.midcast.Ele
  sets.midcast["Hyoton: Ni"] = sets.midcast["Hyoton: Ichi"]
  sets.midcast["Hyoton: San"] = sets.midcast["Hyoton: Ichi"]
  -- huton
  sets.midcast["Huton: Ichi"] = sets.midcast.Ele
  sets.midcast["Huton: Ni"] = sets.midcast["Huton: Ichi"]
  sets.midcast["Huton: San"] = sets.midcast["Huton: Ichi"]
  -- raiton
  sets.midcast["Raiton: Ichi"] = sets.midcast.Ele
  sets.midcast["Raiton: Ni"] = sets.midcast["Raiton: Ichi"]
  sets.midcast["Raiton: San"] = sets.midcast["Raiton: Ichi"]
  -- buffs
  sets.midcast["Utsusemi: Ichi"] = set_combine(sets.midcast.Ninjutsu, 
  { 
    neck = "Moonlight Necklace",
    feet = gear.globals.nin.empyrean.feet,
    back = gear.globals.nin.capes.tp
  })
  sets.midcast["Utsusemi: Ni"] = sets.midcast["Utsusemi: Ichi"]
  sets.midcast["Utsusemi: San"] = sets.midcast["Utsusemi: Ichi"]
end

---------------------------------
-- display stuff
---------------------------------
function drawDisplay()
  local INDENT = ' ':rep(3)
  local displayLines = L{}

  -- Modes
  displayLines:append('[I]dle: '..state.IdleMode.value)
  displayLines:append('[O]ffense: '..state.OffenseMode.value)
  displayLines:append('[C]asting: '..state.CastingMode.value)
  displayLines:append('Auto Ut[s]u.: '..tostring(state.AutoShadowMode.value))

  displayLines:append(' - ')
  -- Buffs
  displayLines:append('Shadows: '..info.shadowCount)
  displayLines:append('Migawari: '..ternary(info.isMigawariUp, 'Up', 'Down'))

  displayLines:append(' - ')
  -- Tools -- tool (bag)
  displayLines:append('Shika: '..get_item_quantity(2972)..'('..get_item_quantity(5868)..')') -- shikanofuda
  displayLines:append('Ino: '..get_item_quantity(2971)..'('..get_item_quantity(5867)..')') -- inoshishinofuda
  displayLines:append('Cho: '..get_item_quantity(2973)..'('..get_item_quantity(5869)..')') -- chonofuda

  --displayBox:text(displayLines:concat('\\cr\n'))
  displayBox:text(displayLines:concat(' | '))
  displayBox:show()
end

---------------------------------
-- built-in gearswap functions
---------------------------------
function job_buff_change(buff, gain) 
  handleBuffGear(buff, gain)
  updateShadowCounter(buff, gain)
  updateMigawariFlag(buff, gain)
  --if not gain and buff:contains("Copy Image") and get_current_shadows() == 0 then
    --recast_shadows()
  --end
  --if buff:contains("Haste") or buff:contains("March") then
    --check_engaged_buff_state()
  --end
  drawDisplay()
end 

function job_status_change(new, old)
  --check_engaged_buff_state()
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

function updateShadowCounter(buffName, gain)
  if buffName:contains("Copy Image") then
    local shadows = get_current_shadows()
    info.shadowCount = ternary(shadows == 4, '4+', tostring(shadows))
  end
end

function updateMigawariFlag(buffName, gain)
  if buffName:contains("Migawari") then 
    info.isMigawariUp = gain
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

function get_item_quantity(item_id) -- res/items.lua
  local player = windower.ffxi.get_player()
  -- we're just gonna search inventory (1) and case (7) --res/bags.lua
  local bags_to_check = {0, 7}

  local count = 0
  for _,bag in pairs(bags_to_check) do 
    local items = windower.ffxi.get_items(bag)
    if (items == nil) then return '?' end
    for _,item in pairs(items) do
      if (type(item) == 'table' and item['id'] == item_id) then
        count = count + item['count']
      end
    end
  end

  return tostring(count)
end

function check_engaged_buff_state(engaged)
  local player = windower.ffxi.get_player()
  if player.status ~= 1 then return end -- a status of 1 is engaged in combat
  
  local haste = false
  local march = false

  for _,buff in pairs(player.buffs) do
    if buff == 33  then haste = true end -- these ids are taken from ~/FFXI_Windower/res/buffs.lua
    if buff == 214 then march = true end
  end

  local set_to_equip =  ternary(haste and march, "Haste & March",
                        ternary(haste, "Haste", 
                        ternary(march, "March", nil)))

  if set_to_equip ~= nil then
    windower.chat.input("/console gs c set OffenseMode " .. set_to_equip)
    --state.OffenseMode.value = set_to_equip
    --equip(sets[set_to_equip])
    return
  end
  windower.chat.input("/console gs c set OffenseMode Normal")
  --state.OffenseMode.value = 'Normal'
end

function ternary(cond, t, f)
  if cond then return t else return f end
end

function get_current_shadows()
	if buffactive["Copy Image (4+)"] then return 4 end
	if buffactive["Copy Image (3)"]  then return 3 end
	if buffactive["Copy Image (2)"]  then return 2 end
	if buffactive["Copy Image"]      then return 1 end
  return 0
end

function check_shadows()
  if get_current_shadows() > 0 then return end

  add_to_chat(123, 'Could not put up shadows, trying again...')
  recast_shadows()
end

function player_has_ninja_tool()
  if player.inventory["Shihei"] ~= nil or player.inventory["Shikanofuda"] ~= nil then
    return true
  end
  return false
end

function recast_shadows()
  if not state.AutoShadowMode.value or areas.Cities:contains(world.area) then return end -- prevents from casting in towns
  
  if player.main_job == 'NIN' or player.sub_job == 'NIN' then
    
    if not player_has_ninja_tool() then 
      add_to_chat(123, 'Shihei or Shikanofuda not found.  Stopping auto shadow attempts.')
      return
    end

    local spell_recasts = windower.ffxi.get_spell_recasts()
    
    -- Utsusemi: San
    local player_has_san = player.main_job == 'NIN' and player.job_points[(res.jobs[player.main_job_id].ens):lower()].jp_spent > 99
    local san_recast = spell_recasts[340]
    local recast_san = player_has_san and san_recast < spell_latency

    if recast_san then
      cast_spell(340)
      return
    end

    -- Utsusemi: Ni
    local ni_recast = spell_recasts[339]
    local recast_ni = ni_recast < spell_latency

    if recast_ni then
      cast_spell(339)
      return
    end

    -- Utsusemi: Ichi
    local ichi_recast = spell_recasts[338]
    local recast_ichi = ichi_recast < spell_latency

    if recast_ichi then
      cast_spell(338)
      return
    end

    -- they're all on cooldown, reschedule with the shortest cooldown
    local recast = math.min(unpack({san_recast, ni_recast, ichi_recast}))/60 -- dividing by 60 because recast times are given in milliseconds
    check_shadows:schedule(recast * 1.1 + 2)
  end
end

function cast_spell(spell_id)
  add_to_chat(123, spell_id)
  local spell = res.spells[spell_id]
  if spell == nil then return end

  local spell_recasts = windower.ffxi.get_spell_recasts()

  windower.chat.input('/ma "' .. spell.english .. '" <me>')

  check_shadows:schedule(spell.cast_time * 1.1 + 2)
end
