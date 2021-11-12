--------------------------
--  Info                --
--------------------------
_addon.name = 'DiscoDeath'
_addon.version = '1.0'
_addon.author = 'BlueGlenn'
_addon.commands = { 'discodeath', 'dd' }

--------------------------------------------
--  Requireds                             --
--  These should be saved in addons/libs  --
--------------------------------------------
require('actions')
require('coroutine')
require('logger')
require('strings')

--------------------------
--  Constants           --
--------------------------
TICK = 0.3

--------------------------
--  System Objects      --
--------------------------

--------------------------
--  User Settings       --
--------------------------
run = false
modes = {
  [1] = 'Carcas Carousel',
  [2] = 'Disco Corpse',
  [3] = 'Wendigo Wiper'
}
mode = 1
angle = 0
angle_increment = 10
angle_direction = 1

----------------------------------
--  Command Handler Functions   --
----------------------------------
function handle_help()
  local help_block = ''
  local instruction_lines = {
    'i still need to make a help file.'
  }
  for i = 1,table.getn(instruction_lines) do -- yep, arrays in lua are 1 based...
    help_block = help_block .. '\n' .. tostring(i) .. '. ' ..  instruction_lines[i]
  end
  windower.add_to_chat(100, help_block)
end

function handle_mode(input)
  input = tonumber(input)
  if input == nil then return end
  mode = input
  notice("Mode set → " .. modes[input])
end

function handle_start() 
  if run then
    return "DiscoDeath is already running.  Type '//dd stop' to stop."
  end

  notice('Beginning DiscoDeath.  May Altana have mercy on your soul.')
  notice("You may type '//dd stop' to stop.")

  math.randomseed(os.time())
  run = true
  engine()
end

function handle_stop()
    if run == false then
        return "DiscoDeath is not running.  Type '//dd start' to start it."
    end

    run = false
    notice('Stopping DiscoDeath.')
end

--------------------------
--  Engine Functions    --
--------------------------
function engine()
  local status = windower.ffxi.get_player().status

  -- status 0 is idle, status 1 is combat, status 33 is healing, 2 is death
  if (run and status == 2) then
    if (mode == 1) then
      angle = linear_angle(0, 359, false)
    end

    if (mode == 2) then
      angle = random_angle()
    end

    if (mode == 3) then
      angle = linear_angle(0, 120, true)
    end

    windower.ffxi.turn(angle:radian())
  else
    handle_stop()
  end

  reschedule_engine()
end

function reschedule_engine()
  coroutine.schedule(engine, TICK)
end

--------------------------
--  Utility Functions   --
--------------------------
function linear_angle(lower, upper, wipe)
  if not wipe then angle_direction = 1 end
  -- todo: pick random start point for wipe.  make it actually wipe back and forth
  local new_angle = angle + angle_increment*angle_direction 
  return ternary(new_angle > upper, lower, new_angle) 
end

function random_angle()
  local number = math.random(1,360)
  return number
end

function ternary(cond, t, f)
  if cond then 
    return t 
  else 
    return f 
  end
end
--------------------------
--  Command Handlers    --
--------------------------
handlers = {
  ['help'] = handle_help,
  ['h'] = handle_help,
  ['mode'] = handle_mode,
  ['start'] = handle_start,
  ['stop'] = handle_stop
}

function handle_command(cmd, ...)
  local cmd = cmd or 'help'
  if handlers[cmd] then
    local msg = handlers[cmd](unpack({...}))
    if msg then
      error(msg)
    end
  else
    error("Unknown command %s":format(cmd))
  end
end

--------------------------
--  Windower Events     --
--------------------------
windower.register_event('addon command', handle_command)