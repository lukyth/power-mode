PowerModeView = require './power-mode-view'
{CompositeDisposable} = require 'atom'
_ = require 'underscore-plus'

module.exports = PowerMode =
  powerModeView: null

  MAX_PARTICLES: 500
  PARTICLE_NUM_RANGE: [5..12]
  PARTICLE_GRAVITY: 0.075
  PARTICLE_ALPHA_FADEOUT: 0.96
  PARTICLE_VELOCITY_RANGE:
    x: [-1, 1]
    y: [-3.5, -1.5]

  OFFSET: 40

  particles: []
  particlePointer: 0
  lastDraw: 0

  subscriptions: null

  editor: null
  canvas: null
  canvasContext: null

  throttledShake: null
  throttledSpawnParticles: null

  activate: (state) ->
    @powerModeView = new PowerModeView(state.powerModeViewState)

    @editor = document.getElementsByTagName("atom-workspace")[0]
    @canvas = @powerModeView.getElement()
    @canvasContext = @canvas.getContext "2d"

    @throttledShake = _.throttle @shake, 100, trailing: false
    @throttledSpawnParticles = _.throttle @spawnParticles, 25, trailing: false

    window.requestAnimationFrame @onFrame.bind this

    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.workspace.observeTextEditors (editor) =>
      @subscriptions.add editor.onDidChangeCursorPosition (event) =>
        @onCursorChange(event)

  deactivate: ->
    @subscriptions.dispose()
    @powerModeView.destroy()

  serialize: ->
    powerModeViewState: @powerModeView.serialize()

  onFrame: ->
    @canvasContext.clearRect 0, 0, @canvas.width, @canvas.height

    for particle in @particles
      continue if particle.alpha <= 0.1

      particle.velocity.y += @PARTICLE_GRAVITY
      particle.x += particle.velocity.x
      particle.y += particle.velocity.y
      particle.alpha *= @PARTICLE_ALPHA_FADEOUT

      @canvasContext.fillStyle = "rgba(#{particle.color.join ", "}, #{particle.alpha})"
      @canvasContext.fillRect Math.round(particle.x - 1), Math.round(particle.y - 1), 3, 3

    window.requestAnimationFrame @onFrame.bind this

  getCursorPosition: ->
    {x: Math.random() * @canvas.width + @OFFSET, y: Math.random() * @canvas.height + @OFFSET}

  spawnParticles: ->
    {x, y} = @getCursorPosition()
    numParticles = _.sample(@PARTICLE_NUM_RANGE)
    color = [255, 255, 255]
    _.times numParticles, =>
      @particles[@particlePointer] = @createParticle x, y, color
      @particlePointer = (@particlePointer + 1) % @MAX_PARTICLES

  createParticle: (x, y, color) ->
    x: x
    y: y + 10
    alpha: 1
    color: color
    velocity:
      x: @PARTICLE_VELOCITY_RANGE.x[0] + Math.random() *
        (@PARTICLE_VELOCITY_RANGE.x[1] - @PARTICLE_VELOCITY_RANGE.x[0])
      y: @PARTICLE_VELOCITY_RANGE.y[0] + Math.random() *
        (@PARTICLE_VELOCITY_RANGE.y[1] - @PARTICLE_VELOCITY_RANGE.y[0])

  drawParticles: ->
    @canvasContext.clearRect 0, 0, @canvas.width, @canvas.height

    for particle in @particles
      continue if particle.alpha <= 0.1

      particle.velocity.y += @PARTICLE_GRAVITY
      particle.x += particle.velocity.x
      particle.y += particle.velocity.y
      particle.alpha *= @PARTICLE_ALPHA_FADEOUT

      @canvasContext.fillStyle = "rgba(#{particle.color.join ", "}, #{particle.alpha})"
      @canvasContext.fillRect Math.round(particle.x - 1), Math.round(particle.y - 1), 3, 3

  shake: ->
    intensity = 1 + 2 * Math.random()
    x = intensity * (if Math.random() > 0.5 then -1 else 1)
    y = intensity * (if Math.random() > 0.5 then -1 else 1)

    @editor.style.transform = "translate3d(#{x}px, #{y}px, 0)"

    setTimeout =>
      @editor.style.transform = ""
    , 75

  onCursorChange: ->
    @throttledShake()
    _.defer => @throttledSpawnParticles()
