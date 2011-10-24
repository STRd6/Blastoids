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
    engine.I.cooldowns.shake = 7

    engine.add
      class: "Explosion"
      owner: I.owner
      x: I.x
      y: I.y

  return self

