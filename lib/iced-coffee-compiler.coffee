{ compile } = require 'iced-coffee-script'

module.exports =
    activate: (state) ->
        atom.commands.add 'atom-workspace', "iced-coffee-compiler:compile": => @compile()
    compile: ->
        @icedCoffeeEditor = atom.workspace.getActiveTextEditor()
        selection = @icedCoffeeEditor.getLastSelection()
        iced_coffee = selection.getText() || @icedCoffeeEditor.getText()
        atom.workspace.open().then (editor) ->
            try
                output = compile iced_coffee, bare: yes
                editor.setGrammar atom.syntax.grammarForScopeName 'source.js'
            catch e
                output = e.toString()
                editor.setGrammar atom.syntax.grammarForScopeName 'text.plain'
            finally
                editor.setText output

    # deactivate: ->
    # serialize: ->
