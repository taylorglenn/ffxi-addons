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
set_lockstyle(04)

---------------------------------
-- macros 
---------------------------------
function set_macros(sheet, book)
  if book then
    send_command('@input /macro book ' .. tostring(book) .. ';wait .1;input /macro set ' .. tostring(sheet))
    return
  end
  send_command('@input /macro set ' .. tostring(sheet))
end
set_macros(1, 8)

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
  blueMagicTables = loadBlueMagicTables()
  info.fantodCounter = 0
end

---------------------------------
-- user setup
---------------------------------
function user_setup() 
  ---------------------------------
  -- states
  ---------------------------------
  state.IdleMode:options('Normal', 'Evasion Tanking')
  send_command('bind ^i gs c cycle IdleMode')

  state.OffenseMode:options('Clubs', 'Swords', 'FeedTp', 'Learn')
  send_command('bind ^o gs c cycle OffenseMode')

  ---------------------------------
  -- jse setup
  ---------------------------------
  gear.blueglenn.blu = 
  {
    capes = 
    { 
      dex_crit= { name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Crit.hit rate+10',}},
      str_att = { name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
      int_mab = { name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','INT+10','"Fast Cast"+10','Phys. dmg. taken-10%',}}, 
      agi_eva_fc = { name="Rosmerta's Cape", augments={ }} --Agi 20 | Eva 25 | Fast Cast 10 | 20 EVA MEVA
    },

    neck = "Mirage Stole +1",

    artifact = 
    {  
      hands = "Assim. Bazu. +1",
      body  = "Assim. Jubbah +2",
      legs  = "Assim. Shalwar +1" 
    },

    relic = 
    {  
      head  = "Luh. Keffiyeh +3",
      body  = "Luhlaza Jubbah +3",
      hands = "Luh. Bazubands +1",
      legs  = "Luhlaza Shalwar +3",
      feet  = "Luhlaza Charuqs +3", 
    },

    empyrean = 
    {  
      body  = "Hashishin Mintan",
      hands = "Hashishin Bazubands +1",
      legs  = "Hashishin Tayt +1",
      feet  = "Hashishin Basmak +1", 
    }
  }
end

---------------------------------
-- user unload
---------------------------------
function user_unload()
  -- unload keybinds
  send_command('unbind ^i') -- unbinds IdleMode from i key
  send_command('unbind ^o') -- unbinds EngagedMode from o key
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
    ammo  = "Staunch Tathlum",
    head  = { name="Rawhide Mask", augments={'HP+50','Accuracy+15','Evasion+20',}},
    body  = gear.blueglenn.jhakri.body,
    hands = gear.blueglenn.nyame.hands,
    legs  = gear.blueglenn.carmine.legs,
    feet  = gear.blueglenn.nyame.feet,
    neck  = "Bathy Choker +1",
    waist = "Flume Belt",
    ear1  = "Genmei Earring",
    ear2  = "Infused Earring",
    ring1 = "Defending Ring",
    ring2 = "Gelatinous Ring +1",
    back  = "Moonbeam Cape", 
  }
  sets.idle.dt =  set_combine(sets.idle, 
  {
    head = gear.blueglenn.nyame.head,
    body = gear.blueglenn.nyame.body,
  })
  sets.idle['Evasion Tanking'] = set_combine(sets.idle, 
  {                                           --| EVA | MEVA | DT |
    ammo = "Amar Cluster",                    --|  10 |    0 |  0 |
    head = gear.blueglenn.nyame.head,         --|  91 |  123 |  7 |
    body = gear.blueglenn.nyame.body,         --| 102 |  139 |  9 |
    hands= gear.blueglenn.nyame.hands,        --|  80 |  112 |  7 |
    legs = gear.blueglenn.nyame.legs,         --|  85 |  150 |  8 |
    feet = gear.blueglenn.nyame.feet,         --| 119 |  150 |  7 |
    neck = "Bathy Choker +1",                 --|  15 |    0 |  0 |
    waist= "Carrier's Sash",                  --|   0 |    0 |  0 |
    ear1 = "Eabani Earring",                  --|  15 |    8 |  0 |
    ear2 = "Infused Earring",                 --|  10 |    0 |  0 |
    ring1= "Defending Ring",                  --|   0 |    0 | 10 |
    ring2= "Gelatinous Ring +1",              --|   0 |    0 |  7 |
    back = gear.blueglenn.blu.capes.agi_eva_fc--|  25 |   20 |  0 |
  })                                          --| 552 |  694 | 55 |

  ---------------------------------
  -- Melee
  ---------------------------------
  sets.engaged = 
  {  
    ammo  = "Aurgelmir Orb",
    head  = gear.blueglenn.adhemar.head,
    body  = gear.blueglenn.gleti.body,
    hands = gear.blueglenn.adhemar.hands,
    legs  = gear.blueglenn.gleti.legs,
    feet  = gear.blueglenn.gleti.feet,
    neck  = gear.blueglenn.blu.neck,
    waist = "Windbuffet Belt +1",
    ear1  = "Telos Earring",
    ear2  = "Cessance Earring",
    ring1 = "Epona's Ring",
    ring2 = "Chirich Ring +1",
    back  = gear.blueglenn.blu.capes.dex_crit, 
  }

  sets.engaged.Clubs  = set_combine(sets.engaged, { main = "Maxentius", sub = "Kaja Rod", })
  sets.engaged.Swords = set_combine(sets.engaged, { main = "Naegling",  sub = "Thibron", })
  sets.engaged.FeedTp = set_combine(sets.engaged, { main = "Nihility", sub = "Wind Knife", })
  sets.engaged.Learn  = set_combine(sets.engaged.Swords, { hands = gear.blueglenn.blu.artifact.hands })
  ---------------------------------
  -- Weapon Skills
  ---------------------------------
  -- Default
  sets.precast.WS = 
  {
    ammo = "Aurgelmmir Orb",
    head = "Sukeroku Hachi.",
    body = gear.blueglenn.blu.artifact.body,
    legs = gear.blueglenn.blu.relic.legs,
    neck = "Fotia Gorget",
    waist= "Fotia Belt",
    ear2 = gear.blueglenn.moonshade,
    back = gear.blueglenn.blu.capes.str_att,
  }
  -- Savage Blade: Sword - Physical - 50% STR / 50% MND - Dynamic fTP: 4.0 / 10.25 / 13.75
  sets.precast.WS["Savage Blade"] = set_combine(sets.precast.WS, 
  { 
    head = gear.blueglenn.jhakri.head,
    body = gear.blueglenn.gleti.body,
    hands= gear.blueglenn.jhakri.hands,
    legs = gear.blueglenn.gleti.legs,
    feet = gear.blueglenn.jhakri.feet,
    neck = gear.blueglenn.blu.neck,
    ear1 = "Telos Earring",
    waist= "Prosilio Belt +1"
  })
  -- Expiacion: Sword - Physical - 30% STR / 30% INT / 20% DEX - Dynamic fTP: 3.8 / 9.4 / 12.2
  sets.precast.WS["Expiacion"] = sets.precast.WS["Savage Blade"]
  -- Chant du Cygne: Sword - Physical - 80% DEX - Static fTP @ 1.63 - Crit Rate @ 1k/2k/3k = 15%/25%/40%
  sets.precast.WS['Chant du Cygne'] = set_combine(sets.precast.WS, 
  {
    head = gear.blueglenn.adhemar.head,
    body = gear.blueglenn.gleti.body,
    hands= gear.blueglenn.adhemar.hands,
    legs = gear.blueglenn.gleti.legs,
    feet = gear.blueglenn.gleti.feet,
    neck = gear.blueglenn.blu.neck,
    ear1 = "Mache Earring +1",
    ring1= "Epona's Ring",
    ring2= "Ilabrat Ring",
    back = gear.blueglenn.blu.capes.dex_crit,
  })
  -- Requeiescat: Sword - Physical - 73~85% MNK - Static fTP @ 1.0 - Attack Power @ 1k/2k/3k = -20%/-10%/-0%
  sets.precast.WS['Requeiescat'] = set_combine(sets.precast.WS, 
  {
    head = gear.blueglenn.blu.relic.head,
    body = gear.blueglenn.blu.relic.body,
    hands= gear.blueglenn.blu.relic.hands,
    legs = gear.blueglenn.gleti.legs,
    feet = gear.blueglenn.blu.relic.feet,
    ear1 = "Sherida earring",
    ring1= "Epona's Ring",
  })
  -- Sangine Blade: Sword - Magical (Dark) - 50% MND / 30% STR - Static fTP @ 2.75 - HP Drained @ 1k/2k/3k = 50%/100%/160%
  sets.precast.WS["Sanguine Blade"] = set_combine(sets.precast.WS, 
  {
    head = "Pixie Hairpin +1",
    body = gear.blueglenn.amalric.body,
    hands= gear.blueglenn.jhakri.hands,
    feet = gear.blueglenn.jhakri.feet, -- todo: amalric nails +1
    neck = "Sanctity Necklace",
    ear1 = "Firomisi Earring",
    ear2 = "Novio Earring",
    ring1= "Archon Ring",
    ring2= "Shiva Ring +1",
    back = gear.blueglenn.blu.capes.int_mab
  })
  -- Vorpal Blade: Sword - Physical - 60% STR - Static fTP @ 1.375 - Crit chance vaires with TP (bg-wiki doesn't have values)
  sets.precast.WS["Vorpal Blade"] = set_combine(sets.precast.WS, 
  {
    head = gear.blueglenn.gleti.head,
    body = gear.blueglenn.gleti.body,
    hands= gear.blueglenn.gleti.hands,
    feet = gear.blueglenn.gleti.feet,
    ear1 = "Sherida Earring",
    ring1= "Epona's Ring",
    ring2= "Ilabrat Ring",
  })
  ---------------------------------
  -- Job Abilities
  ---------------------------------
  sets.precast.JA['Diffusion'] = { feet = gear.blueglenn.blu.relic.feet, }
  ---------------------------------
  -- Spells
  ---------------------------------
  -- precast
  sets.precast.FC = 
  {                                           --| FC | 80% is cap
    ammo  = "Sapience Orb",                   --|  2 |
    head  = gear.blueglenn.carmine.head,      --| 14 |
    body  = gear.blueglenn.blu.empyrean.body, --| 13 | (blue magic only)
    hands = gear.blueglenn.adhemar.hands,     --|  0 | no FC, but 5 haste
    legs  = gear.blueglenn.psycloth.legs.fc,  --|  7 |
    feet  = gear.blueglenn.carmine.feet,      --|  8 |
    neck  = "Stoicheion Medal",               --|  3 | (elemental magic only)
    waist = "Witful Belt",                    --|  3 |
    ear1  = "Loquac. Earring",                --|  2 |
    ear2  = "Enchntr. Earring +1",            --|  2 |
    ring1 = "Defending Ring",                 --|  0 |
    ring2 = "Prolix Ring",                    --|  2 |
    back  = gear.blueglenn.blu.capes.int_mab, --| 10 |
  }                                           --| 66 |

  -- strap in, the blue magic midcast section gets... complicated.
  -- try to keep these in the same order as the load_blue_magic_table function below.  For readability's sake
  sets.midcast['Blue Magic'] = 
  { 
    ammo  = "Mavi Tathlum",
    head  = gear.blueglenn.jhakri.head,
    body  = gear.blueglenn.amalric.body,
    hands = gear.blueglenn.amalric.hands,
    legs  = gear.blueglenn.jhakri.legs,
    feet  = gear.blueglenn.jhakri.feet,
    neck  = "Sanctity Necklace",
    waist = "Eschan Stone",
    ear1  = "Novio Earring",
    ear2  = "Friomisi Earring",
    ring1 = "Shiva Ring +1",
    ring2 = "Acumen Ring",
    back  = "Cornflower Cape", 
  }
  -- all phys spells need to prioritize some amount of strength
  sets.midcast['Blue Magic'].phys = set_combine(sets.midcast['Blue Magic'], 
  {
    head = gear.blueglenn.blu.relic.head,
    body = gear.blueglenn.blu.relic.body,
    hands= gear.blueglenn.jhakri.hands,
    legs = gear.blueglenn.jhakri.legs,
    feet = gear.blueglenn.blu.relic.feet,
    neck = gear.blueglenn.blu.neck,
    waist= "Prosilio Belt +1",
    ear1 = "Telos Earring",
    ear2 = "Tati Earring",
    back = gear.blueglenn.blu.capes.str_att,
  })
  sets.midcast['Blue Magic'].phys_acc = set_combine(sets.midcast['Blue Magic'].phys, { })
  sets.midcast['Blue Magic'].str      = set_combine(sets.midcast['Blue Magic'].phys, { })
  sets.midcast['Blue Magic'].dex      = set_combine(sets.midcast['Blue Magic'].phys, { })
  sets.midcast['Blue Magic'].vit      = set_combine(sets.midcast['Blue Magic'].phys, { })
  sets.midcast['Blue Magic'].agi      = set_combine(sets.midcast['Blue Magic'].phys, { })
  sets.midcast['Blue Magic'].phys_int = set_combine(sets.midcast['Blue Magic'].phys, { })
  sets.midcast['Blue Magic'].phys_mnd = set_combine(sets.midcast['Blue Magic'].phys, { })
  sets.midcast['Blue Magic'].phys_chr = set_combine(sets.midcast['Blue Magic'].phys, { })
  sets.midcast['Blue Magic'].hp       = set_combine(sets.midcast['Blue Magic'].phys, { })
  -- all mag spells need to prioritize some amount of int
  sets.midcast['Blue Magic'].mab = set_combine(sets.midcast['Blue Magic'], 
  {                                                                     --| MAB |
    main = "Maxentius",--|  21 |
    sub  = "Kaja Rod", -- Bunzi's Rod--|  18 |
    ammo = "Mavi Tathlum", -- Pemphredo Tathlum--|  21 |
    head = "", -- empty because cohort cloak--|   0 |
    body = "Cohort Cloak +1",--| 100 |
    hands= gear.blueglenn.amalric.hands,--|  21 |
    legs = gear.blueglenn.blu.relic.legs,--|  21 |
    feet = gear.blueglenn.jhakri.feet, -- gear.blueglenn.amalric.feet,--|  21 |
    neck = "Sanctity Necklace",--|  21 |
    waist= "Eschan Stone",  -- Orpheus's Sash--|  21 |
    ear1 = "Novio Earring", -- Regal Earring--|  21 |
    ear2 = "Friomisi Earring",--|  21 |
    ring1= "Shiva Ring +1",--|  21 |
    ring2= "Acumen Ring",--|  21 |
    back = gear.blueglenn.blu.capes.int_mab,--|  21 |
  })
  sets.midcast['Blue Magic'].mag_int  = set_combine(sets.midcast['Blue Magic'].mab, { })
  sets.midcast['Blue Magic'].mag_dark = set_combine(sets.midcast['Blue Magic'].mab, 
  {                                          -- DARK: | MAB | SKILL | MACC |
    head ="Pixie Hairpin +1",                       --|  28 |     0 |    0 |
    body = gear.blueglenn.amalric.body,             --|   0 |    20 |    0 |
    ring1= "Archon Ring",                           --|   5 |     0 |    5 |
    ring2= "Evanescence Ring",                      --|   0 |    10 |    0 |
  })                                                --|  33 |    30 |    5 |
  sets.midcast['Blue Magic'].mag_light= set_combine(sets.midcast['Blue Magic'].mab, { })
  sets.midcast['Blue Magic'].mag_mnd  = set_combine(sets.midcast['Blue Magic'], { })
  sets.midcast['Blue Magic'].mag_chr  = set_combine(sets.midcast['Blue Magic'], { })
  sets.midcast['Blue Magic'].mag_vit  = set_combine(sets.midcast['Blue Magic'], { })
  sets.midcast['Blue Magic'].mag_dex  = set_combine(sets.midcast['Blue Magic'], { })
  sets.midcast['Blue Magic'].mag_acc  = set_combine(sets.midcast['Blue Magic'], 
  {                                                 --| MACC |
    ammo = "Hydrocera",                             --|    6 |
    --head = gear.blueglenn.jhakri.head,              --|   44 |
    body = "Cohort Cloak +1",                       --|  100 |
    hands= gear.blueglenn.ayanmo.hands,             --|   43 |
    legs = gear.blueglenn.jhakri.legs,              --|   45 |
    feet = gear.blueglenn.jhakri.feet,              --|   42 |
    neck = gear.blueglenn.blu.neck,                 --|   20 |
    waist= "Eschan Stone",                          --|    7 |
    ear1 = "Crep. Earring",                         --|   10 |
    ear2 = "Hermetic Earring",                      --|    7 |
    ring1= "Stikini Ring +1",                       --|   11 |
    ring2= "Stikini Ring",                          --|    8 |
    back = gear.blueglenn.blu.capes.int_mab         --|   20 |
  })                                                --|  319 |
  sets.midcast['Blue Magic'].unbridled_spells = set_combine(sets.midcast['Blue Magic'].mag_acc, { })
  -- aaaaaaaaaand the rest
  sets.midcast['Blue Magic'].breath   = set_combine(sets.midcast['Blue Magic'], { })
  sets.midcast['Blue Magic'].phys_stun= set_combine(sets.midcast['Blue Magic'], { })
  sets.midcast['Blue Magic'].mag_stun = set_combine(sets.midcast['Blue Magic'], { })
  sets.midcast['Blue Magic'].heal     = set_combine(sets.midcast['Blue Magic'], { })
  sets.midcast['Blue Magic'].blu_skill= set_combine(sets.midcast['Blue Magic'],
  {                                                 --| SKILL |
    ammo = "Mavi Tathlum",                          --|     5 | 
    head = gear.blueglenn.blu.relic.head,           --|    17 |
    body = gear.blueglenn.blu.artifact.body,        --|    20 |
    hands= "Rawhide Gloves",                        --|    10 |
    legs = gear.blueglenn.blu.empyrean.legs,        --|    23 |
    feet = gear.blueglenn.blu.relic.feet,           --|    12 |
    neck = gear.blueglenn.blu.neck,                 --|    15 |
    ear2 = "Njordr Earring",                        --|    10 |
    ring1= "Stikini Ring +1",                       --|     8 |
    ring2= "Stikini Ring",                          --|     5 |
    back = gear.blueglenn.blu.capes.agi_eva_fc      --|     0 |
  })                                                --|   125 |
  sets.midcast['Blue Magic'].buff     = set_combine(sets.midcast['Blue Magic'], { })
  sets.midcast['Blue Magic'].refresh  = set_combine(sets.midcast['Blue Magic'], { })
end

---------------------------------
-- gearswap hooks 
---------------------------------
function job_buff_change(buff, gain) 
  -- Is triggered every time you either recieve a buff, or one wears off
  -- buff is the name of the buff, and gain is true if you are getting the buff, and false if the buff is wearing off

  if buff:lower() == 'boost' then
    if not gain then
      resetFantodCounter()
    end
  end

end 

function job_midcast(spell, action, spellMap, eventArgs)
  if spell.type == 'BlueMagic' then
    local setName = getBlueMagicSet(spell.english)
    if setName ~= '' then 
      local fullPath = sets.midcast['Blue Magic'][setName]
      if fullPath == nil then 
        windower.add_to_chat(028, 'WARNING: Blue Magic set: ' .. setName .. ' was not found!')
        return
      end
      windower.add_to_chat(069, '<-- '..spell.english..' | '..setName..' -->')
      equip(fullPath)
    end
  end
end

function job_aftercast(spell, action)
  windower.add_to_chat(028, spell.english)
  if spell.english:lower() == 'fantod' and not spell.interrupted then
    incrementFantodCounter(1)
  end
end

function job_state_change(field, newValue, oldValue)
  -- EngagedMode changed
  if state.OffenseMode:contains(newValue) and newValue ~= oldValue then
    equip(sets.engaged[newValue])
  end
end

---------------------------------
-- my functions 
---------------------------------
function incrementFantodCounter(by)
  windower.add_to_chat(info.fantodCounter)
  if (info.fantodCounter <= 10) then
    info.fantodCounter = info.fantodCounter + by
  end
  reportFantodCounter()
end

function reportFantodCounter()
  windower.add_to_chat(028, 'Fantod Counter: '..info.fantodCounter)
end

function resetFantodCounter()
  info.fantodCounter = 0 
  reportFantodCounter()
end

function getBlueMagicSet(spellName)
  for tableName, table in pairs(blueMagicTables) do
    for tableSpell,_  in pairs(table) do
      if tostring(tableSpell):lower() == tostring(spellName):lower() then return tostring(tableName) end
    end
  end
  return ''
end

function loadBlueMagicTables()
  return {
    -- Mappings for gear sets to use for various blue magic spells.
    
    -- While Str isn't listed for each, it's generally assumed as being at least
    --    moderately signficant, even for spells with other mods.

    -- Physical spells with no particular (or known) stat mods
    phys = S{
      'Bilgestorm',
    },
    -- Spells with heavy accuracy penalties, that need to prioritize accuracy first.
    phys_acc = S{
      'Heavy Strike',
    },
    -- Physical spells with Str stat mod
    str = S{
      'Battle Dance',
      'Bloodrake',
      'Death Scissors',
      'Dimensional Death',
      'Empty Thrash',
      'Quadrastrike',
      'Saurian Slide',
      'Sinker Drill',
      'Spinal Cleave',
      'Sweeping Gouge',
      'Uppercut',
      'Vertical Cleave',
    },
    -- Physical spells with Dex stat mod
    dex = S{
      'Amorphic Spikes',
      'Asuran Claws',
      'Barbed Crescent',
      'Claw Cyclone',
      'Disseverment',
      'Foot Kick',
      'Frenetic Rip',
      'Goblin Rush',
      'Hysteric Barrage',
      'Paralyzing Triad',
      'Seedspray',
      'Sickle Slash',
      'Smite of Rage',
      'Terror Touch',
      'Thrashing Assault',
      'Vanity Dive',
    },
    -- Physical spells with Vit stat mod
    vit = S{
      'Body Slam',
      'Cannonball',
      'Delta Thrust',
      'Glutinous Dart',
      'Grand Slam',
      'Power Attack',
      'Quad. Continuum',
      'Sprout Smack',
      'Sub-zero Smash',
    },
    -- Physical spells with Agi stat mod
    agi = S{
      'Benthic Typhoon',
      'Feather Storm',
      'Helldive',
      'Hydro Shot',
      'Jet Stream',
      'Pinecone Bomb',
      'Spiral Spin',
      'Wild Oats',
    },
    -- Physical spells with Int stat mod
    phys_int = S{
      'Mandibular Bite',
      'Queasyshroom',
    },
    -- Physical spells with Mnd stat mod
    phys_mnd = S{
      'Ram Charge',
      'Screwdriver',
      'Tourbillion',
    },
    -- Physical spells with Chr stat mod
    phys_chr = S{
      'Bludgeon',
    },
    -- Physical spells with HP stat mod
    hp = S{
      'Final Sting',
    },
    -- Magical spells with the typical Int mod
    mag_int = S{
      'Anvil Lightning',
      'Blastbomb',
      'Blazing Bound',
      'Bomb Toss',
      'Cursed Sphere',
      'Droning Whirlwind',
      'Embalming Earth',
      'Entomb',
      'Firespit',
      'Foul Waters',
      'Ice Break',
      'Leafstorm',
      'Maelstrom',
      'Molting Plumage',
      'Nectarous Deluge',
      'Regurgitation',
      'Rending Deluge',
      'Scouring Spate',
      'Silent Storm',
      'Spectral Floe',
      'Subduction',
      'Tem. Upheaval',
      'Water Bomb',
    },
    mag_dark = S{
      'Dark Orb',
      'Death Ray',
      'Eyes On Me',
      'Evryone. Grudge',
      'Palling Salvo',
      'Tenebral Crush',
    },
    mag_light = S{
      'Blinding Fulgor',
      'Diffusion Ray',
      'Radiant Breath',
      'Rail Cannon',
      'Retinal Glare',
    },
    -- Magical spells with a primary Mnd mod
    mag_mnd = S{
      'Acrid Stream',
      'Magic Hammer',
      'Mind Blast',
    },
    -- Magical spells with a primary Chr mod
    mag_chr = S{
      'Mysterious Light',
    },
    -- Magical spells with a Vit stat mod (on top of Int)
    mag_vit = S{
      'Thermal Pulse',
    },
    -- Magical spells with a Dex stat mod (on top of Int)
    mag_dex = S{
      'Charged Whisker',
      'Gates of Hades',
    },
    -- Magical spells (generally debuffs) that we want to focus on magic accuracy over damage.
    -- Add Int for damage where available, though.
    mag_acc = S{
      '1000 Needles',
      'Absolute Terror',
      'Actinic Burst',
      'Atra. Libations',
      'Auroral Drape',
      'Awful Eye',
      'Blank Gaze',
      'Blistering Roar',
      'Blood Saber',
      'Chaotic Eye',
      'Cimicine Discharge',
      'Cold Wave',
      'Corrosive Ooze',
      'Demoralizing Roar',
      'Digest',
      'Dream Flower',
      'Enervation',
      'Feather Tickle',
      'Filamented Hold',
      'Frightful Roar',
      'Geist Wall',
      'Hecatomb Wave',
      'Infrasonics',
      'Jettatura',
      'Light of Penance',
      'Lowing',
      'Mind Blast',
      'Mortal Ray',
      'MP Drainkiss',
      'Osmosis',
      'Reaving Wind',
      'Sandspin',
      'Sandspray',
      'Sheep Song',
      'Soporific',
      'Sound Blast',
      'Stinking Gas',
      'Sub-zero Smash',
      'Venom Shell',
      'Voracious Trunk',
      'Yawn',
    },
    -- Breath-based spells
    breath = S{
      'Bad Breath',
      'Flying Hip Press',
      'Frost Breath',
      'Heat Breath',
      'Hecatomb Wave',
      'Magnetite Cloud',
      'Poison Breath',
      'Self-Destruct',
      'Thunder Breath',
      'Vapor Spray',
      'Wind Breath',
    },
    -- Stun spells
    phys_stun = S{
      'Frypan',
      'Head Butt',
      'Sudden Lunge',
      'Tail slap',
      'Whirl of Rage',
    },
    mag_stun = S{
      'Blitzstrahl',
      'Temporal Shift',
      'Thunderbolt',
    },
    -- Healing spells
    heal = S{
      'Healing Breeze',
      'Magic Fruit',
      'Plenilune Embrace',
      'Pollen',
      'Restoral',
      'Wild Carrot',
    },
    -- spells that depend on blue magic skill
    blu_skill = S{
      'Barrier Tusk',
      'Diamondhide',
      'Magic Barrier',
      'Metallic Body',
      'Plasma Charge',
      'Pyric Bulwark',
      'Reactor Cool',
      'Occultation',
      'Cruel Joke',
    },
    -- Other general buffs
    buff = S{
      'Amplification',
      'Animating Wail',
      'Carcharian Verve',
      'Cocoon',
      'Erratic Flutter',
      'Exuviation',
      'Fantod',
      'Feather Barrier',
      'Harden Shell',
      'Memento Mori',
      'Nat. Meditation',
      'Orcish Counterstance',
      'Refueling',
      'Regeneration',
      'Saline Coat',
      'Triumphant Roar',
      'Warm-Up',
      'Winds of Promyvion',
      'Zephyr Mantle',
    },
    refresh = S{
      'Battery Charge',
    },
    -- Spells that require Unbridled Learning to cast.
    -- These need to be copied out into the proper areas.  I don't have a set for these, nor should i
    -- they don't all have the same modifiers
    unbridled_spells = S{
      'Absolute Terror',
      'Bilgestorm',
      'Blistering Roar',
      'Bloodrake',
      'Carcharian Verve',
      'Cesspool',
      'Crashing Thunder',
      'Droning Whirlwind',
      'Gates of Hades',
      'Harden Shell',
      'Mighty Guard',
      'Polar Roar',
      'Pyric Bulwark',
      'Tearing Gust',
      'Thunderbolt',
      'Tourbillion',
      'Uproot',
    },
  }
end