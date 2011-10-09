ParticleEffect = (I) ->
  I ||= {}

  # Set some default properties
  $.reverseMerge I,
    batchSize: 5
    color: "blue"
    duration: 50
    particleCount: 5
    particleSizes: [8, 6, 8, 4, 6]
    height: 32
    sprite: Sprite.EMPTY
    width: 32

  # Inherit from game object
  self = Emitter(I)

  $.extend self.I.generator,
    acceleration: Point(0, 0)
    color: I.color
    duration: 20
    maxSpeed: 50
    height: (n) ->
      I.particleSizes.wrap(n)
    width: (n) ->
      I.particleSizes.wrap(n)
    velocity: ->
      Point.fromAngle(Random.angle()).scale(6)

  # We must always return self as the last line
  return self

