HomingMissile = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    height: 24
    sprite: "homing_missile"
    width: 24
    velocity: Point(3, 0)

  # Inherit from game object
  self = Bullet(I)

  # Add events and methods here
  self.bind "update", ->
    ; # Add update method behavior

  # We must always return self as the last line
  return self
