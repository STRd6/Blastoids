Player = (I) ->
  I ||= {}

  Object.reverseMerge I,
    color: "blue"
    includedModules: ["Movable"]
    height: 32
    width: 32
    x: 0
    y: 0
    speed: 10
    velocity: Point(0, 0)

  self = GameObject(I)

  self.bind "update", ->
    I.velocity = Point(0, 0)

    if keydown.left
      I.velocity.add$(-1, 0)
    if keydown.right
      I.velocity.add$(1, 0)
    if keydown.up
      I.velocity.add$(0, -1)
    if keydown.down
      I.velocity.add$(0, 1)

    I.velocity.scale$(I.speed)

  return self
