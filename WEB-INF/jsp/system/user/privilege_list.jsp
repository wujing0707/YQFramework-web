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
	<title>Insert title here</title>
	<link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.4/themes/bootstrap/easyui.css">
    <link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.4/themes/icon.css">
    <link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.4/themes/color.css">
    <script type="text/javascript" src="<%=basePath%>js/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.4/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.4/locale/easyui-lang-zh_CN.js"></script>
</head>
<body>
<div style="margin:10px 10px;"></div>
	<table id="userGrid" title="权限管理" class="easyui-datagrid" style="height:300px" width="100%"
	 		data-options="rownumbers:true, pagination:false, singleSelect:true, collapsible:true, fitColumns:true, 
	 		url:'privilegeList.action', method:'get', iconCls:'icon-user'">
        <thead>
            <tr>
                <th field="privilegeName" width="80">权限名</th>
                <th field="description" width="120">描述</th>
                <th data-options="field:'rolesCount', width:80, align:'center', formatter:formatRoles">授予的角色</th>
                <th data-options="field:'usersCount', width:80, align:'center', formatter:formatUsers">直接授予的用户</th>
                <th data-options="field:'allUsersCount', width:80, align:'center', formatter:formatAllUsers">所有授予的用户</th>
            </tr>
        </thead>
    </table>
	<script type="text/javascript">
        function formatRoles(value,row,index){
        	return "<a href='#' onclick='displayUsers(\"winRoles\",\"" + row.id+ "\")'>" + value + "个用户</a>";
		}
        function formatUsers(value,row,index){
        	return "<a href='#' onclick='displayUsers(\"winUsers\",\"" + row.id+ "\")'>" + value + "个用户</a>";
		}
        function formatAllUsers(value,row,index){
        	return "<a href='#' onclick='displayUsers(\"winAllUsers\",\"" + row.id+ "\")'>" + value + "个用户</a>";
		}
        
        function displayUsers(win, id){
        	$('#' + win).window('open');
        	var queryParams = $('#' + win + 'Panel').datagrid('options').queryParams; 
        	queryParams["privilegeId"] = id;
        	$('#' + win + 'Panel').datagrid('options').queryParams = queryParams;
            $('#' + win + 'Panel').datagrid('reload');
        }
    </script>
    
    <div id="winRoles" class="easyui-window" title="新增用户" data-options="iconCls:'icon-add', closed:true" style="width:500px;height:300px;padding:0px;">
        <div title="权限" style="margin:0px;padding:0px">
        	<table id="privilegeGrantPanel" class="easyui-datagrid" style="height:160px;width:470px;margin:10px"
			 		data-options="rownumbers:true, pagination:false, singleSelect:false, collapsible:true, fitColumns:true, 
			 		showHeader:true, selectOnCheck:true, checkOnSelect:true, url:'privilegeList.action', method:'get', iconCls:'icon-user'">
		        <thead>
		            <tr>
		            	<th data-options="field:'ck',checkbox:true"></th>
		                <th field="privilegeName" width="80">名称</th>
		                <th field="description" width="120">描述</th>
		            </tr>
		        </thead>
		    </table>
        </div>
		<div style="text-align:center;padding:5px">
		    <a href="javascript:void(0)" class="easyui-linkbutton" onclick="clearForm()">关闭</a>
		</div>
    </div>
    
    <div id="winUsers" class="easyui-window" title="直接授予的用户 " data-options="closed:true" style="width:500px;height:300px;padding:0px;">
       	<table id="winUsersPanel" class="easyui-datagrid" style="height:240px;"
		 		data-options="border:false, rownumbers:true, pagination:false, singleSelect:false, collapsible:true, fitColumns:true, 
		 		showHeader:true, selectOnCheck:true, checkOnSelect:true, url:'userListByPrivilegeId.action', method:'get', iconCls:'icon-user'">
	        <thead>
	            <tr>
	                <th field="username" width="80">名称</th>
	                <th field="description" width="120">描述</th>
	                <th field="enabled" width="120">启用</th>
	            </tr>
	        </thead>
	    </table>
		<div style="text-align:center;padding:5px">
		    <a href="javascript:void(0)" class="easyui-linkbutton" onclick="clearForm()">关闭</a>
		</div>
    </div>
    
    <div id="winAllUsers" class="easyui-window" title="新增用户" data-options="iconCls:'icon-add', closed:true" style="width:500px;height:300px;padding:0px;">
        <div title="权限" style="margin:0px;padding:0px">
        	<table id="privilegeGrantPanel" class="easyui-datagrid" style="height:160px;width:470px;margin:10px"
			 		data-options="rownumbers:true, pagination:false, singleSelect:false, collapsible:true, fitColumns:true, 
			 		showHeader:true, selectOnCheck:true, checkOnSelect:true, url:'privilegeList.action', method:'get', iconCls:'icon-user'">
		        <thead>
		            <tr>
		            	<th data-options="field:'ck',checkbox:true"></th>
		                <th field="privilegeName" width="80">名称</th>
		                <th field="description" width="120">描述</th>
		            </tr>
		        </thead>
		    </table>
        </div>
		<div style="text-align:center;padding:5px">
		    <a href="javascript:void(0)" class="easyui-linkbutton" onclick="clearForm()">关闭</a>
		</div>
    </div>
    
</div>
</body>
</html>