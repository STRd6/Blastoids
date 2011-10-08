Bullet = (I) ->
  I ||= {}

  $.reverseMerge I,
    color: "red"
    height: 4
    includedModules: ["Movable"]
    width: 4

  # Inherit from game object
  self = GameObject(I)

  # Add events and methods here
  self.bind "update", ->
    ; # Add update method behavior

  # We must always return self as the last line
  return self
