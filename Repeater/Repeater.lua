--------------------------
--  Info                --
--------------------------
_addon.name = 'Repeater'
_addon.version = '1.0'
_addon.author = 'BlueGlenn'
_addon.commands = { 'repeater', 're' }

--------------------------------------------
--  Requireds                             --
--  These should be saved in addons/libs  --
--------------------------------------------
require('chat')
require('coroutine')
require('lists')
require('logger')
require('queues')
require('sets')
require('strings')
res = require('resources')
require('tables')

--------------------------
--  Constants           --
--------------------------
MIN_DELAY = 1
MAX_DELAY = 600

--------------------------
--  System Objects      --
--------------------------

--------------------------
--  User Settings       --
--------------------------
run = false
command_queue = Q{}
command_queue_index = 1
delay = 1
runincombat = false

----------------------------------
--  Command Handler Functions   --
----------------------------------
function handle_help()
  local help_block = ''
  local instruction_lines = {
    "Start Repeater with '//re start'.",
    "Stop Repeater with '//re stop'."
  }
  for i = 1,table.getn(instruction_lines) do -- yep, arrays in lua are 1 based...
    help_block = help_block .. '\n' .. tostring(i) .. '. ' ..  instruction_lines[i]
  end
  windower.add_to_chat(100, help_block)
end

function handle_command(command_input)
  if command_input == '' then return end
  if command_input:lower() == 'clear' then 
    command_queue = Q{}
    notice("Cleared command queue!")
    return
  end
  command_queue:push(command_input)
  notice("Command added to queue → " .. command_input)
end

function handle_delay(delay_input)
  if delay_input == '' then return end
  delay_input = tonumber(delay_input)
  if delay_input < MIN_DELAY or delay_input > MAX_DELAY then handle_stop() end
  delay = delay_input
  notice("Delay → " .. delay)
end

function handle_queue()
  if command_queue:length() == 0 then return "Command Queue is empty!" end
  notice('Command Queue:')
  for k,v in pairs(command_queue['data']) do 
    notice(tostring(k).." → "..tostring(v))
  end
end

function handle_runincombat()
  runincombat = not runincombat
  notice("RunInCombat → " .. tostring(runincombat))
end

function handle_settings()
  local settings = {
    ['running'] = tostring(run),
    ['delay'] = tostring(delay),
    ['RunInCombat'] = tostring(runincombat)
  }
  for key, value in pairs(settings) do
    notice(tostring(key) .. ' → ' .. tostring(value))
  end
  handle_queue()
end

function handle_start() 
  if run then
    return "Repeater is already running.  Type '//re stop' to stop."
  end

  if command_queue:length() == 0 then 
    return 'Command Queue is empty.  To add one, type //re c <command_name>'
  end

  if delay < MIN_DELAY or delay > MAX_DELAY then
    return 'Delay is not in range.  To update delay, type //re d <integer ' .. MIN_DELAY .. '-' .. MAX_DELAY .. '>'
  end

  notice('Beginning Repeater with delay '..tostring(delay)..'.')
  handle_queue()
  notice("You may type '//re stop' to stop.")

  run = true
  engine()
end

function handle_stop()
    if run == false then
        return "Repeater is not running.  Type '//re start' to start it."
    end

    run = false
    notice('Stopping Repeater.')
end

--------------------------
--  Engine Functions    --
--------------------------
function engine()
  local status = windower.ffxi.get_player().status

  -- status 0 is idle, status 1 is combat, status 33 is healing
  if run and (status == 0 or (runincombat and status == 1)) then 
    windower.chat.input(command_queue['data'][command_queue_index]) 
    increment_command_queue_index()
  end

  reschedule_engine()
end

function reschedule_engine()
  coroutine.schedule(engine, delay) -- schedule recursion
end

--------------------------
--  Utility Functions   --
--------------------------
function increment_command_queue_index()
  command_queue_index = 
    ternary(
      command_queue_index == command_queue:length(), 
      1,
      command_queue_index + 1
    )
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
    ['command'] = handle_command,
    ['delay'] = handle_delay,
    ['queue'] = handle_queue,
    ['runincombat'] = handle_runincombat,
    ['settings'] = handle_settings,
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