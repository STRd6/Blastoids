Physics = ->
  WALL_LEFT = 0
  WALL_RIGHT = App.width
  WALL_TOP = App.height
  WALL_BOTTOM = 0

  overlapX = (wall, circle) ->
    (circle.x - wall.center.x).abs() < wall.halfWidth + circle.radius 

  overlapY = (wall, circle) ->
    (circle.y - wall.center.y).abs() < wall.halfHeight + circle.radius

  rectangularOverlap = (wall, circle) ->
    return overlapX(wall, circle) && overlapY(wall, circle)

  # Arena walls
  walls = [{
      normal: Point(1, 0)
      position: WALL_LEFT
    }, {
      normal: Point(-1, 0)
      position: -WALL_RIGHT
    }, {
      normal: Point(0, 1)
      position: WALL_TOP
    }, {
      normal: Point(0, -1)
      position: -WALL_BOTTOM
  }]

  threshold = 5

  resolveCollision = (A, B) ->
    normal = B.center().subtract(A.center()).norm()

    # Elastic collisions
    relativeVelocity = A.I.velocity.subtract(B.I.velocity)

    massA = A.mass()
    massB = B.mass()

    totalMass = massA + massB

    pushA = normal.scale(-2 * (relativeVelocity.dot(normal) * (massB / totalMass) + 1))
    pushB = normal.scale(+2 * (relativeVelocity.dot(normal) * (massA / totalMass) + 1))

    # Adding impulse
    A.I.velocity = A.I.velocity.add(pushA)
    B.I.velocity = B.I.velocity.add(pushB)

  resolveCollisions = (objects, dt) ->
    objects.eachPair (a, b) ->
      return unless a.collides() && b.collides()

      if Collision.circular(a.circle(), b.circle())
        resolveCollision(a, b)

    return 
    # Arena Walls
    objects.each (object) ->
      return unless object.collidesWithWalls()

      center = object.center()
      {radius, velocity} = object.I

      # Wall Collisions
      collided = false
      walls.each (wall) ->
        {position, normal} = wall

        # Penetration Vector
        if center.dot(normal) < radius + position
          velocityProjection = velocity.dot(normal)
          # Heading towards wall
          if velocityProjection < 0
            # Reflection Vector
            velocity = velocity.subtract(normal.scale(2 * velocityProjection))

            collided = true

      if collided
        # Adjust velocity and move to (hopefully) non-penetrating position
        object.I.velocity = velocity
        object.updatePosition(dt, true)

        object.trigger "wallCollision"

      return

  process: (objects) ->
    steps = 4

    dt = 1/steps

    steps.times ->
      objects.invoke "updatePosition", dt

      resolveCollisions(objects, dt)

