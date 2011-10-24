HomingMissile = (I={}) ->
  Object.reverseMerge I,
    damage: 0
    duration: 90
    height: 24
    includedModules: ["Rotatable"]
    sprite: "homing_missile"
    radius: 12
    width: 24
    velocity: Point(0, 0)

  self = Base(I)

  self.bind "collide", (other) ->
    if other != I.source && I.active
      self.destroy()

  self.bind "destroy", (other) ->
    engine.add
      class: "Explosion"
      damage: 2
      deltaRadius: 3
      particleCount: 2
      particleDamage: 2
      radius: 10
      x: I.x
      y: I.y 

  self.bind "wallCollide", ->
    self.destroy()

  self.bind "update", ->
    if I.age >= I.duration && I.active
      self.destroy()
      return

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

  Sound.play "bls_sfx_rocketlaunch_01"

  return self
