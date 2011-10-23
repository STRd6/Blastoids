Mine = (I={}) ->
  Object.reverseMerge I,
    countdown: 60
    sprite: "mine"

  self = GameObject(I)

  self.bind "update", ->
    I.countdown = I.countdown.approach(0, 1)

    if I.countdown == 0
      self.trigger 'destroy' if I.active

  self.bind 'destroy', ->
    engine.add
      class: "Explosion"
      x: I.x
      y: I.y

  return self

