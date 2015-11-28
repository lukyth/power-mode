PowerModeView = require './power-mode-view'
{CompositeDisposable} = require 'atom'

module.exports = PowerMode =
  powerModeView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @powerModeView = new PowerModeView(state.powerModeViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @powerModeView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'power-mode:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @powerModeView.destroy()

  serialize: ->
    powerModeViewState: @powerModeView.serialize()

  toggle: ->
    console.log 'PowerMode was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
