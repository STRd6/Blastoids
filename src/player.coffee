Player = (I) ->
  I ||= {}

  SPRITES_WIDE = 16

  animationStep = 0
  standingOffset = Point(0, -16)

  Object.reverseMerge I,
    color: "blue"
    includedModules: ["Movable"]
    heading: 0
    height: 32
    width: 32
    radius: 16
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
    I.hflip = (I.heading > 2*Math.TAU/8 || I.heading < -2*Math.TAU/8)

    cycle = (I.age/4).floor() % 2
    if -Math.TAU/8 <= I.heading <= Math.TAU/8
      facingOffset = 0
    else if -3*Math.TAU/8 <= I.heading <= -Math.TAU/8
      facingOffset = 4
    else if Math.TAU/8 < I.heading <= 3*Math.TAU/8
      facingOffset = 2
    else
      facingOffset = 0

    teamColor = I.team * SPRITES_WIDE

    spriteIndex = cycle + facingOffset + teamColor

    I.spriteOffset = standingOffset
    I.sprite = sprites[spriteIndex]  

    movement = Point(0, 0)

    if actionDown "left"
      movement = movement.add(Point(-1, 0))
    if actionDown "right"
      movement = movement.add(Point(1, 0))
    if actionDown "up"
      movement = movement.add(Point(0, -1))
    if actionDown "down"
      movement = movement.add(Point(0, 1))

    movement = movement.norm()

    I.velocity = movement.scale(I.speed)

    unless I.velocity.magnitude() == 0
      I.heading = Point.direction(Point(0, 0), I.velocity)

    if actionPressed('space')
      self.shoot(I.velocity.norm()) unless I.velocity.equal(Point(0, 0))

    if actionPressed('z')
      self.shootSpread(I.velocity.norm()) unless I.velocity.equal(Point(0, 0))

    I.x = I.x.clamp(I.width / 2, App.width - I.width / 2)
    I.y = I.y.clamp(I.height / 2, App.height - I.height / 2)

    animationStep

  return self
