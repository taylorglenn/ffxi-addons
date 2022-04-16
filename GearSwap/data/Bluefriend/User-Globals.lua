---------------------------------
-- organizer items 
---------------------------------
organizer_items = 
{
  copper_voucher="Copper Voucher",
  forbidden_key="Forbidden Key",
  macro_orb="Macrocosmic Orb",
  silver_voucher="Silver Voucher",
  sushi="Sole Sushi",
  -- assault things
  leujaoam_log="Leujaoam Log",
  mammool_ja_journal="Mamool Ja Journal",
  lebros_Chronicle="Lebros Chronicle",
  periqia_diary="Periqia Diary",
  ilrusi_ledger="Ilrusi Ledger",
}
---------------------------------
-- gear 
---------------------------------
-- General Town Sets
sets.idle.Town = sets.idle
sets.idle.Town.Bastok = set_combine(sets.idle, { body = "Republic Aketon" })
sets.idle.Town.Windurst = set_combine(sets.idle, { body = "Federatiion Aketon" })
sets.idle.Town["San d'Oria"] = set_combine(sets.idle, { body = "Kingdom Aketon" })
sets.idle.Town.Adoulin = set_combine(sets.idle, { body = "Councilor's Garb" })

-- Bluefriend Gear Sets
gear.bluefriend = {
  moonshade = { name = "Moonshade earring", augments = { "Accuracy+4", "TP Bonus +250"} },
  -----------------------------------------------------
  -----                     JSE                   -----
  -----------------------------------------------------
  blm = { -- just keeping this here until i make a blm lua
    capes = { },
    
    neck = "",

    artifact = {  head  = "Spae. Petasos",
                  body  = "Spae. Coat",
                  hands = "Spae. Gloves",
                  legs  = "Spae. Tonban",
                  feet  = "Spae. Sabots" },

    relic = {     head  = "Arch. Petasos",
                  body  = "Arch. Coat",
                  hands = "Arch. Gloves",
                  legs  = "Arch. Tonban",
                  feet  = "Arch. Sabots" },

    empyrean = {  head  = "Wicce Petasos",
                  body  = "Wicce Coat",
                  hands = "Wicce Gloves",
                  legs  = "Wicce Chausses",
                  feet  = "Wicce Sabots" },
  },

  -----------------------------------------------------
  -----                  Geas Fete                -----
  -----------------------------------------------------
  chironic  = 
  {   
    legs = 
    { 
      enfeebling = { name="Chironic Hose", augments = { 'DEX+5', 'AGI+9', 'Damage taken-1%', 'Accuracy+17 Attack+17', 'Mag. Acc.+10 "Mag.Atk.Bns."+10',} } 
    } 
  },

  grioavolr = 
  {
    fast_cast = { name = "Grioavolr", augments = { '"Fast Cast"+6','INT+6','Mag. Acc.+16','"Mag.Atk.Bns."+11','Magic Damage +4', } },
    conserve_mp = { name = "Grioavolr", augments = { '"Conserve MP"+10','MP+25', } },
  },

  herculean = 
  {   
    head = 
    { 
      mab = { name="Herculean Helm", augments={'"Mag.Atk.Bns."+25','Weapon skill damage +4%','STR+11',}},
    },
    body = 
    { 
      mab = { name="Herculean Vest", augments={'MND+3','STR+8','Mag. Acc.+18 "Mag.Atk.Bns."+18',}},
    },
    hands= 
    { 
      waltz  = { name="Herculean Gloves", augments={'Accuracy+25 Attack+25','"Waltz" potency +11%','Attack+6',}},
    },
    feet = 
    { 
      ta_att = { name="Herculean Boots", augments={'Attack+30','"Triple Atk."+4','Accuracy+15',}},
    },
  },

  psycloth = 
  {   
    legs = 
    { 
      fc = { name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',} } 
    },
  },

  valorous = 
  {
    hands= 
    { 
      wsd = { name="Valorous Mitts", augments={'Weapon skill damage +5%','Attack+7',}},
    },
    feet = 
    { 
      wsd = { name="Valorous Greaves", augments={'Accuracy+26','Weapon skill damage +5%','STR+2',}},
    },
  },

  vanya = 
  {
    head={ name="Vanya Hood", augments={'MP+50','"Fast Cast"+10','Haste+2%',}},
    body={ name="Vanya Robe", augments={'Healing magic skill +20','"Cure" spellcasting time -7%','Magic dmg. taken -3',}},
    hands={ name="Vanya Cuffs", augments={'MP+50','"Cure" potency +7%','Enmity-6',}},
    legs={ name="Vanya Slops", augments={'MP+50','"Cure" potency +7%','Enmity-6',}},
    feet={ name="Vanya Clogs", augments={'"Cure" potency +5%','"Cure" spellcasting time -15%','"Conserve MP"+6',}},
  },
  
  -----------------------------------------------------
  -----                 Abjuration                -----
  -----------------------------------------------------
  adhemar = 
  {     
    head = "Adhemar bonnet +1",
    body = "Adhemar jacket +1",
    hands= "Adhemar wristbands +1" 
  },

  amalric =  
  {
    head  = "Amalric Coif +1",
    body  = "Amalric Doublet +1",
    hands = "Amalric Gages +1", 
  },

  carmine =  
  {
    head = "Carmine Mask +1",
    body = "Carm. Scale Mail +1",
    hands= "Carmine Fin. Ga. +1",
    legs = "Carmine Cuisses +1",
    feet = "Carmine Greaves +1" 
  },

  kaykaus = 
  {
    head = "Kaykaus mitra",
    body = "Kaykaus bliaut",
    hands= "Kaykaus cuffs +1",
    legs = "Kaykaus tights",
    feet = "Kaykaus boots" 
  },

  lustratio = 
  {
    head = "Lustratio Cap +1",
    legs = "Lustr. Subligar +1",
    feet = "Lustra. Leggings +1" 
  },

  rao = 
  {
    head = "Rao Kabuto +1",
    hands= "Rao Kote +1",
    feet = "Rao Sune-Ate" 
  },

  ryuo = 
  {
    head = "Ryuo Somen +1",
    hands= "Ryuo tekko +1",
    legs = "Ryuo Hakama +1",
    feet = "Ryuo Sune-Ate +1" 
  },

  souveran = 
  {
    head = "Souv. Schaller +1",
    body = "Souv. Cuirass +1",
    hands= "Souv. Handsch. +1",
    legs = "Souv. Diechlings +1",
    feet = "Souveran Schuhs +1" 
  },
  -----------------------------------------------------
  -----                 Ambuscade                 -----
  -----------------------------------------------------
  -- abdhaljs fiber
  ayanmo = 
  {      
    head = "Aya. Zucchetto +2",
    body  = "Ayanmo Corazza +2",
    hands = "Aya. Manopolas +2",
    legs  = "Aya. Cosciales +2",
    feet  = "Aya. Gambieras +2" 
  },

  flamma = 
  {      
    head  = "Flam. Zucchetto +2",
    feet  = "Flam. Gambieras +2" 
  },

  mummu = 
  {       
    head  = "Mummu bonnet +2",
    hands = "Mummu wrists +2",
    feet  = "Mummu gamashes +2",
    ring  = "Mummu Ring"
  },

  taliah = 
  {      
    head  = "Tali'ah Turban +2",
    body  = "Tali'ah Manteel +2",
    hands = "Tali'ah Gages +1",
    legs  = "Tali'ah Seraweels +2",
    feet  = "Tali'ah Crackows +2" 
  },

  -- abdhaljs metal
  hizamaru = 
  {    
    body  = "Hiza. haramaki +2",
    legs  = "Hizamaru hizayoroi +2",
    feet  = "Hizamaru sune-ate +1" 
  },

  inyanga = 
  {     
    head  = "Inyanga tiara +2",
    body  = "Inyanga jubbah +2",
    hands = "Inyanga dastanas +1",
    legs  = "Inyanga shalwar +2",
    feet  = "Inyanga crackows +2" 
  },
  
  jhakri = 
  {      
    head  = "Jhakri coronal +2",
    body  = "Jhakri robe +2",
    hands = "Jhakri cuffs +1",
    legs  = "Jhakri slops +2",
    feet  = "Jhakri pigaches +2" 
  },

  meghanada = 
  {   
    head  = "Meghanada Visor +2",
    body  = "Meg. Cuirie +2",
    hands = "Meg. Gloves +2",
    legs  = "Meg. Chausses +2",
    feet  = "Meg. Jam. +2" 
  },
      
  sulevia = 
  {     
    hands = "Sulev. Gauntlets +2",
    feet  = "Sulev. Leggings +2" 
  },
  -----------------------------------------------------
  -----              Skirmish Gear                -----
  -----------------------------------------------------
  taeon     = { legs = {  dw = { name = "Taeon Tights", augments = { '"Dual Wield"+4' ,} } }, },
  telchine  = { head = {  enhancing_duration = { name = "Telchine Cap",   augments = { 'Enh. Mag. eff. dur. +7' ,} } }, 
                legs = {  enhancing_duration = { name="Telchine Braconi", augments = { 'Enh. Mag. eff. dur. +8', } } }, },
  -----------------------------------------------------
  -----                     Su3                   -----
  -----------------------------------------------------
  kendatsuba = -- MNK, SAM, NIN
  {  
    head  = "Kendatsuba jinpachi +1",
    body  = "Kendatsuba samue +1", 
    legs  = "Kendatsuba hakama +1",
    feet  = "Kendatsuba sune-ate +1" 
  },

  oshosi = -- RNG, COR
  {      
    head  = "Oshosi Mask", 
    body  = "Oshosi Vest",
    hands = "Oshosi Gloves",
    legs  = "Oshosi Trousers",
    feet  = "Oshosi Leggings" 
  },
  -----------------------------------------------------
  -----                   Odyssey                 -----
  -----------------------------------------------------
  gleti = 
  {       
    head  = "Gleti's Mask",
    body  = "Gleti's Cuirass",
    hands = "Gleti's Gauntlets",
    legs  = "Gleti's Breeches",
    feet  = "Gleti's Boots" 
  },

  mpaca = 
  {       
    head  = "Mpaca's Cap",
    body  = "Mpaca's Doublet",
    hands = "Mpaca's Gloves",
    legs  = "Mpaca's Hose",
    feet  = "Mpaca's Boots" 
  },

  nyame = 
  {       
    head  = "Nyame Helm",
    body  = "Nyame Mail",
    hands = "Nyame Gauntlets",
    legs  = "Nyame Flanchard",
    feet  = "Nyame Sollerets" 
  },

  sakpata = 
  {     
    head  = "Sakpata's Helm",
    body  = "Sakpata's Breastplate",
    hands = "Sakpata's Gauntlets",
    legs  = "Sakpata's Cuisses",
    feet  = "Sakpata's Leggings" 
  },
}

-- ---------------------------------
-- -- macros 
-- ---------------------------------
-- function set_macros(book, sheet)
--   if book then
--     send_command('@input /macro book ' .. tostring(book) .. ';wait .1;input /macro set ' .. tostring(sheet))
--     return
--   end
--   send_command('@input / macro set ' .. tostring(sheet))
-- end

-- ---------------------------------
-- -- lockstyle 
-- ---------------------------------
-- function set_lockstyle(page)
--   send_command('@wait 6;input /lockstyleset ' .. tostring(page))
-- end
-- ---------------------------------
-- -- dressup 
-- ---------------------------------
-- function dressup(race, gender, face)
--   send_command('@input //lua l dressup')
--   if not race or not gender or not face then send_command('@input //du clear self') return end
--   send_command('@input //du self race ' .. race .. ' ' .. gender)
--   send_command('@wait 2; input //du self face ' .. tostring(face))
-- end

-- ---------------------------------
-- -- organizer 
-- ---------------------------------
-- send_command('@input //gs org;wait6; input //gs validate')