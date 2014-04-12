ProjectQuickOpenView = require './project-quick-open-view'

module.exports =
  configDefaults:
    openProjectsInSameWindow: false
  activate: (state) ->
    @ProjectQuickOpenView = new ProjectQuickOpenView()
  deactivate: ->
    @ProjectQuickOpenView.destroy()

  serialize: ->
    ProjectQuickOpenViewState: @ProjectQuickOpenView.serialize()
