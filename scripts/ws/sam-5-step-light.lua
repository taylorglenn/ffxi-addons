local wait = 6
windower.send_command(
  table.concat({
    'input /echo Beginning 5 step',
    'input /ws "Tachi: Ageha" <t>',
    'wait '..wait,
    'input /ws "Tachi: Kagero" <t>',
    'wait '..wait,
    'input /ws "Tachi: Koki" <t>',
    'wait '..wait,
    'input /ws "Tachi: Shoha" <t>',
    'wait '..wait,
    'input /ws "Tachi: Fudo" <t>',
    'input /echo 5 step complete' 
  }, '\;')
)