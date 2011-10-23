DEBUG_DRAW = false

window.sprites = Sprite.loadSheet('soldiers', 32, 48)

window.engine = Engine 
  backgroundColor: 'black'
  canvas: $("canvas").pixieCanvas()
  cooldowns:
    shake: 0
  includedModules: ["Joysticks"]
  zSort: true

window.playerScores = {}

background = Sprite.loadByName "ice_bg"

physics = Physics()

6.times (i) ->
  engine.add
    class: "Player"
    team: i

2.times (i) ->
  y = 200 * (i + 1)
  engine.add
    class: "Wall"
    start: Point(100, y)
    end: Point(700, y)

  engine.add
    class: "Wall"
    start: Point(100, y)
    end: Point(100, y - 100)

  engine.add
    class: "Wall"
    start: Point(700, y)
    end: Point(700, y + 100)

engine.add
  class: "Flag"
  x: 150
  y: 150

bg = engine.add
  sprite: background
  width: 0
  height: 0
  zIndex: -1

bg.bind 'draw', (canvas) ->
  background.fill(canvas, 0, 0, App.width, App.height)
  canvas.fill('rgba(0, 0, 0, 0.3)')

engine.bind "update", ->
  for key, value of engine.I.cooldowns
    engine.I.cooldowns[key] = value.approach(0, 1)

  if engine.I.cooldowns.shake > 0    
    engine.I.cameraTransform = Matrix()
    # screen shake
    engine.I.cameraTransform.tx += (rand() * 10) - 10 / 2
    engine.I.cameraTransform.ty += (rand() * 10) - 10 / 2
  else
    engine.I.cameraTransform = Matrix()

  walls = engine.find("Wall")
  physics.process(engine.find("Player, Bullet, Box, Flag, Explosion"), walls)

engine.bind "overlay", (canvas) ->
  players = engine.find("Player")

  canvas.drawRoundRect
    color: 'rgba(255, 255, 255, 0.5)'
    x: 0
    y: -10
    width: App.width
    height: 50

  canvas.font('16px helvetica')

  for id, score of window.playerScores
    canvas.centerText
      color: 'black'
      text: "Player #{parseInt(id) + 1}: #{score}"
      x: (App.width / 6 * (id)) + 60
      y: 25

engine.bind "draw", (canvas) ->
  if DEBUG_DRAW
    engine.find("Player, Bullet, Box, Wall, Explosion").each (object) ->
      object.trigger("drawDebug", canvas)  

$(document).bind "keydown", "0", ->
  DEBUG_DRAW = !DEBUG_DRAW

engine.start()

