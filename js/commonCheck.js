$.extend($.fn.validatebox.defaults.rules,{
	englishCheckSub:{
		validator:function(value){
		return /^[a-zA-Z_]+$/.test(value);
		},
		message:"只能包括英文字母和下划线"
	}
});