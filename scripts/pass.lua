local numberOfTreasureSlots = 9
for slot = 0, numberOfTreasureSlots do
    windower.ffxi.pass_item(slot)
end
windower.send_command(
  table.concat({
    'input /echo +------------------------------+',
    'input /echo | Passed on entire loot pool.   |',
    'input /echo +------------------------------+',
  }, '\;')
)