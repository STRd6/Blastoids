Bullet = (I) ->
  I ||= {}

  Object.reverseMerge I,
    color: "red"
    duration: 30
    includedModules: ["Durable", "Movable"]
    speed: 12
    radius: 5
    width: 10
    height: 10

  I.velocity.scale(I.speed)

  self = Base(I)

  return self

