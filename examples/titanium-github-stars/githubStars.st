"
 Example usecase of Sebone.st.
 This example runs in titanium mobile environment.
 Compile this file with littlesmallscript@1.0.2 and 
 structure the project so the require path is correct.
"
| SbModel SbCollection SbView UI |
SbModel      := require value: 'lib/SbModel'.
SbCollection := require value: 'lib/SbCollection'.
SbView       := require value: 'lib/SbView'.
UI           := Ti at:#UI.

+SbModel subclass:#StarGazerModel variables:#().


+SbCollection subclass:#StarGazerCollection variables:#().
!StarGazerCollection init
  self setModelConstructor: StarGazerModel
!.
!StarGazerCollection fetch | http url |
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
  self setUIConstructor: [UI createView: #{#layout:#vertical #top:5 #height:(UI at:#SIZE) #backgroundColor:'#8fbc8f'}]
!.
!StarGazerView render
  self el add: (UI createLabel: #{#text:(self model get:#name) #top:0}).
  self el add: (UI createImageView: #{#image:(self model get:#avatar) #top:5 #height:80 #width:80}).
  link := (UI createLabel: #{#text:(self model get:#url) #top:5 #color:'#06f'}).
  self el add: link.
!.

+SbView subclass:#AppView variables:#(#win #searchBtn #sgColl #sgContainer).
!AppView init
  self _constructDOM.

  sgColl := StarGazerCollection new.
  sgColl addDependent: self.
  searchBtn addEvent:#click Listener:[self search. searchBtn hide]
!.
!AppView _constructDOM
  "If we were in browser these UI parts are already in the DOM.
   We call it DOM but it actually is not"
  win := UI createWindow: #{#backgroundColor:'#fff'} ; open. "main window"
  searchBtn := UI createButton: #{#height:50 #width:'90%' #title:'Who Stargazed LittleSmallscript?'}.
  sgContainer := UI createScrollView: #{#layout:#vertical #height:'100%' #width:'100%' #contentHeight:#auto}.
  win add: sgContainer.
  win add: searchBtn.
!.
!AppView onAdd:obj
  StarGazerView new ;setModel:obj ;render ;addTo:sgContainer
!.
!AppView search
  sgColl fetch
!.

[AppView new] value