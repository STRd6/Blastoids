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

player = engine.add
  class: "Player"

bg = engine.add
  sprite: background
  width: 0
  height: 0
  zIndex: -1

bg.bind 'draw', (canvas) ->
  background.fill(canvas, 0, 0, App.width, App.height)
  canvas.fill('rgba(0, 0, 0, 0.3)')

engine.add
  x: 200
  y: 200
  width: 30
  height: 30

engine.bind "update", ->
  for key, value of engine.I.cooldowns
    engine.I.cooldowns[key] = value.approach(0, 1)

  if engine.I.cooldowns.shake > 0    
    engine.I.cameraTransform = Matrix()
    # screen shake
    engine.I.cameraTransform.tx += (rand() * 10) - 10 / 2
    engine.I.cameraTransform.ty += (rand() * 10) - 10 / 2

  physics.process(engine.find("Player, Bullet"))

engine.start()

