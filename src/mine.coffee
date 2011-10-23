Mine = (I={}) ->
  Object.reverseMerge I,
    height: 24
    sprite: "mine"
    width: 24

  self = GameObject(I)

  self.bind "update", ->
    ; # Add update method behavior

  return self
