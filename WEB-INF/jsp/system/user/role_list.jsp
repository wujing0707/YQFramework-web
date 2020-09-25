<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/tlds/WaFramework.tld" prefix="wf"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String basePath = request.getScheme() + "://" + request.getServerName() 
			+ ":" + request.getServerPort() + request.getContextPath() + "/";
	pageContext.setAttribute("basePath", basePath);
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>角色管理</title>
<link type="text/css" rel="stylesheet"
	href="${pageContext.request.contextPath}/css/styles.css" />
<link rel="stylesheet" type="text/css"
	href="<%=basePath%>js/jquery-easyui-1.4/themes/bootstrap/easyui.css">
<link rel="stylesheet" type="text/css"
	href="<%=basePath%>js/jquery-easyui-1.4/themes/icon.css">
<link rel="stylesheet" type="text/css"
	href="<%=basePath%>js/jquery-easyui-1.4/themes/color.css">
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/themes/icon-suit-a.css">

<script type="text/javascript" src="<%=basePath%>js/commonUtils.js"></script>
<script type="text/javascript"
	src="<%=basePath%>js/jquery-1.10.2.min.js"></script>
<script type="text/javascript"
	src="<%=basePath%>js/jquery-easyui-1.4/jquery.easyui.min.js"></script>
<script type="text/javascript"
	src="<%=basePath%>js/jquery-easyui-1.4/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript"
	src="<%=basePath%>js/jquery-easyui-extend.js"></script>
<script type="text/javascript" src="<%=basePath%>js/base.js"></script>
<script type="text/javascript"
	src="<%=basePath%>js/jquery-easyui-1.4/extension/jquery-easyui-datagridview/datagrid-detailview.js"></script>
