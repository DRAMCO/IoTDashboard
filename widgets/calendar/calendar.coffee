class Dashing.Calendar extends Dashing.Widget

  onData: (data) =>
    events = data.events

    next_events = []
    for next_event in events
      start = moment(next_event.start)
      start_date = start.format('dd DD/MM')
      start_time = start.format('HH:mm')

      next_events.push { calendar: next_event.calendar, summary: next_event.summary, start_date: start_date, start_time: start_time }
    @set('next_events', next_events)
