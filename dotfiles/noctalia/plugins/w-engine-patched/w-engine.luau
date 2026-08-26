function update()
  noctalia.setUpdateInterval(1000)
  barWidget.setGlyph("movie")
end

function onClick()
  noctalia.togglePanel("sho/w-engine-patched:w-engine-panel")
end