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
-- job setup
---------------------------------
function job_setup()

end

---------------------------------
-- user setup
---------------------------------
function user_setup() 

end

---------------------------------
-- user unload
---------------------------------
function user_unload()

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
  sets.idle = 
  { 

  }

  ---------------------------------
  -- Melee
  ---------------------------------
  sets.engaged = 
  {  

  }

  ---------------------------------
  -- Weapon Skills
  ---------------------------------
  -- Default
  sets.precast.WS = 
  {

  }

  ---------------------------------
  -- Spells
  ---------------------------------
  -- precast
  sets.precast.FC = 
  {

  }

  sets.midcast = 
  {

  }
