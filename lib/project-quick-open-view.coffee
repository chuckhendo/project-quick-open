{View, SelectListView} = require 'atom-space-pen-views'
fs = require 'fs'
path = require 'path'
walkdir = require 'walkdir'
tilde = require 'expand-tilde'

module.exports =
class ProjectQuickOpenView extends SelectListView
    initialize: ->
        super
        @addClass('command-palette')
        atom.commands.add 'atom-workspace', 'project-quick-open:toggle', => @toggle()


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
            atom.project.setPaths([newPath])
        else
            # open in new window
            atom.open(
                pathsToOpen: [newPath],
                newWindow: true
            )
        @cancel()

    cancelled: ->
        @hide()

    getProjectPath: ->
        # determine project home
        projectPath = '~'
        if atom.config.get('project-quick-open.projectPaths') && atom.config.get('project-quick-open.projectPaths') != '~'
            projectPath = atom.config.get('project-quick-open.projectPaths')
        else if atom.config.settings.core.projectHome
            projectPath = atom.config.settings.core.projectHome

        @projectHome = path.join(tilde(projectPath), '/')

    getFiles: () ->
        projectPath = @projectHome
        emitter = walkdir projectPath, max_depth: atom.config.get('project-quick-open.maxDepth');
        folders = [];

        emitter.on 'directory', (folder) =>
            folders.push(path.relative(projectPath, folder))

        emitter.on 'error', (path, err) =>
            if err.code == 'ENOENT'
                alert 'ENOENT error. Are your sure your project folder exists?'
            else
                alert err.message

        emitter.on 'end', () =>
            folders.sort()
            @setItems(folders)
            @populateList()

    show: ->
        @getProjectPath()
        @getFiles()

        @panel ?= atom.workspace.addModalPanel(item: this)
        @panel.show()
        @storeFocusedElement()

        @focusFilterEditor()

    hide: ->
        @panel?.hide()

    toggle: ->
        if @panel?.isVisible()
            @cancel()
        else
            @show()
