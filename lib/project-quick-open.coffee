ProjectQuickOpenView = require './project-quick-open-view'
{CompositeDisposable} = require 'atom'

module.exports =
  configDefaults:
    openProjectsInSameWindow: false
    projectPaths: '~'
  activate: (state) ->
    @ProjectQuickOpenView = new ProjectQuickOpenView()

  deactivate: ->
    @ProjectQuickOpenView.destroy()

  serialize: ->
    ProjectQuickOpenViewState: @ProjectQuickOpenView.serialize()
