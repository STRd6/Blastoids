window.sprites = Sprite.loadSheet('soldiers', 32, 48)

window.engine = Engine 
  backgroundColor: 'black'
  canvas: $("canvas").pixieCanvas()

engine.add
  class: "Player"

engine.add
  x: 200
  y: 200
  width: 30
  height: 30

engine.start()