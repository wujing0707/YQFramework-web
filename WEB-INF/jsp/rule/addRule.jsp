<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%    
	String path = request.getContextPath();    
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";    
	pageContext.setAttribute("basePath",basePath);    
%> 
<html>
<head>
    <meta charset="UTF-8">
    <title>规则新增</title>
   <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/themes/bootstrap/easyui.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/themes/icon-suit-a.css">
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/commonUtils.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/locale/easyui-lang-zh_CN.js"></script>
    <script type="text/javascript">
    $(function(){
    	//var status =  ${empty status ? true : status};
    	$("#status").combobox({
    		width: 130,
    	    editable: false,
    	    panelHeight: "auto",
    	    data:[{value:'1',text:'启用'},{value:'0',text:'禁用'}],
    	    valueField: "value",
    	    textField: "text",
    	    onLoadSuccess: function (data) {
               	if (status){
               		 $('#status').combobox('select',data[0].value);
               	}else{
               	 	$('#status').combobox('select',data[1].value);
               	}
            }
     	});
    });
    
   //添加
   function submitForm() {	
	   var name=$('#name').val();
       var formula=$("#formula").val();
       var miaoshu=$("#formulaDesc").val();

       var regu="[\u4e00-\u9fa5]";
       var regrule=/^[^]+\S+[$]+$/;
   		var re = new RegExp(regu);
   		if(re.test(formula)){
   			$.messager.alert('提示',"规则公式不能输入中文",'info');
   		return false;
   	}
   	   		if(!regrule.test(formula)){
   			$.messager.alert('提示',"规则公式不正确",'info');
   		return false;
   	}
   		if(!checkChar(formula)){
   			$.messager.alert('提示','规则公式包含特殊字符!不能输入"号','info');
   			return;
   		}
   		if(!checkChar(miaoshu)){
   			$.messager.alert('提示','规则描述包含特殊字符!不能输入"号','info');
   			return;
   		}
		if(name != '' && !checkInput(name)){	//验证输入框
			$.messager.alert('提示',"规则名称只能输入中文、字母、数字、下划线、或者四个的组合",'info');
			return;
		}

   //非空验证
   if  ($("#name").val() == "") {
		$.messager.alert('提示',"规则名称不能为空！");
		return;
	} else if  ($("#formula").val() == "") {
		$.messager.alert('提示',"规则公式不能为空！");
		return;
	} else if  ($("#formulaDesc").val() == "") {
		$.messager.alert('提示',"规则描述不能为空！");
		return;
	} 
	var act =  $("#id").val().length==0 ? "a_save.action" : "a_update.action";
	var statuss = $('#status').combobox('getValue');
	if ($("#ruleName1").val() != "" && statuss == '0' ) {
		$.messager.alert('提示',"该规则已被使用，不能禁用！");
		return;
	}
	$("#submitBtn").linkbutton("disable");
	$.post("${pageContext.request.contextPath}/rule/" + act, 
		{ id:$("#id").val(),name: $("#name").val(), formula: $("#formula").val(), enabled : statuss ,
		formulaDesc: $("#formulaDesc").val()},
		function(data) {
			if (data.result == true) {
				 $.messager.alert("操作提示", "规则新增成功！","info",function(){
				 	$('#dg').datagrid('reload');
		        	$('#dlg').dialog('close');
				 });
			
			} else {
				$.messager.alert('提示',"规则保存失败,规则名称已经存在！");
			}
			$("#submitBtn").linkbutton("enable");
		}, "json");
}
   function gotoPage(path) {
		window.location.href = "${pageContext.request.contextPath}"  + path ;
	}
    </script>
</head>
<body>
    <div style="margin:20px 0;"></div>
    <div class="easyui-panel" title="规则表单" style="width:400px">
    <input type="hidden" id="id" name="rule.id" value="${id}" />
    <input type="hidden" id="status1"  value="${status}" />
    <input type="hidden" id="ruleName1"  value="${ruleName}" />
        <div style="padding:10px 60px 20px 60px">
            <table cellpadding="5">
                <tr>
                    <td>规则名称:</td>
                    <td><input class="easyui-validatebox" type="text" name="rule.name" id="name" value="${name}" data-options="required:true,validType:'length[0,50]'"></input></td>
                </tr>
                <tr>
                    <td>规则公式:</td>
                    <td><input class="easyui-validatebox" type="text" name="rule.formula"  id="formula" value="${formula}" data-options="required:true,validType:'length[0,200]'"></input></td>
                </tr>
                <tr>
                    <td>规则描述:</td>
                    <td><input class="easyui-validatebox" type="text" name="rule.formulaDesc" id="formulaDesc"value="${formulaDesc}" data-options="required:true,validType:'length[0,250]'"></input></td>
                </tr>
                
                <tr>
                    <td>状态:</td>
                    <td><select id="status"></select>
                    </td>
                </tr>
            </table>
        <div style="text-align:center;padding:5px">
            <a href="javascript:void(0)" class="easyui-linkbutton" onclick="submitForm()">确定</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" onclick="clearForm()">返回</a>
        </div>
        </div>
    </div>
    <script>
        function clearForm(){
        	gotoPage('/rule/toRule.action');
        }
    </script>
</body>
</html>