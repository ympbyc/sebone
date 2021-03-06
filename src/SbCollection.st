"SbCollection
 2012 Minori Yamashita <ympbyc@gmail.com>
"

"A Collections is an object that wraps an array of models of a type"
+Object subclass:#SbCollection variables:#(#_models #_dependents #modelConst).

"You fetch a set of data(e.g. /users), create a model for each item in the set, 
 add them to the collection one by one."

!SbCollection init
  _models     :=  #().
  _dependents :=  #().
  modelConst :=  [].
!.

!SbCollection models
  "Return the raw array of modles"
  _models
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
  self models
!.

!SbCollection reset
  "Empty the collection"
  _models := #()
!.

!SbCollection add: m
  "Add a model to the collection, fire 'add' event"
  _models push: m.
  self added: m
!.

!SbCollection remove: m
  "Remove a model from the collection, fire 'remove' event"
  self each:[:_m :key|
    m === _m ifTrue: [
      _models at:key put:undefined
    ]
  ].
  _models := self reject:[:m|
    m === undefined
  ].
  self removed: m
!.

!SbCollection getByCid: cid
  "Get a model in the collection that has the specified cid"
  self first:[:m|
    m cid === cid
  ]
!.

!SbCollection index: i
  "Get a model in the collection at the specified index"
  self models at: i
!.

!SbCollection size | length |
  "The size of the collection"
  (self models) at:#length
!.

!SbCollection addDependent: view
  "Add views that listen for events on this collection"
  _dependents push: view
!.

!SbCollection added: obj
  "Call onAdd: with obj"
  _dependents forEach: [:view|
    view onAdd:obj
  ]
!.

!SbCollection removed:obj
  "Call onRemove: with obj"
  _dependents forEach: [:view|
    view onRemove:obj
  ]
!.

!SbCollection forEachDependent: blk
  _dependents forEach: [:v|
    [blk value: v] tryCatch:[] "custom events are not always captured"
  ]
!.


"---Collections have useful methods to iterate over the collection---"

!SbCollection each: blk
  self models forEach: blk
!.

!SbCollection map: blk
  self models map: blk
!.

!SbCollection filter:blk | arr |
  arr := #().
  self each:[:m|
    (blk value:m) ifTrue:[arr push:m]].
  arr
!.

!SbCollection reject:blk
  self filter:[:m|
    <! blk(m)>]
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