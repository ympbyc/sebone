| SbModel testModel testModel2 test stdout |

test := [:blk :name|
  ([blk value] tryCatch:[:err|console log:err. false]) ifFalse:[console log: '\u001b[31m'+'failed:'+name]
  ifTrue:[console log:'\u001b[32m'+'passed:'+name]
].

SbModel := require value:'../src/SbModel'.

+SbModel subclass:#TestModel variables:#().


testModel := TestModel new.

test value:[<typeof testModel.cid()> === 'number']
     value:#cid.

testModel set:#name to:#Testy.
testModel set:#num  to:100.

test value:[(testModel get:#name) === #Testy] value:#setGet1.
test value:[(testModel get:#num)  === 100]    value:#setGet2.

test value:[(testModel attributes) === (testModel at:#_attributes)]
     value:#attributesGetter1.
test value:[(testModel attributes at:#name) === #Testy]
     value:#attributesGetter2.

test value:[(JSON stringify:testModel) === <'{"name":"Testy","num":100}'>]
     value:#toJSON.

"fetch, save, destroy are basically empty methods. just test that they exist"

test value:[<typeof testModel.fetch> === 'function']
     value:#fetch.
test value:[<typeof testModel.save> === 'function']
     value:#save.
test value:[<typeof testModel.destroy> === 'function']
     value:#destroy.

testModel _setAttributes: #{#name:#Ninja #num:999}.
test value:[(JSON stringify:testModel) === <'{"name":"Ninja","num":999}'>]
     value:#_setAttributes.

testModel2 := testModel clone.
test value:[(JSON stringify:testModel2) === <'{"name":"Ninja","num":999}'>]
     value:#clone.



testModel addDependent:#{
  #updateto: [:prop :val| stdout := prop+' changed to '+val]
}.
testModel set:#name to:#Samurai.
test value:[stdout === 'name changed to Samurai']
     value:'addDependent - changed: - update:to:'.