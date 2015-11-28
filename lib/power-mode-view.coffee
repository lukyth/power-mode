module.exports =
class PowerModeView
  constructor: (serializedState) ->
    @editor = document.getElementsByTagName("atom-workspace")[0]
    @canvas = @setupCanvas()

  serialize: ->

  destroy: ->
    @canvas.remove()

  getElement: ->
    @canvas

  getElementContext: ->
    @canvas.getContext "2d"

  setupCanvas: ->
    canvas = document.createElement("canvas")
    canvas.classList.add("canvas-overlay")
    @editor.appendChild(canvas)
    canvas = document.getElementsByClassName("canvas-overlay")[0]
    canvas.width = window.innerWidth
    canvas.height = window.innerHeight
    canvas
