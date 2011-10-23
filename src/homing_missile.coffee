HomingMissile = (I={}) ->
  Object.reverseMerge I,
    height: 24
    sprite: "homing_missile"
    width: 24
    velocity: Point(3, 0)

  self = Bullet(I)

  self.bind "update", ->
    players = engine.find("Player")

    if point = Collision.rayCircle(I.start, I.direction, object)
      distanceSquared = Point.distanceSquared(I.start, point)
      hits.push {distanceSquared, point, object}  

    target = currentLevel.nearestTarget(self.position(), I.collisionType);

  return self
