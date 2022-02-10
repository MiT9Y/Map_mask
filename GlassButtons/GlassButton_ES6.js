'use strict';

/*let GlassButton = (function() {

	let _div = document.createElement('div');
	let _img = document.createElement('img');_div.appendChild(_img);
	return class {
		constructor(name,imag_source,url_source) {
			this.name = name;
			_img.src = imag_source;
		};
		add (x,y) {
			_div.style = 'height:100px; width:100px; position:absolute; '+
						 'margin:0px; padding:0px; border:1px solid';	
			_div.style.left = x+'px';
			_div.style.top = y+'px';
/*			_div.style.height = '100px';
			_div.style.width = '100px';
			_div.style.position = 'absolute';
			_div.style.margin = '0px';
			_div.style.padding = '0px';
			_div.style.border = '1px solid';*/
/*			document.body.appendChild(_div);
		};
	};

})();*/
let LibURL = document.scripts[document.scripts.length-1].src.replace('GlassButton_ES6.js','');
document.onmousedown = function () {return false;};
document.ontouchstart = function () {return false;};

class GlassButton {
	static ScaleValue() {
		return 1.2;
	}
	constructor(name,imag_source,OnClickFunction) {
		this.name = name;
		this._OnClickFunction = OnClickFunction;
		this._scale = false;
		
		this._div = document.createElement('div');
		this._div.addEventListener("mouseenter", (function() {this._imgdark.style.visibility = 'hidden';
															  this._imglight.style.visibility = 'visible';}).bind(this));
		this._div.addEventListener("mouseleave", (function() {this._imgdark.style.visibility = 'visible';
															  this._imglight.style.visibility = 'hidden';}).bind(this));
		this._div.addEventListener("mousedown", (function() {
			if (!this._scale) if (typeof this._OnClickFunction == 'function') this._OnClickFunction.call(this);
			this._div.style.transform = 'scale('+GlassButton.ScaleValue()+')';
		}).bind(this));
		this._div.addEventListener("mouseup", (function() {if (!this._scale) this._div.style.transform = 'scale(1)'}).bind(this));

		this._div.addEventListener("touchstart", (function() {
			if (!this._scale) if (typeof this._OnClickFunction == 'function') this._OnClickFunction.call(this);
			this._div.style.transform = 'scale('+GlassButton.ScaleValue()+')';
		}).bind(this));
		this._div.addEventListener("touchend", (function() {if (!this._scale) this._div.style.transform = 'scale(1)'}).bind(this));
		
		this._img = document.createElement('img');
		this._img.style.cssText = 'width:60%; height:60%; margin:20%; position:absolute; left:0px; top:0px';
		this._img.src = imag_source; 
		this._div.appendChild(this._img);

		this._imgdark = document.createElement('img');
		this._imgdark.src = LibURL+'dark.png';
		this._imgdark.style.cssText = 'width:100%; height:100%; position:absolute; left:0px; top:0px';
		this._div.appendChild(this._imgdark);

		this._imglight = document.createElement('img');
		this._imglight.src = LibURL+'light.png';
		this._imglight.style.cssText = 'width:100%; height:100%; position:absolute; left:0px; top:0px; visibility:hidden';
		this._div.appendChild(this._imglight);
		
	};
	add(x,y,size) {
		this._div.style.cssText = 'position:absolute; '+
					 'margin:0px; padding:0px;'; //border:1px solid	
		this._div.style.left = x+'px';
		this._div.style.top = y+'px';
		this._size = size;
		this._div.style.height = size+'px';
		this._div.style.width = size+'px';
		document.body.appendChild(this._div);
	};
	
	drop() {
		document.body.removeChild(this._div);
	}
	
	get scale() {return this._scale};
	set scale(val) {
		this._scale = val;
		if (val) {this._div.style.transform = 'scale('+GlassButton.ScaleValue()+')'} 
		else {this._div.style.transform = 'scale(1)'}
	};
	
	get OnClickFunction() {return this._OnClickFunction};
	set OnClickFunction(Func) {this._OnClickFunction = Func};
	
	SetImage(Img) {this._img.src = Img};
	
	get X() {return parseInt(this._div.style.left,10)};
	set X(val) {this._div.style.left = val+'px'};
	
	get Y() {return parseInt(this._div.style.top,10)};
	set Y(val) {this._div.style.top = val+'px'};

	get Size() {return parseInt(this._div.style.height,10)};
	set Size(val) {this._div.style.height = val+'px'; this._div.style.width = val+'px';};	
};