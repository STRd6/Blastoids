Base = (I) ->
  I ||= {}

  $.reverseMerge I,
    friction: 0
    mass: 1
    velocity: Point(0, 0)

  self = GameObject(I).extend
    collides: ->
      true

    collidesWithWalls: ->
      true

    center: (newCenter) ->
      if newCenter?
        I.x = newCenter.x
        I.y = newCenter.y

        I.center = newCenter

        self
      else
        I.center

    updatePosition: (dt, noFriction) ->
      if noFriction then friction = 0 else friction = I.friction

      # Optimize to not use any point methods because they create
      # new points and this is a hotspot in the code
      frictionFactor = (1 - friction * dt)
      I.velocity.x *= frictionFactor
      I.velocity.y *= frictionFactor

      I.x += I.velocity.x * dt
      I.y += I.velocity.y * dt

      if I.rotationalVelocity
        log 'here'
        I.rotation += I.rotationVelocity 

      I.center.x = I.x
      I.center.y = I.y

      self.trigger "positionUpdated"

  if I.velocity? && I.velocity.x? && I.velocity.y?
    I.velocity = Point(I.velocity.x, I.velocity.y)

  self.bind "update", ->
    I.zIndex = 1 + (I.y + I.height)/App.height

  self.bind "drawDebug", (canvas) ->
    if I.radius
      center = self.center()

      canvas.drawCircle
        position: center
        radius: I.radius
        color: "rgba(255, 0, 255, 0.5)"

  self.attrReader "mass"

  I.center = Point(I.x, I.y)

  self

