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
    10.times (n) ->
      angle = (Math.TAU * (n + 1)) / 10 

      engine.add
        class: "Bullet"
        x: I.x
        y: I.y
        radius: 4
        width: 8
        height: 8      
        velocity: Point.fromAngle(angle).scale(2)

  return self
