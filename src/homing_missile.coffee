HomingMissile = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    height: 24
    sprite: "homing_missile"
    width: 24

  # Inherit from game object
  self = GameObject(I)

  # Add events and methods here
  self.bind "update", ->
    ; # Add update method behavior

  # We must always return self as the last line
  return self
