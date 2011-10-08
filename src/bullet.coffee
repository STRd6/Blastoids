Bullet = (I) ->
  I ||= {}

  $.reverseMerge I,
    color: "red"
    height: 4
    includedModules: ["Movable"]
    speed: 20
    width: 4

  self = GameObject(I)

  return self
