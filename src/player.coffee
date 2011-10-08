Player = (I) ->
  I ||= {}

  Object.reverseMerge I,
    color: "blue"
    height: 32
    width: 32
    x: 0
    y: 0

  self = GameObject(I)

  self.bind "update", ->
    $.noop()

  return self
