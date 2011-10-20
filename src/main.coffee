DEBUG_DRAW = false

window.sprites = Sprite.loadSheet('soldiers', 32, 48)

window.engine = Engine 
  backgroundColor: 'black'
  canvas: $("canvas").pixieCanvas()
  cooldowns:
    shake: 0
  includedModules: ["Joysticks"]
  zSort: true

background = Sprite.loadByName "ice_bg"

physics = Physics()

6.times (i) ->
  engine.add
    class: "Player"
    team: i

engine.add
  class: "Wall"

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

  physics.process(engine.find("Player, Bullet, Box"))

  if rand(30) == 0
    engine.add
      class: "Box"
      x: rand(App.width)
      y: rand(App.height)
      width: 30
      height: 30

engine.bind "draw", (canvas) ->
  if DEBUG_DRAW
    engine.find("Player, Bullet, Box").each (object) ->
      object.trigger("drawDebug", canvas)  

$(document).bind "keydown", "0", ->
  DEBUG_DRAW = !DEBUG_DRAW

engine.start()

