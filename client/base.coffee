Meteor.subscribe 'userData'

Template.body.events

  'click a#login-button': (e, t) ->
    e.preventDefault()
    Meteor.loginWithGoogle {}, (err) ->
      if err
        throw new (Meteor.Error)('Google login failed: ' + err)
      return
    return

  'click a#logout-button': (e, t) ->
    e.preventDefault()
    Meteor.logout (err) ->
      if err
        throw new (Meteor.Error)('Logout failed: ' + err)
      return
    return
