Blade = (I) ->
  I ||= {}

  Object.reverseMerge I,
    color: "red"
    damage: 5
    duration: 200
    speed: 24
    radius: 5
    width: 10
    height: 10

  I.velocity.scale$(I.speed)

  self = Bullet(I)

  self.bind "collide", (other) ->
    if other != I.source && other.I.class != "Bullet" && other.I.class != "Blade" 
      self.destroy() 

  self.bind "update", ->
    I.x = Math.cos(I.age / 90)
    I.y = Math.sin(I.age / 90)

  return self

