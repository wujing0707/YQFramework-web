<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	pageContext.setAttribute("basePath", basePath);
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>用户管理</title>
	<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css" />
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.4/themes/bootstrap/easyui.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/themes/icon-suit-a.css">
    
     <script type="text/javascript" src="<%=basePath%>js/commonUtils.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.4/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.4/locale/easyui-lang-zh_CN.js"></script> 
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-extend.js"></script>
     <script type="text/javascript" src="<%=basePath%>js/base.js"></script>
    	<script type="text/javascript">
	$.extend($.fn.datagrid.methods, {
		fixRownumber : function (jq) {
			return jq.each(function () {
				var panel = $(this).datagrid("getPanel");
				//获取最后一行的number容器,并拷贝一份
				var clone = $(".datagrid-cell-rownumber", panel).last().clone();
				//由于在某些浏览器里面,是不支持获取隐藏元素的宽度,所以取巧一下
				clone.css({
					"position" : "absolute",
					left : -1000
				}).appendTo("body");
				var width = clone.width("auto").width();
				//默认宽度是25,所以只有大于25的时候才进行fix
				if (width > 25) {
					//多加5个像素,保持一点边距
					$(".datagrid-header-rownumber,.datagrid-cell-rownumber", panel).width(width + 5);
					//修改了宽度之后,需要对容器进行重新计算,所以调用resize
					$(this).datagrid("resize");
					//一些清理工作
					clone.remove();
					clone = null;
				} else {
					//还原成默认状态
					$(".datagrid-header-rownumber,.datagrid-cell-rownumber", panel).removeAttr("style");
				}
			});
		}
	});

	
	$(function() {
	
	$("#userGrid").datagrid({
		height:400,
		striped: true,
		rownumbers: true,
		checkOnSelect:false,
		pagination: true,
		toolbar: '#tb',
		iconCls:'icon-user',
		singleSelect:true ,
        url:"${pageContext.request.contextPath}/system/user/list.action", 
        loadMsg: "载入中...请等待.",
        onLoadSuccess : function () {
			 $(this).datagrid("fixRownumber");
			 $(this).datagrid("resize");
				    },
        columns:[[
            {field:"username",title:"用户名",width:'15%',align:'left',
										formatter : function(value) {
											return "<span title='"+value+"'>"+value+"</span>";
										}},
            {field:"realName",title:"真实姓名",width:'15%',align:'left'},
            {field:"departmentName",title:"部门",width:'10%',align:'left'},
            {field:"gender",title:"性别",width:'5%',align:'left',formatter:genderFormat},
            {field:"enabled",title:"状态",width:'5%',align:'left',formatter:enableFormat},
         	{field:"createBy",title:"创建者",width:'10%',align:'left'},
         	{field:"createDate",title:"创建时间",width:'15%',align:'left'},
         	{field:"updateBy",title:"最后更新者",width:'10%',align:'left'},
         	{field:"updateDate",title:"最后更新时间",width:'15%',align:'left'}
        ]]
      
    });
	
    var url="${pageContext.request.contextPath}/system/user/getSex.action";
			$.ajax({
                url: url,
                dataType: 'json',
                success:function(json){  
                $("#gender").combobox({
					data : json.rows,
					valueField:'value',
					textField:'text'
				}); 
				}
            });

		 var deptUrl="${pageContext.request.contextPath}/system/user/getDept.action";
			$.ajax({
                url: deptUrl,
                dataType: 'json',
                success:function(json){  
                $("#departmentId").combobox({
					data : json,
					valueField:'value',
					textField:'text'
				}); 
				}
            });     
            
            $("#enabled").combobox({
			editable : false,
			panelHeight : "auto",
			data : [ {
				value : 'true',
				text : '启用'
			}, {
				value : 'false',
				text : '禁用'
			} ],
			valueField : "value",
			textField : "text"
		});
});
	$("#editRoleGrid").datagrid({    
	    onClickRow: function (index, row) { 
	    	
	    }
	    });
	
		function onAddUser(){
			document.getElementById("winAdd").style.display = "block";
			$('#addUserForm').form('clear');
			//$('#enabled').prop("checked", true);
			//$('#winAdd').window('open');
			
			$('#winAdd').window({
            title:'新增用户',
            width: ($(window).width()) * 0.4,
            height: ($(window).height()) * 0.8,
            top:($(window).height() - 400) * 0.5,   
            left:($(window).width() - 380) * 0.5, 
            shadow: true,
            modal:true,
            iconCls:'icon-add',
      		closed:true,
      		minimizable:false,
      		maximizable:false,
      		collapsible:false
         });
			
			$('#winAdd').dialog('open').dialog('setTitle','新增用户');
			$("#enabled").combobox("setValue",'true');
			$("#gender").combobox("setValue","0");
		}
		
		function checkInput(num){
			var regu="^([\u4E00-\u9FA5]|\[0-9,a-z,A-Z,\\_])*$";
			var re = new RegExp(regu);
			if(!re.test(num)){
				return false;
			}
			return true;
		}
		
		function checkNum(num){
			var reg = "^(0[0-9]{2,3}\-)?([2-9][0-9]{6,7})+(\-[0-9]{1,4})?$";
			var reTl = new RegExp(reg);
			var regMobile = /^(13[0-9]|14[0-9]|15[0-9]|17[0-9]|18[0-9])\d{8}$/;
			var reMo = new RegExp(regMobile);
			if(!reTl.test(num) && !reMo.test(num)){
				$.messager.alert('错误','请输入正确的电话号码！例如：区号-座机号码或者手机号码！','info');
				return false;
			}
			return true;
		}
		
		function addUser(){
			$('#usernameAdd,#password,#addphone').validatebox({
    			required: true
    		})
		
			var idcard = $('#addidCard').val();
			var phone=$('#addphone').val();
			var addRealName=$('#addRealName').val();
			var username=$('#usernameAdd').val();
			
			if(username != '' && !checkInput(username)){	//验证输入框
				$.messager.alert('提示',"用户名只能输入中文、字母、数字、下划线、或者四个的组合",'info');
				return;
			}
			if(addRealName != '' && !checkInput(addRealName)){	//验证输入框
				$.messager.alert('提示',"真实姓名只能输入中文、字母、数字、下划线、或者四个的组合",'info');
				return;
			} 
			if(idcard != '' && !checkIdcard(idcard)){	//验证身份证
				return;
			}
			if(phone != '' && !checkNum(phone)){	//验证电话号码证
				return;
			}
			
        	$('#addUserForm').form('submit', {
        	    success: function(data){
        	        var data = eval('(' + data + ')');  // change the JSON string to javascript object
        	        if (!data.result){
        	        	if(data.message == "1"){
        	        		$.messager.alert('失败','部门不存在!','error');
        	        	}else if(data.message == "2"){
        	        		$.messager.alert('失败','用户名在系统中已经存在!','error');
        	        	}else{}
        	        } else {
        	        	$.messager.alert('成功','用户新增成功!','info');
        	        	$('#userGrid').datagrid('reload');
        	        }
        	        $('#winAdd').dialog('close');
        	    }
        	});
        }
	///

		function onEditUser(){
		var node = $('#userGrid').datagrid('getSelected');
		 var deptUrl="${pageContext.request.contextPath}/system/user/getDept.action";
				$.ajax({
	                url: deptUrl,
	                dataType: 'json',
	                success:function(json){  
	                $("#editDeptId").combobox({
						data : json,
						valueField:'value',
						textField:'text',
					    onLoadSuccess: function (data) {
			            	$('#editDeptId').combobox("setValue", node.departmentId);
				        }
					}); 
					}
	            });  

			
			if(node != null){
               	$('#userId').val(node.id);
               	$('#username').val(node.username);
               	$('#editUsername').val(node.username);
               	$('#editRealName').val(node.realName);
               	$('#editIdCard').val(node.idCard);
               	$('#editAddress').val(node.address);
               	$('#editEmail').val(node.email);
               	$('#editPhoneNumber').val(node.phoneNumber);
            	$('#editzwtid').textbox('setValue',node.zwtid);
               	$('#editGender').combobox({
	               	required:true,
               		editable: false,
					valueField:'id',
				    textField:'text',
				    data: [{
						id: '1',
						text: '男'
					},{
						id: '0',
						text: '女'
					}]
				});
               	$.parser.parse('#winEdit');  
               	
               	$('#winEdit').window({
            	title:'编辑用户',
            	width: 430,
           	 	height: 380,
            	top:($(window).height() - 400) * 0.5,   
            	left:($(window).width() - 380) * 0.5, 
            	shadow: true,
            	modal:true,
            	iconCls:'icon-add',
      			closed:true,
      			minimizable:false,
      			maximizable:false,
      			collapsible:false
         	});
				$('#winEdit').window('open');
				if (node.gender){
               		$('#editGender').combobox("setValue", "1");
               	}else{
               		$('#editGender').combobox("setValue", "0");
               	}
			}else{
				$.messager.alert('选择','请先选择要编辑的用户!','warning');
			}
		}
		
		function editUser(){
			$('#editPhoneNumber,#editRealName').validatebox({
    			required: true
    		})
			
			var idcard = $('#editIdCard').val();
			var phone=$('#editPhoneNumber').val();
			var editRealName=$('#editRealName').val();
			//var editUsername=$('#editUsername').val();
			
// 			if(editUsername != '' && !checkInput(editUsername)){	//验证输入框
// 				$.messager.alert('提示',"用户名只能输入中文、字母、数字、下划线、或者四个的组合",'info');
// 				return;
// 			}
			if(editRealName != '' && !checkInput(editRealName)){	//验证输入框
				$.messager.alert('提示',"真实姓名只能输入中文、字母、数字、下划线、或者四个的组合",'info');
				return;
			} 
			if(idcard != '' && !checkIdcard(idcard)){	//验证身份证
				return;
			}
			if(phone != '' && !checkNum(phone)){	//验证电话号码证
				return;
			}
        	$('#editUserForm').form('submit', {
        	    success: function(data){
        	        var data = eval('(' + data + ')');  // change the JSON string to javascript object
        	        if (!data.result){
        	        	$.messager.alert('失败','编辑用户信息失败!','error');
        	        } else {
        	        	$.messager.alert('成功','编辑用户信息成功!','info');
        	        	$('#userGrid').datagrid('reload');
        	        }
        	        $('#winEdit').window('close');
        	    }
        	});
        }
		
		function resetPassword(){
			var node = $('#userGrid').datagrid('getSelected');
			if(node != null){
				$.messager.prompt('重置密码', '请输入新密码', function(r){
	                if (r){
		              
	                	if(r.length>8||r.length<6){
	                		$.messager.alert('失败','长度为6-8位!','error');
	                		return false;
	                	}
	                	$.post("resetPassword.action?id=" + node.id + "&password=" + encodeURIComponent(r), {}, function(data){
	                		var data = eval('(' + data + ')');  // change the JSON string to javascript object
	            	        if (!data.result){
	            	        	$.messager.alert('失败','重置密码失败!','error');
	            	        }else{
	            	        	$.messager.alert('成功','密码已经被重置!','info');
	            	        	$('#userGrid').datagrid('reload');
	            	        }
	                	});
	                }
	            });
			}else{
				$.messager.alert('选择','请先选择要重置密码的用户!','warning');
			}
		}
		
		
		function userEnable(){
			var node = $('#userGrid').datagrid('getSelected');
			if(node != null){
               	$.post("enable.action?id=" + node.id, {}, function(data){
               		if (!data){
        	        	$.messager.alert('失败','启用/禁用用户失败!','error');
        	        } else {
        	        	$.messager.alert('成功','启用/禁用用户成功!','info');
        	        	$('#userGrid').datagrid('reload');
        	        }
               	});
			}else{
				$.messager.alert('选择','请先选择要启用/禁用的用户!','warning');
			}
		}
		
       function deleteConfirm(){
        	var node = $('#userGrid').datagrid('getSelected');
        	if(node != null){
        	  $.messager.confirm("提示", "确认删除用户吗？", function(r) {
        		if (r) {
        		  $.post(
        			"${pageContext.request.contextPath}/system/user/delete.action",  {"id" : node.id},
					function(data) {
						if (data.result == true) {
							$.messager.alert('提示', "用户删除成功！", function(r){});
							$('#userGrid').datagrid('reload');
						} else if (data.result == false)  {
							$.messager.alert('提示',"用户删除失败！");
						} 
					}, "json");
			   }
		      });
	   }else{
	   
	   		$.messager.alert('选择','请先选择要删除的用户!','warning');
	   }
	/*
			if(node != null){
				$.messager.confirm('确定删除', '确认要删除此用户吗?', function(r){
	                if (r){
	                	$.post("delete.action", {"id" : node.id}, function(data){
	                		var data = eval('(' + data + ')');  // change the JSON string to javascript object
	            	        if (!data.result){
	            	        	$.messager.alert('失败','删除用户失败!','error');
	            	        } else {
	            	        	$.messager.alert('成功','删除用户成功!','info');
	            	        	$('#userGrid').datagrid('reload');
	            	        }
	                	});
	                }
	            });
			}else{
				$.messager.alert('选择','请先选择要删除的用户!','warning');
			}
			*/
		}
		
        
        function onGrant(){
        	$('#editRoleGrid').datagrid('clearSelections');
        	var node = $('#userGrid').datagrid('getSelected');
			if(node != null){
				$('#winGrant').window('setTitle', '用户 ' + node.username + ' 授权');
               	$('#grantUserId').val(node.id);
               	//$('#editRoleGrid').datagrid("reload");
               	//$('#editRoleGrid').datagrid("unselectAll");
               /* 	$('#editPrivilegeTree').tree("options").url = "../privilege/userPrivilege.action?id=" + node.id;
               	$('#editPrivilegeTree').tree("reload"); */
               	$.post("roleIdsAndPrivilegeIds.action?id=" + node.id, {}, function(data){
               		if(data!=null && data.length>0){
            			var data = eval('(' + data + ')');
            			for(var x=0;x<data.roleIds.length;x++){
            				$('#editRoleGrid').datagrid("selectRecord", data.roleIds[x]);
            			}
               		}
            	});
				$('#winGrant').window('open');
			}else{
				$.messager.alert('选择','请先选择要授权的用户!','warning');
			}
        }
        
        function grantUser(){
        	var selectedPrivileges = $('#editPrivilegeTree').tree("getChecked");
        	var param = "";
        	if(selectedPrivileges!=null){
        		for(var i=0;i<selectedPrivileges.length;i++){
        			if(!selectedPrivileges[i].attributes){
        				
        			}else{
	        			param = param + selectedPrivileges[i].id;
	        			if(i<selectedPrivileges.length-1){
	        				param = param + ";";
	       				}
        			}
        		}
        	}
        	$('#privilegeIds').val(param);
        	
        	var selectedRole = $('#editRoleGrid').datagrid("getSelections");
        	param = "";
        	if(selectedRole!=null){
        		for(var i=0;i<selectedRole.length;i++){
        			param = param + selectedRole[i].id;
        			if(i<selectedRole.length-1)
        				param = param + ";";
        		}
        	}
        	$('#roleIds').val(param);
        	
        	$('#grantUserForm').form('submit', {
        	    success: function(data){
        	        var data = eval('(' + data + ')');  // change the JSON string to javascript object
        	        if (!data.result){
        	        	$.messager.alert('失败','用户授权失败!','error');
        	        }else{
        	        	$.messager.alert('成功','授权成功!','info');
        	        	$('#userGrid').datagrid('reload');
	        	        $('#winGrant').dialog('close');
        	        }
        	    }
        	});
        }
        
		function enableFormat(value, row, index){
			if (value){
				return "启用";
			} else {
				return "禁用";
			}
		}
		
		function genderFormat(value, row, index){
			if (value){
				return "男";
			} else {
				return "女";
			}
		}
		var dvalueUsername = "用户名";
