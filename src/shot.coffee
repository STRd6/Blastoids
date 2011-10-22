Shot = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    width: 0
    height: 0
    includedModules: ["Durable"]
    duration: 4
    length: 1200

  COLORS = [
    "rgb(255, 255, 255)"
    "rgba(255, 255, 255, 0.75)"
    "rgba(255, 255, 255, 0.50)"
    "rgba(255, 255, 255, 0.25)"
    "rgba(64, 64, 64, 0.25)"
  ]

  # Inherit from game object
  self = GameObject(I).extend
    detectHit: ->
      objects = engine.find("Player")

      hits = []

      objects.each (object) ->
        unless object == I.source
          if point = Collision.rayCircle(I.start, I.direction, object)
            hits.push {distanceSquared, point, object}

      walls = engine.find("Wall")

      walls.each (wall) ->
        if point = wall.rayCollides(I)
          hits.push {distanceSquared, point, wall}

      hits.sort (a, b) ->
        a.distanceSquared - b.distanceSquared

      if nearestHit = hits.first()
        {point, distanceSquared, object} = nearestHit

        I.end = point
        object.trigger("collide", self)

        engine.add
          class: "ParticleEffect"
          color: "pink"
          x: point.x
          y: point.y

  self.unbind "draw"
  self.bind "draw", (canvas) ->
    if I.end
      canvas.drawLine
        start: I.start
        end: I.end
        color: COLORS[I.age]
        width: 2

    else
      canvas.drawLine
        start: I.start
        direction: I.direction
        length: I.length
        color: COLORS[I.age]
        width: 2

  # Add events and methods here
  self.bind "update", ->
    ; # Add update method behavior

  self.detectHit()

  # We must always return self as the last line
  return self

