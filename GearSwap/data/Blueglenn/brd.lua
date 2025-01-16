--------------------------------------------------------------------------
-----------------------     includes      --------------------------------
--------------------------------------------------------------------------
function get_sets()
  -- Load and initialize the include file.
  mote_include_version = 2
  include('Mote-Include.lua')
end

--------------------------------------------------------------------------
-----------------------     constants      -------------------------------
--------------------------------------------------------------------------
lockstyle_set = "06" -- this one needs to be a string
default_macro_book = 3
default_macro_page = 1

--------------------------------------------------------------------------
-----------------------     job setup      -------------------------------
--------------------------------------------------------------------------
function job_setup()
  --todo
end

--------------------------------------------------------------------------
----------------------     user setup      -------------------------------
--------------------------------------------------------------------------
function user_setup() 
  -- built-in state tables
  state.IdleMode:options('Normal')
  send_command('bind ^i gs c cycle IdleMode')

  state.OffenseMode:options('Normal', 'Dps', 'DT')
  send_command('bind ^o gs c cycle OffenseMode')

  state.CastingMode:options('Normal', 'Resistant')
  send_command('bind ^c gs c cycle CastingMode')

  -- custom state tables
  state.SongMode = M{['description'] = 'SongMode', 'Normal', 'Dummy'}--,'Autodummy'}
  send_command('bind ^s gs c cycle SongMode')

  state.LullabyMode = M{['description'] = 'LullabyMode', 'Harp', 'Horn' }
  send_command('bind ^l gs c cycle LullabyMode')

  set_lockstyle()
  select_default_macro_book()
  dressup()

  ---------------------------------
  -- jse setup
  ---------------------------------
  gear.globals.brd = 
  {
    capes = 
    { 
      fast_cast = { name="Intarabus's Cape", augments={'CHR+20','Mag. Acc+20 /Mag. Dmg.+20','"Fast Cast"+10',}},
      cure      = { name="Intarabus's Cape", augments={'MND+20','Eva.+20 /Mag. Eva.+20','MND+10','"Cure" potency +10%','Spell interruption rate down-10%',}}, 
    },
    
    neck = "Bard's charm +1",

    artifact = 
    {  
      head  = "Brioso roundlet +2",
      body  = "Brioso justaucorps +3",
      hands = "Brioso cuffs +2",
      legs  = "Brioso cannions +3",
      feet  = "Brioso slippers +2" 
    },
  
    relic = 
    {     
      head  = "Bihu roundlet +3",
      body  = "Bihu justaucorps +3",
      hands = "Bihu cuffs +3",
      legs  = "Bihu cannions +3",
      feet  = "Bihu slippers +3" 
    },
  
    empyrean = 
    {  
      head  = "Fili calot +1",
      body  = "Fili hongreline +1",
      hands = "Fili manchettes +1",
      legs  = "Fili rhingrave +1",
      feet  = "Fili cothurnes +1" 
    },
  }
end

function user_unload()
  send_command('unbind ^i')
  send_command('unbind ^o')
  send_command('unbind ^c')
  send_command('unbind ^s')
  send_command('unbind ^l')
