Wall = (I={}) ->
  # Set some default properties
  $.reverseMerge I,
    color: "orange"
    start: Point(0, 10)
    sprite: "placeholder"
    end: Point(50, 10)
    width: 4

  # Inherit from game object
  self = GameObject(I).extend
    normal: ->
      delta = I.end.subtract(I.start)

      Point(-delta.y, delta.x)

    midpoint: ->
      I.start.add(I.end).scale(0.5)

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

  # We must always return self as the last line
  return self

