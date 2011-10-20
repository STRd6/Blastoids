Bullet = (I) ->
  I ||= {}

  Object.reverseMerge I,
    color: "red"
    damage: 5
    duration: 30
    includedModules: ["Durable"]
    speed: 12
    radius: 5
    width: 10
    height: 10

  I.velocity = I.velocity.scale(I.speed)

  self = Base(I)

  self.bind "collide", (other) ->
    if other != I.source && other.I.class != "Bullet" 
      self.destroy() 

  if I.particles
    self.bind "destroy", ->
      engine.add
        class: "ParticleEffect"
        color: "black"
        x: I.x
        y: I.y

  return self

