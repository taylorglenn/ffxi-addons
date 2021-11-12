_addon.name = 'crabsquad'
_addon.version = '1'
_addon.author = 'taylor'
_addon.command = 'cs'

--Requiring libraries used in this addon
--These should be saved in addons/libs
require('logger')
require('tables')
require('strings')
res = require('resources')

windower.register_event('addon command', function(...)
    log('CRAB SQUAD!')
    local player = windower.ffxi.get_player()
    local player_status = player.status
    local mounting_commands = {
        [0] = '/mount "red crab" <me>',
        [85] = '/dismount'
    }
    local command = mounting_commands[player_status]

    if command == nil then
        log('you can\'t crab')
    else
        windower.chat.input(command)
    end
end)