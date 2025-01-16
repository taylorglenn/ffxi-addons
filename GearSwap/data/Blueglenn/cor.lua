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
set_lockstyle(02)

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
set_macros(1, 9)

---------------------------------
-- globals
---------------------------------
flurry = 1

---------------------------------
-- user setup
---------------------------------
function user_setup() 
  state.OffenseMode:options('Normal', 'SavageBlade')
  send_command('bind ^o gs c cycle OffenseMode')

  ---------------------------------
  -- jse setup
  ---------------------------------
  gear.globals.cor = {
    capes = {     int_eva_snapshot  = { name="Camulus's Mantle", augments={'INT+20','Eva.+20 /Mag. Eva.+20','"Snapshot"+10',}},
                  agi_rng_wsd       = { name="Camulus's Mantle", augments={'AGI+20','Rng.Acc.+20 Rng.Atk.+20','Weapon skill damage +10%',}}},

    neck = "Commodore charm +1",

    artifact = {  head  = "Laksa. Tricorne +1",
                  body  = "Laksa. Frac +2",
                  hands = "Laksa. Gants +1",
                  legs  = "Laksa. Trews +1",
                  feet  = "Laksa. Bottes +1" },

    relic = {     head  = "Lanun Tricorne +3",
                  body  = "Lanun Frac +3",
                  hands = "Lanun Gants +3",
                  legs  = "Lanun Trews +3",
                  feet  = "Lanun Bottes +3", },

    empyrean = {  head  = "Chass. Tricorne +1",
                  body  = "Chasseur's Frac +1",
                  hands = "Chasseur's Gants +1",
                  legs  = "Chas. Culottes +1",
                  feet  = "Chasseur's Bottes +1", },
  }
end

