Level = 
  load: (data) ->
    data.each ([start, end]) ->
      engine.add
        class: "Wall"
        start: start
        end: end

