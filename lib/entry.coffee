@Entries = new (Mongo.Collection)('entries')
EntriesSchema = new SimpleSchema(
  brief:
    type: String
    label: 'Brief summary'
  details:
    type: String
    label: 'Full details'
    optional: true
  state:
    type: String
    label: 'Current state'
    allowedValues: ['NOW', 'SOON', 'LATER', 'DONE', 'NEVER']
    defaultValue: 'NOW'
  children:
    type: [String]
    label: 'List of child Entry ids'
    optional: true
  parent:
    type: String
    label: 'Parent Entry id'
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
  days:
    type: [Date]
    label: 'Days worked on'
    autoValue: ->
      []
  user:
    type: String
    label: 'User id'
)
Entries.attachSchema EntriesSchema
Meteor.methods

  createEntry: (brief, details, parentId) ->
    if !Meteor.userId()
      throw new (Meteor.Error)('not-authorized')
    Entries.insert
      brief: brief
      details: details
      user: Meteor.userId()
    if Entries.findOne parentId
      Meteor.call 'setParent', id, parentId

  getEntry: (id) ->
    entry = Entries.findOne id
    if !entry
      throw new (Meteor.Error)('not-found')
    if entry.user != Meteor.userId()
      throw new (Meteor.Error)('not-authorized')
    return entry

  setState: (id, state) ->
    Meteor.call 'getEntry', id
    Entries.update id, $set: state: state, updated: new Date

  setParent: (id, parentId) ->
    Meteor.call 'getEntry', id
    Entries.update id, $set: parent: parentId

  addChild: (id, childId) ->
    Meteor.call 'getEntry', id
    Entries.update id, $push: children: childId, updated: new Date

  removeChild: (id, childId) ->
    Meteor.call 'getEntry', id
    Entries.update id, $push: children: childId, updated: new Date
