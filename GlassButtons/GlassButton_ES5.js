var _createClass = function () { function defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } } return function (Constructor, protoProps, staticProps) { if (protoProps) defineProperties(Constructor.prototype, protoProps); if (staticProps) defineProperties(Constructor, staticProps); return Constructor; }; }();

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

var LibURL = document.scripts[document.scripts.length - 1].src.replace('GlassButton_ES5.js', '');
document.onmousedown = function () {
	return false;
};
document.ontouchstart = function () {
	return false;
};

var GlassButton = function () {
	_createClass(GlassButton, null, [{
		key: 'ScaleValue',
		value: function ScaleValue() {
			return 1.2;
		}
	}]);

	function GlassButton(name, imag_source, OnClickFunction) {
		_classCallCheck(this, GlassButton);

		this.name = name;
		this._OnClickFunction = OnClickFunction;
		this._scale = false;

		this._div = document.createElement('div');
		this._div.addEventListener("mouseenter", function () {
			this._imgdark.style.visibility = 'hidden';
			this._imglight.style.visibility = 'visible';
		}.bind(this));
		this._div.addEventListener("mouseleave", function () {
			this._imgdark.style.visibility = 'visible';
			this._imglight.style.visibility = 'hidden';
		}.bind(this));
		this._div.addEventListener("mousedown", function () {
			if (!this._scale) if (typeof this._OnClickFunction == 'function') this._OnClickFunction.call(this);
			this._div.style.transform = 'scale(' + GlassButton.ScaleValue() + ')';
		}.bind(this));
		this._div.addEventListener("mouseup", function () {
			if (!this._scale) this._div.style.transform = 'scale(1)';
		}.bind(this));

		this._div.addEventListener("touchstart", function () {
			if (!this._scale) if (typeof this._OnClickFunction == 'function') this._OnClickFunction.call(this);
			this._div.style.transform = 'scale(' + GlassButton.ScaleValue() + ')';
		}.bind(this));
		this._div.addEventListener("touchend", function () {
			if (!this._scale) this._div.style.transform = 'scale(1)';
		}.bind(this));

		this._img = document.createElement('img');
		this._img.style.cssText = 'width:60%; height:60%; margin:20%; position:absolute; left:0px; top:0px';
		this._img.src = imag_source;
		this._div.appendChild(this._img);

		this._imgdark = document.createElement('img');
		this._imgdark.src = LibURL + 'dark.png';
		this._imgdark.style.cssText = 'width:100%; height:100%; position:absolute; left:0px; top:0px';
		this._div.appendChild(this._imgdark);

		this._imglight = document.createElement('img');
		this._imglight.src = LibURL + 'light.png';
		this._imglight.style.cssText = 'width:100%; height:100%; position:absolute; left:0px; top:0px; visibility:hidden';
		this._div.appendChild(this._imglight);
	}

	_createClass(GlassButton, [{
		key: 'add',
		value: function add(x, y, size) {
			this._div.style.cssText = 'position:absolute; ' + 'margin:0px; padding:0px;'; //border:1px solid	
			this._div.style.left = x + 'px';
			this._div.style.top = y + 'px';
			this._size = size;
			this._div.style.height = size + 'px';
			this._div.style.width = size + 'px';
			document.body.appendChild(this._div);
		}
	}, {
		key: 'drop',
		value: function drop() {
			document.body.removeChild(this._div);
		}
	}, {
		key: 'SetImage',
		value: function SetImage(Img) {
			this._img.src = Img;
		}
	}, {
		key: 'scale',
		get: function get() {
			return this._scale;
		},
		set: function set(val) {
			this._scale = val;
			if (val) {
				this._div.style.transform = 'scale(' + GlassButton.ScaleValue() + ')';
			} else {
				this._div.style.transform = 'scale(1)';
			}
		}
	}, {
		key: 'OnClickFunction',
		get: function get() {
			return this._OnClickFunction;
		},
		set: function set(Func) {
			this._OnClickFunction = Func;
		}
	}, {
		key: 'X',
		get: function get() {
			return parseInt(this._div.style.left, 10);
		},
		set: function set(val) {
			this._div.style.left = val + 'px';
		}
	}, {
		key: 'Y',
		get: function get() {
			return parseInt(this._div.style.top, 10);
		},
		set: function set(val) {
			this._div.style.top = val + 'px';
		}
	}, {
		key: 'Size',
		get: function get() {
			return parseInt(this._div.style.height, 10);
		},
		set: function set(val) {
			this._div.style.height = val + 'px';this._div.style.width = val + 'px';
		}
	}]);

	return GlassButton;
}();

;