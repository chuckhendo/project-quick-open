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
    newPath = atom.config.settings.core.projectHome + '/' + item
    if atom.config.get('project-quick-open.openProjectsInSameWindow')
      # Open in same window

      # close tabs in current workspace
      panes = atom.workspace.getPanes()
      for pane in panes
        do (pane) ->
          pane.destroyItems()

      # change project path
      atom.project.setPath(newPath)
    else
      # open in new window
      atom.open({ pathsToOpen: [newPath] })
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
  
  destroy: ->
    @detach()
