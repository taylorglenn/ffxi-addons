require('ready_moves')

function getReadyMoveData(moveArray)
  local out = {}
  for _,v in ipairs(moveArray) do
    table.insert(out, ready_moves[v])
  end
  table.sort(out, function(a, b) return a.index < b.index end)
  return out
end

function petModel(dName, dType, dItem, dReady)
  return {
    name = dName,
    type = dType,
    item = dItem,
    ready = getReadyMoveData(dReady)
  }
end

petTable = {
  ['FluffyBredo'] = petModel('Fluffy Bredo', 'Amorph', 'Venomous Broth', {1,2} ),
  ['SwoopingZhivago'] = petModel('Swooping Zhivago', 'Bird', 'Windy Greens', {3,4,5} ),
  ['GenerousArthur'] = petModel('Generous Arthur', 'Amorph', 'Dire Broth', {11,12} ),
  ['EnergizedSefina'] = petModel('Energized Sefina', 'Vermin', 'Gassy Sap', {6,7,8,9,10} ),
  ['DaringRoland'] = petModel('Daring Roland', 'Bird', 'Feculent Broth', {13,14,15,16,17,18} ),
  ['JovialEdwin'] = petModel('Jovial Edwin', 'Aquan', 'Pungent Broth', {19,20,21,22,23} ),
  ['RhymingShizuna'] = petModel('Rhyming Shizna', 'Beast', 'Lyrical Broth', {24,25,26,27} ),
  ['VivaciousGaston'] = petModel('Vivacious Gaston', 'Beast', 'Spumante Broth', {28,29} ),
  ['VivaciousVickie'] = petModel('Vivacious Vickie', 'Beast', 'Tant. Broth', {30,31} ),
  ['BouncingBertha'] = petModel('Bouncing Bertha', 'Vermin', 'Bubbly Broth', {32,33} ),
  ['SultryPatrice'] = petModel('Sultry Patrice', 'Amorph', 'Putrescent Broth', {34,35,36} ),
  ['FatsoFargann'] = petModel('Fatso Fargann', 'Amorph', 'C. Plasma Broth', {37,38,39,40} ),
  ['BlackbeardRandy'] = petModel('Blackbeard Randy', 'Beast', 'Meaty Broth', {41,42,43,44,45} ),
  ['WarlikePatrick'] = petModel('Warlick Patrick', 'Lizard', 'Livid Broth', {46,47,48,49,50,51} ),
  ['PonderingPeter'] = petModel('Pondering Peter', 'Beast', 'Vis. Broth', {52,53,54,55} )
}

