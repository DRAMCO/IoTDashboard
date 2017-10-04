# dashing.js is located in the dashing framework
# It includes jquery & batman for you.
#= require dashing.js

#= require_directory ./gridster
#= require d3-3.2.8.js
#= require dashing.gridster.coffee
#= require jquery.knob.js
#= require rickshaw-1.4.3.min.js

#= require_tree ../../widgets
#= require moment.js

console.log("Yeah! The dashboard has started!")



Batman.Filters.time = (t) ->
  date = new Date(t*1000)
  d = date.getHours()
  m = date.getMinutes()
  if(d < 10)
    d = "0" + d
  if(m < 10)
    m = "0" + m

  return "" + d + ":" + m

Batman.Filters.delay = (t) ->
  if(t > 0)
    t = t / 60
    return "+ " + t + "'"
  else
    return "" 

Batman.Filters.platform = (p, normal) ->
  if(normal == "0" || normal == 0)
    return "<span class=\"changed\">" + p + "</span>"
  else
    return "<span class=\"notchanged\">" + p + "</span>"

Batman.Filters.eq = (l, r) ->
  if( l == r)
    return true
  else
    return false

Dashing.on 'ready', ->
  Dashing.widget_margins ||= [5, 5]
  Dashing.widget_base_dimensions ||= [290, 325]
  Dashing.numColumns ||= 4

  contentWidth = (Dashing.widget_base_dimensions[0] + Dashing.widget_margins[0] * 2) * Dashing.numColumns

  Batman.setImmediate ->
    $('.gridster').width(contentWidth)
    $('.gridster ul:first').gridster
      widget_margins: Dashing.widget_margins
      widget_base_dimensions: Dashing.widget_base_dimensions
      avoid_overlapped_widgets: !Dashing.customGridsterLayout
      draggable:
        stop: Dashing.showGridsterInstructions
        start: -> Dashing.currentWidgetPositions = Dashing.getWidgetPositions()
