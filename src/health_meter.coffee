HealthMeter = (I, self) ->
  I ||= {}

  # Set some default properties
  $.reverseMerge I,
    maxHealth: 100
    health: 100

  self.bind "draw", (canvas) ->
    ratio = I.health / I.maxHealth

    start = Point(-4, -6)

    padding = 1
    maxWidth = 40
    height = 5

    canvas.drawRoundRect
      color: "#fff"
      x: start.x - padding
      y: start.y - padding
      width: maxWidth + 2*padding
      height: height + 2*padding
      radius: 2

    canvas.drawRoundRect
      color: "blue"
      x: start.x
      y: start.y
      width: maxWidth * ratio
      height: height
      radius: 4
      stroke:
        color: 'white'
        width: 1      

  return {}