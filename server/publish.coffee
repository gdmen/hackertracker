Meteor.publish 'userData', ->
  if @userId
    return Meteor.users.find({ _id: @userId }, fields:
      'services.google.given_name': 1
      'services.google.email': 1
    )
  else
    @ready()
  return

Meteor.publish 'entries', ->
  Entries.find user: @userId