newPetTable = 
{ -- Pet details taken from the Bestiary of the BST Guide on FFXIAH: https://www.ffxiah.com/forum/topic/45830/killer-instinct-the-beastmaster-compendium/#bestiary
  [''] = 
  {
    name = '',
    type = '',
    item = '',
    ready = 
    {
      [1] = { name = '', cost = '', type = '' },
      [2] = { name = '', cost = '', type = '' },
      [3] = { name = '', cost = '', type = '' },
      [4] = { name = '', cost = '', type = '' },
      [5] = { name = '', cost = '', type = '' },
      [6] = { name = '', cost = '', type = '' },
    }
  },
  ['PonderingPeter'] = 
  {
    name = 'Pondering Peter',
    type = 'Beast',
    item = 'Vis. Broth',
    ready = 
    {
      [1] = { name = 'Foot Kick', cost = '1', type = 'Slash' },
      [2] = { name = 'Dust Cloud', cost = '1', type = 'Earth' },
      [3] = { name = 'Whirl Claws', cost = '1', type = 'Pierce' },
      [4] = { name = 'Wild Carrot', cost = '2', type = 'Heal' },
    }
  },
  ['AgedAngus'] = 
  {
    name = 'Aged Angus',
    type = 'Aquan',
    item = 'Ferm. Broth',
    ready = 
    {
      [1] = { name = 'Bubble Shower', cost = '1', type = 'Water' },
      [2] = { name = 'Bubble Curtain', cost = '3', type = 'MDT-50%' },
      [3] = { name = 'Big Scissors', cost = '1', type = 'Slash' },
      [4] = { name = 'Scissor Guard', cost = '2', type = 'DEV+100%' },
      [5] = { name = 'Metallic Body', cost = '1', type = 'Stoneskin' },
    }
  },
  ['WarlikePatrick'] = 
  {
    name = 'Warlike Patrick',
    type = 'Lizard',
    item = 'Livid Broth',
    ready = 
    {
      [1] = { name = 'Tail Blow', cost = '1', type = 'Blunt' },
      [2] = { name = 'Fireball', cost = '1', type = 'Fire' },
      [3] = { name = 'Blockhead', cost = '1', type = 'Blunt' },
      [4] = { name = 'Brain Crush', cost = '1', type = 'Blunt' },
      [5] = { name = 'Infrasonics', cost = '2', type = 'EVA-40' },
      [6] = { name = 'Secretion', cost = '1', type = 'EVA+25' },
    }
  },
  ['BouncingBertha'] = 
  {
    name = 'Bouncing Bertha',
    type = 'Vermin',
    item = 'Bubbly Broth',
    ready = 
    {
      [1] = { name = 'Sensilla Blades', cost = '1', type = 'Slash' },
      [2] = { name = 'Tegmina Buffet', cost = '2', type = 'Slash' },
    }
  },
  ['RhymingShizuna'] = 
  {
    name = 'Rhyming Shizuna',
    type = 'Beast',
    item = 'Lyrical Broth',
    ready = 
    {
      [1] = { name = 'Lamb Chop', cost = '1', type = 'Blunt' },
      [2] = { name = 'Rage', cost = '2', type = 'ATT+60%/DEF-60%' },
      [3] = { name = 'Sheep Charge', cost = '1', type = 'Blunt' },
      [4] = { name = 'Sheep Song', cost = '2', type = 'SLeep' },
    }
  },
  ['SwoopingZhivago'] = 
  {
    name = 'Swooping Zhivago',
    type = 'Bird',
    item = 'Windy Greens',
    ready = 
    {
      [1] = { name = 'Molting Plumage', cost = '1', type = 'Wind' },
      [2] = { name = 'Swooping Frenzy', cost = '2', type = 'Pierce' },
      [3] = { name = 'Pentapeck', cost = '3', type = 'Pierce' },
    }
  },
  ['AmiableRoche'] = 
  {
    name = 'Amiable Roche',
    type = 'Aquan',
    item = 'Airy Broth',
    ready = 
    {
      [1] = { name = 'Intimidate', cost = '2', type = 'ATT-' },
      [2] = { name = 'Recoil Dive', cost = '1', type = 'Blunt' },
      [3] = { name = 'Water Wall', cost = '3', type = 'DEF+100%' },
    }
  },
  ['HeraldHenry'] = 
  {
    name = 'Herald Henry',
    type = 'Aquan',
    item = 'Trans. Broth',
    ready = 
    {
      [1] = { name = 'Bubble Shower', cost = '1', type = 'Water' },
      [2] = { name = 'Bubble Curtain', cost = '3', type = 'MDT-50%' },
      [3] = { name = 'Big Scissors', cost = '1', type = 'Slash' },
      [4] = { name = 'Scissor Guard', cost = '2', type = 'DEF+100%' },
      [5] = { name = 'Metallic Body', cost = '1', type = 'Stoneskin' },
    }
  },
  ['BrainyWaluis'] = 
  {
    name = 'Brainy Waluis',
    type = 'Plantoid',
    item = 'Crumbly Soil',
    ready = 
    {
      [1] = { name = 'Frogkick', cost = '1', type = 'Blunt' },
      [2] = { name = 'Spore', cost = '1', type = 'Paralyze' },
      [3] = { name = 'Queasyshroom', cost = '2', type = 'Dark/Poison' },
      [4] = { name = 'Numbshroom', cost = '2', type = 'Dark/Paralyze' },
      [5] = { name = 'Shakeshroom', cost = '2', type = 'Dark/Disease' },
      [6] = { name = 'Silence Gas', cost = '3', type = 'Dark/Silence' },
      [7] = { name = 'Dark Spore', cost = '3', type = 'Dark/Blind' },
    }
  },
  ['SuspiciousAlice'] = 
  {
    name = 'Suspicious Alice',
    type = 'Lizard',
    item = 'Furious Broth',
    ready = 
    {
      [1] = { name = 'Nimble Snap', cost = '1', type = 'Slash' },
      [2] = { name = 'Cyclotail', cost = '1', type = 'Blunt' },
      [3] = { name = 'Geist Wall', cost = '1', type = 'Dispel' },
      [4] = { name = 'Numbing Noise', cost = '1', type = 'Stun' },
      [5] = { name = 'Toxic Spit', cost = '2', type = 'Poison' },
    }
  },
  ['HeadbreakerKen'] = 
  {
    name = 'Headbreaker Ken',
    type = 'Vermin',
    item = 'Blackwater Broth',
    ready = 
    {
      [1] = { name = 'Cursed Sphere', cost = '1', type = 'AoE' },
      [2] = { name = 'Venom', cost = '1', type = 'Water/Poison' },
      [3] = { name = 'Somersault', cost = '1', type = 'Blunt' },
    }
  },
  ['AlluringHoney'] = 
  {
    name = 'Alluring Honey',
    type = 'Plantoid',
    item = 'Bug-Ridden Broth',
    ready = 
    {
      [1] = { name = 'Tickling Tendrils', cost = '1', type = 'Blunt' },
      [2] = { name = 'Stink Bomb', cost = '2', type = 'Earth/Blind/Paralyze' },
      [3] = { name = 'Nectarous Deluge', cost = '2', type = 'Water/Poison' },
      [4] = { name = 'Nepenthic Plunge', cost = '3', type = 'Water/Drown/Weight' },
    }
  },
  ['VivaciousVickie'] = 
  {
    name = 'Vivacious Vickie',
    type = 'Beast',
    item = 'Tant. Broth',
    ready = 
    {
      [1] = { name = 'Sweeping Gouge', cost = '1', type = 'Blunt/DEF-25%' },
      [2] = { name = 'Zealous Snort', cost = '3', type = 'Haste+25%' },
    }
  },
  ['AnklebiterJedd'] = 
  {
    name = 'AnklebiterJedd',
    type = 'Vermin',
    item = 'Crackling Broth',
    ready = 
    {
      [1] = { name = 'Double Claw', cost = '1', type = 'Blunt' },
      [2] = { name = 'Grapple', cost = '1', type = 'Blunt' },
      [3] = { name = 'Spinning Top', cost = '1', type = 'Blunt' },
      [4] = { name = 'Filamented Hold', cost = '2', type = '50% Slow' },
    }
  },
  -- Continue later, i'm bored
}