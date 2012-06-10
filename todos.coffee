$ ->
  
  ### Todo Model ###
  class Todo extends Backbone.Model
    
    # Default attributes for the Todo Model
    defaults: ->
      content: 'empty todo...'
      order: Todos.nextOrder()
      done: false

    # Intialization, ensure that each todo has content
    initialize: -> 
      if !@get('content')
          @set({ 'content': @defaults.content })

    # Toggle the Todo 'done' state 
    toggle: ->
      @.save({ done: !@get('done') })

    # Delete the Todo
    clear: ->
      @destroy()
      @view.remove()

  ### Todo Collection ###
  class TodoList extends Backbone.Collection

    model: Todo

    localStorage: new Store('todos')

    # Filter all completed Todos
    done: ->
      return @filter (todo) ->
        todo.get "done"

    # Filter all incomplete Todos
    remaining: ->
      return @without.apply(this, @done())

    # Return the last index so we can keep the Todos in order
    nextOrder: -> 
      if (!@length) 
        return 1
      return @last().get('order') + 1

    # Backbone comparator for sorting
    comparator: (todo) ->
      return todo.get('order')

  ### Todo Item ###
  class TodoView extends Backbone.View

      tagname: 'li'

      template: _.template( $('#item_template').html() )

      events:
        "click .check"              : "toggleDone",
        "dblclick div.todo-content" : "edit",
        "click span.todo-destroy"   : "clear",
        "keypress .todo-input"      : "updateOnEnter"

      initialize: ->
        @model.bind('change', this.render)
        @model.view = this

      # Render the Todo
      render: => 
        this.$(@el).html(@template(@model).toJSON())
        @setContent
        return this

      # Set all the content from Todo Model to the View
      setContent: ->
        content = @model.get('content')
        this.$('todo-content').html('content')
        @$input = this.$('todo-input')
        @$input.on('blur', @close)
        @$input.val(content)

      # Toggle the done state of this Todo
      toggleDone: ->
        @model.toggle()

      # Switch to editing mode
      edit: ->
        this.$(@el).addClass('editing')
        @input.focus()

      # Close editing mode and save the Todo
      close: =>
        @model.save({ content: @input.val() }) 
        $(@el).removeClass('editing')

      # Bind enter key to the TodoView close function
      updateOnEnter: (e) =>
        @close() if e.keyCode is 13

      # Remove the Todo from the UI
      remove: ->
        $(@el).remove()

      # Destroy the Todo model
      clear: () -> 
        @model.clear()

    ### Application View ###
    class AppView extends Backbone.View



  Todos = new TodoList
  App = new AppView()