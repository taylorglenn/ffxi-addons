--------------------------------------------------------------------------
-----------------------     includes      --------------------------------
--------------------------------------------------------------------------
function get_sets()
  -- Load and initialize the include file.
  mote_include_version = 2
  include('Mote-Include.lua')
  include('organizer-lib')
end

---------------------------------
-- macros 
---------------------------------
function set_macros(book, sheet)
  if book then
    send_command('@input /macro book ' .. tostring(book) .. ';wait .1;input /macro set ' .. tostring(sheet))
    return
  end
  send_command('@input / macro set ' .. tostring(sheet))
end
set_macros(1, 1)

---------------------------------
-- lockstyle 
---------------------------------
function set_lockstyle(page)
  send_command('@wait 6;input /lockstyleset ' .. tostring(page))
end
set_lockstyle(1)

--------------------------------------------------------------------------
-----------------------     job setup      -------------------------------
--------------------------------------------------------------------------
function job_setup()
  state.Buff['Afflatus Solace'] = buffactive['Afflatus Solace'] or false
  state.Buff['Afflatus Misery'] = buffactive['Afflatus Misery'] or false
  state.Buff['Sublimation: Activated'] = buffactive['Sublimation: Activated'] or false

  state.RegenMode = M{['description']='Regen Mode', 'Duration', 'Potency'}
end

--------------------------------------------------------------------------
----------------------     user setup      -------------------------------
--------------------------------------------------------------------------
function user_setup() 
  state.OffenseMode:options('Normal', 'Acc')
  state.CastingMode:options('Normal', 'Resistant')
  state.IdleMode:options('Normal', 'Refresh', 'DT', 'MEva')
  send_command('bind ^i gs c cycle IdleMode')

  state.BarElement = M{['description']='BarElement', 'Barfira', 'Barblizzara', 'Baraera', 'Barstonra', 'Barthundra', 'Barwatera'}
  state.BarStatus  = M{['description']='BarStatus', 'Baramnesra', 'Barvira', 'Barparalyzra', 'Barsilencera', 'Barpetra', 'Barpoisonra', 'Barblindra', 'Barsleepra'}
  state.BoostSpell = M{['description']='BoostSpell', 'Boost-STR', 'Boost-INT', 'Boost-AGI', 'Boost-VIT', 'Boost-DEX', 'Boost-MND', 'Boost-CHR'}

  state.WeaponLock = M(false, 'Weapon Lock')
  -- state.CP = M(false, "Capacity Points Mode")

  ---------------------------------
  -- jse setup
  ---------------------------------
  gear.bluefriend.whm = {
    capes = 
    { 
      fast_cast = { name="Alaunus's Cape", augments={'"Fast Cast"+10',}},
      cure      = { name="Alaunus's Cape", augments={'"Cure" potency +10%',} }, 
    },
    
    neck = "Cleric's torque +1",

    artifact = 
    {  
      head  = "Theo. cap",
      body  = "Theo. Bliaut",
      hands = "Theophany mitts",
      legs  = "Theo. pantaloons",
      feet  = "Theo. duckbills" 
    },
  
    relic = 
    {     
      head  = "Piety cap",
      body  = "Piety Bliaut",
      hands = "Piety mitts",
      legs  = "Piety pantaloons",
      feet  = "Piety duckbills" 
    },
  
    empyrean = 
    {  
      head  = "Ebers cap",
      body  = "Ebers Bliaut",
      hands = "Ebers mitts",
      legs  = "Ebers pantaloons",
      feet  = "Ebers duckbills" 
    }
  }
end

