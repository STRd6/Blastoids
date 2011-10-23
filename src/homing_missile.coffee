HomingMissile = (I={}) ->
  Object.reverseMerge I,
    damage: 10
    duration: 20
    height: 24
    includedModules: ["Durable", "Rotatable"]
    sprite: "homing_missile"
    radius: 12
    width: 24
    velocity: Point(0, 0)

  self = GameObject(I)

  self.bind "collide", (other) ->
    if other != I.source
      self.destroy() 

  self.bind "update", ->
    players = engine.find("Player")
    targets = []

    players.each (player) ->
      unless player == I.source 
        distanceSquared = Point.distanceSquared(Point(I.x, I.y), Point(player.I.x, player.I.y))
        targets.push {distance: distanceSquared, player: player}  

        targets.sort (a, b) ->
          a.distance - b.distance

        if target = targets.first().player
          targetPosition = Point(target.I.x, target.I.y)  

          direction = Math.atan2(targetPosition.y, targetPosition.x)
          I.rotation = direction

          if direction
            I.velocity = Point((I.velocity.x * 0.95) + Math.cos(direction), (I.velocity.y * 0.95) + Math.sin(direction))

    I.x += I.velocity.x
    I.y += I.velocity.y

  return self
