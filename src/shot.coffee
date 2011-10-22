Shot = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    width: 0
    height: 0
    includedModules: ["Durable"]
    duration: 4

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
        unless object != I.source
          if point = Collision.rayCircle(I.start, I.direction, object)
            hits.push [point, object]

      walls = engine.find("Wall")

      walls.each (wall) ->
        if point = Collision.rayLineSegment(I.start, wall)
          ;

      if hits.length
        ; # find closest hit

  self.unbind "draw"
  self.bind "draw", (canvas) ->
    canvas.drawLine
      start: I.start
      direction: I.direction
      length: I.length
      color: COLORS[I.age]
      width: 2

  # Add events and methods here
  self.bind "update", ->
    ; # Add update method behavior

  # We must always return self as the last line
  return self
