ProjectQuickOpenView = require './project-quick-open-view'
{CompositeDisposable} = require 'atom'

module.exports =
  config:
    openProjectsInSameWindow:
      type: 'boolean'
      default: false
    projectPaths:
      type: 'string'
      default: '~'
  activate: (state) ->
    @ProjectQuickOpenView = new ProjectQuickOpenView()

  deactivate: ->
    @ProjectQuickOpenView.destroy()

  serialize: ->
    ProjectQuickOpenViewState: @ProjectQuickOpenView.serialize()
