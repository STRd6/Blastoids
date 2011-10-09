HealthMeter = (I, self) ->
  I ||= {}

  # Set some default properties
  $.reverseMerge I,
    maxHealth: 100
    health: 100

  self.bind "draw", (canvas) ->
    ratio = I.health / I.maxHealth

    start = Point(0, 0)

    padding = 1
    maxWidth = 100
    height = 5

    canvas.fillColor(color)
    canvas.drawText
      text: color
      x: start.x
      y: start.y - 5 

    canvas.fillColor("#fff")
    canvas.drawRoundRect
      x: start.x - padding
      y: start.y - padding
      width: maxWidth + 2*padding
      height: height + 2*padding
      radius: 2

    canvas.drawRoundRect
      color: color
      x: start.x
      y: start.y
      width: maxWidth * ratio
      height: height
      radius: 2
      stroke:
        color: 'white'
        width: 2      

  return {}