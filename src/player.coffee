Player = (I) ->
  I ||= {}

  activeWeapon = 0

  SPRITES_WIDE = 16

  animationStep = 0
  standingOffset = Point(0, -16)

  Object.reverseMerge I,
    color: "red"
    cooldowns:
      shoot: 0
    hasFlag: false
    health: 100
    heading: 0
    height: 32
    width: 32
    radius: 16
    team: 0
    x: rand(App.width)
    y: rand(App.height)
    score: 0
    speed: 7
    velocity: Point(0, 0)

  controller = Joysticks.getController(I.team)

  actionDown = (actions...) ->
    if controller
      controller.actionDown(actions...)
    else
      actions.inject false, (isDown, action) ->
        return isDown || keydown[action]

  actionPressed = (actions...) ->
    actions.inject false, (isDown, action) ->
      return isDown || justPressed[action]

  self = Base(I).extend
    pickUpFlag: ->
      I.hasFlag = true

  self.include HealthMeter

  self.bind "update", ->
    if I.hasFlag
      I.score += 1

    for key, value of I.cooldowns
      I.cooldowns[key] = value.approach(0, 1)

    if controller.actionDown("A")
      activeWeapon = 0
    if controller.actionDown("X")
      activeWeapon = 1
    if controller.actionDown("B")
      activeWeapon = 2
    if controller.actionDown("Y")
      activeWeapon = 3

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

        Sound.play "pew"

        engine.add
          class: "Shot"
          damage: 11
          source: self
          start: self.position()
          direction: direction
          length: 200

    (direction) ->
      if I.cooldowns.shoot == 0      
        I.cooldowns.shoot = 10

        Sound.play "shotgun"

        (10 + rand(5)).times ->
          angle = Math.atan2(direction.y, direction.x) 
          angle += rand() * (Math.TAU / 24) - (Math.TAU / 48)        
          engine.add
            class: "Bullet"
            damage: 3
            radius: 3
            speed: 10
            source: self
            velocity: Point.fromAngle(angle)
            x: I.x + rand(15) * I.x.sign()
            y: I.y + rand(15) * I.y.sign()

    (direction) ->
      if I.cooldowns.shoot == 0
        I.cooldowns.shoot = 20 

        Sound.play "boom"

        engine.I.cooldowns.shake = 10                         

        engine.add
          class: "Bullet"
          color: "black"
          damage: 34
          particles: true
          radius: 7
          velocity: Point(direction.x, direction.y)
          speed: 7
          source: self
          x: I.x
          y: I.y
    (direction) ->
      rotationSpeed = I.age / 3

      3.times (n) ->      
        direction = (Math.TAU * n) / 3

        log engine.I.age

        engine.add
          class: "Bullet"
          damage: 3
          duration: 1
          includedModules: ["Rotatable"]
          radius: 5
          rotation: -Math.PI * engine.I.age / 100
          velocity: Point(Math.cos(rotationSpeed + direction), Math.sin(rotationSpeed + direction))
          speed: 40
          source: self
          sprite: "blade"
          x: I.x 
          y: I.y
  ]  

  self.bind "collide", (other) ->
    if other.I.source != self and other.I.active
      if damage = other.I.damage
        I.health -= damage

        if I.health <= 0
          self.destroy()

  self.bind "drawDebug", (canvas) ->

    canvas.drawLine
      start: I
      end: I.velocity.scale(10).add(I)
      color: "yellow"
      width: 2

  self.bind "destroy", ->
    Sound.play 'death'

    if I.hasFlag
      I.hasFlag = false

      engine.add
        class: "Flag"
        x: I.x
        y: I.y

    engine.add
      class: "ParticleEffect"
      color: I.color
      x: I.x
      y: I.y

    engine.delay 30, ->
      engine.add
        class: "Player"
        team: I.team

  return self

