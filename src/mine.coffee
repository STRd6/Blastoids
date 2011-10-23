Mine = (I={}) ->
  Object.reverseMerge I,
    countdown: 40
    height: 24
    sprite: "mine"
    width: 24

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

    10.times (n) ->
      angle = (Math.TAU * (n + 1)) / 10 

      engine.add
        class: "Shot"
        damage: 2
        direction: Point.fromAngle(angle)
        x: I.x
        y: I.y  
        source: self  
        start: self.position()

  return self
