Wall = (I={}) ->
  # Set some default properties
  $.reverseMerge I,
    color: "orange"
    start: Point(rand(App.width), rand(App.height))
    sprite: "placeholder"
    end: Point(rand(App.width), rand(App.height))
    width: 0
    height: 0

  I.zIndex = 1 + (I.y + I.height)/App.height

  lastProj = 0
  inside = false
  collided = false
  closestPoint = undefined
  norm = undefined

  # Inherit from game object
  self = GameObject(I).extend
    direction: ->
      I.end.subtract(I.start)

    normal: ->
      delta = self.direction()

      Point(-delta.y, delta.x).norm()

    length: ->
      self.direction().length()

    midpoint: ->
      I.start.add(I.end).scale(0.5)

    collides: (circle) ->
      pos = Point(circle.x, circle.y)

      vec = pos.subtract(I.start)
      direction = self.direction().norm()

      lastProj = projectionLength = vec.dot(direction)

      inside = projectionLength > 0 and projectionLength < self.length()

      if inside
        closestPoint = I.start.add(direction.scale(projectionLength))
        closestPoint.radius = 0

        if Collision.circular(circle, closestPoint)
          collided = true
          norm = pos.subtract(closestPoint).norm()

          return norm

      collided = false
      norm = undefined
      closestPoint = undefined

    rayCollides: (ray) ->
      crossProduct = self.direction().cross(ray.direction)

      delta = I.start.subtract(ray.start)

      t = ray.direction.cross(delta) / crossProduct
      s = self.direction().cross(delta) / crossProduct

      # In front of ray
      if 0 <= s
        if 0 <= t <= 1
          Point.interpolate(I.start, I.end, t)

  # Add events and methods here
  self.bind "update", ->
    ; # Add update method behavior

  self.unbind "draw"
  self.bind "draw", (canvas) ->
    canvas.drawLine
      color: I.color
      start: I.start
      end: I.end
      width: 4

  self.bind "drawDebug", (canvas) ->
    # Debug
    canvas.drawLine
      color: "green"
      start: self.midpoint()
      end: self.midpoint().add(self.normal().scale(15))
      width: 3

    canvas.drawCircle
      position: I.start
      radius: 5
      color: "purple"

    if lastProj?
      canvas.drawLine
        color: "rgba(255, 0, 0, 0.75)"
        direction: self.direction()
        start: I.start
        length: lastProj
        width: 2

    if norm? and closestPoint?
      canvas.drawLine
        start: closestPoint
        end: closestPoint.add(norm.scale(20))
        color: "red"

  # We must always return self as the last line
  return self

