{SelectListView} = require 'atom'
# Directory = require 'directory'
fs = require 'fs'

module.exports =
class ProjectQuickOpenView extends SelectListView
  initialize: ->
    super
    @addClass('overlay from-top')
    atom.workspaceView.command 'project-quick-open:toggle', => @toggle()

  viewForItem: (item) ->
    "<li>#{item}</li>"

  confirmed: (item) ->
    atom.open({ pathsToOpen: [atom.config.settings.core.projectHome + '/' + item] })
    @cancel()

  getFiles: () ->
    projectPath = atom.config.settings.core.projectHome + "/"
    fs.readdir projectPath, (err, files) =>
      folders = (file for file in files when file[0] != '.' && fs.statSync(projectPath + file).isDirectory())
      @setItems(folders)
      @populateList()

  toggle: ->
    if @hasParent()
      @cancel()
    else
      @getFiles()
      atom.workspaceView.append(this)
      @focusFilterEditor()