end

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

  --------------------------------------------------------------------------
  -----------------------     idle sets      -------------------------------
  --------------------------------------------------------------------------
  sets.idle = 
  { 
    head  = gear.globals.nyame.head,  --7% DT
    body  = gear.globals.nyame.body,  --9% DT
    hands = gear.globals.nyame.hands, --7% DT
    legs  = gear.globals.nyame.legs,  --8% DT
    feet  = gear.globals.brd.empyrean.feet, --18% Movement Speed
    neck  = "Bathy Choker +1",  --3 Regen
    ear1  = "Genmei Earring",   --2% PDT 
    ear2  = "Infused Earring",  --1 Regen
    ring1 = "Defending Ring",   --10% DT
    ring2 = "Shneddick Ring",
    back  = "Moonbeam Cape",    --5% DT
    waist = "Flume Belt",       --4% PDT
  } --46% DT, 52/50% PDT

  --------------------------------------------------------------------------
  ---------------------     precast sets      ------------------------------
  --------------------------------------------------------------------------
  -- spells
  sets.precast.FC = 
  { 
    head = gear.globals.brd.empyrean.head, --14% song FC
    body = gear.globals.inyanga.body, --14% FC
    hands= "Gende. Gages +1", --4% song FC
    legs = gear.globals.ayanmo.legs, --6% FC
    feet = gear.globals.brd.relic.feet, --10% song FC
    neck = "Mnbw. Whistle +1",
    ear1 = "Enchntr. Earring", --2% FC
    ear2 = "Loquac. Earring", --2% FC
    ring1= "Prolix Ring", --2% FC
    ring2= "Kishar Ring", --4% FC
    back = gear.globals.brd.capes.fast_cast, --10% FC
    waist= "Witful Belt" --3% FC -- Embla Sash (1000 Domain points)
  } --43% FC + 28% song FC = 71/80 FC

  sets.precast.FC.Cure =  
  { 
    head = gear.globals.kaykaus.head,
    body = gear.globals.inyanga.body,
    hands= "Gendewitha Gages",
    legs = gear.globals.kaykaus.legs,
    feet = gear.globals.kaykaus.feet,
    neck = "Twilight Torque",
    ear1 = "Enchntr. Earring +1",
    ear2 = "Loquac. Earring",
    ring1= "Kishar Ring",
    ring2= "Defending Ring",
    back = gear.globals.brd.capes.fast_cast,
    waist= "Witful Belt", 
  }

  sets.precast.FC.Cura = sets.precast.FC.Cure
  sets.precast.FC.Curaga = sets.precast.FC.Cure

  sets.precast.FC['Enhancing Magic'] = sets.precast.FC.Cure

  sets.precast.FC.BardSong = set_combine(sets.precast.FC, { Main = "Kali", sub = "Genmei Shield" })

  sets.precast.FC.SongPlaceholder = sets.precast.FC.BardSong

  sets.precast.FC.Dispelga = {}

  -- Waltz set (chr and vit)
  sets.precast.Waltz = {}

  -- job abilities
  sets.precast.JA["Nightingale"]= { feet = gear.globals.brd.relic.feet }
  sets.precast.JA["Soul Voice"] = { legs = gear.globals.brd.relic.legs }
  sets.precast.JA["Troubadour"] = { body = gear.globals.brd.relic.body }

  -- weapon skills
  sets.precast.WS["Savage Blade"] = 
  { 
    head  = gear.globals.lustratio.head,  -- 39 str + 8 str
    body  = gear.globals.brd.relic.body,  -- 39 str / 38 mnd
    hands = gear.globals.brd.relic.hands, -- 16 str / 42 mnd
    legs  = gear.globals.brd.relic.legs,  -- 33 str / 43 mnd
    feet  = gear.globals.lustratio.feet,  -- 32 str + 15 str
    neck  = gear.globals.brd.neck, 
    ear1  = "Moonshade Earring",
    ring1 = "Apate Ring",                   -- 6 str
    ring2 = "Stikini Ring +1",              -- 8 mnd
    back  = gear.globals.brd.capes.cure   -- 30 mnd
  } 

  --------------------------------------------------------------------------
  ---------------------     midcast sets      ------------------------------
  --------------------------------------------------------------------------
  -- General set for recast times.
  sets.midcast.FastRecast = sets.precast.FC

  -- Gear to enhance certain classes of songs.
  sets.midcast.Ballad     = { legs = gear.globals.brd.empyrean.legs }
  --sets.midcast.Carol    = { hands= "Mousai Gages +1" }
  --sets.midcast.Etude    = { head = "Mousai Turban +1" }
  sets.midcast.HonorMarch = { range= "Marsyas", hands = gear.globals.brd.empyrean.hands } 
  sets.midcast.Madrigal   = { head = gear.globals.brd.empyrean.head }
  --sets.midcast.Mambo    = { feet = "Mousai Crackows +1" }
  sets.midcast.March      = { hands= gear.globals.brd.empyrean.hands }
  --sets.midcast.Minne    = { legs = "Mousai Seraweels +1" }
  sets.midcast.Minuet     = { body = gear.globals.brd.empyrean.body }
  sets.midcast.Paeon      = { head = gear.globals.brd.artifact.head }
  --sets.midcast.Threnody = { body = "Mou. Manteel +1" }

  sets.midcast['Adventurer\'s Dirge'] = { range= "Marsyas", hands = gear.globals.brd.relic.hands }
  sets.midcast['Foe Sirvente']        = { head = gear.globals.brd.relic.head }
  sets.midcast['Magic Finale']        = { legs = gear.globals.brd.empyrean.legs }
  sets.midcast["Sentinel's Scherzo"]  = { feet = gear.globals.brd.empyrean.feet }
  sets.midcast["Chocobo Mazurka"]     = { range= "Marsyas" }

  -- For song buffs (duration and AF3 set bonus)
  sets.midcast.SongEnhancing = 
  { 
    head = gear.globals.brd.empyrean.head,
    body = gear.globals.brd.empyrean.body,
    hands= gear.globals.brd.empyrean.hands,
    legs = gear.globals.inyanga.legs,
    feet = gear.globals.brd.artifact.feet,
    neck = "Mnbw. Whistle +1",
    ear1 = "Odnowa Earring", -- upgrade to +1 when you can
    ear2 = "Etiolation Earring",
    ring1= "Defending Ring",
    ring2= "Gelatinous Ring +1",
    waist= "Flume Belt +1",
    back = gear.globals.brd.capes.fast_cast 
  }

  -- For song defbuffs (duration primary, accuracy secondary)
  sets.midcast.SongEnfeeble =   
  { 
    head = gear.globals.brd.artifact.head,
    body = gear.globals.brd.artifact.body,
    hands= gear.globals.brd.artifact.hands,
    legs = gear.globals.brd.artifact.legs,
    feet = gear.globals.brd.artifact.feet,
    neck = "Mnbw. Whistle +1",
    ear1 = "Hermetic Earring", --"Digni. Earring", need to get
    ear2 = "Enchntr. Earring", --"Regal Earring",  need to get
    ring1= "Stikini Ring +1",
    ring2= "Stikini Ring", 
    waist= "Acuity Belt +1",
    back = gear.globals.brd.capes.fast_cast, 
  }

  -- For Horde Lullaby maxiumum AOE range.
  sets.midcast.Lullaby  = set_combine(
    sets.midcast.SongEnfeeble, {  
      main  = gear.globals.grioavolr.fast_cast,
      sub   = "Enki Strap",
      head  = gear.globals.brd.relic.head,
      body  = gear.globals.brd.empyrean.body, 
      hands = gear.globals.brd.artifact.hands,
      legs  = gear.globals.inyanga.legs,
      feet  = gear.globals.brd.relic.feet,
      ring2 = "Stikini Ring" 
    }
  )
  ---------------------------------
  -- For song defbuffs (accuracy primary, duration secondary)
  ---------------------------------
  sets.midcast.SongEnfeebleAcc = set_combine(sets.midcast.SongEnfeeble, { legs = gear.globals.brd.artifact.legs })

  sets.midcast.SongPlaceholder = sets.midcast.SongEnhancing

  sets.midcast.Cure = 
  { 
    main = gear.globals.grioavolr.conserve_mp,
    sub  = "Giuoco Grip",
    ammo = "Impatiens",
    head = gear.globals.kaykaus.head,
    body = gear.globals.kaykaus.body,
    hands= gear.globals.kaykaus.hands,
    legs = gear.globals.kaykaus.legs,
    feet = gear.globals.kaykaus.feet,
    neck = "Reti Pendant",
    ear1 = "Calamitous Earring",  
    ear2 = "Gifted Earring",
    ring1= "Lebeche Ring",
    ring2= "Mephitas's Ring +1",
    back = gear.globals.brd.capes.cure,
    waist= "Shinjutsu-no-Obi +1", 
  }

  sets.midcast.Cura   = sets.midcast.Cure
  sets.midcast.Curaga = sets.midcast.Cure

  sets.midcast['Enhancing Magic'] = 
  { 
    head = gear.globals.inyanga.head,
    body = gear.globals.inyanga.body,
    hands= "Chironic gloves",
    legs = gear.globals.ayanmo.legs,
    feet = gear.globals.kaykaus.feet,
    neck = "Incanter's Torque",
    ear1 = "Mimir Earring",
    ear2 = "Andoaa Earring",
    ring1= "Stikini Ring +1",
    ring2= "Stikini Ring",
    back = "Fi Follet Cape +1",
    waist= "Embla Sash", 
  }

  sets.midcast['Fire Carol'] = { range = "Daurdabla" }
  sets.midcast['Ice Carol'] = { range = "Daurdabla" }

  sets.midcast.Regen     = set_combine(sets.midcast['Enhancing Magic'], { head = gear.globals.inyanga.head })
  sets.midcast.Haste     = sets.midcast['Enhancing Magic']
  sets.midcast.Stoneskin = set_combine(sets.midcast['Enhancing Magic'], { neck = "Nodens Gorget", waist = "Siegel Sash" })
  sets.midcast.Aquaveil  = set_combine(sets.midcast['Enhancing Magic'], { head = "Chironic Hat",  waist = "Emphatikos Rope" })
  sets.midcast.Protect   = set_combine(sets.midcast['Enhancing Magic'], { ring2= "Sheltered Ring" })
  sets.midcast.Protectra = sets.midcast.Protect
  sets.midcast.Shell     = sets.midcast.Protect
  sets.midcast.Shellra   = sets.midcast.Shell

  ---------------------------------
  -- melee sets
  ---------------------------------
  -- just stacking STP here.  If we're meleeing, we're just trying to get to Savage Blade
  -- don't put anything in the ammo slot
  sets.engaged = 
  { 
    head  = gear.globals.ayanmo.head,
    body  = gear.globals.ayanmo.body,
    hands = gear.globals.ayanmo.hands,
    legs  = gear.globals.ayanmo.legs,
    feet  = gear.globals.ayanmo.feet,
    neck  = gear.globals.brd.neck,
    ear1  = "Telos Earring",
    ear2  = "Dedition Earring",
    ring1 = "Apate Ring",
    ring2 = "Chirich Ring +1",
    --back = gear.globals.brd.capes.dual_wield,
    waist = "Windbuffet Belt +1", -- better belt is Reiki Yotai, which drops from Kouryu in Escha - Ru'Aun Geas Fete
  } 

  -- -53% DT.  I commented out the pieces that overcapped me on DT in favor of STP.
  sets.engaged.DT  = set_combine(
    sets.engaged, {  
      head  = gear.globals.nyame.head, --7% DT
      body  = gear.globals.nyame.body, --9% DT
      hands = gear.globals.nyame.hands, --7% DT
      legs  = gear.globals.nyame.legs, --8% DT
      feet  = gear.globals.nyame.feet, --7% DT
      --neck  = "Loricate torque", --5% DT 
      ring1 = "Defending Ring", --10% DT
      --ring2 = "Gelatinous Ring +1", --7% PDT
      back  = "Moonbeam Cape", --5% DT
      --waist = "Flume Belt" --4% PDT
    }
  ) 
  
  sets.engaged.Dps = set_combine(sets.engaged, { main = "Naegling", sub = "Centovente", })
                               
