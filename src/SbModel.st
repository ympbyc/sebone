"SbModel.st
 2012 Minori Yamashita <ympbyc@gmail.com>
"

"A model is a hash"
+Object subclass:#SbModel variables: #(#_attributes #_dependents #_cid).

"A model is an wrapped hash. It has data storage capability. It has methods to manipulate these data.
 A very small object like one tweet can be a model."

!SbModel init
  _attributes := #{}.
  _dependents := #().
  _cid := Date new getTime. "An instance-unique id"
!.

!SbModel get: prop
  _attributes at:prop
!.

!SbModel set: prop to: val
  _attributes at:prop put:val.
  self changed:prop.
!.

!SbModel toJSON
  "JSON.stringify calls this function and stringify the return value"
  _attributes
!.

!SbModel fetch
  "Override this method to replace the attributes with the value returned from DB"
  self _setAttributes: #{}
!.

!SbModel save
  "Override this method to save the model to SQLite or App.Properties"
  JSON stringify: self.
!.

!SbModel destroy
  "Override this method to destroy the model saved in DB"
!.

!SbModel _setAttributes: hash
  "Do not use this method when possible"
  _attributes := hash
!.

!SbModel attributes
  _attributes
!.

!SbModel clone |ret me key|
  ret := #{}.
  me := self.
  <for (key in me)
    ret[key] = me[key]>.
  ret
!.

!SbModel cid
  "Return unique id for individual model"
  _cid
!.

!SbModel changed: prop 
  "Call update on each view registered as a dependent"
  _dependents forEach:[:view|
    view update: prop to: (self get: prop)
  ]
!.

!SbModel addDependent: view
  "Register views to receive update"
  _dependents push: view
!.


module at:#exports put:SbModel.

SbModel