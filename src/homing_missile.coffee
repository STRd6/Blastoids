HomingMissile = (I={}) ->
  Object.reverseMerge I,
    damage: 10
    duration: 40
    height: 24
    includedModules: ["Durable", "Rotatable"]
    sprite: "homing_missile"
    radius: 12
    width: 24
    velocity: Point(0, 0)

  self = Base(I)

  self.bind "collide", (other) ->
    if other != self
      self.destroy() 

  self.bind "update", ->
    players = engine.find("Player")
    targets = []

    players.each (player) ->
      unless player == I.source 
        distanceSquared = Point.distanceSquared(I, player.position())
        targets.push {distance: distanceSquared, player: player}  

        targets.sort (a, b) ->
          a.distance - b.distance

        if target = targets.first()
          player = target.player

          targetPosition = player.position().subtract(I)  

          direction = Math.atan2(targetPosition.y, targetPosition.x)
          I.rotation = direction

          if direction
            I.velocity = Point((I.velocity.x * 0.95) + Math.cos(direction), (I.velocity.y * 0.95) + Math.sin(direction))
    log I.velocity

  return self
