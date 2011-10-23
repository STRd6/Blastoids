HomingMissile = (I={}) ->
  Object.reverseMerge I,
    height: 24
    includedModules: ["Movable"]
    sprite: "homing_missile"
    radius: 12
    width: 24
    velocity: Point(0, 0)

  self = Bullet(I)

  self.bind "update", ->
    players = engine.find("Player")
    hits = []

    players.each (player) ->
      unless player == self 
        distanceSquared = Point.distanceSquared(Point(I.x, I.y), Point(player.I.x, player.I.y))
        hits.push [distanceSquared, player]  

        hits.sort (a, b) ->
          a[0] - b[0]

        if nearestHit = hits.first()[1]
          nearestPosition = nearestHit.position()  

          direction = Math.atan2(nearestPosition.y, nearestPosition.x)

          if direction
            I.velocity = Point((I.xVelocity * 0.95) + Math.cos(direction), (I.yVelocity * 0.95) + Math.sin(direction))

  return self
