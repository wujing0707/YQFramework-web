//验证手机号码
function checkMobile(mobile) {
	var regMobile = /1[3-8]+\d{9}/;	//验证手机号码
	if(!regMobile.test(mobile)){
		$.messager.alert('错误','请输入有效的手机号码!','info');
		return false;
	}
	return true;
}


//验证数字
function checkNum(num){
	var reg = /^\d+$/;
	if(!reg.test(num)){
		$.messager.alert('错误','请输入数字!','info');
		return false;
	}
	return true;
}

//验证身份证号码
function checkIdcard(num){  
	var factorArr = new Array(7,9,10,5,8,4,2,1,6,3,7,9,10,5,8,4,2,1); 
	var error; 
	var varArray = new Array(); 
	var intValue; 
	var lngProduct = 0; 
	var intCheckDigit; 
	var intStrLen = num.length; 
	var idNumber = num; 
	if (intStrLen != 18) { 
		error = "输入身份证号码长度不对！长度必须为18位！"; 
		$.messager.alert('提示',error,'info');
		
		return false; 
	} 
	for(var i=0;i<intStrLen;i++) { 
		varArray[i] = idNumber.charAt(i); 
		if ((varArray[i] < '0' || varArray[i] > '9') && (i != 17)) { 
			error = "身份证号码中含有不合法字符！"; 
			$.messager.alert('提示',error,'info');
			
			return false; 
		} else if (i < 17) { 
			varArray[i] = varArray[i]*factorArr[i]; 
		} 
	} 
	if (intStrLen == 18) { 
		for(i=0;i<17;i++) { 
			lngProduct = lngProduct + varArray[i]; 
		} 
		intCheckDigit = 12 - lngProduct % 11; 
		switch (intCheckDigit) { 
			case 10: 
				intCheckDigit = 'X'; 
				break; 
			case 11: 
				intCheckDigit = 0; 
				break; 
			case 12: 
				intCheckDigit = 1; 
			break; 
		} 
		if (varArray[17].toUpperCase() != intCheckDigit) { 
			
			$.messager.alert('提示','请输入真实身份证','info');
			
			return false; 
		}
	} 
	return true;
}
//验证输入只能输入中文,大小写字母,数字,或者三个的组合
function checkInput(num){
	var regu="^([\u4E00-\u9FA5]|\[0-9,a-z,A-Z,\\_])*$";
	var re = new RegExp(regu);
	if(!re.test(num)){
		return false;
	}
	return true;
}
//验证特殊字符
function checkChar(Str){
	var charArr = ["\""];
		for(var i=0;i<charArr.length;i++){
			if(Str.indexOf(charArr[i])!=-1){
				return false;
			}
	}
		return true;
}

function getHtmlInfo(s){
	s = s.replace(/&amp;/g, "&");  
    s = s.replace(/&nbsp;/g, " ");  
    s = s.replace(/&#39;/g, "'");          
    s = s.replace(/&lt;/g, "<");  
    s = s.replace(/&gt;/g, ">");  
    s = s.replace(/"<br>"/g, "\n");  
    s = s.replace(/"?D"/g, "—");  
    s = s.replace(/&quot;/g, "\"");  
    return s;  
}

