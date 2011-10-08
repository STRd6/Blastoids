Bullet = (I) ->
  I ||= {}

  Object.reverseMerge I,
    color: "red"
    duration: 30
    height: 4
    includedModules: ["Durable", "Movable"]
    speed: 20
    width: 4

  I.velocity.scale$(I.speed)

  self = GameObject(I)

  return self
