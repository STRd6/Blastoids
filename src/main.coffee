window.sprites = Sprite.loadSheet('soldiers', 32, 48)

window.engine = Engine 
  backgroundColor: 'black'
  canvas: $("canvas").pixieCanvas()
  cooldowns:
    shake: 0
  includedModules: ["Joysticks"]

player = engine.add
  class: "Player"

engine.add
  x: 200
  y: 200
  width: 30
  height: 30

engine.bind "update", ->
  for key, value of I.cooldowns
    I.cooldowns[key] = value.approach(0, 1)

engine.bind "shake", (duration, power = 10) ->
  if I.cooldown.shake == 0
    I.cooldown.shake = duration

    engine.I.cameraTransform = Matrix()
    # screen shake
    engine.I.cameraTransform.tx += (rand() * power) - power / 2
    engine.I.cameraTransform.ty += (rand() * power) - power / 2

engine.start()