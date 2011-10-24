Player = (I) ->
  I ||= {}

  activeWeapon = "machineGun"

  SPRITES_WIDE = 3

  animationStep = 0
  standingOffset = Point(0, -16)

  Object.reverseMerge I,
    color: "red"
    cooldowns:
      shoot: 0
    crosshairPosition: Point(0, 0)
    hasFlag: false
    health: 100
    heading: 0
    height: 32
    width: 32
    radius: 16
    team: 0
    x: rand(App.width)
    y: rand(App.height)
    speed: 7
    velocity: Point(0, 0)

  window.playerScores[I.team] = 0

  sprites = window.playerSprites[I.team]

  controller = Joysticks.getController(I.team)

  # TODO: Switch team to id
  spawnPoint = window.spawnPoints?[I.id]

  if I.randRespawn
    spawnPoint = window.spawnPoints.rand()

  if spawnPoint
    I.x = spawnPoint.x
    I.y = spawnPoint.y

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
      window.playerScores[I.team] += 1

    for key, value of I.cooldowns
      I.cooldowns[key] = value.approach(0, 1)

    if controller.actionDown("A")
      activeWeapon = "machineGun"
    if controller.actionDown("X")
      activeWeapon = "shotgun"
    if controller.actionDown("B")
      activeWeapon = "homingMissile"
    if controller.actionDown("Y")
      activeWeapon = "mine"

    I.hflip = (I.heading > 2*Math.TAU/8 || I.heading < -2*Math.TAU/8)

    cycle = (I.age/3).floor() % 8
    if -Math.TAU/8 <= I.heading <= Math.TAU/8
      facingOffset = 1
    else if -3*Math.TAU/8 <= I.heading <= -Math.TAU/8
      facingOffset = 2
    else if Math.TAU/8 < I.heading <= 3*Math.TAU/8
      facingOffset = 0
    else
      facingOffset = 1

    if I.velocity.equal(Point(0, 0))
      cycle = 0
    else
      cycle += 1

    spriteIndex = cycle * SPRITES_WIDE + facingOffset

    I.spriteOffset = standingOffset
    I.sprite = sprites[spriteIndex]  

    movement = controller.position()

    movement = movement.norm()

    I.velocity = movement.scale(I.speed)

    I.crosshairPosition = controller.position(1).norm().scale(75)

    unless I.velocity.magnitude() == 0
      I.heading = Point.direction(Point(0, 0), I.velocity)

    if I.cooldowns.shoot == 0
      if controller.axis(5) > 16000 || controller.axis(4) > 16000
        if weapon = Weapon.Weapons[activeWeapon]
          I.cooldowns.shoot += weapon.fire(self, I.crosshairPosition.norm())

  self.bind "collide", (other) ->
    if other.I.source != self and other.I.active
      if damage = other.I.damage
        I.health -= damage

        if I.health <= 0
          owner = other.I.owner

          if owner == self
            window.playerScores[I.team] -= 1
          else 
            window.playerScores[owner?.I.team] += 1

          self.destroy()

  self.bind "drawDebug", (canvas) ->

    canvas.drawLine
      start: I
      end: I.velocity.scale(10).add(I)
      color: "yellow"
      width: 2

  self.bind "beforeTransform", (canvas) ->
    if controller.position(1).magnitude() > 0
      canvas.drawCircle
        x: I.x + I.crosshairPosition.x
        y: I.y + I.crosshairPosition.y
        radius: 10
        color: 'rgba(0, 150, 0, 0.5)'

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
        id: I.id
        randRespawn: true

  return self

