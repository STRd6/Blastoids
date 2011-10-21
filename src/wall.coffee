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

  # Inherit from game object
  self = GameObject(I).extend
    direction: ->
      I.end.subtract(I.start)

    normal: ->
      delta = self.direction()

      Point(-delta.y, delta.x)

    midpoint: ->
      I.start.add(I.end).scale(0.5)

    collides: (circle) ->
      pos = Point(circle.x, circle.y).subtract(I.start)

      lastProj = proj = pos.dot(self.direction().norm())

  # Add events and methods here
  self.bind "update", ->
    ; # Add update method behavior

  self.unbind "draw"
  self.bind "draw", (canvas) ->
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

