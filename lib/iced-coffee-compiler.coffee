{ EditorView } = require 'atom'
{ compile } = require('iced-coffee-script').compile
ids = { }

module.exports =
    activate: (state) ->
        atom.workspaceView.command "iced-coffee-compiler:compile", => @compile()
    # deactivate: ->
    compile: ->
        @icedCoffeeEditor = atom.workspace.getActiveEditor()
        selection = @icedCoffeeEditor.getSelection()
        iced_coffee = selection.getText() || @icedCoffeeEditor.getText()

        @view = @getView()
        @editor = @view.getEditor()

        try
            output = compile iced_coffee, bare: yes
            @editor.setGrammar atom.syntax.grammarForScopeName 'source.js'
        catch e
            output = e.toString()
            @editor.setGrammar atom.syntax.grammarForScopeName 'text.plain'
        finally
            @editor.setText output
            @pane = atom.workspaceView.getActivePane()
            @pane.addItem @editor
            @pane.activateNextItem()

    getView: ->
        ids[@icedCoffeeEditor.id] = (
            view = ids[@icedCoffeeEditor.id]
            if view
                editor = view.getEditor()
                if not editor.isAlive() then view = new EditorView mini: yes
                view
            else new EditorView mini: yes
        )
    # serialize: ->
