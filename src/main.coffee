window.engine = Engine 
  backgroundColor: 'black'
  canvas: $("canvas").pixieCanvas()

engine.add
  class: "Player"

engine.start()