class Dashing.News extends Dashing.Widget

  ready: ->
    @currentIndex = 0
    @postElem = $(@node).find('.post-container')
    @nextComment()
    @startCarousel()

  onData: (data) ->
    @currentIndex = 0

  startCarousel: ->
    interval = $(@node).attr('data-interval')
    interval = "30" if not interval
    setInterval(@nextComment, parseInt( interval ) * 1000)

  nextComment: =>
    posts = @get('posts')
    if posts
      @postElem.fadeOut =>
        @currentIndex = (@currentIndex + 1) % posts.length
        @set 'current_post', posts[@currentIndex]
        @postElem.fadeIn()