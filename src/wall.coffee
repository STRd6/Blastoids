Wall = (I={}) ->
  # Set some default properties
  $.reverseMerge I,
    color: "orange"
    start: Point(rand(App.width), rand(App.height))
    sprite: "placeholder"
    end: Point(rand(App.width), rand(App.height))
    width: 4
    zIndex: 2

  lastProj = 0
  inside = false
  collided = false

  # Inherit from game object
  self = GameObject(I).extend
    direction: ->
      I.end.subtract(I.start)

    normal: ->
      delta = self.direction()

      Point(-delta.y, delta.x)

    length: ->
      self.direction().length()

    midpoint: ->
      I.start.add(I.end).scale(0.5)

    collides: (circle) ->
      pos = Point(circle.x, circle.y).subtract(I.start)
      direction = self.direction().norm()

      lastProj = projectionLength = pos.dot(direction)

      inside = projectionLength > 0 and projectionLength < self.length()

      if inside
        closestPoint = I.start.add(direction.scale(projectionLength))
        closestPoint.radius = 0

        if Collision.circular(circle, closestPoint)
          collided = true
          return closestPoint.subtract(pos).norm()

      collided = false

  # Add events and methods here
  self.bind "update", ->
    ; # Add update method behavior

  self.unbind "draw"
  self.bind "draw", (canvas) ->
    if collided
      I.color = "red"
    else if inside
      I.color = "green"
    else
      I.color = "orange"

    canvas.drawLine(I)

    # Debug
    canvas.drawLine
      color: "green"
      start: self.midpoint()
      end: self.midpoint().add(self.normal().norm(15))
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

  # We must always return self as the last line
  return self

