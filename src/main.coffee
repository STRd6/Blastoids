window.sprites = Sprite.loadSheet('soldiers', 32, 48)

window.engine = Engine 
  backgroundColor: 'black'
  canvas: $("canvas").pixieCanvas()
  includedModules: ["Joysticks"]

player = engine.add
  class: "Player"

engine.add
  x: 200
  y: 200
  width: 30
  height: 30

engine.bind "afterUpdate", ->
  engine.I.cameraTransform = Matrix()
  # screen shake
  engine.I.cameraTransform.tx += (rand() * 10) - 5
  engine.I.cameraTransform.ty += (rand() * 10) - 5

engine.start()