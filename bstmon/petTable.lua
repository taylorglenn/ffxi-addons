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