end

--------------------------------------------------------------------------
---------------------     job functions      -----------------------------
--------------------------------------------------------------------------
function job_precast(spell, action, spellMap, eventArgs)
  equip_ranged(get_instrument(spell))
end

function job_midcast(spell, action, spellMap, eventArgs)
  if spell.type == 'BardSong' then
    local song_class = get_song_class(spell)

    if song_class and sets.midcast[song_class] then
      equip(sets.midcast[song_class])
    end

  end
end

function job_aftercast(spell, action, spellMap, eventArgs)
  enable(range)
  if spell.english:contains('Lullaby') and not spell.interrupted then
    get_lullaby_duration(spell)
  end
end

--------------------------------------------------------------------------
-------------------     utility functions      ---------------------------
--------------------------------------------------------------------------
function equip_ranged(item)
  equip({ range = item })
  disable(range)
end

function get_instrument(spell)
  if spell.name == 'Honor March' then return "Marsyas" end
  if spell.english:contains('Lullaby') then return "Blurred Harp +1" end
  if is_dummy_song() then return "Daurdabla" end
  if state.SongMode.value == 'Normal' then return "Gjallarhorn" end

  return "Gjallarhorn"
end

-- Determine the custom class to use for the given song.
function get_song_class(spell)
  -- Can't use spell.targets:contains() because this is being pulled from resources
  if set.contains(spell.targets, 'Enemy') then
    if state.CastingMode.value == 'Resistant' then return "SongEnfeebleAcc" end
    return "SongEnfeeble"
  end

  if is_dummy_song() then return "SongPlaceholder" end
    
  return "SongEnhancing"
