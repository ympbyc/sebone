(function () {
  var Sebone, root;

  root = this;

  if (typeof exports !== 'undefined') {
    Sebone = exports;
  } else {
    Sebone = root.Sebone = {};
  }

  Sebone.version = '0.1.0';

  Sebone.Model = (function () {
    "use strict";
    var SbModel;
    SbModel = function () {
      this._attributes = null;
      this._dependents = null;
      this._cid = null;
      if (this.init) {
        this.init.apply(this, arguments);
      }
    };
    SbModel.__super = Object.prototype;
    SbModel.prototype = new Object();
    SbModel.prototype.init = function () {
      var _this = this;
      _this._attributes = {};
      _this._dependents = [];
      return _this._cid = new Date().getTime();
    };
    SbModel.prototype.get = function (prop) {
      var _this = this;
      return _this._attributes[prop];
    };
    SbModel.prototype.setto = function (prop, val) {
      var _this = this;
      _this._attributes[prop] = val;
      return _this.changed(prop);
    };
    SbModel.prototype.toJSON = function () {
      var _this = this;
      return _this._attributes;
    };
    SbModel.prototype.fetch = function () {
      var _this = this;
      return _this._setAttributes({});
    };
    SbModel.prototype.save = function () {
      var _this = this;
      return JSON.stringify(_this);
    };
    SbModel.prototype.destroy = function () {
      var _this = this;
      return null;
    };
    SbModel.prototype._setAttributes = function (hash) {
      var _this = this;
      return _this._attributes = hash;
    };
    SbModel.prototype.attributes = function () {
      var _this = this;
      return _this._attributes;
    };
    SbModel.prototype.clone = function () {
      var _this = this;
      var ret, me, key;
      ret = {};
      me = _this;
      for (key in me)
        ret[key] = me[key];
      return ret;
    };
    SbModel.prototype.cid = function () {
      var _this = this;
      return _this._cid;
    };
    SbModel.prototype.changed = function (prop) {
      var _this = this;
      return _this._dependents.forEach(function (view) {
        return view.updateto(prop, _this.get(prop));
      });
    };
    SbModel.prototype.addDependent = function (view) {
      var _this = this;
      return _this._dependents.push(view);
    };
    return SbModel;
  }).call(this);

  Sebone.View = (function () {
    "use strict";
    var SbView;
    SbView = function () {
      this._model = null;
      this.uiConstructor = null;
      this.elem = null;
      if (this.init) {
        this.init.apply(this, arguments);
      }
    };
    SbView.__super = Object.prototype;
    SbView.prototype = new Object();
    SbView.prototype.setModel = function (m) {
      var _this = this;
      _this._model = m;
      return _this._model.addDependent(_this);
    };
    SbView.prototype.model = function () {
      var _this = this;
      return _this._model;
    };
    SbView.prototype.setUIConstructor = function (uiConst) {
      var _this = this;
      _this.uiConstructor = uiConst;
      return _this.elem = uiConst();
    };
    SbView.prototype.el = function () {
      var _this = this;
      return _this.elem;
    };
    SbView.prototype.render = function () {
      var _this = this;
      return _this;
    };
    SbView.prototype.addTo = function (ui) {
      var _this = this;
      return ui.add(_this.el());
    };
    SbView.prototype.show = function () {
      var _this = this;
      return _this.el().show();
    };
    SbView.prototype.hide = function () {
      var _this = this;
      return _this.el().hide();
    };
    SbView.prototype.oninvoke = function (ev, blk) {
      var _this = this;
      return _this.el().addEventListener(ev, blk);
    };
    SbView.prototype.updateto = function (prop, val) {
      var _this = this;
      return null;
    };
    SbView.prototype.onAdd = function (mdl) {
      var _this = this;
      return null;
    };
    SbView.prototype.onRemove = function (mdl) {
      var _this = this;
      return null;
    };
    return SbView;
  }).call(this);

  Sebone.Collection = (function () {
    "use strict";
    var SbCollection;
    SbCollection = function () {
      this._models = null;
      this._dependents = null;
      this.modelConst = null;
      if (this.init) {
        this.init.apply(this, arguments);
      }
    };
    SbCollection.__super = Object.prototype;
    SbCollection.prototype = new Object();
    SbCollection.prototype.init = function () {
      var _this = this;
      _this._models = [];
      _this._dependents = [];
      return _this.modelConst = function () {
        return null;
      };
    };
    SbCollection.prototype.models = function () {
      var _this = this;
      var ms;
      ms = [];
      _this._models.forEach(function (it) {
        return (it !== undefined) ? (function () {
          return ms.push(it);
        })() : void 0;
      });
      return ms;
    };
    SbCollection.prototype.setModelConstructor = function (m) {
      var _this = this;
      return _this.modelConst = m;
    };
    SbCollection.prototype.create = function () {
      var _this = this;
      return new _this.modelConst();
    };
    SbCollection.prototype.toJSON = function () {
      var _this = this;
      return _this.models();
    };
    SbCollection.prototype.reset = function () {
      var _this = this;
      return _this._models = [];
    };
    SbCollection.prototype.add = function (m) {
      var _this = this;
      _this._models.push(m);
      return _this.added(m);
    };
    SbCollection.prototype.remove = function (m) {
      var _this = this;
      _this.each(function (_m, key) {
        return (m === _m) ? (function () {
          return _this._models[key] = undefined;
        })() : void 0;
      });
      return _this.removed(m);
    };
    SbCollection.prototype.getByCid = function (cid) {
      var _this = this;
      return _this.first(function (m) {
        return (m.cid() === cid);
      });
    };
    SbCollection.prototype.index = function (i) {
      var _this = this;
      return _this.models()[i];
    };
    SbCollection.prototype.push = function (m) {
      var _this = this;
      _this._models.push(m);
      return _this.added(m);
    };
    SbCollection.prototype.pop = function () {
      var _this = this;
      var m;
      m = _this._models.pop();
      return _this.removed(m);
    };
    SbCollection.prototype.size = function () {
      var _this = this;
      var length;
      return _this.models().length;
    };
    SbCollection.prototype.addDependent = function (view) {
      var _this = this;
      return _this._dependents.push(view);
    };
    SbCollection.prototype.added = function (obj) {
      var _this = this;
      return _this._dependents.forEach(function (view) {
        return view.onAdd(obj);
      });
    };
    SbCollection.prototype.removed = function (obj) {
      var _this = this;
      return _this._dependents.forEach(function (view) {
        return view.onRemove(obj);
      });
    };
    SbCollection.prototype.forEachDependent = function (blk) {
      var _this = this;
      return _this._dependents.forEach(function (v) {
        return (function () {
          var _ret;
          try {
            _ret = (function () {
              return blk(v);
            })();
          } catch (err) {
            _ret = function () {
              return null;
            }(err);
          }
          return _ret;
        })();
      });
    };
    SbCollection.prototype.each = function (blk) {
      var _this = this;
      return _this.models().forEach(blk);
    };
    SbCollection.prototype.map = function (blk) {
      var _this = this;
      return _this.models().map(blk);
    };
    SbCollection.prototype.injectinto = function (initial, blk) {
      var _this = this;
      var last;
      last = initial;
      _this.each(function (it) {
        return last = blk(it, last);
      });
      return last;
    };
    SbCollection.prototype.first = function (blk) {
      var _this = this;
      var retVal, frozen;
      frozen = false;
      _this.each(function (m) {
        return frozen ? void 0 : (function () {
          return blk(m) ? (function () {
            retVal = m;
            return frozen = true;
          })() : void 0;
        })();
      });
      return retVal;
    };
    return SbCollection;
  }).call(this);

  return Sebone;
}).call(this);