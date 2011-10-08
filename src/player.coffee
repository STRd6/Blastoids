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

  actionDown = (actions...) ->
    actions.inject false, (isDown, action) ->
      return isDown || keydown[action]

  actionDown = (actions...) ->
    actions.inject false, (isDown, action) ->
      return isDown || justPressed[action]

  self = GameObject(I).extend
    shoot: (direction) ->
      engine.add
        class: "Bullet"
        velocity: Point(direction.x, direction.y)

  self.bind "update", ->
    I.velocity = Point(0, 0)

    if actionDown('left')
      I.velocity.add$(-1, 0)
    if actionDown('right')
      I.velocity.add$(1, 0)
    if actionDown('up')
      I.velocity.add$(0, -1)
    if actionDown('down')
      I.velocity.add$(0, 1)

    I.velocity.scale$(I.speed)

    if actionDown || justPressed.z


  return self
