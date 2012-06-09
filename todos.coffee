$ ->
  
  class Todo extends Backbone.Model
    
    defaults ->
      content: 'empty todo...'
      order: Todos.nextOrder()
      done: false

    initialize -> 
      if !@get('content')
          @set({ 'content': @defaults.content })

    toggle ->
      @.save({ done: !@get('done') })

    clear ->
      @destroy()
      @view.remove()

