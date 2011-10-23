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
  blade: Weapon
    cooldown: 200
    fire: (source, direction) ->
      3.times (n) ->
        direction = (Math.TAU * n) / 3
        position = source.position().add(Point(Math.cos(direction), Math.sin(direction)).scale(30))

        engine.add
          class: "Blade"
          x: position.x
          y: position.y

  homingMissile: Weapon
    cooldown: 15
    fire: (source, direction) ->
      engine.add
        class: "HomingMissile"

  machineGun: Weapon
    cooldown: 3
    fire: (source, direction) ->
      angle = Math.atan2(direction.y, direction.x)
      angle += rand() * (Math.TAU / 96) - (Math.TAU / 192)

      Sound.play "bls_sfx_machinegun_01"

      engine.add
        class: "Shot"
        damage: 4
        source: source
        start: source.position()
        direction: Point.fromAngle(angle)

  mine: Weapon
    cooldown: 40
    fire: (source, direction) ->
      engine.add
        class: "Mine"
        x: source.position().x
        y: source.position().y

  shotgun: Weapon
    cooldown: 20
    fire: (source, direction) ->
      Sound.play "bls_sfx_shotgun_01"

      6.times ->
        angle = Math.atan2(direction.y, direction.x) 
        angle += rand() * (Math.TAU / 24) - (Math.TAU / 48)        
        engine.add
          class: "Shot"
          damage: 12
          direction: Point.fromAngle(angle)
          source: source
          start: source.position()

  starDetonator: Weapon
    cooldown: 15
    fire: (source, direction) ->

