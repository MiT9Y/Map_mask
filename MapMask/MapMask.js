function MapMaskClass(img){
	this._mask = document.createElement('Canvas');
    this._mask.width = img.width;
    this._mask.height = img.height;
	this._sizeX = 1;
	this._sizeY = 1;
    var MaskCTX = this._mask.getContext('2d');
    MaskCTX.drawImage(img,0,0);
    console.log(img.width);console.log(img.height);
	this._maskdata = MaskCTX.getImageData(0, 0, img.width, img.height);
    this._currentColor = 0;
    
	this.OnMouseMove = function(obj,e) {
		var ObjSize = obj.getBoundingClientRect();
		var x = Math.round((e.clientX-ObjSize.left)/this._sizeX);
		var y = Math.round((e.clientY-ObjSize.top)/this._sizeY);
		var i=((y*this._maskdata.width)+x)*4;
        var R=this._maskdata.data[i];
        var G=this._maskdata.data[i+1];
        var B=this._maskdata.data[i+2];
		var A=this._maskdata.data[i+3];
		var color = R+(G*256)+(B*65536);
		if  (color != this._currentColor) {
			if (typeof this.OnChangeColor == 'function') this.OnChangeColor(color, this._currentColor);
			this._currentColor = color;
		}
	};
	this.OnMouseLeave = function(obj,e) {
		var ObjSize = obj.getBoundingClientRect();
		var x = Math.round(e.clientX-ObjSize.left);
		var y = Math.round(e.clientY-ObjSize.top);
		if (ObjSize.width<=x || x<=0 || ObjSize.height<=y || y<=0) {
			this._currentColor = 0;
			if (typeof this.OnLeaveMask == 'function') this.OnLeaveMask();
		}
	};
	this.ReSize = function(W,H) {
		this._sizeX = W/this._mask.width;
		this._sizeY = H/this._mask.height;
	};
}