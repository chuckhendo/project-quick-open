ProjectQuickOpenView = require './project-quick-open-view'

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
