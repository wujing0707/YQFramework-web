/**
 * +------------------------------------------------------------------------------
 * input用户名自动提示插件 参数
 * 
 * @input 入参 json对象 
 * @ dvalue input表单提示默认值 
 * @ tip 默认提示信息样式名class 
 * @ tipnone
 *        在指定的input执行click时替换的样式名class
 *+------------------------------------------------------------------------------
 * 使用方法: $("#xxx").autotip(); @ #xxx 为需要提示的input的id
 */
$.fn.autoTip = function(G) {
    var D;
    D = {
        dvalue : "用户名/电子邮箱",// 表单默认值
        tip : "tip", // 默认提示信息样式名class
        tipnone : "tipnone" // 在指定的input执行click时替换的样式名class
    };
    $.extend(D, G);
    // $(this).css("color","#d0d0d0");
    if ($.trim($(this).val()) == "") {
        $(this).val(D.dvalue).addClass(D.tip).click(function() {
            if ($(this).val() == D.dvalue) {
                $(this).val("");
                $(this).removeClass(D.tip);
                $(this).addClass(D.tipnone);
                // $(this).css("color","#000000");
            }
        }).blur(function() {
            if ($.trim($(this).val()) == "") {
                $(this).removeClass(D.tipnone);
                $(this).addClass(D.tip);
                $(this).val(D.dvalue);
                // $(this).css("color","#d0d0d0");
            }
        });
    }
    ;
}

// 设置jquery的ajax全局请求参数 ,处理ajax请求session过期的问题
$.ajaxSetup({
    cache : false,
    complete : function(XMLHttpRequest, textStatus) {
        var sessionstatus = XMLHttpRequest.getResponseHeader('ajaxSessionStatus');
        if (sessionstatus == 'ajaxTimeOut') {
            // alert(getRootPath());
            window.top.location.href = getRootPath();
        }
    }
});

// js获取项目根路径
function getRootPath() {
    // 获取当前网址，如： http://localhost:8083/uimcardprj/share/meun.jsp
    var curPath = window.document.location.href;
    // 获取主机地址之后的目录，如： uimcardprj/share/meun.jsp
    var pathName = window.document.location.pathname;
    var pos = curPath.indexOf(pathName);
    // 获取主机地址，如： http://localhost:8083
    var localhostPath = curPath.substring(0, pos);
    // 获取带"/"的项目名，如：/uimcardprj
    var projectName = pathName.substring(0, pathName.substr(1).indexOf('/') + 1);
    return (localhostPath + projectName);
}

//添加Map支持
function Map(){
    this.container = new Object();
}

Map.prototype.put = function(key, value){
this.container[key] = value;
}
Map.prototype.get = function(key){
    return this.container[key];
}
Map.prototype.keySet = function() {
    var keyset = new Array();
    var count = 0;
    for (var key in this.container) {
        // 跳过object的extend函数
        if (key == 'extend') {
            continue;
        }
        keyset[count] = key;
        count += 1;
    }
    return keyset;
}
Map.prototype.size = function() {
    var count = 0;
    for (var key in this.container) {
    // 跳过object的extend函数
        if (key == 'extend'){
            continue;
        }
        count += 1;
    }
    return count;
}
Map.prototype.remove = function(key) {
    delete this.container[key];
}
Map.prototype.toString = function(){
    var str = "";
    for (var i = 0, keys = this.keySet(), len = keys.length; i < len; i++) {
    str = str + keys[i] + "=" + this.container[keys[i]] + ";\n";
    }
    return str;
}