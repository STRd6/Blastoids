Box = (I) ->
  I ||= {}

  # Set some default properties
  $.reverseMerge I,
    color: "blue"
    height: 32
    width: 32
    radius: 16

  # Inherit from game object
  self = Base(I)

  self.bind "collide", ->
    debugger
    self.destroy()

  self.bind "destroy", ->
    engine.add
      class: "ParticleEffect"
      x: I.x
      y: I.y

  # We must always return self as the last line
  return self

