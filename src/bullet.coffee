Bullet = (I) ->
  I ||= {}

  Object.reverseMerge I,
    color: "red"
    height: 4
    includedModules: ["Movable"]
    speed: 20
    width: 4

  I.velocity.scale$(I.speed)

  self = GameObject(I)

  return self
