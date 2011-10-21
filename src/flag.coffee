Flag = (I) ->
  I ||= {}

  $.reverseMerge I,
    height: 40
    sprite: "flag"
    width: 20

  self = Base(I)

  return self
