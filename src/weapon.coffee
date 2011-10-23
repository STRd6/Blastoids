Weapon = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    color: "blue"
    height: 32
    width: 32
    fire: ->

  # Inherit from game object
  self = GameObject(I).extend
    fire: (source, direction) ->
      I.fire(source, direction)

  # We must always return self as the last line
  return self

