--------------------------
--  Info                --
--------------------------
_addon.name = 'Dancr'
_addon.version = '1.0'
_addon.author = 'BlueGlenn'
_addon.commands = { 'dancr', 'dnc' }

--------------------------------------------
--  Requireds                             --
--  These should be saved in addons/libs  --
--------------------------------------------
config = require('config')
packets = require('packets')
res = require('resources')
texts = require('texts')
require('tables')
require('logger')

--------------------------
--  Color Constants     --
--------------------------
colors = 
{
  ['white'] = '\\cs(255,255,255) ',
  ['red'] = '\\cs(255,0,0) ',
  ['green'] = '\\cs(0,255,0) ',
  ['yellow'] = '\\cs(255,255,0) ',
}

--------------------------
--  Configure Settings  --
--------------------------
local defaults = T{}
settings = config.load('data\\settings.xml', defaults)

--------------------------
--  Box Setup           --
--------------------------
box = texts.new(settings.text_box_settings, settings)
box:text('')

--------------------------
--  Global Flags        --
-------------------------- 
is_hidden = false
verbose = false

----------------------------------
--  Command Handler Functions   --
----------------------------------
function handle_help()
  local INDENT = ' ':rep(3)
  local help_lines = 
  {
    '-- Dancr (a simple addon by BlueGlenn) --',
    'Commands:',
    INDENT..'//dnc show:'..INDENT..'shows the addon',
    INDENT..'//dnc hide:'..INDENT..'hides the addon',
    INDENT..'//dnc verbose:'..INDENT..'shows or hides the flourish descriptions',
  }
  notice(table.concat(help_lines,'\n'))
end

function handle_show() 
  is_hidden = false
end

function handle_hide()
  is_hidden = true
end

function handle_verbose()
  verbose = not verbose
end

------------------------------
--  Box Drawing Functions   --
------------------------------
function draw_box()
  if is_hidden then
    box:hide()
    return
  end

  local box_lines = L{}

  local INDENT = ' ':rep(3)
  local flourishes = load_flourishes()

  -- Display No Foot Rise Timer
  local nfr_obj = get_nfr_obj()
  box_lines:append(nfr_obj.color..'No Foot Rise: '..nfr_obj.recast..'\\cr')

  -- Display Number of Finishing Moves Available
  local fm_obj = get_fm_obj()
  box_lines:append(fm_obj.color..'Finishing Moves: '..fm_obj.moves..'\\cr\n')

  -- Display Flourishes
  for _,fl_obj in pairs(flourishes) do
    box_lines:append(fl_obj.color..fl_obj.name..': '..fl_obj.recast)

    -- Display Flourish Guide
    for _,flourish in pairs(fl_obj.flourishes) do
      local line = (
        verbose and '['..flourish.fms..'] '..flourish.name..' ('..flourish.help..')'
        or
        not verbose and flourish.name)

      box_lines:append(INDENT..line)
    end

    box_lines:append('\\cr')
  end
  
  box:text(box_lines:concat('\n'))
  box:show()
end

--------------------------
--  Utility Functions   --
--------------------------
function ter(cond, t, f)
  if cond then return t else return f end
end

function get_recast_time(recast_id)
  local recast_timer = windower.ffxi.get_ability_recasts()[recast_id]
  if recast_timer == nil then return 0 end
  return recast_timer
end

function get_finishing_moves()
  local buffs = S(windower.ffxi.get_player().buffs)
  local finishing_move_ids = 
  { --  ~/res/buffs.lua
    [1] = 381,
    [2] = 382,
    [3] = 383,
    [4] = 384,
    [5] = 385,
    [6] = 588 -- this is actually 6 plus, but it needs to be an integer to be used in logic elsewhere
  }

  for k,v in pairs(finishing_move_ids) do
    if buffs:contains(v) then return k end
  end

  return 0
end

function get_fm_obj()
  local m = get_finishing_moves()
  return 
  {
    moves = ter(m == 6, '6+', tostring(m)),
    color = 
      ter(
        m > 0, 
        ter(
          m == 1, 
          colors.yellow, 
          colors.green), 
        colors.red)
  }
end

function get_nfr_obj()
  -- recast_id from ~/res/job_abilities.lua
  local nfr_recast = get_recast_time(223) -- no foot rise
  return 
  {
    recast = math.ceil(nfr_recast),
    color = ter(nfr_recast > 0, colors.red, colors.green)
  }
end

function load_all_job_abilities()
  for k,v in pairs(res.job_abilities) do
    all_items[string.lower(v.english)] = { id = k, name = v.english, recast_id = v.recast_id }
  end
end

function load_flourishes()
   -- these are recast_id from ~/res/job_abilities.lua
   local f1_recast = math.ceil(get_recast_time(221))
   local f2_recast = math.ceil(get_recast_time(222))
   local f3_recast = math.ceil(get_recast_time(226))

  return 
  {
    [1] =
    {
      name = 'Flourishes I',
      recast = f1_recast,
      color = ter(f1_recast > 0, colors.red, colors.white),
      flourishes = 
      T{
        {name='Animated Flourish', fms='1~2', help='Provoke'},
        {name='Desperate Flourish', fms='1', help='Gravity'},
        {name='Violent Flourish', fms='1', help='Stun'}
      }
    },
    [2] =
    {
      name = 'Flourishes II',
      recast = f2_recast,
      color = ter(f2_recast > 0, colors.red, colors.white),
      flourishes = 
      T{
        {name='Reverse Flourish', fms='1~5', help='Gain TP'},
        {name='Building Flourish', fms='1~3', help='Buff next WS'},
        {name='Wild Flourish', fms='2', help='Ready Skillchain'}
      }
    },
    [3] =
    {
      name = 'Flourishes III',
      recast = f3_recast,
      color = ter(f3_recast > 0, colors.red, colors.white),
      flourishes = 
      T{
        {name='Climactic Flourish', fms='1~5', help='Force crit(s)'},
        {name='Striking Flourish', fms='2', help='Force DA'},
        {name='Ternary Flourish', fms='3', help='Force TA'}
      }
    }
  }
end

--------------------------
--  Command Handlers    --
--------------------------
handlers = {
    ['help'] = handle_help,
    ['h'] = handle_help,
    ['show'] = handle_show,
    ['hide'] = handle_hide,
    ['verbose'] = handle_verbose
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
windower.register_event('prerender', draw_box)