end

function get_lullaby_duration(spell)
  local self = windower.ffxi.get_player()

  local troubadour = false
  local clarioncall = false
  local soulvoice = false
  local marcato = false

  for i,v in pairs(self.buffs) do
    if v == 348 then troubadour = true end
    if v == 499 then clarioncall = true end
    if v == 52 then soulvoice = true end
    if v == 231 then marcato = true end
  end

  local mult = 1

  if player.equipment.range == 'Daurdabla' then mult = mult + 0.3 end -- change to 0.25 with 90 Daur
  if player.equipment.range == "Gjallarhorn" then mult = mult + 0.4 end -- change to 0.3 with 95 Gjall
  if player.equipment.range == "Marsyas" then mult = mult + 0.5 end

  if player.equipment.main == "Carnwenhan" then mult = mult + 0.5 end -- 0.1 for 75, 0.4 for 95, 0.5 for 99/119
  if player.equipment.main == "Legato Dagger" then mult = mult + 0.05 end
  if player.equipment.main == "Kali" then mult = mult + 0.05 end
  if player.equipment.sub == "Kali" then mult = mult + 0.05 end
  if player.equipment.sub == "Legato Dagger" then mult = mult + 0.05 end
  if player.equipment.neck == "Aoidos' Matinee" then mult = mult + 0.1 end
  if player.equipment.neck == "Mnbw. Whistle" then mult = mult + 0.2 end
  if player.equipment.neck == "Mnbw. Whistle +1" then mult = mult + 0.3 end
  if player.equipment.body == "Fili Hongreline +1" then mult = mult + 0.12 end
  if player.equipment.legs == "Inyanga Shalwar +1" then mult = mult + 0.15 end
  if player.equipment.legs == "Inyanga Shalwar +2" then mult = mult + 0.17 end
  if player.equipment.feet == "Brioso Slippers" then mult = mult + 0.1 end
  if player.equipment.feet == "Brioso Slippers +1" then mult = mult + 0.11 end
  if player.equipment.feet == "Brioso Slippers +2" then mult = mult + 0.13 end
  if player.equipment.feet == "Brioso Slippers +3" then mult = mult + 0.15 end
  if player.equipment.hands == 'Brioso Cuffs +1' then mult = mult + 0.1 end
  if player.equipment.hands == 'Brioso Cuffs +2' then mult = mult + 0.1 end
  if player.equipment.hands == 'Brioso Cuffs +3' then mult = mult + 0.2 end

  --JP Duration Gift
  if self.job_points.brd.jp_spent >= 1200 then
    mult = mult + 0.05
  end

  if troubadour then
    mult = mult * 2
  end

  if spell.en == "Foe Lullaby II" or spell.en == "Horde Lullaby II" then
    base = 60
  elseif spell.en == "Foe Lullaby" or spell.en == "Horde Lullaby" then
    base = 30
  end

  totalDuration = math.floor(mult * base)

  -- Job Points Buff
  totalDuration = totalDuration + self.job_points.brd.lullaby_duration
  if troubadour then
    totalDuration = totalDuration + self.job_points.brd.lullaby_duration
    -- adding it a second time if Troubadour up
  end

  if clarioncall then
    if troubadour then
      totalDuration = totalDuration + (self.job_points.brd.clarion_call_effect * 2 * 2)
      -- Clarion Call gives 2 seconds per Job Point upgrade.  * 2 again for Troubadour
    else
      totalDuration = totalDuration + (self.job_points.brd.clarion_call_effect * 2)
      -- Clarion Call gives 2 seconds per Job Point upgrade.
    end
  end

  if marcato and not soulvoice then
    totalDuration = totalDuration + self.job_points.brd.marcato_effect
  end

  -- Create the custom timer
  if spell.english == "Foe Lullaby II" or spell.english == "Horde Lullaby II" then
    send_command('@timers c "Lullaby II ['..spell.target.name..']" ' ..totalDuration.. ' down spells/00377.png')
  elseif spell.english == "Foe Lullaby" or spell.english == "Horde Lullaby" then
    send_command('@timers c "Lullaby ['..spell.target.name..']" ' ..totalDuration.. ' down spells/00376.png')
  end
