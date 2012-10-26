"
 Example usecase of Sebone.st.
 This example runs in titanium mobile environment.
 Compile this file and structure the project so the 'require' path is correct.
"
| SbModel SbCollection SbView UI |
SbModel      := require value: 'model/SbModel'.
SbCollection := require value: 'collection/SbCollection'.
SbView       := require value: 'view/SbView'.
UI           := Ti at:#UI.

+SbModel subclass:#StarGazerModel variables:#().


+SbCollection subclass:#StarGazerCollection variables:#().
!StarGazerCollection init
  self setModelConstructor: StarGazerModel
!.
!StatGazerCollection fetch | http url |
  url := 'https://api.github.com/repos/ympbyc/LittleSmallscript/stargazers'.
  http := (Ti at:#Network) createHTTPClient.
  http setOnload: [| gazers |
    gazers := JSON parse: (http at:#responseText).
    self addGazers: gazers "add each user to the collection"
  ].
  (http at:#open) value:#GET value:url.
  http send
!.
!StarGazerCollection addGazers: gazers | starGazer |
  gazers forEach:[:g|
    starGazer := self create 
    ; set:#name   to:(g at:#login) 
    ; set:#avatar to:(g at:#avatar_url)
    ; set:#url    to:(g at:#url).

    self add:starGazer
  ]
!.


+SbView subclass:#StarGazerView variables:#(#link).
!StarGazerView init
  self setUIConstructor: [UI createView ;setLayout:#vertical ;setTop:5 ;setHeight:(UI at:#SIZE) ;setBackgroundColor:'#8fbc8f']
!.
!StarGazerView render
  self el add: (UI createLabel ;setText:(self model get:#name) ;setTop:0).
  self el add: (UI createImageView ;setImage:(self model get:#avatar) ;setTop:5 ;setHeight:80 ;setWidth:80).
  link := (UI createLabel ;setText:(self model get:#url) ;setTop:5 ;setColor:'#06f').
  self el add: link.
!.

+SbView subclass:#AppView variables:#(#win #searchBtn #sgColl #sgContainer).
"AppView is a button"
!AppView init
  self _constructDOM.

  sgColl := StarGazerCollection new.
  sgColl addDependent: self.
  searchBtn addEvent:#click Listener:[self search. searchBtn hide]
!.
!AppView _constructDOM
  "If we were in browser these UI parts are already in the DOM.
   We call it DOM but it actually is not"
  win := UI createWindow ;setBackgroundColor:'#fff' ;open. "main window"
  searchBtn := UI createButton ; setHeight:50 ; setWidth:'90%' ; setTitle:'Who Stargazed LittleSmallscript?'.
  sgContainer := UI createScrollView ;setLayout:#vertical ;setHeight:'100%' ;setWidth:'100%' ;setContentHeight:#auto.
  win add: sgContainer.
  win add: searchBtn.
!.
!AppView onEvent:ev with:obj
  ev === #add ifTrue:[
    [StarGazerView new ;setModel: obj ;render ;addTo:sgContainer] tryCatch:[:err|alert value:err]
  ].
!.
!AppView search
  sgColl fetch
!.

[AppView new] value