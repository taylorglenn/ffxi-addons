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
-- dislpay globals
---------------------------------
displaySettings = 
{ 
  pos = 
  {
    x = 0,
    y = 0
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
  -- built-in state tables
  state.IdleMode:options('Normal', 'Evasion Tanking')
  send_command('bind ^i gs c cycle IdleMode')

  state.OffenseMode:options('Normal')
  send_command('bind ^o gs c cycle OffenseMode')

  state.CastingMode:options('Normal', 'Force Clubs', 'Golden Entomb')
  send_command('bind ^c gs c cycle CastingMode')

  -- custom state tables
  state.AutoUnbridled = M{ 'false', 'true' }
  send_command('bind ^u gs c cycle AutoUnbridled')

  state.DisplayMode = M{ 'true', 'false'}

  drawDisplay() -- make sure this is directly after any state declarations
  ---------------------------------
  -- jse setup
  ---------------------------------
  gear.globals.blu = 
  {
    capes = 
    { 
      dex_crit= { name="Rosmerta's Cape", augments={'DEX+20','Accuracy+20 Attack+20','Crit.hit rate+10',}},
      str_att = { name="Rosmerta's Cape", augments={'STR+20','Accuracy+20 Attack+20','STR+10','Weapon skill damage +10%','Phys. dmg. taken-10%',}},
      int_mab_sird = { name="Rosmerta's Cape", augments={'INT+20','Mag. Acc+20 /Mag. Dmg.+20','Mag. Acc.+10','"Mag.Atk.Bns."+10','Spell interruption rate down-10%',}},
      agi_eva_fc = { name="Rosmerta's Cape", augments={'AGI+20','Eva.+20 /Mag. Eva.+20','INT+10','"Fast Cast"+10','Spell interruption rate down-10%',}},
    },

    neck = "Mirage Stole +1",

    artifact = 
    {  
      head  = "Assim. Keffiyeh +3",
      hands = "Assim. Bazu. +1",
      body  = "Assim. Jubbah +3",
      legs  = "Assim. Shalwar +3" 
    },

    relic = 
    {  
      head  = "Luh. Keffiyeh +3",
      body  = "Luhlaza Jubbah +3",
      hands = "Luh. Bazubands +3",
      legs  = "Luhlaza Shalwar +3",
      feet  = "Luhlaza Charuqs +3", 
    },

    empyrean = 
    {  
      head  = "Hashishin Kavuk +2",
      body  = "Hashishin Mintan +2",
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
  send_command('unbind ^c') -- unbinds CastingMode from c key
  send_command('unbind ^u') -- unbinds AutoUnbridled from u key
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
    ammo  = "Staunch Tathlum",
    head  = { name="Rawhide Mask", augments={'HP+50','Accuracy+15','Evasion+20',}},
    body  = gear.globals.blu.empyrean.body,
    hands = gear.globals.nyame.hands,
    legs  = gear.globals.carmine.legs,
    feet  = gear.globals.nyame.feet,
    neck  = "Bathy Choker +1",
    waist = "Flume Belt",
    ear1  = "Genmei Earring",
    ear2  = "Infused Earring",
    ring1 = "Defending Ring",
    ring2 = "Shneddick Ring",
    back  = "Moonbeam Cape", 
  }
  sets.idle.dt =  set_combine(sets.idle, 
  {
    head = gear.globals.nyame.head,
    body = gear.globals.nyame.body,
  })
  sets.idle['Evasion Tanking'] = set_combine(sets.idle, 
  {                                           --| EVA | MEVA | DT |
    ammo = "Amar Cluster",                    --|  10 |    0 |  0 |
    head = gear.globals.nyame.head,           --|  91 |  123 |  7 |
    body = gear.globals.nyame.body,           --| 102 |  139 |  9 |
    hands= gear.globals.nyame.hands,          --|  80 |  112 |  7 |
    legs = gear.globals.nyame.legs,           --|  85 |  150 |  8 |
    feet = gear.globals.nyame.feet,           --| 119 |  150 |  7 |
    neck = "Bathy Choker +1",                 --|  15 |    0 |  0 |
    waist= "Carrier's Sash",                  --|   0 |    0 |  0 |
    ear1 = "Eabani Earring",                  --|  15 |    8 |  0 |
    ear2 = "Infused Earring",                 --|  10 |    0 |  0 |
    ring1= "Defending Ring",                  --|   0 |    0 | 10 |
    ring2= "Gelatinous Ring +1",              --|   0 |    0 |  7 |
    back = gear.globals.blu.capes.agi_eva_fc  --|  25 |   20 |  0 |
  })                                          --| 552 |  694 | 55 |

  ---------------------------------
  -- Melee
  ---------------------------------
  sets.engaged = 
  {  
    ammo  = "Coiste Bodhar",
    head  = gear.globals.adhemar.head,
    body  = gear.globals.adhemar.body,
    hands = "Malignance Gloves",
    legs  = "Samnuha Tights",
    feet  = gear.globals.herculean.feet.ta_att,
    neck  = gear.globals.blu.neck,
    waist = "Reiki Yotai",
    ear1  = "Dedition Earring",
    ear2  = "Suppanomimi",
    ring1 = "Epona's Ring",
    ring2 = "Chirich Ring +1",
    back  = gear.globals.blu.capes.dex_crit, 
  }

  ---------------------------------
  -- Weapon Skills
  ---------------------------------
  -- Default
  sets.precast.WS = 
  {
    ammo = "Aurgelmmir Orb",
    head = gear.globals.blu.empyrean.head,
    body = gear.globals.blu.artifact.body,
    legs = gear.globals.blu.relic.legs,
    neck = "Fotia Gorget",
    waist= "Fotia Belt",
    ring1= "Epaminondas's Ring",
    ear1 = "Ishvara Earring",
    ear2 = gear.globals.moonshade,
    back = gear.globals.blu.capes.str_att,
  }
  -- Savage Blade: Sword - Physical - 50% STR / 50% MND - Dynamic fTP: 4.0 / 10.25 / 13.75
  sets.precast.WS["Savage Blade"] = set_combine(sets.precast.WS, 
  { 
    body = gear.globals.gleti.body,
    hands= gear.globals.jhakri.hands,
    legs = gear.globals.gleti.legs,
    feet = gear.globals.jhakri.feet,
    neck = gear.globals.blu.neck,
    ear1 = "Ishvara Earring",
    waist= "Sailfi Belt +1"
  })
  -- Expiacion: Sword - Physical - 30% STR / 30% INT / 20% DEX - Dynamic fTP: 3.8 / 9.4 / 12.2
  sets.precast.WS["Expiacion"] = set_combine(sets.precast.WS["Savage Blade"], {
    ammo = "Oshasha's treatise",
    body = gear.globals.blu.artifact.body,
    legs = gear.globals.blu.relic.legs
  })
  -- Chant du Cygne: Sword - Physical - 80% DEX - Static fTP @ 1.63 - Crit Rate @ 1k/2k/3k = 15%/25%/40%
  sets.precast.WS['Chant du Cygne'] = set_combine(sets.precast.WS, 
  {
    head = gear.globals.adhemar.head,
    body = gear.globals.gleti.body,
    hands= gear.globals.adhemar.hands,
    legs = gear.globals.gleti.legs,
    feet = gear.globals.gleti.feet,
    neck = gear.globals.blu.neck,
    ear1 = "Mache Earring +1",
    ring1= "Epona's Ring",
    ring2= "Ilabrat Ring",
    back = gear.globals.blu.capes.dex_crit,
  })
  -- Requeiescat: Sword - Physical - 73~85% MNK - Static fTP @ 1.0 - Attack Power @ 1k/2k/3k = -20%/-10%/-0%
  sets.precast.WS['Requeiescat'] = set_combine(sets.precast.WS, 
  {
    head = gear.globals.blu.relic.head,
    body = gear.globals.blu.relic.body,
    hands= gear.globals.blu.relic.hands,
    legs = gear.globals.gleti.legs,
    feet = gear.globals.blu.relic.feet,
    ear1 = "Brutal earring",
    ring1= "Epona's Ring",
  })
  -- Sangine Blade: Sword - Magical (Dark) - 50% MND / 30% STR - Static fTP @ 2.75 - HP Drained @ 1k/2k/3k = 50%/100%/160%
  sets.precast.WS["Sanguine Blade"] = set_combine(sets.precast.WS, 
  {
    head = "Pixie Hairpin +1",
    body = gear.globals.amalric.body,
    hands= gear.globals.jhakri.hands,
    feet = gear.globals.jhakri.feet, -- todo: amalric nails +1
    neck = "Sanctity Necklace",
    ear1 = "Firomisi Earring",
    ear2 = "Novio Earring",
    ring1= "Archon Ring",
    ring2= "Shiva Ring +1",
    back = gear.globals.blu.capes.agi_eva_fc
  })
  -- Vorpal Blade: Sword - Physical - 60% STR - Static fTP @ 1.375 - Crit chance vaires with TP (bg-wiki doesn't have values)
  sets.precast.WS["Vorpal Blade"] = set_combine(sets.precast.WS, 
  {
    head = gear.globals.gleti.head,
    body = gear.globals.gleti.body,
    hands= gear.globals.gleti.hands,
    feet = gear.globals.gleti.feet,
    ear1 = "Sherida Earring",
    ring1= "Epona's Ring",
    ring2= "Ilabrat Ring",
  })
  ---------------------------------
  -- Job Abilities
  ---------------------------------
  sets.precast.JA['Diffusion'] = { feet = gear.globals.blu.relic.feet, }
  ---------------------------------
  -- Spells
  ---------------------------------
  -- precast
  sets.precast.FC = 
  {                                           --| FC |  -- you get 20% by just setting erratic flutter
    ammo  = "Sapience Orb",                   --|  2 |
    head  = gear.globals.carmine.head,        --| 14 |
    body  = gear.globals.nyame.body,          --|    |
    hands = "Leyline Gloves",                 --|  6 | -- 5 base + 1 from augment
    legs  = gear.globals.psycloth.legs.fc,    --|  7 |
    feet  = gear.globals.carmine.feet,        --|  8 |
    neck  = "Voltsurge Torque",               --|  4 |
    waist = "Witful Belt",                    --|  3 |
    ear1  = "Loquac. Earring",                --|  2 |
    ear2  = "Enchntr. Earring +1",            --|  2 |
    ring1 = "Defending Ring",                 --|    |
    ring2 = "Gelatinous Ring +1",             --|    |
    back  = gear.globals.blu.capes.agi_eva_fc,--| 10 |
  }                                           --| 78 | -- 20% from setting erratic flutter -- 80% is cap

  -- try to keep these in the same order as the load_blue_magic_table function below.  For readability's sake
  sets.midcast.blue = 
  { 
    ammo  = "Mavi Tathlum",
    head  = gear.globals.jhakri.head,
    body  = gear.globals.amalric.body,
    hands = gear.globals.amalric.hands,
    legs  = gear.globals.jhakri.legs,
    feet  = gear.globals.jhakri.feet,
    neck  = "Sanctity Necklace",
    waist = "Eschan Stone",
    ear1  = "Novio Earring",
    ear2  = "Friomisi Earring",
    ring1 = "Shiva Ring +1",
    ring2 = "Acumen Ring",
    back  = "Cornflower Cape", 
  }
  -- all phys spells need to prioritize some amount of strength
  sets.midcast.blue.phys = set_combine(sets.midcast.blue, 
  {                                         -- | STR | Att |
    ammo = "Aurgelmir Orb",                 -- |   7 |  10 |
    head = gear.globals.blu.relic.head,     -- |  30 |  62 |
    body = gear.globals.blu.relic.body,     -- |  37 |  86 |
    hands= gear.globals.blu.relic.hands,    -- |  21 |  63 |
    legs = gear.globals.jhakri.legs,        -- |  47 |  45 |
    feet = gear.globals.blu.relic.feet,     -- |  22 |  86 |
    neck = gear.globals.blu.neck,
    waist= "Prosilio Belt +1",              -- |     |  28 |
    ear1 = "Telos Earring",                 -- |     |  10 |
    ear2 = "Tati Earring",                  -- |     |  15 |
    ring1= "Ifrit Ring",                    -- |   8 |     |
    ring2= "Apate Ring",                    -- |   6 |     |
    back = gear.globals.blu.capes.str_att,  -- |  30 |  20 |
  })                                        -- | 208 | 425 |
  -- all mag spells need to prioritize some amount of int
  sets.midcast.blue.mab = set_combine(sets.midcast.blue, 
  {                                             --| MAB |
    --main = "Maxentius",                       --|  21 |
    --sub  = "Kaja Rod",                        --|  18 |  "Bunzi's Rod", --|  35 |
    ammo = "Mavi Tathlum", -- Pemphredo Tathlum
    head = "", -- empty because cohort cloak
    body = "Cohort Cloak +1",                    --| 100 |
    hands= gear.globals.amalric.hands,         --|  53 |
    legs = gear.globals.blu.relic.legs,        --|  57 |
    feet = gear.globals.jhakri.feet,           --|  39 |  gear.globals.amalric.feet,--|  52 |
    neck = "Sanctity Necklace",                  --|  10 |  "Baetyl Pendant", --|  13 |
    waist= "Eschan Stone",                       --|   7 |  "Orpheus's Sash", --|   ? |
    ear1 = "Novio Earring",                      --|   7 |  "Regal Earring", --|   7 |
    ear2 = "Friomisi Earring",                   --|  10 |
    ring1= "Shiva Ring +1",                      --|   3 |
    ring2= "Acumen Ring",                        --|   4 |
    back = gear.globals.blu.capes.int_mab_sird,--|  10 |
  })                                             --| 339 |
  sets.midcast.blue.mag_dark = set_combine(sets.midcast.blue.mab, 
  {                                          -- DARK: | MAB | SKILL | MACC |
    head ="Pixie Hairpin +1",                       --|  28 |     0 |    0 |
    body = gear.globals.amalric.body,               --|   0 |    20 |    0 |
    ring1= "Archon Ring",                           --|   5 |     0 |    5 |
    ring2= "Evanescence Ring",                      --|   0 |    10 |    0 |
  })                                                --|  33 |    30 |    5 |
  sets.midcast.blue.mag_acc  = set_combine(sets.midcast.blue, 
  {                                                 --| MACC |
    ammo = "Hydrocera",                             --|    6 |
    head = gear.globals.blu.artifact.head,        --|   46 |
    body = gear.globals.amalric.body,             --|   53 |
    hands= gear.globals.ayanmo.hands,             --|   43 |
    legs = gear.globals.blu.artifact.legs,        --|   39 |
    feet = gear.globals.jhakri.feet,              --|   42 |
    neck = gear.globals.blu.neck,                 --|   20 |
    waist= "Eschan Stone",                          --|    7 |
    ear1 = "Crep. Earring",                         --|   10 |
    ear2 = "Hermetic Earring",                      --|    7 |
    ring1= "Stikini Ring +1",                       --|   11 |
    ring2= "Stikini Ring",                          --|    8 |
    back = gear.globals.blu.capes.int_mab_sird    --|   30 |
  })                                                --|  322 |
  sets.midcast.blue.additional_effect = set_combine(sets.midcast.blue.mag_acc, {
    ammo = "Falcon Eye", 
    head = gear.globals.carmine.head,
    body = gear.globals.jhakri.body,
    hands= gear.globals.jhakri.hands,
    legs = gear.globals.jhakri.legs,
    feet = gear.globals.blu.relic.feet
  })
  sets.midcast.blue.heal = set_combine(sets.midcast.blue, 
  {                                                   -- |  HP | Pot |
    head = gear.globals.telchine.head.hp_cure_pot,  -- |  44 |   8 |
    body = gear.globals.telchine.body.hp_cure_pot,  -- |  44 |   7 |
    hands= gear.globals.telchine.hands.enhancing_duration_sird,     -- |  40 |     |
    legs = gear.globals.telchine.legs.hp_cure_pot,  -- |  45 |   7 |
    feet = gear.globals.telchine.feet.enhancing_duration_sird,      -- |  35 |     |
    neck = "Unmoving Collar +1",                      -- | 200 |     |
    ring2= "Gelatinous Ring +1",                      -- | 100 |     |
    ear2 = "Odnowa Earring +1",                       -- | 110 |     |
    back = "Moonbeam Cape"                            -- | 250 |     |
  })                                                  -- | 868 |  22 |
  sets.midcast.blue.heal_self = set_combine(sets.midcast.blue.heal, 
  { 

  })
  sets.midcast.blue.blu_skill = set_combine(sets.midcast.blue,
  {                                                 --| SKILL | -- a mastered blue mage has 460 skill, + 1 skill per master level, 600 is the cap
    ammo = "Mavi Tathlum",                          --|     5 | 
    head = gear.globals.blu.relic.head,           --|    17 |
    body = gear.globals.blu.artifact.body,        --|    20 |
    hands= "Rawhide Gloves",                        --|    10 |
    legs = gear.globals.blu.empyrean.legs,        --|    23 |
    feet = gear.globals.blu.relic.feet,           --|    12 |
    neck = gear.globals.blu.neck,                 --|    15 |
    ear2 = "Njordr Earring",                        --|    10 |
    ring1= "Stikini Ring +1",                       --|     8 |
    ring2= "Stikini Ring",                          --|     5 |
    back = gear.globals.blu.capes.agi_eva_fc      --|     0 |
  })                                                --|   125 |
  sets.midcast.blue.sird = set_combine(sets.midcast.blue,  
  {                                                 -- | SIRD |
    ammo = "Staunch tathlum",                       -- |   10 |
    hands= gear.globals.telchine.hands.enhancing_duration_sird,   -- |    8 |
    legs = gear.globals.blu.artifact.legs,        -- |   22 |
    feet = gear.globals.telchine.feet.enhancing_duration_sird,    -- |    7 |
    waist= "Rumination Sash",                       -- |   10 |
    ear1 = "Halasz Earring",                        -- |    5 |
    ear2 = "Magnetic Earring",                      -- |    8 |
    ring2= "Evanescence Ring",                      -- |    5 |
    back = gear.globals.blu.capes.int_mab_sird    -- |   10 |
  })                                                -- |   85 | -- cap is 102

  sets.midcast.blue.goldenEntomb = set_combine(sets.midcast.blue, 
  {
    ammo  = "Per. Lucky Egg", -- TH+1
    head  = "Wh. Rarab Cap +1", -- TH+1
  })
end

---------------------------------
-- display stuff
---------------------------------
function drawDisplay()
  if (state.DisplayMode.value == 'false') then
    displayBox:hide()
    return
  end

  local INDENT = ' ':rep(3)
  local displayLines = L{}

  displayLines:append('[I]dle: '..state.IdleMode.value)
  displayLines:append('[O]ffense: '..state.OffenseMode.value)
  displayLines:append('[C]asting: '..state.CastingMode.value)
  displayLines:append('Auto [U]nbridled: '..state.AutoUnbridled.value)

  --displayBox:text(displayLines:concat('\\cr\n'))
  displayBox:text(displayLines:concat(' | '))
  displayBox:show()
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

function job_precast(spell, action, spellMap, eventArgs)
  autoUnbridled(spell, true)
end

function job_midcast(spell, action, spellMap, eventArgs)
  -- golden entomb
  if spell.name == 'Entomb' and state.CastingMode.value == 'Golden Entomb' then
    equip(sets.midcast.blue.goldenEntomb)
    return
  end

  -- otherwise
  if spell.type == 'BlueMagic' then
    local setName = getBlueMagicSet(spell.english)
    if setName ~= '' then 
      local fullPath = sets.midcast.blue[setName]
      if fullPath == nil then 
        windower.add_to_chat(028, 'WARNING: Blue Magic set: ' .. setName .. ' was not found!')
        equip(sets.midcast.blue)
        return
      end
      -- Inform the user 
      --windower.add_to_chat(069, '<-- '..spell.english..' | '..setName..' -->')
      -- If Force Clubs then equip clubs on cast of mab or mab_dark
      if (state.CastingMode.value == 'Force Clubs' and (setName == 'mab' or setName == 'mab_dark')) then
        equip({ main = "Maxentius", sub = "Kaja Rod" })
      end
      -- Finally, equip the full path on top
      equip(fullPath)
    end
  end
end

function job_aftercast(spell, action)
  if spell.english:lower() == 'fantod' and not spell.interrupted then
    incrementFantodCounter(1)
  end
end

function job_state_change(field, newValue, oldValue)
  -- EngagedMode changed
  --if state.OffenseMode:contains(newValue) and newValue ~= oldValue then
    --equip(sets.engaged[newValue])
  --end
end

function job_state_change(field, newValue, oldValue)
  -- any mode changed
  drawDisplay()
end

---------------------------------
-- my functions 
---------------------------------
function autoUnbridled(spell, diffusion) -- TODO: we don't want to use diffusion on offensive spells
  local unbridledSpells = 
  S{
    -- Buffs
    'Harden Shell',
    'Carcharian Verve',
    'Mighty Guard',
    -- Not Buffs
    'Thunderbolt',
    'Absolute Terror',
    'Gates of Hades',
    'Tourbillion',
    'Pyric Bulwark',
    'Blistering Roar',
    'Cesspool',
    'Crashing Thunder',
    'Cruel Joke',
    'Droning Whirlwind',
    'Polar Roar',
    'Tearing Gust',
    'Uproot',
    'Bilgestorm',
    'Bloodrake'
  }
  local self = windower.ffxi.get_player()
  local isUnbridledSpell = unbridledSpells:contains(spell.english)
  local recastTimers = windower.ffxi.get_ability_recasts()
  local isUnbridledLearningOnCooldown = recastTimers[81] > 0 -- 81 is code for Unbridled Learning 

  local isUnbridledLearningUp = false
  for i,v in pairs(self.buffs) do
    if v == 485 or v == 505 then -- 485 is UnbridledLearning, 505 is UnbridledWisdom
      isUnbridledLearningUp = true
      return
    end
  end

  if isUnbridledLearningUp then return end -- buff is already up, gtfo

  if isUnbridledSpell and isUnbridledLearningOnCooldown then cancel_spell() return end -- failsafe for when running easyfarm

  if 
    isUnbridledSpell and 
    state.AutoUnbridled.value == 'true' and
    not isUnbridledLearningOnCooldownthen and
    not isUnbridledLearningUp
  then
    windower.add_to_chat(123, "Auto Unbridled: Attempting to use Unbridled Learning")
    cast_delay(1.1)
    send_command('@input /ja "Unbridled Learning" <me>')
  end
end

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
      'Amorphic Spikes',
      'Asuran Claws',
      'Battle Dance',
      'Benthic Typhoon',
      'Bilgestorm',
      'Bloodrake',
      'Bludgeon',
      'Body Slam',
      'Cannonball',
      'Claw Cyclone',
      'Death Scissors',
      'Dimensional Death',
      'Disseverment',
      'Empty Thrash',
      'Feather Storm',
      'Final Sting',
      'Foot Kick',
      'Frenetic Rip',
      'Frypan',
      'Glutinous Dart',
      'Goblin Rush',
      'Grand Slam',
      'Head Butt',
      'Heavy Strike',
      'Helldive',
      'Hydro Shot',
      'Hysteric Barrage',
      'Jet Stream',
      'Mandibular Bite',
      'Pinecone Bomb',
      'Power Attack',
      'Quad. Continuum',
      'Quadrastrike',
      'Queasyshroom',
      'Ram Charge',
      'Saurian Slide',
      'Screwdriver',
      'Seedspray',
      'Sickle Slash',
      'Sinker Drill',
      'Smite of Rage',
      'Spinal Cleave',
      'Spiral Spin',
      'Sprout Smack',
      'Sudden Lunge',
      'Tail Slap',
      'Terror Touch',
      'Thrashing Assault',
      'Uppercut',
      'Vanity Dive',
      'Vertical Cleave',
      'Whirl of Rage',
      'Wild Oats',
    },

    mab = S{
      'Acrid Stream',
      'Anvil Lightning',
      'Blastbomb',
      'Blazing Bound',
      'Blinding Fulgor',
      'Blitzstrahl',
      'Blood Drain',
      'Bomb Toss',
      'Cesspool',
      'Charged Whisker',
      'Crashing Thunder',
      'Cursed Sphere',
      'Diffusion Ray',
      'Droning Whirlwind',
      'Embalming Earth',
      'Entomb',
      'Firespit',
      'Foul Waters',
      'Gates of Hades',
      'Ice Break',
      'Leafstorm',
      'Light of Penance',
      'Maelstrom',
      'Magic Hammer',
      'Mighty Guard',
      'Molting Plumage',
      'Mysterious Light',
      'Nectarous Deluge',
      'Polar Roar',
      'Rail Cannon',
      'Regurgitation',
      'Rending Deluge',
      'Retinal Glare',
      'Scouring Spate',
      'Searing Tempest',
      'Self-Destruct',
      'Silent Storm',
      'Spectral Floe',
      'Subduction',
      'Tearing Gust',
      'Tem. Upheaval',
      'Temporal Shift',
      'Thermal Pulse',
      'Thunderbolt',
      'Uproot',
      'Water Bomb',
      'White Wind',
    },

    mag_dark = S{
      'Dark Orb',
      'Death Ray',
      'Eyes On Me',
      'Evryone. Grudge',
      'Palling Salvo',
      'Tenebral Crush',
    }, 

    -- Spells (generally debuffs) that we want to focus on magic accuracy over damage.
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
      'Soporific',
      'Sound Blast',
      'Stinking Gas',
      'Sub-zero Smash',
      'Venom Shell',
      'Voracious Trunk',
      'Yawn',
    }, 
    additional_effect = S{
      'Paralyzing Triad', -- 20% potency paralyze
      'Delta Thrust', -- 100/tick plague
      'Barbed Crescent', -- 30 accuracy down
      'Sweeping Gouge', -- 16% defense down
      'Tourbillion',
    },
    -- Healing spells
    heal = S{
      'Healing Breeze',
      'Magic Fruit',
      'Plenilune Embrace',
      'Pollen',
      'Wild Carrot',
      'White Wind'
    }, 
    heal_self = S{
      'Restoral',
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
      
    breath = S{
      'Bad Breath',
      'Flying Hip Press',
      'Frost Breath',
      'Heat Breath',
      'Hecatomb Wave',
      'Magnetite Cloud',
      'Poison Breath',
      'Radiant Breath',
      'Thunder Breath',
      'Vapor Spray',
      'Wind Breath',      
    }, 
           
    sird = S{
      -- Stuns
      'Blitzstrahl', -- magic
      'Frypan', -- physical
      'Head Butt', -- physical
      'Sudden Lunge', -- physical
      'Tail slap', -- physical
      'Temporal Shift', -- magic
      'Thunderbolt', -- magic
      'Whirl of Rage', -- physical

      -- Debuffs
      "Dream Flower", -- dark-based sleep
      "Sheep Song", -- light-based sleep

      -- Buffs
      'Amplification',
      'Animating Wail',
      'Battery Charge',
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
  }
end