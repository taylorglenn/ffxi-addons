local wait = 7
windower.send_command(
  table.concat({
    'input /echo Beginning 4 step',
    'input /ws "Tachi: Fudo" <t>',
    'wait '..wait,
    'input /ws "Tachi: Kasha" <t>',
    'wait '..wait,
    'input /ws "Tachi: Shoha" <t>',
    'wait '..wait,
    'input /ws "Tachi: Fudo" <t>',
    'input /echo 4 step complete' 
  }, '\;')
)