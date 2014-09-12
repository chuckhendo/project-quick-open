{SelectListView} = require 'atom'
fs = require 'fs'
tilde = require 'tilde-expansion'

module.exports =
class ProjectQuickOpenView extends SelectListView
  initialize: ->
    super
    @addClass('overlay from-top')
    atom.workspaceView.command 'project-quick-open:toggle', => @toggle()

  viewForItem: (item) ->
    "<li>#{item}</li>"

  confirmed: (item) ->
    newPath = @projectHome + item
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

  getProjectPath: (cb) ->
    # determine project home
    projectPath = '~'
    if atom.config.get('project-quick-open.projectPaths') && atom.config.get('project-quick-open.projectPaths') != '~'
      projectPath = atom.config.get('project-quick-open.projectPaths')
    else if atom.config.settings.core.projectHome
      projectPath = atom.config.settings.core.projectHome

    projectPath = if projectPath.slice(-1) != '/' then projectPath + '/' else projectPath

    tilde projectPath, (pp) =>
      @projectHome = pp
      cb()

  getFiles: () ->
    projectPath = @projectHome
    fs.readdir projectPath, (err, files) =>
      if err
        if err.code == 'ENOENT'
          alert 'ENOENT error. Are your sure your project folder exists?'
        else
          alert err.message
      else
        folders = (file for file in files when file[0] != '.' && fs.statSync(projectPath + file).isDirectory())
        @setItems(folders)
        @populateList()

  toggle: ->
    if @hasParent()
      @cancel()
    else
      @getProjectPath =>
        @getFiles()
        atom.workspaceView.append(this)
        @focusFilterEditor()
