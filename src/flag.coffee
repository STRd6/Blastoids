Flag = (I) ->
  I ||= {}

  # Set some default properties
  $.reverseMerge I,
    color: "blue"
    height: 40
    sprite: "flag"
    width: 20

  # Inherit from game object
  self = GameObject(I)

  # Add events and methods here
  self.bind "update", ->
    ; # Add update method behavior

  # We must always return self as the last line
  return self
