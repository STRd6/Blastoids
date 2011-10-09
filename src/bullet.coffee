Bullet = (I) ->
  I ||= {}

  Object.reverseMerge I,
    color: "red"
    duration: 30
    includedModules: ["Durable"]
    speed: 12
    radius: 5
    width: 10
    height: 10

  I.velocity.scale$(I.speed)

  self = Base(I)

  self.bind "collide", ->
    self.destroy()  

  return self

