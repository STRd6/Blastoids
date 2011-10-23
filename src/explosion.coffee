Explosion = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,  
    damage: 20
    duration: 4
    radius: 30
    deltaRadius: 10
    color: "rgba(255, 0, 0, 0.5)"
    velocity: Point(0, 0)

  # Inherit from game object
  self = Base(I)

  self.bind "update", ->
    I.radius += I.deltaRadius

  self.bind "create", ->
    20.times (n) ->
      angle = (Math.TAU * (n + 1)) / 20 

      engine.add
        class: "Shot"
        damage: 15
        direction: Point.fromAngle(angle + rand() * Math.TAU / 16)
        source: I.source
        start: self.position()

  # We must always return self as the last line
  return self

