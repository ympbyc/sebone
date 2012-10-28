| SbView testView test aModel |

test := [:blk :name|
  ([blk value] tryCatch:[:err|console log:err. false]) ifFalse:[console log: '\u001b[31m'+'failed:'+name]
  ifTrue:[console log:'\u001b[32m'+'passed:'+name]
].

SbView := require value:'../bin/SbView'.

+SbView subclass:#TestView variables:#().


testView := TestView new.

aModel := #{#attributes:#{} #addDependent:[]}.

testView setModel:aModel.
test value:[testView model === aModel]
     value:'setModel - model'.

testView setUIConstructor: ['someUI'].
test value:[testView el === 'someUI']
     value:'setUIConstructor - el'.

"Other methods are just there to be overloaded. Let's just test that they exist"

test value:[<typeof testView.render> === 'function']
     value:#render.

test value:[<typeof testView.addTo> === 'function']
     value:#addTo.

test value:[<typeof testView.show> === 'function']
     value:#show.

test value:[<typeof testView.hide> === 'function']
     value:#hide.

test value:[<typeof testView.oninvoke> === 'function']
     value:'on:invoke:'.

test value:[<typeof testView.updateto> === 'function']
     value:'update:to:'.

test value:[<typeof testView.onAdd> === 'function']
     value:#onAdd.

test value:[<typeof testView.onRemove> === 'function']
     value:#onRemove