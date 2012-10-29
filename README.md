```
         ___      _                       _ 
        / __| ___| |__  ___ _ _  ___   __| |_ 
        \__ \/ -_) '_ \/ _ \ ' \/ -_)_(_-<  _|
        |___/\___|_.__/\___/_||_\___(_)__/\__|
Backbone-like MVC structure to your LittleSmallscript.
```

Sebone is a tiny subset of Backbone.js the client side MVC toolset.  
Sebone provides just a small number of carefully chosen APIs; just enough to suggest your sense to structure your app in MVC pattern. Sebone will never attempt to provide a full-stack framework that constrain your thinking.

Sebone is not dependent on a specific environment. You can use it in browsers, Titanium Mobile, Node.js app, ... whereever JavaScript runs.

Sebone is written in <a href="https://github.com/ympbyc/LittleSmallscript">LittleSmallscript</a> and its methods have names that follows Smalltalk's convention. To get the most of it, we strongly recommend you to use Sebone with LittleSmallscript.

Installation
------------
The bin/ directory contains the stable compiled version of Sebone. Copy it to your file system and `require`.

```smalltalk
| Sebone |
Sebone := require value:'sebone'.
```

Manual
======
`Sebone` is a namespace that contain three important classes: Sebone.Model, Sebone.Collection, and Sebone.View. You will be subclassing these classes to create your own classes.

Models
------
Models are wrapped dictionaries (or hashes). You store every piece of data your app deals with into an instance of one of the models.

```smalltalk
| Model yourModel |
Model := Sebone at:#Model.
+Model subclass:#HackerModel variables:#().

yourModel := HackerModel new.
```

### set:to:/get:
You set a data to the model with `set:to:`.  
You get a data from the model with `get:`.

```smalltalk
yourModel set:#name to:#Ninja.
yourModel get:#name
```

### Dependents
Sebone uses `dependent pattern` - a variation of observer patterns. Each model have a private slot that holds a set of `dependent` objects (They are views most of the time). Whenever a change happen to the data the model is handling, the model sends `update:to` message to each dependent; letting the dependents to sync with the model.

To add a dependent to (i.e. subscribe to) a model, send `addDependent:` message to the model.

```smalltalk
yourModel addDependent:hackerView. "We'll talk about hackerView later"
```

### Fetching and saving
Models have ability to `fetch` and `save`. 

```smalltalk
!HackerModel fetch
  "You have to implement this message on your own"
  $ ajax:#{
    #url    : 'https://api.twitter.com/1/users/show.json?screen_name=ympbyc',
    #type   : #GET,
    #success: [:result| self set:#twitter_screen_name to:(result at:#screen_name)]
  }
!.
```

Collections
-----------
If a model wraps a dictionary, a collection wrapps an array. Collections are arrays of models.  
Register the models' constructor on initialize if you like.

```smalltalk
| Collection anonymous gundam azumanga |
Collection := Sebone at:#Collection.
+Collection subclass:#HackerGuild variables:#().

!HackerGuild init
  self setModelConstructor:HackerModel
!.

anonymous := HackerGuild new.
```

### add:/remove:
To add a model to a collection, send `add:` message.

```smalltalk
"Let's create some more hackers"
gundam   := HackerModel new ;set:#name to:#GUNDAM.
azumanga := HackerModel new ;set:#name to:#Azumanga.

"Now add them to the collection"
anonymous add:yourModel.
anonymous add:gundam.
anonymous add:azumanga.
```

To remove a model from a collection, send `remove:` message.

```smalltalk
anonymous remove:yourModel
```

### Iterators
Collections have some useful iteration methods defined.

```smalltalk
anonymous each:[:hacker| console log:(hacker get:#name)].
anonymous inject:0 into:[:hacker :last| last + 1].
```

### Dependents
Collections also can have dependents. 

```smalltalk
anonymous addDependent:appView. "We wll talk about appView later"
```

Collections send `onAdd:` and `onRemove:` instead of `update:to:`.  
You can also set up the collection to send custom messages.

```smalltalk
!HackerGuild exploded
  self forEachDependent:[:dep| dep onExplode]
!.
```

### Fetchng and saving
Collections also can fetch and save.  
When creating a new model to add to the collection itself, it is useful to use `create:` that is available if you registered the modelConstructor.

```smalltalk
!HackerGuild fetch
  $ ajax:#{
    #url: 'https://api.twitter.com/1/friends/ids.json?screen_name=AnonymousIRC',
    #type: #GET,
    #success: [:result| self lookup:result]
  }
!.
!HackerGuild lookup: hackerids
  $ ajax:#{
    #url    : 'https://api.twitter.com/1/users/lookup.json',
    #type   : #POST,
    #data   : #{#user_id: (hackerids join:','}
    #success: [:result| 
      result forEach:[:user|
        self add:(self create ; set:#name to:(user at:#screen_name)
      ]
    ]
  }
!.
```

Views
-----
Views are the listeners of Collections amd Models. Whenever a change happens to them, the Views get notified and update themselves to reflect the change to UI.

### init

```smalltalk
| View hackerView |
View := Sebone at:#View.
+View subclass:#HackerView variables:#().

!HackerView init
  self setUIConstructor:[$ value:'<li></li>']. "What this view wraps"
!.

hackerView := HackerView new.
```

Each view has a reference to a model which the model depends on. Set this relationship with `setModel:`.

```smalltalk
hackerView setModel:yourModel
```

### render

Each view implements `render` message to update the UI with new infomation.  
`el` message pulls out the instance of the UIConstructor that you set on initialize.  
`model` pulls out the model you set with `setModel`.

```smalltalk
!HackerView render
  ($ value: self el) html: (self model get:#name)
!.
!HackerView update:property to:val
  "When the model's #name property change, re-render the UI"
  property === #name ifTrue:[self render]
!.
```

AppView
-------
An app starts in AppView, listening for whatever an event to kick things in.

Now, let's create AppView and listen on the anonymous's collection for messages.

```smalltalk
| appView |
+View subclass:#AppView variables:#().

!AppView init
  self setUIConstructor:[$ value:'<ul></ul>'].
!.
!AppView onAdd: aHackerModel | hv |
  "invoked when anonymous sends onAdd message"
  hv := HackerView new.
  hv setModel:aHackerModel.
  hv render.
  ($ value: hv el) appendTo: self el "create a hackerView, set data to it and add to myself"
!.
```

The main script would be like this.

```smalltalk
appView := AppView new.
anonymous fetch.
($ value: appView el) appendTo:#body
```


Using Sebone in environments other than browsers
================================================
Easy! Just replace the UI constructor block you give to `setUIConstructor` with what suits the environment. So if you are using Titanium Mobile:

```smalltalk
!HackerView init
  self setUIConstructor:[(Ti at:#UI) createTableViewRow]
!.

!AppView init
  self setUIConstructor:[(Ti at:#UI) createTableView]
!.
```

would do the job.