--------------------------------------------------------------------------
--------------------     define gear sets      ---------------------------
--------------------------------------------------------------------------
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

  sets.idle = 
	{ 
		main = "Chatoyant Staff", -- Malignance Pole is really what you want here.  it has -20% dt
		  --sub  = "Mensch Strap +1",
		  --ammo = "Homiliary",
		  head = gear.bluefriend.inyanga.head,
		  body = gear.bluefriend.inyanga.body,
		  hands= gear.bluefriend.inyanga.hands,
		  --legs = gear.bluefriend.inyanga.legs,
		  --feet = gear.bluefriend.inyanga.feet,
		  --neck = "Bathy choker +1",
		  neck = "Wiglen Gorget",
		  --ear1 = "Infused earring",
		  --ear2 = "Etiolation earring",
		  --ring1= "Defending ring",
		  ring2= "Inyanga ring",
		  --back = "Moonbeam cape", -- get a pdt cape, you'll cap mdt with shell
		  back = "Aptitude Mantle +1",
		  --waist= "Hachirin-no-obi" 
	}

  sets.idle.Town   = set_combine(sets.idle, { feet = "Herald's gaiters" })

  --sets.idle.Refresh = set_combine(sets.idle, { ring1 = "Stikini Ring +1" })

  sets.precast.FC = 
	{ 
	  ammo = "Hasty Pinion +1",
	  head = gear.bluefriend.vanya.head,
	  body = gear.bluefriend.inyanga.body,
	  hands= gear.bluefriend.vanya.hands,
	  legs = gear.bluefriend.ayanmo.legs,
	  feet = gear.bluefriend.vanya.feet,
	  neck = gear.bluefriend.whm.neck,
	  ear1 = "Beatific Earring",
	  ear2 = "Enchntr. Earring +1",
	  ring1= "Prolix Ring",
	  ring2= "Veneficium Ring",
	  back = gear.bluefriend.whm.capes.fast_cast,
	  waist= "Witful belt" 
	}

  sets.precast.FC.Cure =  
    set_combine(sets.precast.FC, 
      { 
        --ammo = "Impatiens",
        --head = gear.bluefriend.whm.artifact.head,
        --ear1 = "Mendi. Earring"
      }
    )

  sets.midcast.Cure = 
  { 
    main = "Chatoyant staff",
    sub  = "Achaq grip",
    head = gear.bluefriend.vanya.head,
    body = gear.bluefriend.vanya.body,
    hands= gear.bluefriend.vanya.hands,
    legs = gear.bluefriend.vanya.legs,
    feet = gear.bluefriend.vanya.feet,
    neck = gear.bluefriend.whm.neck,
    ear1 = "Beatific Earring",
	  ear2 = "Enchntr. Earring +1",
    ring1= "Sirona's Ring",
    ring2= "Mediator's Ring",
    back = gear.bluefriend.whm.capes.cure,
    --waist= "Hachirin-no-obi" 
  }

  sets.midcast.Curaga = 
  set_combine(sets.midcast.Cure, 
    {  
      --ammo = "Hydrocera",
      --body = gear.bluefriend.whm.artifact.body,
      --back = "Twilight Cape" -- get cape from Shinryu in Abyssea
    }
  ) 

  --sets.midcast.Stoneskin  = { neck = "Nodens Gorget", waist = "Siegel Sash" }

  sets.midcast.Cursna = 
  { 
	  --head = gear.bluefriend.kaykaus.head,
	  --body = gear.bluefriend.whm.empyrean.body,
	  --hands= "Fanatic Golves",
	  --legs = gear.bluefriend.ayanmo.legs,
	  --feet = gear.bluefriend.kaykaus.feet,
	  --neck = "Debils Medallion",
	  --ring1= "Haoma's Ring",
	  --ring2= "Haoma's Ring",
	  --back = gear.bluefriend.whm.capes.cure
  }

end

--------------------------------------------------------------------------
---------------------     job functions      -----------------------------
--------------------------------------------------------------------------
function job_precast(spell, action, spellMap, eventArgs)

end

function job_midcast(spell, action, spellMap, eventArgs)

end

--------------------------------------------------------------------------
-------------------     job post functions      --------------------------
--------------------------------------------------------------------------
function job_post_precast(spell, spellMap, eventArgs)
  if string.find(spell.name, 'Cure') then
    if not buffactive['Afflatus Solace'] then
      windower.add_to_chat(028, 'WARNING: Curing without Afflatus Solace active')
    end
    if not buffactive['Aurorastorm'] then
      windower.add_to_chat(028, 'WARNING: Curing without Aurorastorm active')
    end
  end
end

function job_post_midcast(spell, action, spellMap, eventArgs)

end


