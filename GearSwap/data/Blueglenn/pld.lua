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
set_lockstyle(10)

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
set_macros(1, 6)

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
-- constants
---------------------------------
FAST_PANTS_THRESHOLD = 80 -- this is a percentage of your max health

---------------------------------
-- user setup 
---------------------------------
function user_setup() 
  state.IdleMode:options('Normal', 'meva')
  send_command('bind ^i gs c cycle IdleMode')

  state.OffenseMode:options('Normal', 'mdt', 'hybrid')
  send_command('bind ^o gs c cycle OffenseMode')

  state.CastingMode:options('Normal', 'SIRD')
  send_command('bind ^c gs c cycle CastingMode')

  drawDisplay()

  ---------------------------------
  -- jse setup
  ---------------------------------
  gear.globals.pld = 
  {
    capes = 
    { 
      enmity = { name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+2','Enmity+10','Chance of successful block +5',}},
      meva = {}, --HP+60, M.Eva/Eva+20, M.Eva+10, Resist All+10%
      fast_cast = { name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','"Fast Cast"+10','Phys. dmg. taken-10%',}},
      cure = {}, -- HP+60, M.Eva/Eva+20, M.Eva+10, Cure Pot+10%, PDT-10%
      hybrid = {}, -- HP60, acc/att20, acc10, stp10, resistall10
    },
    
    neck = "Kgt. Beads +1",

    artifact = 
    {  
      head  = "Rev. Coronet",
      body  = "Rev. Surcoat",
      hands = "Rev. Gauntlets",
      legs  = "Rev. Breeches",
      feet  = "Rev. Leggings" 
    },

    relic = 
    {     
      head  = "Cab. Coronet",
      body  = "Cab. Surcoat",
      hands = "Cab. Gauntlets +3",
      legs  = "Cab. Breeches",
      feet  = "Cab. Leggings" 
    },

    empyrean = 
    {  
      head  = "Chev. Armet",
      body  = "Chev. Cuirass",
      hands = "Chev. Gauntlets",
      legs  = "Chev. Cuisses",
      feet  = "Chev. Sabatons" 
    }
  }
end

---------------------------------
-- user unload
---------------------------------
function user_unload()
  -- unload keybinds
  send_command('unbind ^i') -- unbinds IdleMode from i key
  send_command('unbind ^o') -- unbinds OffenseMode from o key
  send_command('unbind ^s') -- unbinds CastingMode from s key
end

---------------------------------
-- job setup 
---------------------------------
function job_setup()
  windower.raw_register_event('hp change', determineFastPants)
end

---------------------------------
-- define gear sets
---------------------------------
function init_gear_sets()
  ---------------------------------
  -- template
  ---------------------------------
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
  sets.idle = -- we are stacking M.Eva and M.Resist here.  Nyame over Sakpata for extra INT and MND towards this end.
  { 
    ammo  = "Staunch Tathlum", --2 dt
    head  = gear.globals.nyame.head, --7 dt
    body  = gear.globals.nyame.body, --9 dt
    hands = gear.globals.nyame.hands, --7 dt
    legs  = gear.globals.nyame.legs, -- 8 dt
    feet  = gear.globals.nyame.feet, --7 dt
    neck  = "Moonlight Necklace",
    ear1  = "Etiolation Earring", --3 mdt
    ear2  = "Cryptic Earring",
    ring1 = "Defending Ring", --10 dt
    ring2 = "Vengeful Ring", 
    back  = gear.globals.pld.capes.enmity,
    waist = "Flume Belt",
  } -- 50 dt 

  sets.idle.meva = 
  set_combine(                              -- +------+------+------+------+------+------+------+------+------+
    sets.idle,                              -- |  pdt |  mdt | meva |  mdb | sird | emty |   hp |  int |  mnd |
    {                                       -- +------+------+------+------+------+------+------+------+------+
      ammo  = "Staunch Tathlum",            -- |    3 |    3 |      |      |   11 |      |      |      |      |
      head  = gear.globals.nyame.head,      -- |    7 |    7 |  123 |    5 |      |      |   91 |   28 |   26 |
      body  = gear.globals.nyame.body,      -- |    9 |    9 |  139 |    8 |      |      |  136 |   42 |   37 |
      hands = gear.globals.nyame.hands,     -- |    7 |    7 |  112 |    4 |      |      |   91 |   28 |   40 |
      legs  = gear.globals.nyame.legs,      -- |    8 |    8 |  150 |    7 |      |      |  114 |   44 |   32 |
      feet  = gear.globals.nyame.feet,      -- |    7 |    7 |  150 |    5 |      |      |   68 |   25 |   26 |
      neck  = "Moonlight Necklace",         -- |      |      |   15 |      |   15 |   15 |      |      |      |
      ear1  = "Eabani Earring",             -- |      |      |    8 |      |      |      |   45 |      |      |
      ear2  = "Flashward Earring",          -- |      |      |    8 |      |      |      |      |      |    2 |
      ring1 = "Vengeful Ring",              -- |      |      |    9 |      |      |    3 |   20 |      |      |
      ring2 = "Purity Ring",                -- |      |    4 |   10 |      |      |      |      |      |      |
      back  = gear.globals.pld.capes.meva,  -- |      |      |   30 |      |      |      |   60 |      |      |
      waist = "Carrier's Sash"              -- |      |      |      |      |      |      |   20 |      |      |
    }                                       -- +------+------+------+------+------+------+------+------+------+
  )                                         -- |   41 |   45 |  754 |   29 |   26 |   18 |  645 |  166 |  163 |
                                            -- +------+------+------+------+------+------+------+------+------+
  sets.idle.Town = 
  set_combine(
    sets.idle, 
    {
      legs = gear.globals.carmine.legs
    }
  )
  ---------------------------------
  -- enmity set
  ---------------------------------
  sets.enmity =
  {                                           -- | enmity |
    ammo = "Sapience Orb",                    -- |      2 |
    head = gear.globals.souveran.head,        -- |      9 |
    body = gear.globals.souveran.body,        -- |     20 |
    hands= gear.globals.souveran.hands,       -- |      9 |
    legs = gear.globals.souveran.legs,        -- |      9 |
    feet = gear.globals.eschite.feet.enmity,  -- |     15 |
    neck = "Moonlight Necklace",              -- |     15 |
    ear1 = "Friomisi Earring",                -- |      2 |
    ear2 = "Cryptic Earring",                 -- |      4 |
    ring1= "Supershear Ring",                 -- |      5 |
    ring2= "Eihwaz Ring",                     -- |      5 |
    back = gear.globals.pld.capes.enmity,     -- |     10 |
    waist= "Creed Baudrier",                  -- |      5 |
  }                                           -- |    110 |
  ---------------------------------
  -- engaged
  ---------------------------------
  sets.engaged = 
    set_combine(
      sets.enmity,
      {
      }
    )
  sets.engaged.mdt = 
    set_combine(
      sets.engaged, 
      {
      }
    )
  sets.engaged.hybrid = 
    set_combine(
      sets.engaged,
      {
        ammo = "Aurgelmmir Orb",
        head = gear.globals.sakpata.head,
        body = gear.globals.sakpata.body,
        hands= gear.globals.sakpata.hands,
        legs = gear.globals.sakpata.legs,
        feet = gear.globals.sakpata.feet,
        neck = "Moonlight Necklace",
        ear1 = "Odnowa Earring +1",
        ear2 = "Cessance Earring",
        ring1= "Chirich Ring +1",
        ring2= "Petrov Ring",
        waist= "Sailfi Belt +1",
      }
    )
  ---------------------------------
  -- weapon skills
  ---------------------------------
  sets.precast.WS = 
  {
    ammo = "Aurgelmir Orb",
    body = "Hjarrandi Breast.",
    hands= gear.globals.valorous.hands.wsd,
    feet = gear.globals.valorous.feet.wsd,
    neck = "Fotia Gorget",
    ear1 = gear.globals.moonshade,
    --back = wsd cape?  worth an inv slot?
    waist= "Fotia Belt",
  }
  sets.precast.WS['Knights of Round'] = 
    set_combine(
      sets.precast.WS,
      {
        
      }
    )
  sets.precast.WS['Chant du Cygne'] = 
    set_combine(
      sets.precast.WS, 
      {
        head  = gear.globals.lustratio.head,
        legs  = gear.globals.lustratio.legs,
        feet  = gear.globals.lustratio.feet,
      }
    )
  sets.precast.WS['Atonement'] = 
    set_combine(
      sets.enmity,
      {
        ear1 = gear.globals.moonshade,
        waist= "Fotia Belt"
      }
    )
  -- Requiescat: Sword - Physical - 85% MND - Static fTP: 1.0 - TP modifies attack power reduction: -20% / -10% / -0%
  sets.precast.WS['Requiescat'] = 
    set_combine(
      sets.precast.WS, 
      {
        head = "Hijarrandi Helm",
        body = gear.globals.sakpata.body,
        hands= gear.globals.sakpata.hands,
        legs = gear.globals.sakpata.legs,
        feet = gear.globals.sakpata.feet,
        ear2 = "Cessance Earring",
        ring1= "Petrov Ring",
        ring2= "Regal Ring", -- todo
      }
    )
  -- Savage Blade: Sword - Physical - 50% STR / 50% MND - Dynamic fTP: 4.0 / 10.25 / 13.75
  sets.precast.WS["Savage Blade"] = -- 229 str, 90 mnd
    set_combine(
      sets.precast.WS, 
      { 
        head  = gear.globals.lustratio.head,  -- 39 str + 8 str
        body  = gear.globals.sakpata.body,    -- 42 str, 28 mnd
        hands = gear.globals.sakpata.hands,   -- 24 str, 33 mnd
        legs  = gear.globals.sakpata.legs,    -- 48 str, 21 mnd
        feet  = gear.globals.lustratio.feet,  -- 32 str + 15 str
        neck  = gear.globals.pld.neck,
        ring1 = "Apate Ring",                   -- 6 str (jam a regal ring in here when you get it)
        ring2 = "Stikini Ring +1",              -- 8 mnd
        wasit = "Sailfi Belt +1",               -- 15 str
      }
    )
  -- Torcleaver: Greatsword - Physical - 80% VIT - Dynamic fTP: 4.75 / 7.5 / 9.77
  sets.precast.WS['Torcleaver'] = 
    set_combine(
      sets.precast.WS, 
      {
        ammo = "Aurgelmir Orb",
        head = gear.globals.sakpata.head,
        body = gear.globals.sakpata.body,
        hands= gear.globals.sakpata.hands,
        legs = gear.globals.sakpata.legs,
        feet = gear.globals.sakpata.feet,
        ear2 = "Mache Earring +1",
        ring1= "Supershear Ring",
        ring2= "Petrov Ring",
      }
    )
  ---------------------------------
  -- abilities
  ---------------------------------
  sets.precast.JA['Shield Bash']  = { hands= gear.globals.pld.relic.hands }
  sets.precast.JA['Invincible']   = { legs = gear.globals.pld.relic.legs }
  sets.precast.JA['Holy Circle']  = { feet = gear.globals.pld.artifact.feet }
  sets.precast.JA['Sentinel']     = { feet = gear.globals.pld.relic.feet }
  sets.precast.JA['Cover']        = { head = gear.globals.pld.artifact.head, body = gear.globals.pld.relic.body }
  sets.precast.JA['Rampart']      = { head = gear.globals.pld.relic.head }
  sets.precast.JA['Fealty']       = { body = gear.globals.pld.relic.body }
  sets.precast.JA['Chivalry']     = { hands= gear.globals.pld.relic.hands }
  sets.precast.JA['Divine Emblem']= { feet = gear.globals.pld.empyrean.feet }
  ---------------------------------
  -- precast
  ---------------------------------
  sets.precast.FC = 
  {                                           -- | FC |
    ammo = "Sapience Orb",                    -- |  2 |
    head = gear.globals.carmine.head,         -- | 14 |
    --body = gear.globals.pld.artifact.body,  -- |  5 | +5% at +2, +10% at +3
    --hands= "Leyline Gloves",                -- |  5 |
    --legs = gear.globals.eschite.legs.fc,    -- |  5 |
    feet = gear.globals.odyssean.feet.fc,     -- | 11 |
    --ear1 = "Enchntr. Earring +1",           -- |  2 |
    --ear2 = "Loquac. Earring",               -- |  2 |
    --ring1= "Prolix Ring",                   -- |  2 |
    --ring2= "Kishar Ring",                   -- |  4 |
    back = gear.globals.pld.capes.fast_cast,  -- | 10 |
  }                                           -- | 57 |
  ---------------------------------
  -- midcast
  ---------------------------------
  sets.midcast = sets.enmity
  -- Cure --
  sets.midcast['Cure'] = 
    set_combine(
      sets.enmity,
      {
        ring1 = "Vexer Ring +1",
      }
    )
  sets.midcast['Cure'].SIRD = 
    set_combine(
      sets.midcast.Cure,
      {
        ammo = "Staunch Tathlum",
        legs = "Founder's Hose",
        neck = "Moonlight Necklace",
        ring1= "Gelatinous Ring +1",
        waist= "Audumbla Sash"
      }
    )
  -- Flash --
  sets.midcast['Flash'] = 
    set_combine(
      sets.enmity, 
      {
        head = gear.globals.carmine.head,
        body = gear.globals.pld.artifact.body,
        feet = gear.globals.carmine.feet,
        ear1 = "Odnowa Earring +1",
      }
    )
  sets.midcast['Flash'].SIRD = 
    set_combine(
      sets.midcast.Flash, 
      {
        ammo = "Staunch Tathlum",
        legs = "Founder's Hose",
        waist= "Audumbla Sash"
      }
    )
  -- Phalanx --
  sets.midcast['Phalanx'] = 
    set_combine(
      sets.enmity, 
      {
        hands= gear.globals.souveran.hands,
        legs = gear.globals.sakpata.legs,
        feet = gear.globals.souveran.feet,
        neck = "Incanter's Torque", -- todo
        ring1= "Stikini Ring",
        ring2= "Stikini Ring +1",
        ear1 = "Odnowa Earring +1",
        ear2 = "Mimir Earring", -- todo
        waist= "Olympus Sash",
      }
    )
  sets.midcast['Phalanx'].SIRD = 
    set_combine(
      sets.midcast.Phalanx, 
      {
        legs = "Founder's Hose",
        neck = "Moonlight Necklace",
        waist= "Audumbla Sash"
      }
    )
  -- Reprisal --
  sets.midcast['Reprisal'] = 
    set_combine(
      sets.enmity, 
      {
        head = gear.globals.carmine.head,
      }
    )
  sets.midcast['Reprisal'].SIRD = 
    set_combine(
      sets.midcast.Reprisal, 
      {
        legs = "Founder's Hose",
        neck = "Moonlight Necklace",
        ring1= "Gelatinous Ring +1",
        ring2= "Defending Ring",
        waist= "Audumbla Sash"
      }
    )
  -- Enlight --
  sets.midcast['Enlight'] = 
    set_combine(
      sets.enmity, 
      {
        body = gear.globals.pld.artifact.body,
        neck = "Incanter's Torque", -- todo
        ring1= "Stikini Ring",
        ring2= "Stikini Ring +1",
        waist= "Asklepian Belt",
      }
    )
  sets.midcast['Enlight II'] = sets.midcast['Enlight']
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

  displayBox:text(displayLines:concat(' | '))
  displayBox:show()
end

---------------------------------
-- gearswap hooks
---------------------------------
function job_midcast(spell, action, spellMap, eventArgs)
  handleMidcastSird(spell)
end

function job_state_change(field, newValue, oldValue)
  -- any mode changed
  drawDisplay()
end

---------------------------------
--my functions 
---------------------------------
function handleMidcastSird(spell)
  local set = sets.midcast[spell.name]
  if set ~= nil then
    if state.CastingMode.value == 'SIRD' and set.SIRD ~= nil then
      equip(set.SIRD)
      return
    end
    equip(set)
  end
end

function ternary(cond, t, f)
  if cond then return t else return f end
end

function determineFastPants(new_hp, old_hp)
  local player = windower.ffxi.get_player()
  if player.status == 0 then -- status of 0 is idle
    local hpPercentage = player.vitals.hpp
    --windower.add_to_chat(123, tostring(hpPercentage))
    local leggies = 
      ternary(
          hpPercentage > FAST_PANTS_THRESHOLD, -- player has more than 90% hp
          gear.globals.carmine.legs,
          gear.globals.nyame.legs
        )
    --windower.add_to_chat(123, tostring(leggies))
    equip({ legs = leggies })
  end
end