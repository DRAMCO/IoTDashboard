class Dashing.CommentList extends Dashing.Widget

  Batman.Filters.parseHashTag = (str) ->
    str.replace(/(?:[^&])([#]+[A-Za-z0-9-_öäüéß]+)/gi, (a,t) ->

      tag = t.replace("#","%23")
      '<span class="hashtag">'+t.link("https://twitter.com/search?q="+tag)+'</span>'
    ).replace(/^([#]+[A-Za-z0-9-_öäüéß]+)/gi, (a,t) ->
      tag = t.replace("#","%23")
      '<span class="hashtag">'+t.link("https://twitter.com/search?q="+tag)+'</span>'
    )

  Batman.Filters.parseTwitterUser = (str) ->
    str.replace(/[@]+[A-Za-z0-9-_]+/g, (t) ->

      '<span class="twitter-user">'+t.link("https://twitter.com/"+t)+'</span>'
    )

  Batman.Filters.fixAmp = (str) ->
    str.replace(/&amp;amp;/g, '&amp;')

  @accessor 'updatedAtMessage', ->
    if updatedAt = @get('updatedAt')
      timestamp = new Date(updatedAt * 1000)
      hours = timestamp.getHours()
      minutes = ("0" + timestamp.getMinutes()).slice(-2)
      seconds = ("0" + timestamp.getSeconds()).slice(-2)
      "Last updated: #{hours}:#{minutes}:#{seconds}"

  ready: ->

    $node = $(@node)
    $wrap = $node.find('.wrap')
    $commentList = $node.find('.comment-list')
    $title = $node.find('.title')
    $moreInfo = $node.find('.more-info')
    $updatedAt = $node.find('.updated-at')
    container = $node.parent()

    dimensions = Dashing.widget_base_dimensions
    margins = Dashing.widget_margins
    paddings = parseInt($node.css('padding-top'), 10) + parseInt($node.css('padding-bottom'), 10)

    moreInfoHeight= parseInt($moreInfo.outerHeight(true), 10) || 0;
    updatedAtHeight = parseInt($updatedAt.outerHeight(true), 10) || 0;
    titleHeight = parseInt($title.outerHeight(true), 10) || 0;
    listMargin = parseInt($commentList.css('margin-top'), 10) + parseInt($commentList.css('margin-bottom'), 10) || 0;

    wrapperHeight = (container.data('sizey') * dimensions[1]) + (2 * Dashing.widget_margins[1]) - paddings
    listHeight = wrapperHeight - moreInfoHeight - updatedAtHeight - titleHeight - listMargin;


    # console.log("listHeight: #{listHeight} MoreInfoHeight: #{moreInfoHeight} TitleHeight: #{titleHeight} UpdatedAtHeight: #{updatedAtHeight}")

    $wrap.css({height: wrapperHeight+'px', overflow: 'hidden'})
    $commentList.css({ height: listHeight+'px'})



  onData: (data) ->
    console.log('OnData:', data)
