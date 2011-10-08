Player = (I) ->
  I ||= {}

  Object.reverseMerge I,
    color: "blue"
    includedModules: ["Movable"]
    height: 32
    width: 32
    x: 50
    y: 50
    speed: 10
    velocity: Point(0, 0)

  actionDown = (actions...) ->
    actions.inject false, (isDown, action) ->
      return isDown || keydown[action]

  actionPressed = (actions...) ->
    actions.inject false, (isDown, action) ->
      return isDown || justPressed[action]

  self = GameObject(I).extend
    shoot: (direction) ->
      engine.add
        class: "Bullet"
        velocity: Point(direction.x, direction.y)
        x: I.x
        y: I.y

    shootSpread: (direction) ->
      angle = Math.atan2(direction.y, direction.x)

      up = Point.fromAngle(angle - Math.TAU / 32)
      down = Point.fromAngle(angle + Math.TAU / 32)

      engine.add
        class: "Bullet"
        speed: 15
        velocity: Point(up.x, up.y)
        x: I.x
        y: I.y  

      engine.add
        class: "Bullet"
        speed: 15
        velocity: Point(direction.x, direction.y)
        x: I.x
        y: I.y

      engine.add
        class: "Bullet"
        speed: 15
        velocity: Point(down.x, down.y)
        x: I.x
        y: I.y

  self.bind "update", ->
    I.sprite = sprites[0]  

    I.velocity = Point(0, 0)

    if actionDown('left')
      I.velocity.add$(-1, 0)
      I.hflip = true
      I.sprites =  sprites[0]
    if actionDown('right')
      I.velocity.add$(1, 0)
      I.hflip = false
      I.sprites = sprites[0]
    if actionDown('up')
      I.velocity.add$(0, -1)
      I.sprite = sprites[5]
    if actionDown('down')
      I.velocity.add$(0, 1)
      I.sprite = sprites[3]

    I.velocity.scale$(I.speed)

    if actionPressed('space')
      self.shoot(I.velocity.norm()) unless I.velocity.equal(Point(0, 0))

    if actionPressed('z')
      self.shootSpread(I.velocity.norm()) unless I.velocity.equal(Point(0, 0))

    I.x = I.x.clamp(I.width / 2, App.width - I.width / 2)
    I.y = I.y.clamp(I.height / 2, App.height - I.height / 2)

  return self
