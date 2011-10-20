Box = (I) ->
  I ||= {}

  # Set some default properties
  $.reverseMerge I,
    color: "blue"
    health: 20
    height: 48
    width: 48
    radius: 16
    sprite: "barrel"

  # Inherit from game object
  self = Base(I)

  self.bind "collide", (other) ->
    if other.I.active
      if damage = other.I.damage
        I.health -= damage

        if I.health <= 0
          self.destroy()

  self.bind "destroy", ->
    engine.add
      class: "ParticleEffect"
      x: I.x
      y: I.y

  # We must always return self as the last line
  return self

