HomingMissile = (I={}) ->
  Object.reverseMerge I,
    height: 24
    includedModules: ["Movable"]
    sprite: "homing_missile"
    radius: 12
    width: 24
    velocity: Point(3, 0)

  self = Bullet(I)

  self.bind "update", ->
    players = engine.find("Player")
    hits = []

    players.each (player) ->
      unless player == I.source    

      if point = Collision.circular(self, player)
        distanceSquared = Point.distanceSquared(I.start, point)
        hits.push {distanceSquared, point, object}  

      hits.sort (a, b) ->
        a.distanceSquared - b.distanceSquared

      if nearestHit = hits.first()
        nearestPosition = nearestHit.position()  

        direction = Math.atan2(nearestPosition.y, nearestPosition.x)

        if direction
          I.velocity = ((I.xVelocity * 0.95) + Math.cos(direction), (I.yVelocity * 0.95) + Math.sin(direction))

  return self