---------------------------------
-- define gear sets
---------------------------------
function init_gear_sets()
  ---------------------------------
  -- idle
  ---------------------------------
  sets.idle = { --range = "Fomalhaut",
                ammo  = "Chrono Bullet",
                head  = gear.globals.adhemar.head,
                body  = gear.globals.adhemar.body,
                hands = gear.globals.adhemar.hands,
                legs  = gear.globals.carmine.legs,
                feet  = gear.globals.meghanada.feet,
                neck  = "Bathy Choker +1",
                waist = "Windbuffet Belt +1",
                ring1 = "Defending Ring",
                ring2 = "Shneddick Ring",
                ear1  = "Telos Earring",
                ear2  = "Cessance Earring" }
  
  sets.idle.Town  = set_combine(sets.idle, { legs = gear.globals.carmine.legs, feet = "Hermes' Sandals" })

  ---------------------------------
  -- Job Abilities
  ---------------------------------
  sets.precast.JA = { 
    ["Fold"]         = {  body  = gear.globals.cor.relic.body },
    ["QuickDraw"]    = {  head  = gear.globals.herculean.head.mab,
                          body  = gear.globals.cor.relic.body,
                          hands = gear.globals.carmine.hands,
                          legs  = gear.globals.cor.relic.legs,
                          feet  = gear.globals.cor.relic.feet,
                          neck  = "Baetyl Pendant",
                          waist = "Eschan Stone",
                          ring1 = "Shiva Ring +1",
                          ring2 = "Acumen Ring",
                          ear1  = "Friomisi Earring",
                          ear2  = "Novio Earring",
                          back  = gear.globals.cor.capes.agi_rng_wsd }, -- should replace with an AGI/MACC/MAB cape
    ["RandomDeal"]   = {  body  = gear.globals.cor.relic.body },
    ["SnakeEye"]     = {  legs  = gear.globals.cor.relic.legs },
    ["TripleShot"]   = {  body  = gear.globals.cor.empyrean.body },
    ["WildCard"]     = {  feet  = gear.globals.cor.relic.feet }
  }

  sets.TripleShot = { head = gear.globals.oshosi.head,
                      body = gear.globals.cor.empyrean.body,
                      hands= gear.globals.cor.relic.hands,
                      legs = gear.globals.oshosi.legs,
                      feet = gear.globals.oshosi.feet }

  ---------------------------------
  -- Corsair Roll ("Phantom Roll" in game)
  ---------------------------------
  sets.precast.CorsairRoll = {  main  = "Rostam",
                                range = "Compensator",
                                head  = gear.globals.cor.relic.head,
                                neck  = gear.globals.cor.neck,
                                body  = gear.globals.meghanada.body,
                                hands = gear.globals.cor.empyrean.hands,
                                feet  = gear.globals.cor.relic.feet,
                                ring1 = "Defending Ring",
                                ring2 = "Barataria Ring",
                                back  = gear.globals.cor.capes.int_eva_snapshot,
                                waist = "Flume belt", }

  ---------------------------------
  -- Weapon Skills
  ---------------------------------
  sets.precast.WS     = 
  { 
    ammo  = "Chrono Bullet",
    head  = gear.globals.cor.relic.head,-- default for any weapon skill that isn't more specifically defined
    ear1  = "Telos earring",
    ear2  = { name = "Moonshade earring", augments = { "Accuracy+4", "TP Bonus +250"}},
    body  = gear.globals.cor.artifact.body,
    hands = gear.globals.meghanada.hands,
    legs  = gear.globals.cor.artifact.legs,
    feet  = gear.globals.cor.relic.feet,
    ring1 = "Chirich ring +1",
    ring2 = "Rajas ring",
    back  = gear.globals.cor.capes.agi_rng_wsd,
    waist = "Fotia belt", 
  }

  sets.precast.WS["Last Stand"] = set_combine(sets.precast.WS, {  
                                              head  = gear.globals.cor.relic.head,
                                              neck  = "Fotia Gorget",
                                              ear2  = { name = "Moonshade earring", augments = { "Accuracy+4", "TP Bonus +250"}},
                                              ear1  = "Telos earring", -- Ishvara is better when you can get it
                                              body  = gear.globals.cor.artifact.body,
                                              hands = gear.globals.meghanada.hands,
                                              ring1 = "Apate Ring", -- Regal Ring is best swap here
                                              ring2 = "Hajduk Ring +1", -- Epaminondas's Ring (STP-10, WSD+5%) is good swap if you don't need the acc from Hajduk
                                              back  = gear.globals.cor.capes.agi_rng_wsd,
                                              waist = "Fotia belt",
                                              legs  = gear.globals.meghanada.legs,
                                              feet  = gear.globals.cor.relic.feet })

  sets.precast.WS['Leaden Salute'] = set_combine(sets.precast.WS, {  
                                              head  = "Pixie Hairpin +1",
                                              neck  = gear.globals.cor.neck,
                                              ear2  = { name = "Moonshade earring", augments = { "Accuracy+4", "TP Bonus +250"}},
                                              ear1  = "Friomisi earring",
                                              body  = gear.globals.cor.relic.body,
                                              hands = gear.globals.carmine.hands, -- herc hands with wsd are probably better
                                              ring1 = "Archon Ring",
                                              ring2 = "Acumen Ring", -- Dingir Ring is good if you can get it
                                              back  = gear.globals.cor.capes.agi_rng_wsd,
                                              --waist = "Eschan Stone",
                                              wait  = "Hachirin-no-obi",
                                              legs  = gear.globals.cor.artifact.legs, -- Herc with AGI/MAB/WSD is better, Shned. Tights +1 is also a good swap
                                              feet  = gear.globals.cor.relic.feet })

  sets.precast.WS["Wildfire"]      = set_combine(sets.precast.WS, {  
                                              head  = gear.globals.herculean.head.mab,
                                              neck  = gear.globals.cor.neck,
                                              ear1  = "Novio Earring",
                                              ear2  = "Friomisi earring",
                                              body  = gear.globals.cor.relic.body,
                                              hands = gear.globals.carmine.hands, -- herc hands with wsd are probably better
                                              ring1 = "Shiva ring +1",
                                              ring2 = "Acumen Ring",
                                              back  = gear.globals.cor.capes.agi_rng_wsd,
                                              waist = "Eschan Stone", -- Skrymir Cord +1 is better, but who has the cash?
                                              legs  = gear.globals.cor.artifact.legs, -- Herc with AGI/MAB/WSD is better, Shned. Tights +1 is also a good swap
                                              feet  = gear.globals.cor.relic.feet })

  sets.precast.WS["Savage Blade"]  = set_combine(sets.precast.WS, {  
                                              head  = gear.globals.herculean.head.wsd,
                                              hands = gear.globals.meghanada.hands,
                                              --legs  = gear.globals.herculean.legs.wsd,
                                              neck  = gear.globals.cor.neck,
                                              --ring1 = "Regal Ring",  -- drops from omen, so... don't hold your breath
                                              --ring2 = "Epaminodas's Ring", -- i'll never get this lol
                                              back  = gear.globals.cor.capes.agi_rng_wsd,
                                              waist = "Sailfi Belt +1"
                                            })

  sets.precast.WS["Requiescat"]    = set_combine(sets.precast.WS, { })

  sets.precast.WS["Evisceration"]  = set_combine(sets.precast.WS, { })

  sets.precast.WS["Aeolian Edge"]  = set_combine(sets.precast.WS, {  
                                              head  = gear.globals.herculean.head.mab,
                                              neck  = "Stoicheion medal",
                                              ear2  = { name = "Moonshade earring", augments = { "Accuracy+4", "TP Bonus +250"}},
                                              ear2  = "Friomisi earring",
                                              body  = gear.globals.cor.relic.body,
                                              hands = gear.globals.meghanada.hands,
                                              ring1 = "Shiva ring +1",
                                              ring2 = "Acumen Ring",
                                              back  = gear.globals.cor.capes.agi_rng_wsd,
                                              waist = "Fotia belt",
                                              legs  = gear.globals.cor.artifact.legs,
                                              feet  = gear.globals.cor.relic.feet })

  ---------------------------------
  -- Melee
  ---------------------------------
  sets.engaged            = { --ammo = "Chrono Bullet",
                              head = gear.globals.adhemar.head,
                              body = gear.globals.adhemar.body,
                              hands = gear.globals.adhemar.hands,
                              legs = gear.globals.carmine.legs,
                              feet = gear.globals.meghanada.feet,
                              neck = gear.globals.cor.neck,
                              ear1 = "Telos earring",
                              ear2 = "Cessance Earring",
                              --ring1 = "Defending Ring",
                              --ring2 = "Gelatinous Ring +1",
                              ring1 = "Chirich ring +1",
                              ring2 = "Rajas ring",
                              waist = "Windbuffet belt +1",
                              --back = "Aptitude Mantle +1" 
                            }
  sets.engaged.SavageBlade = set_combine(sets.engaged, { main = "Naegling", range = "Anarchy +2"})

  ---------------------------------
  -- Ranged
  ---------------------------------
  sets.precast.RA         = { range = "Fomalhaut",
                              head  = gear.globals.cor.empyrean.head,
                              body  = gear.globals.cor.artifact.body, -- use su3 body when you get it
                              hands = gear.globals.carmine.hands,
                              back  = gear.globals.cor.capes.int_eva_snapshot,
                              neck  = gear.globals.cor.neck, 
                              waist = "Yemaya belt",
                              legs  = gear.globals.oshosi.legs,
                              feet  = gear.globals.meghanada.feet,
                              ring1 = "Defending Ring",
                              ring2 = "Gelatinous Ring +1" }

  sets.precast.RA.Flurry  = set_combine(sets.precast.RA, { body=gear.globals.cor.artifact.body })
  sets.precast.RA.Flurry2 = set_combine(sets.precast.RA, {
                            head = gear.globals.cor.empyrean.head,
                            body = gear.globals.cor.artifact.body,
                            feet = gear.globals.meghanada.feet })

  sets.precast.RA.Flurry1 = set_combine(sets.precast.RA, { body = gear.globals.cor.artifact.body })

  sets.precast.RA.Flurry2 = set_combine(sets.precast.RA.Flurry1, {
                            head = gear.globals.cor.empyrean.head, 
                            feet = "Pursuer's Gaiters", 
                            neck = gear.globals.cor.neck })

  sets.midcast.RA         = { range = "Fomalhaut",
                              head  = gear.globals.meghanada.head,
                              body  = gear.globals.adhemar.body,
                              neck  = "Marked Gorget",
                              ear1  = "Telos earring",
                              hands = gear.globals.meghanada.hands,
                              ring1 = "Chirich ring +1",
                              ring2 = "Hajduk ring +1",
                              back  = gear.globals.cor.capes.int_eva_snapshot,
                              waist = "Yemaya belt",
                              legs  = gear.globals.meghanada.legs,
                              feet  = gear.globals.meghanada.feet }

