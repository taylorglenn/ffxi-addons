---------------------------------
-- gear 
---------------------------------
-- General Town Sets
sets.idle.Town = sets.idle
sets.idle.Town.Bastok = set_combine(sets.idle, { body = "Republic Aketon" })
sets.idle.Town.Windurst = set_combine(sets.idle, { body = "Federatiion Aketon" })
sets.idle.Town["San d'Oria"] = set_combine(sets.idle, { body = "Kingdom Aketon" })
sets.idle.Town.Adoulin = set_combine(sets.idle, { body = "Councilor's Garb" })

-- Blueglenn Gear Sets
gear.globals = {
  moonshade = { name = "Moonshade earring", augments = { "Accuracy+4", "TP Bonus +250"} },
  -----------------------------------------------------
  -----                     JSE                   -----
  -----------------------------------------------------
  blm = { -- just keeping this here until i make a blm lua
    capes = { },
    
    neck = "",

    artifact = 
    {  
      head  = "Spae. Petasos",
      body  = "Spae. Coat",
      hands = "Spae. Gloves",
      legs  = "Spae. Tonban",
      feet  = "Spae. Sabots" 
    },

    relic = 
    {     
      head  = "Arch. Petasos",
      body  = "Arch. Coat",
      hands = "Arch. Gloves",
      legs  = "Arch. Tonban",
      feet  = "Arch. Sabots" 
    },

    empyrean = 
    {  
      head  = "Wicce Petasos",
      body  = "Wicce Coat",
      hands = "Wicce Gloves",
      legs  = "Wicce Chausses",
      feet  = "Wicce Sabots" 
    },
  },

  -----------------------------------------------------
  -----                  Geas Fete                -----
  -----------------------------------------------------
  chironic  = 
  {   
    legs = 
    { 
      enfeebling = { name="Chironic Hose", augments = { 'DEX+5', 'AGI+9', 'Damage taken-1%', 'Accuracy+17 Attack+17', 'Mag. Acc.+10 "Mag.Atk.Bns."+10',} } 
    },
  },

  eschite = 
  {
    legs = 
    {
      fc = { name="Eschite Cuisses", augments = {'"Mag.Atk.Bns."+25','"Conserve MP"+6','"Fast Cast"+5', }},
    },
    feet = 
    {
      enmity = { name="Eschite Greaves", augments={'HP+80','Enmity+7','Phys. dmg. taken -4',}},
    },
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
      fc = { name="Herculean Helm", augments={'"Fast Cast"+6','STR+5',}},
    },
    body = 
    { 
      mab = { name="Herculean Vest", augments={'MND+3','STR+8','Mag. Acc.+18 "Mag.Atk.Bns."+18',}},
    },
    hands= 
    { 
      ta = { name="Herculean Gloves", augments={'Accuracy+24','"Triple Atk."+4','INT+10','Attack+9',}},
      waltz  = { name="Herculean Gloves", augments={'Accuracy+25 Attack+25','"Waltz" potency +11%','Attack+6',}},
    },
    legs = 
    {
      fc = { name="Herculean Trousers", augments={'Attack+2','"Fast Cast"+6','"Mag.Atk.Bns."+8',}},
    },
    feet = 
    { 
      ta_att = { name="Herculean Boots", augments={'Attack+30','"Triple Atk."+4','Accuracy+15',}},
      fc = { name="Herculean Boots", augments={'Mag. Acc.+23','"Fast Cast"+6','MND+3',}},
    },
  },

  merlinic = 
  {
    body = 
    {
      drain_aspir = {{ name="Merlinic Jubbah", augments={'"Drain" and "Aspir" potency +11','CHR+7','"Mag.Atk.Bns."+13',}}}
    },
    hands = 
    {
      drain_aspir = { name="Merlinic Dastanas", augments={'"Mag.Atk.Bns."+25','"Drain" and "Aspir" potency +11','Mag. Acc.+14',}}
    },
    feet = 
    {
      fc = { name="Merlinic Crackows", augments={'Mag. Acc.+22 "Mag.Atk.Bns."+22','"Fast Cast"+4','"Mag.Atk.Bns."+11',}}
    },
  },

  odyssean = 
  {
    feet = 
    {
      fc = { name="Odyssean Greaves", augments={'Attack+1','"Fast Cast"+6','Accuracy+1',}},
    },
  },

  psycloth = 
  {   
    legs = 
    { 
      fc = { name="Psycloth Lappas", augments={'MP+80','Mag. Acc.+15','"Fast Cast"+7',}},
    },
  },

  rawhide =
  {
    hands =
    {
      macc = { name="Rawhide Gloves", augments={'Mag. Acc.+15','INT+7','MND+7',}},
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

  mallquis = 
  {
    head  = "Mall. Chapeau +2",
    body  = "Mallquis Saio +2",
    hands = "Mallquis Cuffs +1",
    legs  = "Mallquis Trews +2",
    feet  = "Mallquis Clogs +2",
    ring  = "Mallquis Ring"
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
    feet  = "Hizamaru sune-ate +2" 
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
  taeon = 
  { 
    body = {
      pet = { name="Taeon Tabard", augments={'Pet: Accuracy+22 Pet: Rng. Acc.+22','Pet: "Dbl. Atk."+4','Pet: Damage taken -4%',}},
    },
    hands = {
      pet = { name="Taeon Gloves", augments={'Pet: Accuracy+20 Pet: Rng. Acc.+20','Pet: "Dbl. Atk."+3','Pet: Damage taken -3%',}},
    },
    legs = 
    {  
      pet = { name="Taeon Tights", augments={'Pet: Attack+22 Pet: Rng.Atk.+22','Pet: "Dbl. Atk."+3','Pet: Damage taken -4%',}},
    },
    feet = {
      pet = { name="Taeon Boots", augments={'Pet: Attack+19 Pet: Rng.Atk.+19','Pet: "Dbl. Atk."+3','Pet: Damage taken -3%',}},
    },
  },

  telchine = 
  { 
    head = 
    {  
      enhancing_duration = { name = "Telchine Cap",   augments = { 'Enh. Mag. eff. dur. +7' ,}}, 
      hp_cure_pot = { name="Telchine Cap", augments={'"Cure" potency +8%','HP+44',}},
    },
    body = 
    {
      enhancing_duration = { name="Telchine Chas.", augments={'Enh. Mag. eff. dur. +8',}},
      cure_regen_pot = { name="Telchine Chas.", augments={'"Cure" potency +7%','"Regen" potency+2',}},
    },
    hands = 
    {
      enhancing_duration_sird = { name="Telchine Gloves", augments={'Spell interruption rate down -8%','Enh. Mag. eff. dur. +8',}},
      regen_pot = { name="Telchine Gloves", augments={'"Regen" potency+3',}},
    },
    legs = 
    {  
      enhancing_duration = { name="Telchine Braconi", augments = { 'Enh. Mag. eff. dur. +8', }},
      cure_regen_pot = { name="Telchine Braconi", augments={'"Cure" potency +7%','"Regen" potency+3',}},
    }, 
    feet = 
    {
      enhancing_duration_sird = { name="Telchine Pigaches", augments={'Spell interruption rate down -7%','Enh. Mag. eff. dur. +7',}},
      regen_pot = { name="Telchine Pigaches", augments={'"Regen" potency+3',}},
    }
  },
  -----------------------------------------------------
  -----                     Su3                   -----
  -----------------------------------------------------
  heyoka = -- BST, PUP
  {
    head = "Heyoka Cap +1",
    body = "Heyoka Harness",
    hands= "Heyoka Mittens",
    legs = "Heyoka Subligar",
    feet = "Heyoka Leggings",
  },

  kendatsuba = -- MNK, SAM, NIN
  {  
    head  = "Ken. jinpachi +1",
    body  = "Ken. samue +1", 
    hands = "Ken. Tekko +1",
    legs  = "Ken. hakama +1",
    feet  = "Ken. sune-ate +1" 
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
  agwu = 
  {
    head  = "Agwu's Cap",
    body  = "Agwu's Robe",
    hands = "Agwu's Gages",
    legs  = "Agwu's Slops",
    feet  = "Agwu's Pigaches"
  },

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
