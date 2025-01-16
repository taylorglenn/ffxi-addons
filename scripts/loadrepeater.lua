windower.send_command(
  table.concat({
    'input //lua u repeater',
    'wait 1',
    'input //lua l repeater',
    'wait 1',
    'input //re delay 30',
    'wait 1',
    'input //re command "//craft make \"Sunstone\""',
    --'input //re command "//craft make \"Aquamarine 2\""',
    'input //re command "//craft make \"Fluorite\""',
    'input //re command "//craft make \"Jadeite\""',
    'input //re command "//craft make \"Chrysoberyl\""',
    'input //re command "//craft make \"Zircon\""',
    'input //re command "//craft make \"Moonstone\""',
    'input //re command "//craft make \"Painite\""',
  }, '\;')
)