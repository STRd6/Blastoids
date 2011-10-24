Explosion = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,  
    damage: 20
    duration: 4
    radius: 30
    particleCount: 20
    particleDamage: 15
    deltaRadius: 10
    color: "rgba(255, 0, 0, 0.5)"
    velocity: Point(0, 0)

  # Inherit from game object
  self = Base(I)

  self.bind "update", ->
    I.radius += I.deltaRadius

  # TODO: Get binding create to work
  # to fix serializing and de-serializing

  # self.bind "create", ->  

  Sound.play ["bls_sfx_explosion1_01", "bls_sfx_explosion2_01", "bls_sfx_explosion3_01"].rand()

  I.particleCount.times (n) ->
    angle = (Math.TAU * (n + 1)) / I.particleCount

    engine.add
      class: "Shot"
      damage: I.particleDamage
      direction: Point.fromAngle(angle + rand() * Math.TAU / 16)
      source: I.source
      start: self.position()

  # We must always return self as the last line
  return self

