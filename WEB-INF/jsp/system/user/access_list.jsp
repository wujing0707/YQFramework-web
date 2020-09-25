<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	<title>系统功能权限管理</title>
	<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css" />
	<link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.4/themes/bootstrap/easyui.css">
    <link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.4/themes/icon.css">
    <link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.4/themes/color.css">
    <script type="text/javascript" src="<%=basePath%>js/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.4/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.4/locale/easyui-lang-zh_CN.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.4/extension/jquery-easyui-datagridview/datagrid-detailview.js"></script>
</head>
<body>
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
    	$('#accessTree').tree("options").url = "../access/tree.action";
       	$('#accessTree').tree("reload");
       	$('#accessTree').tree({
       		onSelect: function(node) {
       			//if ($('#accessTree').tree('isLeaf', node.target)) {
           			conditionSearch(node.id);
       			//}
       		}, 
            onContextMenu: function(e, node) {
                e.preventDefault();
                $(this).tree('select', node.target);
                $('#mm').menu('show', {
                    left: e.pageX,
                    top: e.pageY
                });
            }
       	});
       
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
	
    function conditionSearch(parentId) {
    	setFirstPage("#accessGrid");
    	var queryParams = $('#accessGrid').datagrid('options').queryParams;
    	queryParams["parentId"] = parentId;
        $('#accessGrid').datagrid('options').queryParams = queryParams;
        $("#accessGrid").datagrid('reload');
    }

	function onAddAccess() {
		var node = $('#accessTree').tree('getSelected');
		if (node != null) {
   			if (node.attributes != null && node.attributes == 'available') {
   				$('#accessAddForm').form("clear");
   	            $('#menuId').val(node.id);
   	            $('#accessAddForm').form('validate');
   				$('#winAdd').window('open');
   				$("#addButton").show();
   			} else {
   				$.messager.alert('选择','请选择系统菜单树的叶子节点进行功能权限新增!','warning');
   			}
		} else {
			$.messager.alert('选择','请先在左边的树中选择功能权限节点!','warning');
		}
	}
	
	function addAccess() {
		$("#addButton").hide();//确定按钮隐藏
       	$('#accessAddForm').form('submit', {
            success : function(data) {
                var data = eval('(' + data + ')'); // change the JSON string to javascript object
                if (!data.result) {
                    $.messager.alert('失败', data.message, 'error');
                	$("#addButton").show();
                } else {
                    $.messager.alert('成功', data.message, 'info');
                	$("#addButton").show();
                    $('#accessTree').tree("reload");
                    conditionSearch("");
                    $('#winAdd').dialog('close');
                }
            }
       	});
	}
	
	function onEditAccess() {
		var node = $('#accessGrid').datagrid('getSelected');
	
		if (node != null) {
			$('#privilegeId').val(node.privilegeId);
		
			$('#editMenuId').val(node.menuId);
			
			$('#privilegeCode').textbox('setValue', getHtmlInfo(node.privilegeCode));
			
			$('#privilegeName').textbox('setValue', getHtmlInfo(node.privilegeName));
			
			$('#url').textbox('setValue', getHtmlInfo(node.url));
			
	
			$('#description').textbox('setValue', getHtmlInfo(node.description));
	
			$('#accessEditForm').form('validate');
			$('#winEdit').window('open');
		} else {
			$.messager.alert('选择','请在列表中选择功能编辑权限项!','warning');
		}
	}
	
	function editAccess() {
       	$('#accessEditForm').form('submit', {
            success : function(data) {
                var data = eval('(' + data + ')'); // change the JSON string to javascript object
                if (!data.result) {
                    $.messager.alert('失败', data.message, 'error');
                } else {
                    $.messager.alert('成功', data.message, 'info');
                    $('#accessTree').tree("reload");
                    $("#accessGrid").datagrid('reload');
                    $('#winEdit').dialog('close');
                }
            }
       	});
	}
	
    function deleteAccess() {
    	var node = $('#accessTree').tree('getSelected');
    	var gridNode = $('#accessGrid').datagrid('getSelected');
		if (node != null) {
   			if ($('#accessTree').tree('isLeaf', node.target)) {
   				$.messager.confirm('确定删除', '删除此功能权限会解除相关的授权项目, 确认要删除此功能权限吗?', function(r) {
   	                if (r) {
   	                	$.post("deleteAccess.action", {id: node.id}, function(data) {
   	                		var data = eval('(' + data + ')');  // change the JSON string to javascript object
   	            	        if (!data.result) {
   	            	        	$.messager.alert('失败', data.message, 'warning');
   	            	        } else {
   	            	        	$.messager.alert('成功', data.message, 'info');
   	            	        }
   	                        $('#accessTree').tree("reload");
   	                     	conditionSearch("");
   	                	});
   	                }
   	            });
   			} else {
   				$.messager.alert('选择','请选择树的叶子节点(功能权限节点)进行操作!','warning');
   			}
		} else if (gridNode != null) {
				$.messager.confirm('确定删除', '删除此功能权限会解除相关的授权项目, 确认要删除此功能权限吗?', function(r) {
   	                if (r) {
   	                	$.post("deleteAccess.action", {id: gridNode.privilegeId}, function(data) {
   	                		var data = eval('(' + data + ')');  // change the JSON string to javascript object
   	            	        if (!data.result) {
   	            	        	$.messager.alert('失败', data.message, 'error');
   	            	        } else {
   	            	        	$.messager.alert('成功', data.message, 'info');
   	            	        }
   	                        $('#accessTree').tree("reload");
   	                     	conditionSearch("");
   	                	});
   	                }
   	            });
		} else {
			$.messager.alert('选择','请先在左边的树中选择功能权限节点!','warning');
		}
    }
	
	</script>
	<div>
			<div class="place">
				<span>位置：</span>
				<ul class="placeul">
						<li><%=request.getAttribute("path") %></li>
				</ul>
			</div>
    <div id="layoutzone" class="easyui-layout" style="width:100%; height:420px;">
        <div id="westzone" data-options="region:'west', split:true, title:'功能权限树', iconCls:'globe'" style="width:25%;">
			<div id="accessTree" class="easyui-tree" style="margin: 10px" 
			    data-options="lines:true, animate:true, method:'post'">
			</div>
		</div>
        <div id="mainzone" data-options="region:'center', title:'功能权限列表', iconCls:'icon-document'">
            <table id="accessGrid" class="easyui-datagrid" data-options="url:'list.action', 
                rownumbers:true, method:'post', toolbar:'#tb', border:false,  
                singleSelect:true, fit:true, fitColumns:true">
                <thead>
                    <tr>
                        <th data-options="field:'privilegeName',align:'center'" width="80">权限功能名称</th>
                        <th data-options="field:'privilegeCode',align:'center'" width="120">权限功能编码</th>
                        <th data-options="field:'description',align:'center'" width="150">说明</th>
                    </tr>
                </thead>
            </table>
        </div>
    </div>
   </div>   
    <div id="tb" style="padding:5px;height:auto">
        <div style="margin-bottom:5px">
            <a  href="#" onclick="onAddAccess();" iconCls='icon-add' plain=true" class="easyui-linkbutton">新增功能权限</a>
            <a  href="#" onclick="onEditAccess();" iconCls='icon-edit' plain=true" class="easyui-linkbutton">编辑功能权限</a>
            <a  href="#" onclick="deleteAccess();" iconCls='icon-remove' plain=true" class="easyui-linkbutton">删除功能权限</a>
        </div>
    </div>

	<div id="winAdd" class="easyui-window" title="新增功能权限"
		data-options="modal:true, iconCls:'icon-add',left:'25%', top:'10%', closed:true, tools:'#addTool'"
		style="width: 415px; height: 350px; padding: 10px;">
		<form id="accessAddForm" method="post" action="addAccess.action">
			<input type="hidden" name="menuId" id="menuId">
			<table>
				<tr>
					<td height="30px">功能权限编码:</td>
					<td><input class="easyui-textbox" name="privilegeCode" data-options="required:true, validType:'length[0,30]'"></input></td>
				</tr>
				<tr>
					<td height="30px">功能权限名称:</td>
					<td><input class="easyui-textbox" name="privilegeName" data-options="required:true,validType:'length[0,30]'"></input></td>
				</tr>
				<tr>
					<td height="85px">功能权限URL<br>(多个路径中间<br>以','号分隔):</td>
					<td><input class="easyui-textbox" name="url" data-options="required:true, width: '245px', height:'80px', multiline:true,validType:'length[0,600]'"></input></td>
				</tr>
				<tr>
					<td height="90px">说明描述:</td>
					<td><input class="easyui-textbox" name="description" data-options="width: '245px', height:'80px', multiline:true, validType:'length[0,150]'"></input></td>
				</tr>
			</table>
		</form>
		<div id="addTool">
			<a href="javascript:void(0)" class="icon-save" onclick="addAccess()" title="保存功能权限"></a>
		</div>
		<div id="add-buttons" style="text-align:center;padding:5px">
			<a href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-ok" onclick="addAccess()">确定</a> 
			<a href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-cancel" onclick="$('#winAdd').window('close');"
				style="width:66px">取消</a>
		</div>
	</div>
	
	<div id="winEdit" class="easyui-window" title="编辑功能权限"
		data-options="modal:true, iconCls:'icon-edit',left:'25%', top:'10%', closed:true, tools:'#editTool'"
		style="width: 415px; height: 350px; padding: 10px;">
		<form id="accessEditForm" method="post" action="editAccess.action">
			<input type="hidden" name="privilegeId" id="privilegeId"></input>
			<input type="hidden" name="editMenuId" id="editMenuId"></input>
			<table>
				<tr>
					<td height="30px">功能权限编码:</td>
					<td><input class="easyui-textbox" id="privilegeCode" name="privilegeCode" data-options="required:true, validType:'length[0,30]'"></input></td>
				</tr>
				<tr>
					<td height="30px">功能权限名称:</td>
					<td><input class="easyui-textbox" id="privilegeName" name="privilegeName" data-options="required:true, validType:'length[0,30]'"></input></td>
				</tr>
				<tr>
					<td height="85px">功能权限URL<br>(多个路径中间<br>以','号分隔):</td>
					<td><input class="easyui-textbox" id="url" name="url" data-options="required:true, width: '245px', height:'80px', multiline:true,validType:'length[0,600]'"></input></td>
				</tr>
				<tr>
					<td height="90px">说明描述:</td>
					<td><input class="easyui-textbox" id="description" name="description" data-options="width: '245px', height:'80px', multiline:true, validType:'length[0,150]'"></input></td>
				</tr>
			</table>
		</form>
		<div id="editTool">
			<a href="javascript:void(0)" class="icon-save" onclick="editAccess()" title="保存功能权限"></a>
		</div>
		<div id="edit-buttons" style="text-align:center;padding:5px">
			<a href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-ok" onclick="editAccess()">确定</a> 
			<a href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-cancel" onclick="$('#winEdit').window('close');"
				style="width:66px">取消</a>
		</div>
	</div>
	
	<div id="mm" class="easyui-menu" style="width:120px;">
		<div onclick="onAddAccess()" data-options="iconCls:'icon-add'">新增功能权限</div>
		<div onclick="deleteAccess()" data-options="iconCls:'icon-remove'">删除功能权限</div>
	</div>
	
</body>
</html>