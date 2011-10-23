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
    targets = []

    players.each (player) ->
      unless player == self 
        distanceSquared = Point.distanceSquared(Point(I.x, I.y), Point(player.I.x, player.I.y))
        targets.push {distance: distanceSquared, target: player}  

        targets.sort (a, b) ->
          a.distance - b.distance

        if target = targets.first().target
          targetPosition = target.position()  

          direction = Math.atan2(targetPosition.y, targetPosition.x)

          if direction
            I.velocity = Point((I.velocity.x * 0.95) + Math.cos(direction), (I.velocity.y * 0.95) + Math.sin(direction))

  return self
