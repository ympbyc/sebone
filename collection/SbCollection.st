"A Collections is an object that wraps an array of models of a type"

+Object subclass:#SbCollection variables:#(#models #dependents #modelConst).

"You fetch a set of data(e.g. /users), create a model for each item in the set, 
 add them to the collection one by one."

!SbCollection init
  models     :=  #().
  dependents :=  #().
  modelConst :=  [].
!.

!SbCollection getModels
  "Return the raw array of modles"
  models
!.

!SbCollection setModelConstructor: m
  "Constructor function to create a model this collection handles"
  modelConst := m
!.

!SbCollection create
  "Create an instance of the model"
  modelConst new
!.

!SbCollection toJSON
  models
!.

!SbCollection reset
  "Empty the collection"
  models := #()
!.

!SbCollection add: m
  "Add a model to the collection, fire 'add' event"
  models push: m.
  self trigger: #add with: m
!.

!SbCollection remove: m
  "Remove a model from the collection, fire 'remove' event"
  self each:[:_m :key|
    m === _m ifTrue: [
      <delete models[key]>
    ]
  ].
  self trigger: #remove with: m
!.

!SbCollection getByCid: cid
  "Get a model in the collection that has the specified cid"
  self first:[:m|
    m cid === cid
  ]
!.

!SbCollection index: i
  "Get a model in the collection at the specified index"
  models at: i
!.

!SbCollection push: m
  "Push a model at the end of the collection"
  models push: m.
  self trigger: #add with: m
!.

!SbCollection pop |m|
  "Pop the model at the end of the collection"
  m := models pop
  self trigger: #remove with: m
!.

!SbCollection size
  "The size of the collection"
  models at:#length
!.

!SbCollection addDependent: view
  "Add views that listen for events on this collection"
  dependents push: view
!.

!SbCollection added: obj
  "Call onAdd: with obj"
  dependents forEach: [:view|
    view onAdd:obj
  ]
!.

!SbCollection removed:obj
  "Call onRemove: with obj"
  dependents forEach: [:view|
    view onRemove:obj
  ]
!.


"---Collections have useful methods to iterate over the collection---"

!SbCollection each: blk
  models forEach: blk
!.

!SbCollection map: blk
  models map: blk
!.

!SbCollection inject: initial into: blk |last|
  last := initial.
  self each: [:it|
    last := blk value: it value: last
  ].
  last
!.

!SbCollection first: blk | retVal frozen |
  frozen := false.
  self each:[:m|
    frozen ifFalse:[
      (blk value: m) ifTrue: [retVal := m. frozen := true]
    ]
  ].
  retVal
!.


module at:#exports put:SbCollection.

SbCollection