</head>
	<script type="text/javascript">
	
	$(function() {
	
	$("#roleGrid").datagrid({
    	//title: '归集信息',
    	height:370,
		striped: true,
		rownumbers: true,
		checkOnSelect:false,
		pagination: true,
		toolbar: '#tb',
		iconCls:'icon-user',
		singleSelect:true ,
        url:"<%=basePath%>system/role/list.action", 
        loadMsg: "载入中...请等待.",
        columns:[[
            {field:"roleName",title:"角色名称",width:'15%',align:'left',formatter : function(value) {return "<span title='"+value+"'>"+value+"</span>";}},
            {field:"description",title:"描述",width:'14%',align:'left',formatter : function(value) {return "<span title='"+value+"'>"+value+"</span>";}},
            {field:"deptdesc",title:"部门",width:'20%',align:'left'},
            {field:"department",hidden: true},
            {field:"createBy",title:"创建者",width:'10%',align:'left'},
         	{field:"createDate",title:"创建时间",width:'15%',align:'left'},
         	{field:"updateBy",title:"最后更新者",width:'10%',align:'left'},
         	{field:"updateDate",title:"最后更新时间",width:'15%',align:'left'},
        	{field:"dataaccessid",hidden: true}
        ]]
      
    });
	
});

        function onAddRole(){
        	$("#addButton").show();
        	$('#roleAddForm').form("clear");
        	$('#winAdd').window('open');
       
    		// 部门下拉框
    		$('#adddept').combobox({
    			url : '${pageContext.request.contextPath}/system/user/getDept.action' ,
    			valueField : 'value',
    			textField : 'text',
    			multiple : false,
    			panelHeight : '150',
    			editable : false,
    			required:true
    
    		});
    		
    
				
    		$('#addPrivilegeTree').combotree({
    			url: '${pageContext.request.contextPath}/system/privilege/list.action',
    			animate:true,
    			lines:true,
    			required: true,
    			multiple:true,
    			checkbox:true,
    			cascadeCheck:true
             });  
    		
    		$('#addPrivilegeGrid').combobox({
    			url: '${pageContext.request.contextPath}/dataaccess/getAllAccessList.action',
    			valueField : 'value',
    			textField : 'text',
    			required: true,
    			editable:false
             }); 
    	
        }
        
        function addRole(){

        	//var t = $('#addPrivilegeTree').combotree("getText");	// 得到选择的节点的textFiled文本内容,
        	//菜单权限
        	var param = $('#addPrivilegeTree').combotree("getValues");	// 多选，得到选择的节点的valueFiled的值，di值
            $('#addPrivilegeIds').val(param);
        	
            //数据权限
        	var dataparam = $('#addPrivilegeGrid').combobox('getValue');
        	$('#dataaccessid').val(dataparam);
        	
        	//部门
        	var departcode = $('#adddept').combobox('getValue');
        	$('#departid').val(departcode);
        	
        	$("#addButton").hide();//确定按钮隐藏
        	$('#roleAddForm').form('submit', {
        		onSubmit: function(){  
                    if(!$(this).form('validate')){
                    	$("#addButton").show();
                    	return false;
                    }  
                },
        	    success: function(data){
        	    	var data = eval('(' + data + ')');  // change the JSON string to javascript object
        	        if (!data.result){
        	        	$.messager.alert('失败','角色名称已经存在!','error');
        	        	$("#addButton").show();
        	        	
        	        }else{
        	        	$.messager.alert('成功','角色新增成功!','info',function(){
        	        			$("#addButton").show();
        	        			$('#roleGrid').datagrid('reload');
	        	        		$('#winAdd').dialog('close');
        	        	});

        	        }
        	    },
        	    error : function() {
        	    		$("#addButton").show();
						$.messager.alert("提示", "网络错误", "error");
					}
        	});
        }
        
        function deleteRole(){
        	var node = $('#roleGrid').datagrid('getSelected');
			if(node != null){
				 $.messager.confirm('提示', '确认要删除此角色吗?', function(r){
	                if (r){ 
	                	$.post("deleteRole.action?id=" + node.id, {}, function(data){
	                		var data = eval('(' + data + ')');  // change the JSON string to javascript object
	            	        if (!data.result){
	            	        	$.messager.alert('失败','这个角色下拥有权限用户,不能删除!','error');
	            	        } else {
	            	        	$.messager.alert('成功','删除角色成功!','info',function(){
	            	        		$('#roleGrid').datagrid('reload');
	            	        	});
	            	            
	            	        }
	                	});
	                }
	            }); 
			}else{
				$.messager.alert('选择','请先选择要删除的角色!','warning');
			}
        }
        
        function onEditRole(){
       		$('#roleEditForm').form('reset');
        	var node = $('#roleGrid').datagrid('getSelected');
			if(node != null){
               	$('#roleName').val(node.roleName);
               	$("#description").textbox('setValue',node.description)//赋值 
               	$('#roleId').val(node.id);
            
            	$('#editPrivilegeTree').combotree({
        			url: '${pageContext.request.contextPath}/system/privilege/rolePrivilege.action?id=' + node.id,
        			animate:true,
        			lines:true,
        			required: true,
        			multiple:true,
        			checkbox:true,
        			cascadeCheck:true
                 }); 
         
  
               	$('#editPrivilegeGrid').combobox({
        			url: '${pageContext.request.contextPath}/dataaccess/getAllAccessList.action',
        			valueField : 'value',
        			textField : 'text',
        			required: true,
        			editable:false
                 }); 
       
        		$('#editdept').combobox({
        			url : '${pageContext.request.contextPath}/system/user/getDept.action' ,
        			valueField : 'value',
        			textField : 'text',
        			multiple : false,
        			panelHeight : '150',
        			editable : false,
        			required:true
        
        		});
        		
               	$('#editdept').combobox('setValue',node.department);
             
             	$('#editPrivilegeGrid').combobox('setValue',node.dataaccessid);
             	
               	$('#roleEditForm').form('validate');
				$('#winEdit').window('open');
			}else{
				$.messager.alert('选择','请先选择要编辑/授权的角色!','warning');
			}
        }
        
        function editRole(){

        	var param = $('#editPrivilegeTree').combotree("getValues");
        	$('#editPrivilegeIds').val(param);
        	
        	var dataparam = $('#editPrivilegeGrid').combobox('getValue');
        	//alert(dataparam);
        	$('#dataaccessidEdi').val(dataparam);
        	
        	var deptedit = $('#editdept').combobox('getValue');
        	$('#deptEdi').val(deptedit);
        	
        	$('#roleEditForm').form('submit', {
        	    success: function(data){
        	        var data = eval('(' + data + ')');  // change the JSON string to javascript object
        	        if (!data.result){
        	        	$.messager.alert('失败','角色名称已经存在!','error');
        	        }else{
        	        	$.messager.alert('成功','编辑角色信息成功!','info');
	        	        $('#roleGrid').datagrid('reload');
	        	        $('#winEdit').dialog('close');
        	        }
        	    }
        	});
        }
        
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


         //查询
 function conditionSearch() {
 		setFirstPage("#roleGrid");
		var roleName = $.trim($('#searchName').val());
		var deptname=	 $('#accessDept').combobox('getValue');
		var queryParams = $('#roleGrid').datagrid('options').queryParams;
		queryParams["roleName"] = roleName;
		queryParams["deptname"] = deptname;
		$('#roleGrid').datagrid('options').queryParams = queryParams;
		$('#roleGrid').datagrid('reload');
	}
	
//重置
function clearSearch(){
	$('#searchName').val('');
	$('#accessDept').combobox('setValue','');
}

    </script>
