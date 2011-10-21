Physics = ->
  overlapX = (wall, circle) ->
    (circle.x - wall.center.x).abs() < wall.halfWidth + circle.radius 

  overlapY = (wall, circle) ->
    (circle.y - wall.center.y).abs() < wall.halfHeight + circle.radius

  rectangularOverlap = (wall, circle) ->
    return overlapX(wall, circle) && overlapY(wall, circle)

  resolveCollisions = (objects, dt) ->
    objects.eachPair (a, b) ->
      return unless a.collides() && b.collides()

      if Collision.circular(a.circle(), b.circle())
        a.trigger "collide", b
        b.trigger "collide", a

    return

  resolveWallCollisions = (objects, walls, dt) ->
    objects.each (object) ->
      velocity = object.I.velocity
      collided = false

      walls.each (wall) ->
        if normal = wall.collides(object.I)
          velocityProjection = velocity.dot(normal)
          # Heading towards wall
          if velocityProjection < 0
            debugger
            # Reflection Vector
            velocity = velocity.subtract(normal.scale(2 * velocityProjection))

      if collided
        object.I.velocity = velocity
        # Move out of wall
        object.updatePosition(dt)

  process: (objects, walls) ->
    players = objects.select (object) ->
      object.I.class == "Player"

    steps = 4

    dt = 1/steps

    steps.times ->
      objects.invoke "updatePosition", dt

      resolveCollisions(objects, dt)
      resolveWallCollisions(players, walls, dt)

    # Debug walls
    if player1 = engine.find("Player.team=0").first()
      engine.find("Wall").invoke("collides", player1.I)

