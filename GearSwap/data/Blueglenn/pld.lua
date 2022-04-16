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
-- constants
---------------------------------
FAST_PANTS_THRESHOLD = 80 -- this is a percentage of your max health

---------------------------------
-- user setup 
---------------------------------
function user_setup() 
  state.OffenseMode:options('Normal', 'mdt', 'hybrid', 'savageBlade')
  send_command('bind ^o gs c cycle OffenseMode')

  ---------------------------------
  -- jse setup
  ---------------------------------
  gear.blueglenn.pld = {
    capes = { 
      enmity    = { name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','Mag. Evasion+2','Enmity+10','Chance of successful block +5',}},
      fast_cast = { name="Rudianos's Mantle", augments={'HP+60','Eva.+20 /Mag. Eva.+20','"Fast Cast"+10','Phys. dmg. taken-10%',}},
    },
    
    neck = "Kgt. Beads +1",

    artifact = {  head  = "Rev. Coronet",
                  body  = "Rev. Surcoat",
                  hands = "Rev. Gauntlets",
                  legs  = "Rev. Breeches",
                  feet  = "Rev. Leggings" },

    relic = {     head  = "Cab. Coronet",
                  body  = "Cab. Surcoat",
                  hands = "Cab. Gauntlets",
                  legs  = "Cab. Breeches",
                  feet  = "Cab. Leggings" },

    empyrean = {  head  = "Chev. Armet",
                  body  = "Chev. Cuirass",
                  hands = "Chev. Gauntlets",
                  legs  = "Chev. Cuisses",
                  feet  = "Chev. Sabatons" },
  }
end

---------------------------------
-- job setup 
---------------------------------
function job_setup()
  --windower.raw_register_event('action', determineFastPants)
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
    head  = gear.blueglenn.nyame.head, --7 dt
    body  = gear.blueglenn.nyame.body, --9 dt
    hands = gear.blueglenn.nyame.hands, --7 dt
    --legs  = gear.blueglenn.nyame.legs, -- 8 dt
    legs  = gear.blueglenn.carmine.legs,
    feet  = gear.blueglenn.nyame.feet, --7 dt
    neck  = "Moonlight Necklace",
    ear1  = "Cryptic Earring",
    ear2  = "Etiolation Earring", --3 mdt
    ring1 = "Defending Ring", --10 dt
    ring2 = "Vengeful Ring", 
    back  = gear.blueglenn.pld.capes.enmity,
    waist = "Asklepian Belt",
  } -- 50 dt 
  ---------------------------------
  -- enmity set
  ---------------------------------
  sets.enmity = --87 enmity
  {
    ammo = "Sapience Orb", --2
    head = gear.blueglenn.souveran.head, --9
    body = gear.blueglenn.souveran.body, --9
    hands= gear.blueglenn.souveran.hands,--9
    legs = gear.blueglenn.souveran.legs, --9
    feet = gear.blueglenn.souveran.feet, --9
    neck = "Moonlight Necklace", --10
    ear1 = "Friomisi Earring", --2
    ear2 = "Cryptic Earring", --4
    ring1= "Supershear Ring", --5
    ring2= "Petrov Ring", --4
    back = gear.blueglenn.pld.capes.enmity, --10
    waist= "Creed Baudrier", --5
  }
  ---------------------------------
  -- engaged
  ---------------------------------
  sets.engaged = 
    set_combine(
      sets.enmity,
      {
        main = "Excalibur",
        sub  = "Priwen", -- todo: Ochain
      }
    )
  sets.engaged.mdt = 
    set_combine(
      sets.engaged, 
      {
        sub = "Aegis"
      }
    )
  sets.engaged.hybrid = 
    set_combine(
      sets.engaged,
      {
        sub  = "Priwen",
        ammo = "Aurgelmmir Orb",
        head = gear.blueglenn.sakpata.head,
        body = gear.blueglenn.sakpata.body,
        hands= gear.blueglenn.sakpata.hands,
        legs = gear.blueglenn.sakpata.legs,
        feet = gear.blueglenn.sakpata.feet,
        neck = "Moonlight Necklace",
        ear1 = "Telos Earring",
        ear2 = "Cessance Earring",
        ring1= "Chirich Ring +1",
        ring2= "Petrov Ring",
        waist= "Sailfi Belt +1",
      }
    )
  sets.engaged.savageBlade = 
    set_combine(
      sets.engaged.hybrid,
      {
        main = "Naegling",
        sub  = "Blurred Shield +1"
      }
    )
  ---------------------------------
  -- weapon skills
  ---------------------------------
  sets.precast.WS = 
  {
    ammo = "Aurgelmir Orb",
    body = "Hjarrandi Breast.",
    hands= gear.blueglenn.valorous.hands.wsd,
    feet = gear.blueglenn.valorous.feet.wsd,
    neck = "Fotia Gorget",
    ear1 = gear.blueglenn.moonshade,
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
        head  = gear.blueglenn.lustratio.head,
        legs  = gear.blueglenn.lustratio.legs,
        feet  = gear.blueglenn.lustratio.feet,
      }
    )
  -- Requiescat: Sword - Physical - 85% MND - Static fTP: 1.0 - TP modifies attack power reduction: -20% / -10% / -0%
  sets.precast.WS['Requiescat'] = 
    set_combine(
      sets.precast.WS, 
      {
        head = "Hijarrandi Helm",
        body = gear.blueglenn.sakpata.body,
        hands= gear.blueglenn.sakpata.hands,
        legs = gear.blueglenn.sakpata.legs,
        feet = gear.blueglenn.sakpata.feet,
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
        head  = gear.blueglenn.lustratio.head,  -- 39 str + 8 str
        body  = gear.blueglenn.sakpata.body,    -- 42 str, 28 mnd
        hands = gear.blueglenn.sakpata.hands,   -- 24 str, 33 mnd
        legs  = gear.blueglenn.sakpata.legs,    -- 48 str, 21 mnd
        feet  = gear.blueglenn.lustratio.feet,  -- 32 str + 15 str
        neck  = gear.blueglenn.pld.neck,
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
        head = gear.blueglenn.sakpata.head,
        body = gear.blueglenn.sakpata.body,
        hands= gear.blueglenn.sakpata.hands,
        legs = gear.blueglenn.sakpata.legs,
        feet = gear.blueglenn.sakpata.feet,
        ear2 = "Mache Earring +1",
        ring1= "Supershear Ring",
        ring2= "Petrov Ring",
      }
    )
  ---------------------------------
  -- abilities
  ---------------------------------
  sets.precast.JA['Invincible']   = { legs = gear.blueglenn.pld.relic.legs }
  sets.precast.JA['Holy Circle']  = { feet = gear.blueglenn.pld.artifact.feet }
  sets.precast.JA['Sentinel']     = { feet = gear.blueglenn.pld.relic.feet }
  sets.precast.JA['Cover']        = { head = gear.blueglenn.pld.artifact.head, body = gear.blueglenn.pld.relic.body }
  sets.precast.JA['Rampart']      = { head = gear.blueglenn.pld.relic.head }
  sets.precast.JA['Fealty']       = { body = gear.blueglenn.pld.relic.body }
  sets.precast.JA['Chivalry']     = { hands= gear.blueglenn.pld.relic.hands }
  sets.precast.JA['Divine Emblem']= { feet = gear.blueglenn.pld.empyrean.feet }
  ---------------------------------
  -- precast
  ---------------------------------
  sets.precast.FC = 
  {
    ammo = "Sapience Orb",
    head = gear.blueglenn.carmine.head,
    body = gear.blueglenn.pld.relic.body,
    feet = gear.blueglenn.carmine.feet,
    ear1 = "Enchntr. Earring +1",
    ear2 = "Loquac. Earring",
    ring1= "Prolix Ring",
    ring2= "Kishar Ring",
    back = gear.blueglenn.pld.capes.fast_cast,
  }
  ---------------------------------
  -- midcast
  ---------------------------------
  sets.midcast = {}
  sets.midcast['Enlight'] = 
    set_combine(
      sets.enmity, 
      {
        body = gear.blueglenn.pld.artifact.body,
        neck = "Incanter's Torque", -- todo
        ring1= "Stikini Ring",
        ring2= "Stikini Ring +1",
        waist= "Asklepian Belt",
      }
    )
  sets.midcast['Enlight II'] = sets.midcast['Enlight']
  sets.midcast['Flash'] = 
    set_combine(
      sets.enmity, 
      {
        sub  = "Srivatsa", -- todo
        head = gear.blueglenn.carmine.head,
        body = gear.blueglenn.pld.artifact.body,
        feet = gear.blueglenn.carmine.feet,
      }
    )
  sets.midcast['Phalanx'] = 
    set_combine(
      sets.midcast, 
      {
        sub  = "Priwen",
        hands= gear.blueglenn.souveran.hands,
        neck = "Incanter's Torque", -- todo
        ring1= "Stikini Ring",
        ring2= "Stikini Ring +1",
        ear1 = "Mimir Earring", -- todo
        waist= "Olympus Sash",
      }
    )
  sets.midcast['Reprisal'] = 
    set_combine(
      sets.enmity, 
      {
        head = gear.blueglenn.carmine.head,
      }
    )
end

---------------------------------
--my functions 
---------------------------------
-- function ternary(cond, t, f)
--   if cond then return t else return f end
-- end

-- function determineFastPants()
--   local player = windower.ffxi.get_player()
--   if player.status == 0 then -- status of 0 is idle
--     local vitals = player.vitals
--     local hpPercentage = math.floor((vitals.hp / vitals.max_hp) * 100)
--     windower.add_to_chat(123, tostring(hpPercentage))
--     local leggies = 
--       ternary(
--           hpPercentage > FAST_PANTS_THRESHOLD, -- player has more than 90% hp
--           gear.blueglenn.carmine.legs,
--           gear.blueglenn.nyame.legs
--         )
--     windower.add_to_chat(123, tostring(leggies))
--     equip({ legs = leggies })
--   end
-- end