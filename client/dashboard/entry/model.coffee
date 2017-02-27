Meteor.subscribe 'entries'

Template.dashboard.helpers
  entries_now: ->
    Entries.find { state: 'NOW' }, sort: created: -1

Template.createEntry.events

  'submit #create-entry': (e) ->
    e.preventDefault()
    Meteor.call 'createEntry', e.target.brief.value
    e.target.brief.value = ""
    return

Template.showEntry.events

  "focusin .entry": (e) ->
    e.preventDefault()
    if Session.get 'selectedEntry' == event.target.getAttribute "data-entry"
      return
    console.log event.target.getAttribute "data-entry"
    Session.set 'selectedEntry', event.target.getAttribute "data-entry"

  "focusout .entry": (e) ->
    e.preventDefault()
    entryId = Session.get 'selectedEntry'
    console.log entryId

  "keydown .entry": (e) ->
    selectedId = Session.get 'selectedEntry'
    if selectedId != e.target.id
      return
    code = e.keyCode or e.which
    if code == 9
      e.preventDefault()
      console.log "TAB " + selectedId
