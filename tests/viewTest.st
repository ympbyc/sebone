| SbView testView test |

test := [:blk :name|
  ([blk value] tryCatch:[:err|console log:err. false]) ifFalse:[console log: '\u001b[31m'+'failed:'+name]
  ifTrue:[console log:'\u001b[32m'+'passed:'+name]
].

SbView := require value:'../view/SbView'.

+SbView subclass:#TestView variables:#()

"write tests here"