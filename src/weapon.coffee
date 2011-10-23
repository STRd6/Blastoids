Weapon = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    color: "blue"
    cooldown: 3
    height: 32
    width: 32
    fire: ->

  # Inherit from game object
  self = GameObject(I).extend
    fire: (source, direction) ->
      I.fire(source, direction)

      return I.cooldown

  # We must always return self as the last line
  return self

Weapon.Weapons =
  machineGun: Weapon
    cooldown: 3
    fire: (source, direction) ->
      angle = Math.atan2(direction.y, direction.x)
      angle += rand() * (Math.TAU / 96) - (Math.TAU / 192)

      Sound.play "pew"

      engine.add
        class: "Shot"
        damage: 4
        source: source
      start: source.position()
      direction: Point.fromAngle(angle)

  shotgun: Weapon
    cooldown: 20
    fire: (source, direction) ->
      Sound.play "shotgun"

      6.times ->
        angle = Math.atan2(direction.y, direction.x) 
        angle += rand() * (Math.TAU / 24) - (Math.TAU / 48)        
        engine.add
          class: "Shot"
          damage: 12
          direction: Point.fromAngle(angle)
          source: self
          start: self.position()

  starDetonator: Weapon
    cooldown: 15
    fire: (source, direction) ->

