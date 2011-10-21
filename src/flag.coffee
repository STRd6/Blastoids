Flag = (I) ->
  I ||= {}

  $.reverseMerge I,
    height: 40
    sprite: "flag"
    width: 20

  self = Base(I)

  self.bind "collide", (other) ->
    if other.I.source != self and other.I.class == "Player"
      other.pickUpFlag()

    self.destroy()

  return self