<body style="height: 450px">
<!-- 列表 -->
	<div>
		<div class="place">
			<span>位置：</span>
			<ul class="placeul">
				<li><%=request.getAttribute("path") %></li>
			</ul>
		</div>
		<table id="roleGrid" width="100%">
		</table>
	</div>
	<div id="tb" style="padding: 5px; height: auto">
		<div style="margin-bottom: 5px">
			<a href="#" class="easyui-linkbutton" onclick="onAddRole();"
				iconCls='icon-add' plain="true">新增</a> <a href="#"
				class="easyui-linkbutton" onclick="deleteRole();"
				iconCls='icon-remove' plain="true">删除</a> <a href="#"
				class="easyui-linkbutton" onclick="onEditRole();"
				iconCls='icon-edit' plain="true">编辑/授权</a>
			<div style="float: right;">
				角色名称： <input id="searchName" class="easyui-input"
					style="width: 120px">&nbsp;&nbsp; &nbsp;&nbsp; 部门：<input
					style="width: 150px" class="easyui-combobox" id="accessDept"
					editable="false"
					url='${pageContext.request.contextPath}/system/user/getDept.action'
					data-options="valueField:'value', textField:'text',multiple:false">
				&nbsp;&nbsp; &nbsp;&nbsp; <a href="#" class="easyui-linkbutton"
					iconCls="icon-search" onclick="conditionSearch();">查询</a> <a
					href="#" class="easyui-linkbutton" iconCls="icon-refresh"
					onclick="clearSearch();">重置</a>
			</div>
		</div>
	</div>
	
<!-- 新增 -->
	<div id="winAdd" class="easyui-window" title="新增角色"
		data-options="modal:true, iconCls:'icon-add', closed:true, tools:'#addTool',minimizable:false"
		style="width: 500px; height: 360px; padding: 10px;">

		<form id="roleAddForm" method="post" action="addRole.action">
			<input type="hidden" name="privilegeIds" id="addPrivilegeIds"
				value=""> <input type="hidden" name="dataaccessid"
				id="dataaccessid" value="">
				<input type="hidden" name="departcode" id="departid" value="">
			<table
				style="margin-left: auto; margin-right: auto; margin-top: auto; margin-bottom: auto; padding: 10px">
				<tr>
					<td height="30">部门:</td>
					<td colspan="2">
					<input id="adddept" name="adddept" style="width: 150px" editable="false" />
				   </td>
				</tr>
				<tr>
					<td height="30">角色名称:</td>
					<td colspan="2"><input class="easyui-validatebox" type="text"
						style="width: 350px" name="roleName"
						data-options="required:true,validType:'length[0,18]'"></input></td>
				</tr>
				<tr>
					<td height="30">描述:</td>
					<td colspan="2"><textarea name="description"
							style="width: 350px; height: 120px; resize: none;"
							class="easyui-textbox"
							data-options="multiline:true, validType:'length[0,250]'"
							maxlength="250"></textarea></td>
				</tr>

				<tr>
					<td height="30">菜单权限:</td>
					<td>
					<input id="addPrivilegeTree"  style="width: 350px" editable="false" />
					</td>
				</tr>
				<tr>
					<td height="30">数据权限:</td>
					<td><input id="addPrivilegeGrid" style="width: 350px;" />
					</td>
				</tr>
			</table>
		</form>
<div id="add-buttons" style="text-align:center;padding:5px">
			<a href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-ok" onclick="addRole()">确定</a> 
			<a href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-cancel" onclick="$('#winAdd').window('close');$('#addButton').show();"
				style="width:66px">取消</a>
		</div>
	</div>


<!-- 修改 -->
	<div id="winEdit" class="easyui-window" title="角色编辑/授权"
		data-options="modal:true, iconCls:'icon-add', closed:true, tools:'#tt',minimizable:false"
		style="width: 500px; height: 360px; padding: 10px;">

		<form id="roleEditForm" method="post" action="editRole.action">
			<input type="hidden" name="privilegeIds" id="editPrivilegeIds"
				value=""> <input type="hidden" name="roleId" id="roleId"
				value=""> <input type="hidden" name="dataaccessidEdi"
				id="dataaccessidEdi" value="">
				<input type="hidden" name="deptEdi" id="deptEdi" value="">

			<table
				style="margin-left: auto; margin-right: auto; margin-bottom: auto; margin-top: auto; padding: 10px">
				<tr>
					<td height="30">部门:</td>
					<td colspan="2"><input style="width:150px" id="editdept" /> </td>
				</tr>
				<tr>
					<td height="30">角色名称:</td>
					<td colspan="2"><input class="easyui-validatebox" type="text"
						style="width: 350px" name="roleName" id="roleName"
						data-options="required:true,validType:'length[0,18]'"></input></td>
				</tr>
				<tr>
					<td height="30">描述:</td>
					<td colspan="2"><textarea name="description" id="description"
							style="width: 350px; height: 120px; resize: none;"
							class="easyui-textbox"
							data-options="multiline:true, validType:'length[0,250]'"
							maxlength="250"></textarea></td>
				</tr>
				<tr>
					<td height="30">菜单权限:</td>
					<td><input id="editPrivilegeTree" style="width: 350px;"></input></td>
				</tr>
				<tr>
					<td height="30">数据权限:</td>
					<td><input id="editPrivilegeGrid" style="width: 350px;" />
					</td>
				</tr>

			</table>
		</form>
		<div id="tt">
			<a href="javascript:void(0)" class="icon-save" onclick="editRole()"
				title="保存角色权限"></a>
		</div>
		<div id="edit-buttons" style="text-align:center;padding:5px">
			<a href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-ok" onclick="editRole()">确定</a> 
			<a href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-cancel" onclick="$('#winEdit').dialog('close');"
				style="width:66px">取消</a>
		</div>

	</div>
</body>
</html>