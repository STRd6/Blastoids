Blade = (I={}) ->
  Object.reverseMerge I,
    damage: 3
    duration: 200
    includedModules: ["Durable", "Rotatable"]
    radius: 5
    rotation: -Math.PI * engine.I.age / 100
    source: self
    speed: 40
    sprite: "blade"
    velocity: Point(Math.cos(rotationSpeed + direction), Math.sin(rotationSpeed + direction))
    x: I.x
    y: I.y

  self = GameObject(I)

  return self
