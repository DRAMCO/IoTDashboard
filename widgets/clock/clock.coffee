class Dashing.Clock extends Dashing.Widget

  ready: ->
    setInterval(@startTime, 500)

  startTime: =>
    today = new Date()

    h = today.getHours()
    m = today.getMinutes()
    s = today.getSeconds()
    da = today.getDate()
    mo = today.getMonth()
    ye = today.getFullYear()
    m = @formatTime(m)
    s = @formatTime(s)
    da = @formatTime(da)
    mo = @formatTime(mo)
    @set('time', h + ":" + m )
    @set('date', da + "/" + mo + "/" + ye)

  formatTime: (i) ->
    if i < 10 then "0" + i else i