end

function get_player_songs()
  local counter = 0
  local player = windower.ffxi.get_player()
  
  for _, buffCode in pairs(player.buffs) do
    if buffCode >= 195 and buffCode <= 222 then -- see ~\FFXI_Windower\res\buffs.lua for a complete list of buff codes. These are beneficial songs.
      counter = counter + 1
    end
  end

  return counter
end

function is_dummy_song()
  local songs = get_player_songs()
  return state.SongMode.value == 'Dummy' or (songs >= 2 and songs < 4 and state.SongMode.value == 'Autodummy')
end

--------------------------------------------------------------------------
----------------------     style lock      -------------------------------
--------------------------------------------------------------------------
function set_lockstyle() 
  send_command('@wait 6;input /lockstyleset ' .. lockstyle_set)
end

--------------------------------------------------------------------------
------------------------     macros      ---------------------------------
--------------------------------------------------------------------------
function select_default_macro_book()
  if default_macro_book then
    send_command('@input /macro book ' .. tostring(default_macro_book) .. ';wait .1;input /macro set ' .. tostring(default_macro_page))
    return
  end
  send_command('@input / macro set ' .. tostring(default_macro_page))
end

---------------------------------
-- dressup 
---------------------------------
function dressup(race, gender, face)
  send_command('@input //lua l dressup')
  if not race or not gender or not face then send_command('@input //du clear self') return end
  send_command('@input //du self race ' .. race .. ' ' .. gender)
  send_command('@wait 2; input //du self face ' .. tostring(face))
end