// 		var dvalueStartDate = "开始时间";
// 		var dvalueEndName = "结束时间";
		jQuery(function(){
			//$("#conditionName").autoTip({dvalue:dvalueUsername});
// 			$("#conditionStartDate").next().find("input").first().autoTip({dvalue:dvalueStartDate,tip:'0'});
// 			$("#conditionEndDate").next().find("input").first().autoTip({dvalue:dvalueEndName,tip:'0'});
		});
		
		function setFirstPage(ids){
    var opts = $(ids).datagrid('options');
var pager = $(ids).datagrid('getPager');
opts.pageNumber = 1;
    opts.pageSize = opts.pageSize;
pager.pagination('refresh',{
	    	pageNumber:1,
	    	pageSize:opts.pageSize
	});
}
		
        function conditionSearch() {
        setFirstPage("#userGrid");
        	var name = $.trim($('#conditionName').val());
        	var deptCode = $.trim($('#dept').combobox('getValue'));
        	var realname = $.trim($('#userName').val());
        	var zhuangtai = $.trim($('#zhuangtai').combobox('getValue'));
        	
//         	var startDate = jQuery("#conditionStartDate").datebox('getValue');
//         	var endDate = jQuery("#conditionEndDate").datebox('getValue');
  //      	name = name == dvalueUsername ? '' : name;
//         	startDate = startDate==dvalueStartDate?'':startDate;
//         	endDate = endDate==dvalueEndName?'':endDate;
        	var queryParams = $('#userGrid').datagrid('options').queryParams;
//         	var dateReg = /^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$/;
//         	if(startDate!='' && !dateReg.test(startDate)){
//         		jQuery.messager.alert('失败','日期格式有误!','error');
//         		return;
//         	}
//         	if(endDate!='' && !dateReg.test(endDate)){
//         		jQuery.messager.alert('失败','日期格式有误!','error');
//         		return;
//         	}
        	queryParams["username"] = name;
        	queryParams["zhuangtai"] = zhuangtai;
        	queryParams["realname"] = realname;
         	queryParams["deptCode"] = deptCode;
         	queryParams["role"]= $.trim($('#role').combobox('getValue'));
//         	queryParams["endDate"] = endDate;
            $('#userGrid').datagrid('options').queryParams = queryParams;
            $('#userGrid').datagrid('options').pageNumber = 1;
            $('#userGrid').datagrid('getPager').pagination({pageNumber: 1});
            $('#userGrid').datagrid('reload');
        }
        
    	function conditionReset(){
    		$("#dept").combobox("setValue","");
    		$("#role").combobox("setValue","");
    		$("#zhuangtai").combobox("setValue","");
    		$('#conditionName').val('');
    		$('#userName').val('');
    	}
    	
    	function cancel(){
    		$('#winAdd').dialog('close');
    		$('#winEdit').dialog('close');
    		
    	}
    	
    	
    	function getZwtId(){
    		zwtUserName=$("#zwtUserName").val();
    		$.ajax({
    		   async:false,
    		   dataType:"json",
     		   url: "http://172.25.127.12/data/api/HRModel/User?$filter=AccountName eq '"+zwtUserName+"'&$select=Id",
     		   type: "GET",
     		   success: function (json) {//客户端jquery预先定义好的callback函数,成功获取跨域服务器上的json数据后,会动态执行这个callback函数
     		    	if(json.value.length==0){
     		    		alert("没有对应的政务通用户");
     		    	}else{
     		    			$("#zwtid").textbox('setValue',json.value[0].Id)
     		    		}
     		   }
     		});	 
    		
    	}
    	
    	function getEditZwtId(){
    	var	editzwtUserName=$("#editzwtUserName").val();
    		$.ajax({
    		   async:false,
    		   dataType:"json",
     		   url: "http://172.25.127.12/data/api/HRModel/User?$filter=AccountName eq '"+editzwtUserName+"'&$select=Id",
     		   type: "GET",
     		   success: function (json) {//客户端jquery预先定义好的callback函数,成功获取跨域服务器上的json数据后,会动态执行这个callback函数
     		    	if(json.value.length==0){
     		    		alert("没有对应的政务通用户");
     		    	}else{
     		    			$("#editzwtid").textbox('setValue',json.value[0].Id)
     		    		}
     		   }
     		});	 
    	}
    	
