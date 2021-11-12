--------------------------
--  Info                --
--------------------------
_addon.name = 'BouncyCastle'
_addon.version = '1.0'
_addon.author = 'BlueGlenn'
_addon.commands = { 'bouncycastle', 'bc' }

--------------------------------------------
--  Requireds                             --
--  These should be saved in addons/libs  --
--------------------------------------------
require('logger')
require('tables')
require('strings')
res = require('resources')

--------------------------
--  Constants           --
--------------------------
CONST_DELAY = 1

--------------------------
--  System Objects      --
--------------------------

--------------------------
--  User Settings       --
--------------------------
run = false

----------------------------------
--  Command Handler Functions   --
----------------------------------
function handle_help()
    local help_block = ''
    local instruction_lines = {
        "Start BouncyCastle with '//bc start'.",
        "Stop BouncyCastle with '//bc stop'."
    }
    for i = 1,table.getn(instruction_lines) do -- yep, arrays in lua are 1 based...
        help_block = help_block .. '\n' .. tostring(i) .. '. ' ..  instruction_lines[i]
    end
    windower.add_to_chat(100, help_block)
end

function handle_start() 
    if run then
        return "BouncyCastle is already running.  Type '//bc stop' to stop."
    end

    notice('Beginning BouncyCastle.  Be careful!')
    notice("You may type '//bc stop' to stop.")

    run = true
    engine()
end

function handle_stop()
    if run == false then
        return "BouncyCastle is not running.  Type '//bc start' to start it."
    end

    run = false
    notice('Stopping BouncyCastle.')
end

--------------------------
--  Engine Functions    --
--------------------------
function engine()
    local player = windower.ffxi.get_player()

    if run and player.status ~= 1 then
        windower.chat.input('/jump')
    end

    reschedule_engine()
end

function reschedule_engine()
    engine:schedule(CONST_DELAY) -- schedule recursion
end

--------------------------
--  Utility Functions   --
--------------------------

--------------------------
--  Command Handlers    --
--------------------------
handlers = {
    ['help'] = handle_help,
    ['h'] = handle_help,
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