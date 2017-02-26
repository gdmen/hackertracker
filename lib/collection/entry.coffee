@Entries = new (Mongo.Collection)('entries')
EntriesSchema = new SimpleSchema(
  brief:
    type: String
    label: 'Brief summary'
  details:
    type: String
    label: 'Full details'
  state:
    type: String
    label: 'Current state'
    allowedValues: ['NOW', 'SOON', 'LATER', 'DONE', 'NEVER']
    defaultValue: 'NOW'
  subentries:
    type: [String]
    label: 'List of sub Entry ids'
    optional: true
  created:
    type: Date
    label: 'Date created'
    autoValue: ->
      if @isInsert
        return new Date
      @unset
      return
  updated:
    type: Date
    label: 'Date updated'
    autoValue: ->
      new Date
  user:
    type: String
    label: 'User id'
)
Entries.attachSchema EntriesSchema
Meteor.methods

  createEntry: (brief, details) ->
    if !Meteor.userId()
      throw new (Meteor.Error)('not-authorized')
    Entries.insert
      brief: brief
      details: details
      user: Meteor.userId()

  setEntryState: (id, state) ->
    entry = Entries.findOne id
    if entry.user != Meteor.userId()
      throw new (Meteor.Error)('not-authorized')
    Entries.update id, $set: state: state, updated: new Date
