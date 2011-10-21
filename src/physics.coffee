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

  resolveCollisions = (objects, dt) ->
    objects.eachPair (a, b) ->
      return unless a.collides() && b.collides()

      if Collision.circular(a.circle(), b.circle())
        a.trigger "collide", b
        b.trigger "collide", a

    return

  process: (objects) ->
    steps = 4

    dt = 1/steps

    steps.times ->
      objects.invoke "updatePosition", dt

      resolveCollisions(objects, dt)

