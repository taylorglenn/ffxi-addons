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
set_macros(1, 5)

---------------------------------
-- job setup
---------------------------------
function job_setup()
  
end

---------------------------------
-- user setup
---------------------------------
function user_setup() 
  state.OffenseMode:options('Normal', 'Acc')
  send_command('bind ^o gs c cycle OffenseMode')

  ---------------------------------
  -- jse setup
  ---------------------------------
  gear.globals.rng = {
    capes = { },
    
    neck = "",

    artifact = { feet = "Orion Socks +1" },

    relic = { },

    empyrean = { },
  }
end

---------------------------------
-- user unload
---------------------------------
function user_unload()
  -- unload keybinds
  send_command('unbind ^l') -- unbinds EngagedMode from l key
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
  sets.idle =       { legs = gear.globals.carmine.legs,
                      feet = gear.globals.rng.feet }
  ---------------------------------
  -- Melee
  ---------------------------------
  sets.engaged =    { }
  ---------------------------------
  -- Job Abilities
  ---------------------------------
  sets.precast.JA = { }
  ---------------------------------
  -- Weapon Skills
  ---------------------------------
  sets.precast.WS =   { }
  
end