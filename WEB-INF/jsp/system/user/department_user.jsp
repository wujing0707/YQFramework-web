<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%    
    String path = request.getContextPath();    
    String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";    
    pageContext.setAttribute("basePath",basePath);    
%> 
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>本部门用户管理</title>
	<link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.4/themes/bootstrap/easyui.css">
    <link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.4/themes/icon.css">
    <link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.4/themes/color.css">
    <script type="text/javascript" src="<%=basePath%>js/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.4/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.4/locale/easyui-lang-zh_CN.js"></script>
</head>
<body style="height:450px">
	<div style="margin:10px 10px;"></div>
	<table id="userGrid" title="本部门用户管理" class="easyui-datagrid" 
			style="height:420px" width="100%"
	 		data-options="rownumbers:true, pagination:false, 
	 		singleSelect:true, collapsible:true, fitColumns:true, 
	 		url:'list.action', method:'post', 
	 		iconCls:'icon-user', toolbar:'#tb'">
        <thead>
            <tr>
                <th field="username" width="80">用户名</th>
                <th field="realName" width="80">真实姓名</th>
                <th field="gender" width="80" formatter="genderFormat">性别</th>
                <th field="sysDepartment" data-options="formatter:function(value){return value.departmentName;}" width="80">所属部门</th>
                <th field="enabled" formatter="enableFormat" width="120">启用</th>
                <!-- <th field="rolesCount" width="120">拥有的角色</th>
                <th field="privilegesCount" width="120">拥有的权限</th> -->
                <th field="createBy" width="80" align="right">创建者</th>
                <th field="createDate" width="80" align="right">创建时间</th>
                <th field="updateBy" width="80" align="right">最后更新者</th>
                <th field="updateDate" width="80" align="right">最后更新时间</th>
            </tr>
        </thead>
    </table>
    <div id="tb" style="padding:5px;height:auto">
        <div style="margin-bottom:5px">
            <a href="#" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="onAddUser();">新增</a>
            <a href="#" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="onEditUser();">编辑</a>
            <a href="#" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="deleteConfirm();">删除</a>
            <a href="#" class="easyui-linkbutton" iconCls="icon-disable" plain="true" onclick="userEnable();">启用/禁用</a>
            <a href="#" class="easyui-linkbutton" iconCls="icon-undo" plain="true" onclick="resetPassword();">重置密码</a>
            <a href="#" class="easyui-linkbutton" iconCls="icon-save" plain="true" onclick="onGrant();">授权</a>
        </div>
    </div>
	<script type="text/javascript">
		function onAddUser(){
			$('#addUserForm').form('clear');
			$('#enabled').prop("checked", true);
			$('#winAdd').window('open');
		}
		
		function addUser(){
        	$('#addUserForm').form('submit', {
        	    success: function(data){
        	        var data = eval('(' + data + ')');  // change the JSON string to javascript object
        	        if (!data.result){
        	        	if(data.message == "2"){
        	        		$.messager.alert('失败','你不是管理员, 不能创建用户!','error');
        	        	}else if(data.message == "1"){
        	        		$.messager.alert('失败','用户名在系统中已经存在!','error');
        	        	}else{}
        	        }
        	        $('#userGrid').datagrid('reload');
        	        $('#winAdd').dialog('close');
        	    }
        	});
        }
		
		function onEditUser(){
			var node = $('#userGrid').datagrid('getSelected');
			if(node != null){
               	$('#userId').val(node.id);
               	$('#editRealName').val(node.realName);
               	if (node.gender){
               		$('#editGender').combobox("setValue", "1");
               	}else{
               		$('#editGender').combobox("setValue", "0");
               	}
               	$('#editIdCard').val(node.idCard);
               	$('#editAddress').val(node.address);
               	$('#editEmail').val(node.email);
               	$('#editPhoneNumber').val(node.phoneNumber);
				$('#winEdit').window('open');
			}else{
				$.messager.alert('选择','请先选择要编辑的用户!','info');
			}
		}
		
		function editUser(){
        	$('#editUserForm').form('submit', {
        	    success: function(data){
        	        var data = eval('(' + data + ')');  // change the JSON string to javascript object
        	        if (!data.result){
        	        	$.messager.alert('失败','编辑用户失败!','error');
        	        }
        	        $('#userGrid').datagrid('reload');
        	        $('#winEdit').dialog('close');
        	    }
        	});
        }
		
		function resetPassword(){
			var node = $('#userGrid').datagrid('getSelected');
			if(node != null){
				$.messager.prompt('重置密码', '请输入新密码', function(r){
	                if (r){
	                	$.post("resetPassword.action?id=" + node.id + "&password=" + encodeURIComponent(r), {}, function(data){
	                		var data = eval('(' + data + ')');  // change the JSON string to javascript object
	            	        if (!data.result){
	            	        	$.messager.alert('失败','重置密码失败!','error');
	            	        }else{
	            	        	$.messager.alert('成功','密码已经被重置!','info');
	            	        }
	            	        $('#userGrid').datagrid('reload');
	                	});
	                }
	            });
			}else{
				$.messager.alert('选择','请先选择要重设密码的用户!','info');
			}
		}
		
		
		function userEnable(){
			var node = $('#userGrid').datagrid('getSelected');
			if(node != null){
               	$.post("enable.action?id=" + node.id, {}, function(data){
           	        $('#userGrid').datagrid('reload');
               	});
			}else{
				$.messager.alert('选择','请先选择要启用/禁用的用户!','info');
			}
		}
		
        function deleteConfirm(){
        	var node = $('#userGrid').datagrid('getSelected');
			if(node != null){
				$.messager.confirm('确定删除', '确认要删除此用户吗?', function(r){
	                if (r){
	                	$.post("delete.action?id=" + node.id, {}, function(data){
	                		var data = eval('(' + data + ')');  // change the JSON string to javascript object
	            	        if (!data.result){
	            	        	$.messager.alert('失败','删除用户失败!','error');
	            	        }
	            	        $('#userGrid').datagrid('reload');
	                	});
	                }
	            });
			}else{
				$.messager.alert('选择','请先选择要删除的用户!','info');
			}
		}
        
        function onGrant(){
        	var node = $('#userGrid').datagrid('getSelected');
			if(node != null){
				$('#winGrant').window('setTitle', '用户 ' + node.username + ' 授权');
               	$('#grantUserId').val(node.id);
               	$('#editRoleGrid').datagrid("reload");
               	$('#editRoleGrid').datagrid("unselectAll");
               	$('#editPrivilegeGrid').datagrid("reload");
               	$('#editPrivilegeGrid').datagrid("unselectAll");
               	$.post("roleIdsAndPrivilegeIds.action?id=" + node.id, {}, function(data){
               		if(data!=null && data.length>0){
            			var data = eval('(' + data + ')');
            			for(var x=0;x<data.roleIds.length;x++){
            				$('#editRoleGrid').datagrid("selectRecord", data.roleIds[x]);
            			}
            			for(var x=0;x<data.privilegeIds.length;x++){
            				$('#editPrivilegeGrid').datagrid("selectRecord", data.privilegeIds[x]);
            			}
               		}
            	});
				$('#winGrant').window('open');
			}else{
				$.messager.alert('选择','请先选择要授权的用户!','info');
			}
        }
        
        function grantUser(){
        	var selectedPrivileges = $('#editPrivilegeGrid').datagrid("getSelections");
        	var param = "";
        	if(selectedPrivileges!=null){
        		for(var i=0;i<selectedPrivileges.length;i++){
        			param = param + selectedPrivileges[i].id;
        			if(i<selectedPrivileges.length-1)
        				param = param + ";";
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
		
    </script>
    
    <div id="winAdd" class="easyui-window" title="新增用户" data-options="iconCls:'icon-add', closed:true, border:false" style="width:380px;height:380px;padding:0px;">
        <form id="addUserForm" method="post" action="add.action">
            <table style="padding: 10px;">
                <tr>
                    <td align="right">用户名:</td>
                    <td><input class="easyui-validatebox" type="text" name="username" data-options="required:true"></input></td>
                </tr>
                <tr>
                    <td align="right">密码:</td>
                    <td><input class="easyui-validatebox" type="text" name="password" data-options="required:true"></input></td>
                </tr>
                <tr>
                    <td align="right">启用:</td>
                    <td><input class="easyui-validatebox" type="checkbox" name="enabled" id="enabled" checked="checked" ></input></td>
                </tr>
                
                <tr>
                    <td align="right">真实姓名:</td>
                    <td><input class="easyui-validatebox" type="text" name="realName" data-options="validType:'length[0,10]'" style="width:150px"></input></td>
                </tr>
                <tr>
                    <td align="right">性别:</td>
                    <td>
                    	<select name="gender" id="cc" class="easyui-combobox" data-options="required:true, editable:false" style="width:150px">
                    		<option value="1" selected>男</option>
                    		<option value="0">女</option>
                    	</select>
                    </td>
                </tr>
                <tr>
                    <td align="right">身份证号:</td>
                    <td><input class="easyui-validatebox" type="text" name="idCard" data-options="validType:'length[0,18]'" style="width:150px"></input></td>
                </tr>
                <tr>
                    <td align="right">地址:</td>
                    <td><input class="easyui-validatebox" type="text" name="address" data-options="validType:'length[0,50]'"  style="width:250px"></input></td>
                </tr>
                <tr>
                    <td align="right">E-Mail:</td>
                    <td><input class="easyui-validatebox" type="text" name="email" data-options="validType:['email', 'length[0,50]']" style="width:150px"></input></td>
                </tr>
                <tr>
                    <td align="right">联系电话:</td>
                    <td><input class="easyui-validatebox" type="text" name="phoneNumber" data-options="validType:'length[0,50]'"  style="width:150px"></input></td>
                </tr>
            </table>
        </form>
        <div style="text-align:center;padding:5px">
            <a href="javascript:void(0)" class="easyui-linkbutton" onclick="addUser()">确定</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" onclick="$('#winAdd').dialog('close');">取消</a>
        </div>
    </div>
    
    <div id="winEdit" class="easyui-window" title="编辑用户" data-options="iconCls:'icon-add', closed:true, border:false" style="width:380px;height:280px;padding:0px;">
        <form id="editUserForm" method="post" action="edit.action">
        	<input type="hidden" name="userId" id="userId" value="">
            <table style="padding: 10px;">
                <tr>
                    <td align="right">真实姓名:</td>
                    <td><input class="easyui-validatebox" type="text" id="editRealName" name="realName" data-options="validType:'length[0,10]'" style="width:150px"></input></td>
                </tr>
                <tr>
                    <td align="right">性别:</td>
                    <td>
                    	<select name="gender" class="easyui-combobox" id="editGender" data-options="required:true, editable:false" style="width:150px">
                    		<option value="1" selected>男</option>
                    		<option value="0">女</option>
                    	</select>
                    </td>
                </tr>
                <tr>
                    <td align="right">身份证号:</td>
                    <td><input class="easyui-validatebox" type="text" id="editIdCard" name="idCard" data-options="validType:'length[0,18]'" style="width:150px"></input></td>
                </tr>
                <tr>
                    <td align="right">地址:</td>
                    <td><input class="easyui-validatebox" type="text" id="editAddress" name="address" data-options="validType:'length[0,50]'"  style="width:250px"></input></td>
                </tr>
                <tr>
                    <td align="right">E-Mail:</td>
                    <td><input class="easyui-validatebox" type="text" id="editEmail" name="email" data-options="validType:['email', 'length[0,50]']" style="width:150px"></input></td>
                </tr>
                <tr>
                    <td align="right">联系电话:</td>
                    <td><input class="easyui-validatebox" type="text" id="editPhoneNumber" name="phoneNumber" data-options="validType:'length[0,50]'"  style="width:150px"></input></td>
                </tr>
            </table>
        </form>
        <div style="text-align:center;padding:5px">
            <a href="javascript:void(0)" class="easyui-linkbutton" onclick="editUser()">确定</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" onclick="$('#winEdit').dialog('close');">取消</a>
        </div>
    </div>
    
    <div id="winGrant" class="easyui-window" title="用户授权" data-options="iconCls:'icon-add', closed:true, border:false" style="width:565px;height:340px;padding:0px;">
        <form id="grantUserForm" method="post" action="grant.action">
        	<input type="hidden" name="userId" id="grantUserId" value="">
        	<input type="hidden" name="privilegeIds" id="privilegeIds" value="">
        	<input type="hidden" name="roleIds" id="roleIds" value="">
        	<table>
        		<tr><td>用户角色:</td><td>用户权限:</td></tr>
        		<tr><td>
		            <table id="editRoleGrid" class="easyui-datagrid" style="height:220px;width:270px;margin:10px"
					 		data-options="rownumbers:true, pagination:false, singleSelect:false, collapsible:true, fitColumns:true, idField:'id',
					 		showHeader:true, selectOnCheck:true, checkOnSelect:true, url:'currentRoleList.action', method:'post', iconCls:'icon-user'">
				        <thead>
				            <tr>
				            	<th data-options="field:'privilegeIds', checkbox:true"></th>
				                <th field="roleName" width="80">角色</th>
				                <th field="description" width="120">描述</th>
				            </tr>
				        </thead>
				    </table>
				    </td><td>
				    <table id="editPrivilegeGrid" class="easyui-datagrid" style="height:220px;width:270px;margin:10px"
					 		data-options="rownumbers:true, pagination:false, singleSelect:false, collapsible:true, fitColumns:true, idField:'id',
					 		showHeader:true, selectOnCheck:true, checkOnSelect:true, url:'currentPrivilegeList.action', method:'post', iconCls:'icon-user'">
				        <thead>
				            <tr>
				            	<th data-options="field:'privilegeIds', checkbox:true"></th>
				                <th field="privilegeName" width="80">权限</th>
				                <th field="description" width="120">描述</th>
				            </tr>
				        </thead>
				    </table>
				</td><tr>
		    </table>
        </form>
        <div style="text-align:center;padding:5px">
            <a href="javascript:void(0)" class="easyui-linkbutton" onclick="grantUser()">确定</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" onclick="$('#winGrant').dialog('close');">取消</a>
        </div>
    </div>
</body>
</html>