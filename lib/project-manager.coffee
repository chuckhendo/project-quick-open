ProjectManagerView = require './project-manager-view'

module.exports =
  # configDefaults:
  #   ProjectPath: process.env.HOME || process.env.HOMEPATH || process.env.USERPROFILE
  activate: (state) ->
    @projectManagerView = new ProjectManagerView()
  deactivate: ->
    @projectManagerView.destroy()

  serialize: ->
    projectManagerViewState: @projectManagerView.serialize()
