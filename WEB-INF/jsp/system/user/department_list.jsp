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
	<title>部门管理</title>
	<link type="text/css" rel="stylesheet"
	href="${pageContext.request.contextPath}/css/styles.css" />
	<link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.4/themes/bootstrap/easyui.css">
    <link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.4/themes/icon.css">
    <link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.4/themes/color.css">
    <script type="text/javascript" src="<%=basePath%>js/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.4/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.4/locale/easyui-lang-zh_CN.js"></script>
</head>
<body style="height:450px">
	 <div class="place">
			<span>位置：</span>
			<ul class="placeul">
					<li><%=request.getAttribute("path") %></li>
			</ul>
		</div>
	<table id="departmentTreeGrid" class="easyui-treegrid" 
			style="height:420px" width="100%"
	 		data-options="rownumbers:true, singleSelect:true, collapsible:true, fitColumns:true, 
	 		url:'list.action', method:'post', idField:'id', treeField:'departmentName', toolbar:'#tb'">
        <thead>
            <tr>
                <th field="departmentName" width="80" align="center">部门名称</th>
                <th field="description" width="80" align="center">描述</th>
                <!-- <th field="rolesCount" width="120">拥有的角色</th>
                <th field="privilegesCount" width="120">拥有的权限</th> -->
                <th field="createBy" width="80" align="center">创建者</th>
                <th field="createDate" width="80" align="center">创建时间</th>
                <th field="updateBy" width="80" align="center">最后更新者</th>
                <th field="updateDate" width="80" align="center">最后更新时间</th>
            </tr>
        </thead>
    </table>
    
    <div id="tb" style="padding:5px;height:auto">
        <div style="margin-bottom:5px">
            <a href="#" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="addRootDepartment();">新增根部门</a>
            <a href="#" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="addSubDepartment();">新增下级部门</a>
            <a href="#" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="editDepartment();">编辑</a>
            <!--a href="#" class="easyui-linkbutton" iconCls="icon-check" plain="true" onclick="">授权</a -->
            <a href="#" class="easyui-linkbutton" iconCls="icon-delete" plain="true" onclick="deleteConfirm();">删除部门</a>
        </div>
    </div>
   
	<script type="text/javascript">
	
		function addRootDepartment(){
			$('#addDepartmentForm').form('clear');
			$('#winAdd').window("setTitle", "新增根部门");
			$('#parentId').val('ROOT');
			$('#winAdd').window('open');
		}
		
		function addSubDepartment(){
			var node = $('#departmentTreeGrid').treegrid('getSelected');
			if(node != null){
				$('#addDepartmentForm').form('clear');
				$('#winAdd').window("setTitle", "新增下级部门");
				$('#parentId').val(node.id);
				$('#winAdd').window('open');
			}else{
				$.messager.alert('选择','请先选择父部门!','info');
			}
		}
		
		function addDepartment(){
        	$('#addDepartmentForm').form('submit', {
        	    success: function(data){
        	        var data = eval('(' + data + ')');  // change the JSON string to javascript object

        	        if (!data.result){
        	        	$.messager.alert('失败','新增部门失败!','error');
        	        }
        	        $('#departmentTreeGrid').treegrid('reload');
        	        $('#winAdd').dialog('close');
        	    }
        	});
        }
		
		function editDepartment(){
			var node = $('#departmentTreeGrid').treegrid('getSelected');
			if(node != null){
				$.get('../user/listByDepartmentId.action?departmentId=' + node.id, {}, function(data){
               		var data = eval('(' + data + ')');
    				$("#adminUsername").combobox("loadData", data);
               	}); 
				if(node.adminUsername != null && node.adminUsername != "")
					$("#adminUsername").combobox("select", node.adminUsername);
				$('#departmentCode').val(node.departmentCode);
				$('#departmentName').val(node.departmentName);
				$('#description').val(node.description);
				$('#departmentId').val(node.id);
				$('#editDepartmentForm').form('validate');
				$('#winEdit').window('open');
			}else{
				$.messager.alert('选择','请先选择编辑部门!','info');
			}
		}
		
		function editSubmit(){
			$('#editDepartmentForm').form('submit', {
			    onSubmit: function () {
                 //表单验证
                     return $(this).form('validate')
                 },
        	    success: function(data){
        	        var data = eval('(' + data + ')');  // change the JSON string to javascript object
        	        if (!data.result){
        	        	$.messager.alert('失败','部门名称不能重复!','error');
        	        }else{
        	        	$('#departmentTreeGrid').treegrid('reload');
        	        	$('#winEdit').dialog('close');
        	        }
        	        
        	    }
        	});
		}
	
        function deleteConfirm(){
        	var node = $('#departmentTreeGrid').treegrid('getSelected');
			if(node != null){
				$.messager.confirm('确定删除', '确认要删除?', function(r){
	                if (r){
	                	$.post("delete.action?id=" + node.id, {}, function(data){
	                		var data = eval('(' + data + ')');  // change the JSON string to javascript object
	            	        if (!data.result){
	            	        	if(data.message == "1"){
	            	        		$.messager.alert('失败','该部门存在相关人员!','error');
	            	        	}
	            	        	if(data.message == "3"){
	            	        		$.messager.alert('失败','部门下面包含子部门, 请先删除子部门!','error');
	            	        	}
	            	        }
	            	        $('#departmentTreeGrid').treegrid('reload');
	                	});
	                }
	            });
			}else{
				$.messager.alert('选择','请先选择要删除的部门!','info');
			}
           	
		}
    </script>
	<div id="winAdd" class="easyui-window" title="新增部门" 
			data-options="iconCls:'icon-add', closed:true, border:false" 
			style="width:400px;height:248px;padding:0px;">
        <form id="addDepartmentForm" method="post" action="add.action">
        	<input type="hidden" name="parentId" id="parentId" value="ROOT">
            <table>
                <tr>
                    <td align="right">部门名称:</td>
                    <td><input class="easyui-validatebox" type="text" name="departmentName" data-options="required:true" maxlength="50"></input></td>
                </tr>
                <tr>
                    <td align="right">描述:</td>
                    <td><textarea name="description" style="width: 300px;height: 100px;" data-options="required:false,validType:'length[0,250]'" maxlength="250"></textarea></td>
                </tr>
            </table>
        </form>
        <div style="text-align:center;padding:5px">
            <a href="javascript:void(0)" class="easyui-linkbutton" onclick="addDepartment()">确定</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" onclick="$('#winAdd').dialog('close');">关闭</a>
        </div>
	</div>
	
	<div id="winEdit" class="easyui-window" title="编辑部门" 
			data-options="iconCls:'icon-add', closed:true, border:false" 
			style="width:400px;height:240px;padding:0px;">
        <form id="editDepartmentForm" method="post" action="edit.action">
        	<input type="hidden" name="id" id="departmentId" value="">
            <table>
                <tr>
                    <td align="right">部门名称:</td>

                    <td><input class="easyui-validatebox" type="text" id="departmentName" name="departmentName" data-options="required:true,validType:'length[0,30]'" maxlength="50"></input></td>
                </tr>
                <tr>
                    <td align="right">描述:</td>
                    <td><textarea id="description" name="description" style="width: 300px;height: 100px;" data-options="required:false,validType:'length[0,250]'" maxlength="250"></textarea></td>
                </tr>
            </table>
        </form>
        <div style="text-align:center;padding:5px">
            <a href="javascript:void(0)" class="easyui-linkbutton" onclick="editSubmit()">确定</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" onclick="$('#winEdit').dialog('close');">关闭</a>
        </div>
	</div>
	
	<div style="margin:20px 20px;"></div>
</body>
</html>