//Easyui-Window弹出居中    	
var easyuiPanelOnOpen = function (left, top) {    
	var iframeWidth = $(this).parent().parent().width();       
	var iframeHeight = $(this).parent().parent().height();    
	var windowWidth = $(this).parent().width();    
	var windowHeight = $(this).parent().height();    
	var setWidth = (iframeWidth - windowWidth) / 2;    
	var setHeight = (iframeHeight - windowHeight) / 2;    
	$(this).parent().css({/* 修正面板位置 */        
		left: setWidth,        
		top: setHeight    
	});
	if (iframeHeight < windowHeight)    {        
		$(this).parent().css({/* 修正面板位置 */            
			left: setWidth,            
			top: 0        
		});    
	}    
	$(".window-shadow").hide();
	};
$.fn.window.defaults.onOpen = easyuiPanelOnOpen;



    </script>
</head>
<body>

	<div>
		<div class="place">
			<span>位置：</span>
			<ul class="placeul">
				<li><%=request.getAttribute("path") %></li>
				
			</ul>
		</div>
		<table id="userGrid" width="100%">
		</table>
	</div>
	<div id="tb" style="padding:5px;height:55px;">
		<div style="margin-bottom:5px">
			<a  href="#" class="easyui-linkbutton"
				onclick="onAddUser();" iconCls='icon-add' plain="true">新增</a>
			<a  href="#" class="easyui-linkbutton"
				onclick="deleteConfirm();"
				iconCls='icon-remove' plain="true">删除</a>
			<a  href="#" class="easyui-linkbutton"
				onclick="userEnable();"
				iconCls='icon-disable' plain="true">启用/禁用</a>
			<a  href="#" class="easyui-linkbutton"
				onclick="resetPassword();"
				iconCls='icon-undo' plain="true">重置密码</a>
			<a  href="#" class="easyui-linkbutton"
				onclick="onEditUser();"
				iconCls='icon-edit' plain="true">编辑</a>
			<a  href="#" class="easyui-linkbutton"
				onclick="onGrant();" iconCls='icon-save' plain="true">授权</a>

		</div>
						<div style="float: left;">
			&nbsp; 用户名： <input id="conditionName" class="easyui-input"
				style="width:100px"> 姓名： <input id="userName"
				class="easyui-input" style="width:100px"/> 
				部门：<input style="width:150px"
					class="easyui-combobox" id="dept" editable="false"
					url='${pageContext.request.contextPath}/system/user/getDept.action'
					data-options="valueField:'value', textField:'text',multiple:false">
				</input>
				角色：<input style="width:150px"
					class="easyui-combobox" id="role" editable="false"
					url='${pageContext.request.contextPath}/system/role/getRoleListByDept.action'
					data-options="valueField:'id', textField:'rolename',multiple:false">
				</input>
				状态：<input
				id="zhuangtai" style="width:100px" class="easyui-combobox"
				panelHeight="auto"
				data-options="editable:false,valueField:'value',textField:'text',data:[{'value':'true','text':'启用'},{'value':'false','text':'禁用'}]" />
			<!--             <input id="conditionStartDate" type="hidden" class="easyui-datetimebox" style="width:140px"> -->
			<!--            	<input id="conditionEndDate" type="hidden" class="easyui-datetimebox" style="width:140px"> -->
			<a href="#" class="easyui-linkbutton" iconCls="icon-search"
				onclick="conditionSearch();">查询</a>&nbsp;&nbsp; <a href="#"
				class="easyui-linkbutton" iconCls="icon-refresh"
				onclick="conditionReset();">重置</a>
				</div>
	</div>




	<style type="text/css">