end

function job_precast(spell, action, spellMap, eventArgs)
  -- if user doesn't have any ammo
  local ammo_name = "Bronze Bullet"
  local ammo_pouch_name = "Bronze Bullet Pouch"
  local available_ammo = player.inventory[ammo_name] or player.wardrobe[ammo_name]
  if (spell.action_type == 'Ranged Attack' and player.equipment.ammo == 'empty' and available_ammo < 1) then
    -- use ammo pouch
    windower.chat.input('/item \"%s\" <me> <wait 2>':format(ammo_pouch_name))
  end
end

---------------------------------
-- post precast
---------------------------------
function job_post_precast(spell, action, spellMap, eventArgs)
  if spell.action_type == 'Ranged Attack' then
    if flurry == 2 then
      equip(sets.precast.RA.Flurry2)
    elseif flurry == 1 then
      equip(sets.precast.RA.Flurry1)
    end
  end
end

---------------------------------
-- post midcast
---------------------------------
function job_post_midcast(spell, action, spellMap, eventArgs)
  if spell.action_type == 'Ranged Attack' then
    if buffactive['Triple Shot'] then
      equip(sets.TripleShot)
    end
  end
end

---------------------------------
-- Utility functions specific to this job.
---------------------------------
function is_player_target(action)
  local playerId = windower.ffxi.get_player().id
  for _, target in ipairs(action.targets) do
    if playerId == target.id then
      return true
    end
  end
  return false
end

-- Read incoming packet to differentiate between Haste/Flurry I and II
windower.register_event('action',
  function(action)
    if is_player_target(action) then
      if action.category == 4 then -- action category 4 is a spell
        local param = action.param

        if param == 845 and flurry ~= 2 then -- 845 is fulrry
          add_to_chat(122, 'Flurry Status: Flurry I')
          flurry = 1
          return
        end

        if param == 846 then
          add_to_chat(122, 'Flurry Status: Flurry II')
          flurry = 2
          return
        end

      end
    end
  end
)

function special_ammo_check()
  -- Stop if Animikii/Hauksbok equipped
  if no_shoot_ammo:contains(player.equipment.ammo) then
      cancel_spell()
      add_to_chat(123, '** Action Canceled: [ '.. player.equipment.ammo .. ' equipped!! ] **')
      return
  end
end