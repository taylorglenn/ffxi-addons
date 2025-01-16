local me, target
repeat
    me = windower.ffxi.get_mob_by_target('me')
    target = windower.ffxi.get_mob_by_target('t')
    if target then
        windower.ffxi.run(target.x - me.x, target.y - me.y)
    end
    coroutine.sleep(.005)
until target and math.sqrt(target.distance) < 2