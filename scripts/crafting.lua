---------------------------------
-- style lock
---------------------------------
windower.send_command('@input /lockstyleset 20')
---------------------------------
-- cast dummy songs
---------------------------------
windower.send_command(
  table.concat({
    'input /echo <-- Changing to Crafting Set -->',
    'input /equip body "Goldsmith\'s Smock"',
    'input /equip hands "Goldsmith\'s Cuffs"',
    'input /equip head "Shaded Specs."',
    'input /equip ring1 "Orvail Ring"',
    'input /equip ring2 "Artificer\'s Ring"',
    'input /equip neck "Goldsm. Torque"',
    'input //gs disable all',
  }, '\;')
)