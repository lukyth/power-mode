{CompositeDisposable} = require 'atom'
_ = require 'underscore-plus'

module.exports = PowerMode =
  subscriptions: null
  editor: null
  throttledShake: null

  activate: (state) ->
    @editor = document.getElementsByTagName("atom-workspace")[0]

    @throttledShake = _.throttle @shake, 100, trailing: false

    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.workspace.observeTextEditors (editor) =>
      @subscriptions.add editor.onDidChangeCursorPosition (event) =>
        @onCursorChange(event)

  deactivate: ->
    @subscriptions.dispose()

  shake: ->
    intensity = 1 + 2 * Math.random()
    x = intensity * (if Math.random() > 0.5 then -1 else 1)
    y = intensity * (if Math.random() > 0.5 then -1 else 1)

    @editor.style.transform = "translate3d(#{x}px, #{y}px, 0)"

    setTimeout =>
      @editor.style.transform = ""
    , 75

  onCursorChange: (e) ->
    @throttledShake()
