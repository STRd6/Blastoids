window.engine = Engine 
  backgroundColor: 'black'
  canvas: $("canvas").pixieCanvas()

engine.add
  x: 0
  y: 0
  width: 20
  height: 20
  color: 'red'

engine.start()