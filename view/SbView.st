"A view is an UI wrapper"

+Object subclass:#SbView variables:#(#_model #_collection #uiConstructor #elem).

"Views receive events from collections and models and update the UI with current state of the model.
 Views are also responsible for receiving UI events like clicks and call suitable methods of the model.
 Sebone is intended to be used in non-browser environment so there is no dependency on DOM."

!SbView setModel: m
  "Each view has a reference to a model. To listen for updates"
  _model := m.
  _model addDependent: self
!.

!SbView setUIConstructor: uiConst
  "A function to create an instance of some UI should be passed.
   The instance is stored to the view's el field"
  uiConstructor := uiConst.
  elem := uiConst value
!.

!SbView el
  "Return the raw UI instance"
  elem
!.

!SbView render
  "Override this method to render the view from model data"
!.

!SbView addTo: ui
  "Add the view's el to other UI"
  ui add: self el
!.

!SbView show
  self el show
!.

!SbView hide
  self el hide
!.

!SbView model
  _model
!.

!SbView on:ev invoke: blk
  "Listen for UI events like 'click' and 'keydown'"
  self el addEvent: ev Listener: blk
!.

!SbView update: prop to: val
  "Override to listen for model updates"
!.

!SbView onEvent: ev with: obj
  "Override to listen for collection updates"
!.

module at:#exports put:SbView.

SbView