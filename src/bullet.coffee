Bullet = (I) ->
  I ||= {}

  $.reverseMerge I,
    color: "red"
    height: 4
    includedModules: ["Movable"]
    width: 4

  self = GameObject(I)

  return self
