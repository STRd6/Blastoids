Mine = (I={}) ->
  Object.reverseMerge I,
    duration: 40
    height: 24
    sprite: "mine"
    width: 24

  self = GameObject(I)

  self.bind "update", ->
    if I.age > I.duration
      self.trigger 'destroy'

  self.bind 'destroy', ->
    10.times (n) ->
      angle = Math.TAU / (n + 1)  

      engine.add
        class: "Bullet"
        x: I.x
        y: I.y
        radius: 4
        width: 8
        height: 8      
        direction: Point.fromAngle(angle).scale(5)

  return self
