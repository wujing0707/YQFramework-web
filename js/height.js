function resize(){
	var width = 1000;
	var width1 = 1000;
	var height = 800;
	if ( isIE() && (navigator.userAgent.indexOf('Opera') < 0)) {
		width = document.documentElement.clientWidth - 160;//160����+17����
		width1 = document.documentElement.clientWidth - 160;//160����
		height = document.documentElement.clientHeight - 116;//90top��+26foot��
	} else if (navigator.userAgent.indexOf('Firefox') >= 0) {
		width = window.innerWidth - 160;
		width1 = window.innerWidth - 180;
		height = window.innerHeight - 116;
	} else if ((navigator.userAgent.indexOf('Opera') >= 0) || (navigator.userAgent.indexOf('Chrome') >= 0)) {
			width = window.innerWidth - 160;
			width1 = window.innerWidth - 180;
			height = window.innerHeight - 116;
		}	
	//alert(window.innerHeight+"--------"+height);
	document.getElementById('leftmenu').style.height = height+"px";
	document.getElementById('contain').style.height = height+"px";
	
	document.getElementById('iframeCon').style.width = width+"px";
	document.getElementById('contain').style.width = width1+"px";
	window.onresize = resize;
}
function isIE() { //ie?  
    if (window.ActiveXObject || "ActiveXObject" in window)  
        return true;  
    else  
        return false;  
}


window.setInterval("resize()", 200);