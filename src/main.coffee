DEBUG_DRAW = false

window.playerSprites = [0..5].map (n) ->
  Sprite.loadSheet("shootman#{n}", 32, 48)

window.engine = Engine 
  backgroundColor: 'black'
  canvas: $("canvas").pixieCanvas()
  cooldowns:
    shake: 0
  includedModules: ["Joysticks"]
  zSort: true

window.playerScores = {
  0: 0
  1: 0
  2: 0
  3: 0
  4: 0
  5: 0
}

background = Sprite.loadByName "ice_bg"

physics = Physics()

Level.load Level.data.rand()

6.times (i) ->
  engine.add
    class: "Player"
    team: i
    id: i

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
    engine.I.cameraTransform.tx += (rand() * 14) - 14 / 2
    engine.I.cameraTransform.ty += (rand() * 14) - 14 / 2
  else
    engine.I.cameraTransform = Matrix()

  walls = engine.find("Wall")
  physics.process(engine.find("Player, Bullet, Box, Flag, Explosion, HomingMissile"), walls)

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

