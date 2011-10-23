Mine = (I={}) ->
  Object.reverseMerge I,
    countdown: 60
    sprite: "mine"

  self = Base(I)

  self.bind "update", ->
    I.countdown = I.countdown.approach(0, 1)

    if I.countdown == 0
      self.destroy()

  self.bind 'destroy', ->
    engine.add
      class: "Explosion"
      x: I.x
      y: I.y

  return self

