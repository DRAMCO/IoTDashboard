class Dashing.Klimato extends Dashing.Widget

  ready: ->
    container = $(@node).parent()
    # Gross hacks. Let's fix this.
    width = (Dashing.widget_base_dimensions[0] * container.data("sizex")) + Dashing.widget_margins[0] * 2 * (container.data("sizex") - 1)
    height = (Dashing.widget_base_dimensions[1] * container.data("sizey"))
    @klimato = new Rickshaw.Graph(
      element: @node
      width: width
      height: height
      renderer: "area"
      max: 255
      series: [
        {
        color: "#fff",
        data: [{x:0, y:0}],
        stroke: true
        }
      ]
      padding: {top: 0.02, left: 0.02, right: 0.02, bottom: 0.02}
    )

    @klimato.series[0].data = @get('rainForecast') if @get('rainForecast')

    x_axis = new Rickshaw.Graph.Axis.Time(graph: @klimato)
    y_axis = new Rickshaw.Graph.Axis.Y(graph: @klimato, tickFormat: Rickshaw.Fixtures.Number.formatKMBT)
    @klimato.render()

  onData: (data) ->
    if @klimato
      @klimato.series[0].data = data.rainForecast
      @klimato.render()

