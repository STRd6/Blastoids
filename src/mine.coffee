Mine = (I={}) ->
  Object.reverseMerge I,
    countdown: 60
    sprite: "mine"

  self = GameObject(I)

  self.bind "update", ->
    I.countdown = I.countdown.approach(0, 1)

    if I.countdown == 0
      self.trigger 'destroy' if I.active
      I.active = false

  self.bind 'destroy', ->
    engine.add
      class: "Bullet"
      damage: 90
      duration: 2
      x: I.x
      y: I.y
      radius: 60
      color: "transparent"
      velocity: Point(0, 0)

    20.times (n) ->
      angle = (Math.TAU * (n + 1)) / 20 

      engine.add
        class: "Shot"
        damage: 15
        direction: Point.fromAngle(angle)
        source: self  
        start: self.position()

  return self
