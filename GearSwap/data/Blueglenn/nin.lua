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
-- globals
---------------------------------
res = require('resources')
latency = 0.7 -- adjust this as necessary
spell_latency = (latency * 60) + 18 -- these figures are from the gs library

---------------------------------
-- job setup
---------------------------------
function job_setup()

end

---------------------------------
-- user setup
---------------------------------
function user_setup() 
  state.OffenseMode:options('Normal', 'March', 'Haste', 'HasteAndMarch')
  send_command('bind ^o gs c cycle OffenseMode')

  state.AutoShadowMode = M(false, 'Auto Shadow Mode')
  send_command('bind ^s gs c cycle AutoShadowMode')

  ---------------------------------
  -- jse setup
  ---------------------------------
  gear.blueglenn.nin = 
  {
    capes = 
    { 
      fast_cast = { },
    },

    neck = "",

    artifact = 
    {  
      head  = "",
      body  = "",
      hands = "",
      legs  = "",
      feet  = "" 
    },

    relic = 
    {     
      head  = "",
      body  = "",
      hands = "",
      legs  = "",
      feet  = "" 
    },

    empyrean = 
    {  
      head  = "",
      body  = "",
      hands = "",
      legs  = "",
      feet  = "" 
    },
  }
end

---------------------------------
-- user unload
---------------------------------
function user_unload()
  -- unload keybinds
  send_command('unbind ^o')
  send_command('unbind ^s')
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
  sets.idle = { head = gear.blueglenn.adhemar.head }

  ---------------------------------
  -- Melee
  ---------------------------------
  --0% haste from magic - ~39DW in gear needed to reach cap 
  sets.engaged = {                                    -- | haste - DW - TA - STP |
    ammo = "Date Shuriken", -- swap: Seki Shuriken
    head = gear.blueglenn.ryuo.head,                  -- |  7 -  9 -  0 -  7 |
    body = gear.blueglenn.adhemar.body,               -- |  4 -  6 -  4 -  0 |
    hands= gear.blueglenn.adhemar.hands,              -- |  5 -  0 -  4 -  7 |
    legs = gear.blueglenn.nin.relic.legs,             -- |  6 - 10 -  0 -  0 |
    feet = gear.blueglenn.hizamaru.feet,              -- |  3 -  8 -  0 -  0 |
    neck = gear.blueglenn.nin.neck,                   -- |  0 -  0 -  0 -  7 |
    ear1 = "Eabani Earring",                          -- |  4 -  0 -  0 -  0 |
    ear2 = "Telos Earring", -- swap: Suppanomimi      -- |  0 -  0 -  0 -  5 |
    ring1= "Hetairoi Ring",                           -- |  0 -  0 -  2 -  0 |
    ring2= "Epona's Ring",                            -- |  0 -  0 -  3 -  0 |
    waist= "Windbuffet Belt", -- swap: Shetal Stone   -- |  0 -  6 -  0 -  0 | -- stretch goal swap: reiki yotai
    back = gear.blueglenn.nin.capes.dex_acc_att_da
  }                                                   -- | 29 - 39 - 13 - 26 |

  sets.engaged.March = set_combine( --15% haste from marches - ~32DW in gear needed to reach cap
    sets.engaged, {

    }
  )
  
  sets.engaged.Haste = set_combine(  --30% haste from haste II - ~21DW in gear needed to reach cap
    sets.engaged, {

    }
  )

  sets.engaged.HasteAndMarch = set_combine( --assuming magic haste cap - ~1DW in gear needed to reach cap
    sets.engaged, {

    }
  )

  ---------------------------------
  -- Job Abilities
  ---------------------------------

  ---------------------------------
  -- Weapon Skills
  ---------------------------------

end

---------------------------------
-- built-in gearswap functions
---------------------------------
function job_buff_change(buff, gain) 
  if not gain and buff:contains("Copy Image") and get_current_shadows() == 0 then
    recast_shadows()
  end
  if buff:contains("Haste") or buff:contains("March") then
    check_engaged_buff_state()
  end
end 

function job_status_change(new, old)
  check_engaged_buff_state()
end

---------------------------------
-- user defined functions 
---------------------------------
function check_engaged_buff_state(engaged)
  local player = windower.ffxi.get_player()
  if player.status ~= 1 then return end -- a status of 1 is engaged in combat
  
  local haste = false
  local march = false

  for _,buff in pairs(player.buffs) do
    if buff == 33  then haste = true end -- these ids are taken from ~/FFXI_Windower/res/buffs.lua
    if buff == 214 then march = true end
  end

  local set_to_equip =  ternary(haste and march, "HasteAndMarch",
                        ternary(haste, "Haste", 
                        ternary(march, "March", nil)))

  if set_to_equip ~= nil then
    windoer.chat.input("/console gs c set OffenseMode " .. set_to_equip)
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
      cast_shadow(340)
      return
    end

    -- Utsusemi: Ni
    local ni_recast = spell_recasts[339]
    local recast_ni = ni_recast < spell_latency

    if recast_ni then
      cast_shadow(339)
      return
    end

    -- Utsusemi: Ichi
    local ichi_recast = spell_recasts[338]
    local recast_ichi = ichi_recast < spell_latency

    if recast_ichi then
      cast_shadow(338)
      return
    end

    -- they're all on cooldown, reschedule with the shortest cooldown
    local recast = math.min(unpack({san_recast, ni_recast, ichi_recast}))/60 -- dividing by 60 because recast times are given in milliseconds
    check_shadows:schedule(recast * 1.1 + 2)
  end
end

function cast_shadow(spell_id)
  add_to_chat(123, spell_id)
  local spell = res.spells[spell_id]
  if spell == nil then return end

  local spell_recasts = windower.ffxi.get_spell_recasts()

  windower.chat.input('/ma "' .. spell.english .. '" <me>')

  check_shadows:schedule(spell.cast_time * 1.1 + 2)
end
