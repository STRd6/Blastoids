Wall = (I={}) ->
  # Set some default properties
  $.reverseMerge I,
    color: "orange"
    start: Point(0, 10)
    sprite: "placeholder"
    end: Point(50, 10)
    width: 4

  # Inherit from game object
  self = GameObject(I)

  # Add events and methods here
  self.bind "update", ->
    ; # Add update method behavior

  self.unbind "draw"
  self.bind "draw", (canvas) ->
    canvas.drawLine(I)

  # We must always return self as the last line
  return self

