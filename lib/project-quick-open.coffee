ProjectQuickOpenView = require './project-quick-open-view'

module.exports =
  # configDefaults:
  #   ProjectPath: process.env.HOME || process.env.HOMEPATH || process.env.USERPROFILE
  activate: (state) ->
    @ProjectQuickOpenView = new ProjectQuickOpenView()
  deactivate: ->
    @ProjectQuickOpenView.destroy()

  serialize: ->
    ProjectQuickOpenViewState: @ProjectQuickOpenView.serialize()
