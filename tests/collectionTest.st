| SbCollection testCollection test aModel bModel stdout |

test := [:blk :name|
  ([blk value] tryCatch:[:err|console log:err. false]) ifFalse:[console log: '\u001b[31m'+'failed:'+name]
  ifTrue:[console log:'\u001b[32m'+'passed:'+name]
].

SbCollection := require value:'../src/SbCollection'.

+SbCollection subclass:#TestCollection variables:#().

!TestCollection triggerSomeEvent
  self forEachDependent:[:d|
    d onSomeEvent
  ]
!.

testCollection := TestCollection new.

testCollection add:1.
testCollection add:2.
test value:[|ms| ms := testCollection models. (ms at:0)===1 && ((ms at:1)===2)]
     value:#modelsGetter.

testCollection setModelConstructor:[#{#name:#dummyModel}].

test value:[(JSON stringify: testCollection create) === <'{"name":"dummyModel"}'>]
     value:'setModelConstructor - create'.

test value:[(JSON stringify: testCollection) === '[1,2]']
     value:#toJSON.

testCollection reset.
test value:[|ms| ms := testCollection models. <ms instanceof Array> && ((ms at:#length) === 0)]
     value:#reset.

aModel := #{#name:#Ninja, #cid:[123]}.
bModel := #{#name:#Samurai, #cid:[2345]}.

testCollection add:aModel.
testCollection add:bModel.
test value:[(JSON stringify: testCollection) === <'[{"name":"Ninja"},{"name":"Samurai"}]'>]
     value:#add.

testCollection remove:aModel.
test value:[(JSON stringify: testCollection) === <'[{"name":"Samurai"}]'>]
     value:#remove.

test value:[(testCollection getByCid:2345) === bModel]
     value:#getByCid.

testCollection ;add:1 ;add:2 ;add:3 ;add:4.
test value:[(testCollection index:2) === 2]
     value:#index.

testCollection addDependent:#{
  #onAdd:   [:m| stdout := 'model got '+m]
  #onRemove:[:m| stdout := 'model lost '+m]
  #onSomeEvent:[stdout := 'someEvent happened']
}.
testCollection push:999.
test value:[stdout === 'model got 999']
     value:'push - added - onAdd'.
testCollection pop === 999.
test value:[stdout === 'model lost 999']
     value:'pop - removed - onRemove'.

test value:[testCollection size === 5]
     value:#size.


testCollection add:100.
test value:[stdout === 'model got 100']
     value:'addDependent - add - added - onAdd'.
testCollection remove:1.
test value:[stdout === 'model lost 1']
     value:'addDependent - remove - removed - onRemove'.

testCollection triggerSomeEvent.
test value:[stdout === 'someEvent happened']
     value:#forEachDependent
