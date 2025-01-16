---------------------------------
-- requireds
---------------------------------
queue = require('queues')
require('coroutine')

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
set_lockstyle(20)

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
set_macros(1, 12)

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
-- job setup
---------------------------------
function job_setup()
  maneuverTable = loadManeuverTable()
  windower.register_event('status change', handleStatusChange)
end

---------------------------------
-- user setup
---------------------------------
function user_setup() 
  state.IdleMode:options('Normal', 'Overdrive')
  send_command('bind ^i gs c cycle IdleMode')

  state.OffenseMode:options('Normal', 'MasterTP', 'AutoTp', 'SubtleBlow')
  send_command('bind ^o gs c cycle OffenseMode')

  state.FightMode = M{ 'Manual', 'Auto' }
  send_command('bind ^f gs c cycle FightMode')

  state.ManeuverMode = M{ 'Manual', 'Auto' }
  send_command('bind ^m gs c cycle ManeuverMode')

  drawDisplay()

  ---------------------------------
  -- jse setup
  ---------------------------------
  gear.globals.pup = 
  {
    capes = 
    { 
      full_pet_stats = { name="Visucius's Mantle", augments={'Pet: Acc.+20 Pet: R.Acc.+20 Pet: Atk.+20 Pet: R.Atk.+20','Eva.+20 /Mag. Eva.+20','Pet: Accuracy+10 Pet: Rng. Acc.+10','Pet: Haste+10','Pet: Magic dmg. taken-10%',}},
    },
    
    neck = "Puppetmaster's collar +1",

    artifact = 
    {  
      head  = "Foire Taj +1",
      body  = "Foire Tobe +1",
      hands = "Foire Dastanas +1",
      legs  = "Foire Churidars +2",
      feet  = "Foire Babouches +1" 
    },

    relic = 
    {     
      head  = "Pitre Taj +3",
      body  = "Pitre Tobe +3",
      hands = "Pitre Dastanas +1",
      legs  = "Pitre Churidars +1",
      feet  = "Pitre Babouches +1" 
    },

    empyrean = 
    {  
      head  = "Karagoz Capello +1",
      body  = "Karagoz Farsetto +1",
      hands = "Karagoz Guanti +1",
      legs  = "Karagoz Pantaloni +1",
      feet  = "Karagoz Scarpe +1" 
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

  coroutine.close()
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
    --main  = "Godhands",
    range = "Animator P +1",
    ammo  = "Automat. Oil +3",
    head  = gear.globals.rao.head,
    body  = gear.globals.hizamaru.body,
    hands = gear.globals.rao.hands,
    legs  = gear.globals.nyame.legs,
    feet  = "Hermes' Sandals",
    neck  = "Bathy Choker +1",
    waist = "Moonbow Belt +1",
    ear1  = "Infused Earring",
    ear2  = "Etiolation Earring",
    ring1 = "Defending Ring",
    ring2 = "Shneddick Ring",
    back  = "Moonbeam Cape", 
  }

  sets.idle.Overdrive = {
    main = "Xiucoatl",
    head = "Anwig Salade",
    body  = gear.globals.taeon.body.pet,
    hands = gear.globals.taeon.hands.pet,
    legs  = gear.globals.taeon.legs.pet,
    feet  = gear.globals.taeon.feet.pet,
    neck  = "Shulmanu Collar",
    waist = "Klouskap Sash +1",
    ring1 = {name="Varar Ring +1",bag="Wardrobe 7"},
    ring2 = {name="Varar Ring +1",bag="Wardrobe 8"},
    ear1  = "Crep. Earring", -- rimeice when you get it from shiva
    ear2  = "Enmerkar Earring",
    back  = gear.globals.pup.capes.full_pet_stats,
  }
  ---------------------------------
  -- melee
  ---------------------------------
  sets.engaged =  -- focus on dual TP
  {
    range = "Animator P +1",
    ammo  = "Automat. Oil +3",
    head = gear.globals.mpaca.head, -- todo: su3 head
    body = gear.globals.taliah.body,
    hands= gear.globals.mpaca.hands,
    legs = gear.globals.mpaca.legs, -- todo: su3 legs
    feet = gear.globals.herculean.ta_att,
    neck = "Shulmanu Collar",
    waist= "Moonbow Belt +1",
    ear1 = "Telos Earring",
    ear2 = "Crep. Earring",
    ring1= "Epona's Ring", -- todo: Niqmaddu ring
    ring2= "Gere Ring",
    back = "Visucius's Mantle"
    --back = "str/acc/atk/da", 
  }
  sets.engaged.MasterTP =
    set_combine(sets.engaged, 
    {
      --head = , -- todo: malignance head
      legs = gear.globals.ryuo.legs,
      ear1 = "Mache Earring +1",
      ear2 = "Cessance Earring",
      --back = "str/acc/atk/da", 
    }
  )
  -- focus on auto TP
  sets.engaged.AutoTp = 
    set_combine(sets.engaged, 
      {
        main = "Ohtas", -- todo
        --head = gear.globals.taeon.head.pet_acc_da_dt, -- todo
        body = gear.globals.pup.relic.body,
        --hands= gear.globals.taeon.hands.pet_acc_da_dt, -- todo
        --legs = gear.globals.taeon.legs.pet_acc_da_dt, -- todo
        --feet = gear.globals.taeon.feet.pet_acc_da_dt, -- todo
        waist= "Klouskap Sash +1", -- todo
        ear1 = "Enmerkar Earring",
        ear2 = "Domes. Earring",
        ring1= "Varar Ring +1",  -- todo
        ring2= "C. Palug Ring",  -- todo
        --back = "acc/att/pet:acc/r.acc/att/r.att/haste",  -- todo
      }
    )
  -- focus on capping SB
  sets.engaged.SubtleBlow = 
    set_combine(sets.engaged, 
      {
        main = "Xiucoatl",
        legs = gear.globals.mpaca.legs,
        neck = "Bathy Choker +1",
        ring1= "Chirich Ring +1",
      }
    )

  ---------------------------------
  -- job abilities
  ---------------------------------
  sets.precast.JA.Maneuver = 
  {
    body = gear.globals.pup.empyrean.body
  }

  ---------------------------------
  -- weapon skill sets
  ---------------------------------
  sets.precast.WS = 
  {
    head = gear.globals.mpaca.head,
    feet = gear.globals.herculean.feet.ta_att,
    neck = "Fotia Gorget",
    waist= "Fotia Belt",
    ear1 = "Cessance Earring",
    ear2 = gear.globals.moonshade,
    ring1= "Niqmaddu Ring", -- todo
    ring2= "Gere Ring",
    --back = gear.globals.pup.capes.wsd -- todo
  }
  -- Stringing Pummel - Physical - 32% STR / 32% VIT - 6x attack - Static fTP @ 1.0 - TP modifies crit chance: 15% / 30% / 45%
  sets.precast.WS['Stringing Pummel'] = 
    set_combine(sets.precast.WS,
      {
        head = "Blistering Sallet +1", -- todo -- gotta augment to get 10% crit chance
        body = "He. Harness +1", -- todo: su3
        hands= gear.globals.ryuo.hands,
        legs = gear.globals.hizamaru.legs,
      }
    )
  -- Victory Smite: 80% STR - Static fTP @ 1.5 - TP modifies critical hit rate - +10% / +25% / +45%
  sets.precast.WS['Victory Smite'] = 
    set_combine(sets.precast.WS['Stringing Pummel'],
      {
        belt = "Moonbow Belt",
      }
    )
  -- Shijin Spiral: 85% DEX - Static fTP @ 1.5 - TP modifies Plague (-50TP/tick @5-8 ticks) effect accuracy
  sets.precast.WS['Shijin Spiral'] = 
    set_combine(sets.precast.WS,
      {
        body = gear.globals.taliah.body,
        ear1 = "Mache Earring +1",
        --back = "dex/acc/atk/da", -- todo
      }
    )
  -- Asuran Fists: 15% STR / 15% VIT - 8x attack - Static fTP @ 1.25 - TP modifies accuracy but bg-wiki doesn't know the parameters
  sets.precast.WS['Asuran Fists'] = 
    set_combine(sets.precast.WS, 
      {
        head = gear.globals.pup.relic.head,
        body = gear.globals.pup.relic.body,
        hands= gear.globals.pup.relic.hands,
        legs = gear.globals.pup.relic.legs,
        feet = gear.globals.pup.relic.feet,
        ear1 = "Telos Earring",
      }
    )
  -- Howling Fist: 50% VIT / 20% STR - 2x attack - Dynamic fTP: 2.05 / 3.58 / 5.8
  sets.precast.WS['Howling Fist'] = 
    set_combine(sets.precast.WS,
      {
        body = gear.globals.taliah.body,
        neck = gear.globals.pup.neck,
        waist= "Moonbow Belt +1",
        --back = "str/acc/atk/da", -- todo
      }
    )
  -- Raging Fists: 30% STR / 30% DEX - 5x attack - Dynamic fTP: 1.0 / 2.19 / 3.75
  sets.precast.WS['Raging Fists'] = sets.precast.WS['Howling Fist']
end

---------------------------------
-- gearswap hooks
---------------------------------
function job_buff_change(buff, gain) 
  -- Is triggered every time you either recieve a buff, or one wears off
  -- buff is the name of the buff, and gain is true if you are getting the buff, and false if the buff is wearing off
  handleBuffGear(buff, gain)
  local maneuver = getManeuverByName(buff)
  if not gain and maneuver ~= nil and state.ManeuverMode.value == 'Auto' and isPupActive() then
    useManeuver(maneuver.name, 0)
  end

  drawDisplay()
end

function job_midcast(spell, action, spellMap, eventArgs)
  local spellName = spell.english:lower()
  -- Heady Artifice
  if (spellName == "heady artifice") then headyArtificeReminder() end
end

function job_aftercast(spell, action, spellMap, eventArgs) 
  if spell.interrupted and spell.name:contains('Maneuver') then 
    useManeuver(spell.name, 1)
  end
end

-- Called when a player gains or loses a pet.
-- pet == pet gained or lost
-- gain == true if the pet was gained, false if it was lost.
function job_pet_change(pet, gain)

end

-- Called by the 'update' self-command, for common needs.
-- Set eventArgs.handled to true if we don't want automatic equipping of gear.
function job_update(cmdParams, eventArgs)

end

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

  -- Modes
  displayLines:append('[I]dle: '..state.IdleMode.value..' | ')
  displayLines:append('[O]ffense: '..state.OffenseMode.value..' | ')
  displayLines:append('[F]ight Mode: '..state.FightMode.value..' | ')
  displayLines:append('[M]aneuver Mode: '..state.ManeuverMode.value)
  -- Auto Maneuvers
  if state.ManeuverMode.value == 'Auto' then
    displayLines:append(' - ')
    local activeManeuvers = getActiveManeuvers()
    for id, maneuver in pairs(activeManeuvers) do
      displayLines:append(' '..(maneuver.color)..(maneuver.slug))
    end
  end
  displayBox:text(displayLines:concat())
  displayBox:show()
end

---------------------------------
-- my functions
---------------------------------
function useManeuver(maneuverName, waitTime) 
  local waitCommand = ''
  if waitTime == nil or waitTime < 1 then
    waitCommand = 'wait '..waitTime..';'
  end
  send_command(waitCommand..'input /pet "'..maneuverName..'" <me>')
end

function isManeuverOnCooldown() 
  local maneuverRecastId = 210 -- taken from ~/res/ability_recasts.lua
  return get_recast_time(maneuverRecastId) > 0
end

function getManeuverById(maneuverId) 
  if maneuverTable[maneuverId] ~= nil then
    return maneuverTable[maneuverId]
  end
  return nil
end

function getManeuverByName(maneuverName) 
  for id,maneuver in pairs(maneuverTable) do
    if maneuver.name == maneuverName then return maneuver end
  end
  return nil
end

function getActiveManeuvers()
  local activeManeuvers = {}
  local player = windower.ffxi.get_player()
  for _,buffCode in pairs(player.buffs) do
    if maneuverTable[buffCode] ~= nil then
      table.insert(activeManeuvers, maneuverTable[buffCode])
    end
  end
  return activeManeuvers;
end

function isManeuverActive(identifier) -- identifier can be slug, name, or id 
  local activeManeuvers = getActiveManeuvers()
  local active = false
  for id,maneuver in pairs(maneuverTable) do
    active = identifier == id or identifier == maneuver.slug or identifier == maneuver.name
  end
  return active
end

function handleStatusChange(new_status_id, old_status_id)
  -- supported statuses: 0 - Idle; 1 - Combat; 33 - Resting; 2 - Dead; ? - Zoning

  -- if status is chaning to combat
  if (isPupActive() and new_status_id == 1 and state.FightMode.value == 'Auto') then 
    send_command('@input /pet "Deploy" <t>')
  end
end

function isPupActive()
  local pet = windower.ffxi.get_mob_by_target('pet')
  -- we gotta check a few flags to make sure this doesn't id a trust or Kyra's water spirit as our pet
  return (pet ~= nil and pet.valid_target and pet.charmed)
end

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

function get_recast_time(recast_id)
  local recast_timer = windower.ffxi.get_ability_recasts()[recast_id]
  if recast_timer == nil then return 0 end
  return recast_timer
end

function headyArtificeReminder()
  local petHead = pet.head
  local hArtificeDesc = 
    {
      ['harlequin head'] = 'phys. accuracy +2 -- M. Strikes',
      ['valoredge head'] = 'enmity +100 -- Invincible',
      ['sharpshot head'] = 'damage +3% -- Eagle Eye Shot',
      ['stormwalker head'] = 'magic damage +2% -- Chainspell',
      ['soulsoother head'] = 'refresh +1% -- Benediction',
      ['spiritreaver head'] = 'magic damage +5% -- Manafont',
    }
  windower.send_command('@input /echo -- '..petHead..' -- '..hArtificeDesc[petHead:lower()]..' --')
end

---------------------------------
-- data
---------------------------------
function loadManeuverTable()
  -- ~/res/buffs.lua
  return {
    [300] = {id=300, name="Fire Maneuver"   , slug="fire"   , color="\\cs(255,0,  0  )"},
    [301] = {id=301, name="Ice Maneuver"    , slug="ice"    , color="\\cs(0,  255,255)"},
    [302] = {id=302, name="Wind Maneuver"   , slug="wind"   , color="\\cs(0,  255,0  )"},
    [303] = {id=303, name="Earth Maneuver"  , slug="earth"  , color="\\cs(255,255,0  )"},
    [304] = {id=304, name="Thunder Maneuver", slug="thunder", color="\\cs(255,0,  255)"},
    [305] = {id=305, name="Water Maneuver"  , slug="water"  , color="\\cs(0,  128,255)"},
    [306] = {id=306, name="Light Maneuver"  , slug="light"  , color="\\cs(255,255,255)"},
    [307] = {id=307, name="Dark Maneuver"   , slug="dark"   , color="\\cs(128,128,128)"},
  }
end

-- mov = {counter=0}
-- if player and player.index and windower.ffxi.get_mob_by_index(player.index) then
--     mov.x = windower.ffxi.get_mob_by_index(player.index).x
--     mov.y = windower.ffxi.get_mob_by_index(player.index).y
--     mov.z = windower.ffxi.get_mob_by_index(player.index).z
-- end
-- moving = false
-- windower.raw_register_event('prerender',function()
--     mov.counter = mov.counter + 1;
--     if mov.counter>15 then
--         local pl = windower.ffxi.get_mob_by_index(player.index)
--         if pl and pl.x and mov.x then
--             local movement = math.sqrt( (pl.x-mov.x)^2 + (pl.y-mov.y)^2 + (pl.z-mov.z)^2 ) > 0.1
--             if movement and not moving then
--                 chat('moving')
--                 --send_command('gs c started to move!')
--                 moving = true
--             elseif not movement and moving then
--               chat('not moving')
--                 --send_command('gs c stopped moving!')
--                 moving = false
--             end
--         end
--         if pl and pl.x then
--             mov.x = pl.x
--             mov.y = pl.y
--             mov.z = pl.z
--         end
--         mov.counter = 0
--     end
-- end)