#addUserForm {
	margin: 0;
	padding: 10px 60px;
}
#editUserForm div{
	margin: 0;
	padding: 8px 40px;
}

.ftitle {
	font-size: 14px;
	font-weight: bold;
	padding: 5px 0;
	margin-bottom: 10px;
	border-bottom: 1px solid #ccc;
}

.fitem {
	margin-bottom: 5px;
}

.fitem label {
	display: inline-block;
	width: 80px;
}

.fitem input {
	width: 160px;
}

#winAdd{
	margin-left:auto; margin-right:auto; width:168px;
}
#winEdit{
	margin-left:auto; margin-right:auto; width:168px;
}
#winGrant{
	margin-left:auto; margin-right:auto; width:168px;
}

</style>

	<div id="winAdd" class="easyui-dialog" title="新增用户"
		style="display:none;width:400px;height:380px;padding:10px 20px;left: ($(window).width() - 400) * 0.5);top: ($(window).height() - 380) * 0.5)" closed="true">
		<form id="addUserForm" method="post" action="add.action">
			<div class="fitem">
				<label>用户名：</label> <input name="username"
					class="easyui-validatebox" id="usernameAdd"
					data-options="required:true,validType:'length[0,50]'"
					maxlength="50">
			</div>
			<div class="fitem">
				<label>密码：</label> <input name="password" class="easyui-validatebox"
					id="password" data-options="required:true,validType:'length[6,8]'">
			</div>
		
		<div class="fitem">
				<label>政务通用户：</label> <input name="zwtUserName"
					class="easyui-textbox" id="zwtUserName"
					/>
					<a href="#"  onclick="getZwtId()" style="text-decoration:underline;color:blue">点击获取ID</a>
			</div>
		<div class="fitem">
				<label>政务通ID：</label> <input name="zwtid"
					class="easyui-textbox" id="zwtid" 
					/>
			</div>
			<div class="fitem">
				<label>状态:</label> <select id="enabled" name="enabled" style="width:160px"
					panelHeight="auto"></select>
			</div>
			<div class="fitem">
				<label>真实姓名：</label> <input name="realName"
					class="easyui-validatebox" id="addRealName"
					data-options="required:true,validType:'length[0,10]'" maxlength="10">
			</div>
			<div class="fitem">
				<label>部门:</label> <select id="departmentId" name="departmentId"
					data-options="required:true,editable:false" style="width:160px"></select>
			</div>
			<div class="fitem">
				<label>性别：</label> <input name="gender" id="gender"
					class="easyui-textbox" data-options="required:true, editable:false"
					panelHeight="auto" style="width:160px">
			</div>
			<div class="fitem">
				<label>身份证号：</label> <input class="easyui-validatebox"
					id="addidCard" name="idCard"
					data-options="validType:'length[0,18]'" maxlength="18"></input>
			</div>
			<div class="fitem">
				<label>地址：</label> <input class="easyui-validatebox" name="address"
					data-options="validType:'length[0,120]'"></input>
			</div>
			<div class="fitem">
				<label>E-Mail：</label> <input class="easyui-validatebox"
					name="email" data-options="validType:['email', 'length[0,50]']"></input>
			</div>
			<div class="fitem">
				<label>联系电话：</label> <input class="easyui-validatebox" id="addphone"
					name="phoneNumber"  data-options="required:true, validType:'length[0,13]'"></input>
			</div>
		</form>
		<div id="dlg-buttons" style="text-align:center;padding:5px">
			<a href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-ok" onclick="addUser()">确定</a> 
			<a
				href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-cancel" onclick="cancel()"
				style="width:66px">取消</a>
		</div>
		
	</div>


	<div id="winEdit" class="easyui-window" title="编辑用户"
		data-options="closed:true, border:false">
		
		<form id="editUserForm" method="post" action="edit.action">
			<input type="hidden" name="userId" id="userId" value=""/>
			<input type="hidden" name="username" id="username"/>
			<div class="fitem">
				<label>用户名：</label> <input name="editusername"
					class="easyui-validatebox" id="editUsername"
					maxlength="50" disabled="disabled">
			</div>
			<div class="fitem">
				<label>政务通用户：</label> <input name="editzwtUserName"
					class="easyui-textbox" id="editzwtUserName"
					/>
					<a href="#"  onclick="getEditZwtId()" style="text-decoration:underline;color:blue">点击获取ID</a>
			</div>
			<div class="fitem">
				<label>政务通ID：</label> <input name="zwtid"
					class="easyui-textbox" id="editzwtid" 
					/>
			</div>
			
			<div class="fitem">
				<label>真实姓名：</label> <input name="realName"
					class="easyui-validatebox" id="editRealName"
					data-options="validType:'length[0,10]'" maxlength="10">
			</div>
			<div class="fitem">
				<label>部门:</label> <select id="editDeptId" name="departmentId"
					data-options="required:true,editable:false" style="width:160px"></select>
			</div>
			<div class="fitem">
				<label>性别：</label> <select name="gender" 
					id="editGender" 
					style="width:160px">
					<option value="1" selected>男</option>
					<option value="0">女</option>
				</select>
			</div>
			<div class="fitem">
				<label>身份证号：</label> <input class="easyui-validatebox"
					id="editIdCard" name="idCard"
					data-options="validType:'length[0,18]'" maxlength="18"></input>
			</div>
			<div class="fitem">
				<label>地址：</label> <input class="easyui-validatebox"
					id="editAddress" name="address"
					data-options="validType:'length[0,120]'"></input>
			</div>
			<div class="fitem">
				<label>E-Mail：</label> <input class="easyui-validatebox"
					id="editEmail" name="email"
					data-options="validType:['email', 'length[0,50]']"></input>
			</div>
			<div class="fitem">
				<label>联系电话：</label> <input class="easyui-validatebox"
					id="editPhoneNumber" name="phoneNumber"
					data-options="required:true, validType:'length[0,13]'"></input>
			</div>
		</form>
		<div style="text-align:center;padding:5px">
			<a href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-ok" onclick="editUser()">确定</a> <a
				href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-cancel" onclick="cancel()">取消</a>
		</div>
	</div>

	<div id="winGrant" class="easyui-window" title="用户授权"
		data-options="iconCls:'icon-add', closed:true, border:false,tools:'#tt'"
		style="width:655px;height:340px;padding:10px;">
		
		<form id="grantUserForm" method="post" action="grant.action">
			<input type="hidden" name="userId" id="grantUserId" value="">
			<input type="hidden" name="privilegeIds" id="privilegeIds" value="">
			<input type="hidden" name="roleIds" id="roleIds" value="">
			<table>
				<tr>
					<td>用户角色:</td>
					<!-- <td>用户权限:</td> -->
				</tr>
				<tr>
					<td valign="top">
						<table id="editRoleGrid" class="easyui-datagrid"
							style="height:220px;width:600px;margin:10px"
							data-options="rownumbers:true, pagination:false, singleSelect:false, collapsible:false, nowrap:false,fitColumns:true, idField:'id',
					 		showHeader:true, selectOnCheck:true, checkOnSelect:true, url:'../role/alllist.action', method:'get', iconCls:'icon-user'">
							<thead>
								<tr>
									<th data-options="field:'privilegeIds', checkbox:true"></th>
									<th field="roleName" width="150">角色</th>
									<th field="description" width="120">描述</th>
								</tr>
							</thead>
						</table>
					</td>
					<td>
						<%--
				    <table id="editPrivilegeGrid" class="easyui-datagrid" style="height:220px;width:270px;margin:10px"
					 		data-options="rownumbers:true, pagination:false, singleSelect:false, collapsible:true, fitColumns:true, idField:'id',
					 		showHeader:true, selectOnCheck:true, checkOnSelect:true, url:'../privilege/list.action', method:'get', iconCls:'icon-user'">
				        <thead>
				            <tr>
				            	<th data-options="field:'privilegeIds', checkbox:true"></th>
				                <th field="privilegeName" width="80">权限</th>
				                <th field="description" width="120">描述</th>
				            </tr>
				        </thead>
				    </table>
				     --%> <!--  <table id="editPrivilegeTree" class="easyui-tree" style="height:220px;width:240px;margin:10px"
					 		data-options="rownumbers:true, idField:'id',treeField:'text',pagination:false,fitColumns : true,checkbox:true">
				    </table>  -->
					</td>
				<tr>
			</table>
		</form>
		<div id="tt">
			<a href="javascript:void(0)" class="icon-save" onclick="grantUser()"
				title="保存用户授权"></a>
		</div>
		<div style="text-align:center;padding:5px">
			<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok"
				onclick="grantUser()">确定</a> <a href="javascript:void(0)" iconCls="icon-cancel"
				class="easyui-linkbutton" onclick="$('#winGrant').dialog('close');">取消</a>
		</div>
	</div>
</body>
</html>