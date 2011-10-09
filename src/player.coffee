Player = (I) ->
  I ||= {}

  activeWeapon = 0

  controller = Joysticks.getController(0)

  SPRITES_WIDE = 16

  animationStep = 0
  standingOffset = Point(0, -16)

  Object.reverseMerge I,
    color: "blue"
    cooldowns:
      shoot: 0
    heading: 0
    height: 32
    width: 32
    radius: 16
    team: 0
    x: 50
    y: 50
    speed: 7
    velocity: Point(0, 0)

  actionDown = (actions...) ->
    if controller
      controller.actionDown(actions...)
    else
      actions.inject false, (isDown, action) ->
        return isDown || keydown[action]

  actionPressed = (actions...) ->
    actions.inject false, (isDown, action) ->
      return isDown || justPressed[action]

  self = Base(I)

  self.bind "update", ->
    for key, value of I.cooldowns
      I.cooldowns[key] = value.approach(0, 1)

    if controller.actionDown("A")
      activeWeapon += 1

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

    movement = controller.position()
    shootVelocity = controller.position(1)

    movement = movement.norm()

    I.velocity = movement.scale(I.speed)

    unless I.velocity.magnitude() == 0
      I.heading = Point.direction(Point(0, 0), I.velocity)

    if shootVelocity.magnitude() > 0.5
      weapons.wrap(activeWeapon)(shootVelocity.norm())

  weapons = [
    (direction) ->    
      if I.cooldowns.shoot == 0
        I.cooldowns.shoot = 5

        engine.add
          class: "Bullet"
          velocity: Point(direction.x, direction.y)
          x: I.x
          y: I.y
    (direction) ->
      angle = Math.atan2(direction.y, direction.x)

      up = Point.fromAngle(angle - Math.TAU / 32)
      down = Point.fromAngle(angle + Math.TAU / 32)

      if I.cooldowns.shoot == 0
        I.cooldowns.shoot = 10

        engine.add
          class: "Bullet"
          radius: 4
          speed: 10
          velocity: Point(up.x, up.y)
          x: I.x
          y: I.y  

        engine.add
          class: "Bullet"
          radius: 4
          speed: 10
          velocity: Point(direction.x, direction.y)
          x: I.x
          y: I.y

        engine.add
          class: "Bullet"
          radius: 4
          speed: 10
          velocity: Point(down.x, down.y)
          x: I.x
          y: I.y
    (direction) ->
      if I.cooldowns.shoot == 0
        I.cooldowns.shoot = 20 

        engine.I.cooldowns.shake = 10                         

        engine.add
          class: "Bullet"
          radius: 7
          velocity: Point(direction.x, direction.y)
          speed: 7
          x: I.x
          y: I.y
  ]

  return self
