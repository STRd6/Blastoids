Weapon = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    color: "blue"
    height: 32
    width: 32
    fire: ->

  # Inherit from game object
  self = GameObject(I).extend
    fire: (direction) ->
      I.fire(direction)

  # We must always return self as the last line
  return self

