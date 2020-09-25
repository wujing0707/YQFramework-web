$.extend($.fn.linkbutton.methods, {
	enable : function(jq) {
		return jq.each(function(n, obj) {
			var state = $.data(obj, "linkbutton");
			state.options.disabled = false;
			if (state.href) {
				$(obj).attr("href", state.href);
			}
			if (state.onclick) {
				obj.onclick = state.onclick;
			}
			if (state.events) {
				for (var i = 0; i < state.events.length; i++) {
					$(obj).bind(state.events[i].type, state.events[i].handler);
				}
			}
			$(obj).removeClass("l-btn-disabled");
		});
	}
});

$.extend($.fn.linkbutton.methods, {
	disable : function(jq) {
		return jq.each(function(n, obj) {
			var state = $.data(obj, "linkbutton");
			state.options.disabled = true;
			var href = $(obj).attr("href");
			if (href) {
				state.href = href;
				$(obj).attr("href", "javascript:void(0)");
			}
			if (obj.onclick) {
				obj.onclick = obj.onclick;
				obj.onclick = null;
			}
			//事件处理
			var events = $(obj).data("events");
			if (events) {
				var clicks = events.click;//暂时只处理click事件
				state.events = state.events || [];
				$.extend(state.events, clicks);
				$(obj).unbind("click");
			}

			$(obj).addClass("l-btn-disabled");
		});
	}
});

$.extend($.fn.validatebox.defaults.rules, {
	organCode : {
		validator : function(value) {
			/*return /^(\d{8}-[a-zA-Z0-9]{1})$/.test(value);  */
			return /^([a-zA-Z0-9]{8}-[a-zA-Z0-9]{1})$/.test(value);
		},
		message : '8位数字or字母加"-"1位字母or数字组合',
		missingMessage : '该项是必填项，不能为空！'
	}
});

$.extend($.fn.validatebox.defaults.rules, {
	registerNumber : {
		validator : function(value) {
			return /^(([a-zA-Z0-9]{13})|([a-zA-Z0-9]{15}))$/.test(value);  
		},
		message : '工商号只能是13或15位数字和字母组合',
		missingMessage : '该项是必填项，不能为空！'
	}
});

$.extend($.fn.validatebox.defaults.rules, {
	taxRegistryNumber : {
		validator : function(value) {
			return /^[a-zA-Z0-9]{15}$/.test(value);  
		},
		message : '税务登记证号只能是15位数字和字母组合。',
		missingMessage : '该项是必填项，不能为空！'
	}
});
//固定电话校验
$.extend($.fn.validatebox.defaults.rules, {
	linkmanPhone : {
		validator : function(value) {
			return /^((0\d{2,3})-)?(\d{7,8})(-(\d{3,}))?$/.test(value); 
			//return /^([0-9-]+)$/.test(value);
		},
		message : '电话号码输入格式不正确,正确格式比如020-88888888或88888888',
		missingMessage : '该项是必填项，不能为空！'
	}
});
$.extend($.fn.validatebox.defaults.rules, {
	linkmanMobile : {
		validator : function(value) {
			return /^(13[0-9]|15[0|1|2|3|5|6|7|8|9]|18[0|2|1|5|6|7|8|9]|14[0-9]|17[0-9])\d{8}$/.test(value);  
		},
		message : '手机号码输入格式不正确,正确格式比如13888888888',
		missingMessage : '该项是必填项，不能为空！'
	}
});
$.extend($.fn.validatebox.defaults.rules, {
	number : {
		validator : function(value) {
			return /^[+]?[0-9]+\d*$/.test(value);
		},
		message : '请输入有效数字',
		missingMessage : '该项是必填项，不能为空！'
	}
});
