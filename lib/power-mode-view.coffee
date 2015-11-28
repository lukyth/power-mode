module.exports =
class PowerModeView
  constructor: (serializedState) ->
    @canvas = @setupCanvas()

  serialize: ->

  destroy: ->
    @canvas.remove()

  getElement: ->
    @canvas

  setupCanvas: ->
    canvas = document.createElement("canvas")
    canvas.classList.add("canvas-overlay")
    document.getElementsByTagName("atom-workspace")[0].appendChild(canvas)
    canvas = document.getElementsByClassName("canvas-overlay")[0]
    canvas.width = window.innerWidth
    canvas.height = window.innerHeight
    canvas
