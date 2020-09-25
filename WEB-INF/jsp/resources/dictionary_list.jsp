<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css" />
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.4/themes/bootstrap/easyui.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/themes/icon-suit-a.css">
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-easyui-1.4/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-easyui-1.4/locale/easyui-lang-zh_CN.js"></script>

<title>数据字典</title>
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
    $("#dg").datagrid({
    	//title: '数据字典',
    	height:370,
		striped: true,
		rownumbers: true,
		checkOnSelect:false,
		pagination: true,
		singleSelect:true ,
		toolbar: '#tb',
		iconCls:'icon-user',
        url:"${pageContext.request.contextPath}/dictionarys/newlist.action", 
        loadMsg: "载入中...请等待.",
        onLoadSuccess : function () {
			 $(this).datagrid("fixRownumber");
			 $(this).datagrid("resize");
				    },
        columns:[[
            {field:"field",title:"字典类型编码",width :183,align:'left'},
            {field:"fieldname",title:"字典类型名称",width:183,align:'left'},
            {field:"code",title:"字典编码",width:183,align:'left'},
            {field:"codedesc",title:"字典名称",width:283,align:'left'},
            /* {field:"ENABLED",title:"启用状态",align:'center',
            	formatter:function(value){        
        		if(value==1)                
        			return '启用';        
        		else                
        			return '禁用';        
        		}
        		}, 
            	
            {field:"EDITMODE",title:"编辑状态",align:'center',
        			formatter:function(value){        
                		if(value==1)                
                			return '只读';        
                		else                
                			return '可编辑';        
                		}
        		},*/
            {field:"remark",title:"备注",width:230,align:'left'}
        ]]
      
    });
	$("#ENABLEDS").combobox({
		width: 130,
	    editable: false,
	    panelHeight: "auto",
	    data:[{value:'1',text:'启用'},{value:'0',text:'禁用'}],
	    valueField: "value",
	    textField: "text"
 	});
	$("#EDITMODES").combobox({
		width: 130,
	    editable: false,
	    panelHeight: "auto",
	    data:[{value:'1',text:'只读'},{value:'0',text:'可编辑'}],
	    valueField: "value",
	    textField: "text"
 	});
	 
	
});

function getHtmlInfo(s){
	if(s!=""){
		s = s.replace(/&amp;/g, "&");  
		s = s.replace("&quot;", "\"");  
	    s = s.replace(/&nbsp;/g, " ");  
	    s = s.replace(/&#39;/g, "'");          
	    s = s.replace(/&lt;/g, "<");  
	    s = s.replace(/&gt;/g, ">");  
	    s = s.replace(/"<br>"/g, "\n");  
	    s = s.replace(/"?D"/g, "—");  
	    s = s.replace(/&quot;/g, "\"");  
	    return s;  
    }else{
        return;
    }
}

function newUser(){
	$('#fm').form('clear');
	$('#dlg').window({
    			modal:true
			});
	$('#dlg').dialog('open').dialog('setTitle','数据维护字典');
	$("#ENABLEDS").combobox("setValue","1");
	$("#EDITMODES").combobox("setValue","1");
	}
//添加   
function submitForm() {
	//非空验证
	   if  ($("#field").val() == "") {
			$.messager.alert('提示',"请将信息项填写完整！");
			return;
		} else if  ($("#fieldname").val() == "") {
			$.messager.alert('提示',"请将信息项填写完整！");
			return;
		} else if  ($("#code").val() == "") {
			$.messager.alert('提示',"请将信息项填写完整！");
			return;
		}else if  ($("#codedesc").val() == "") {
			$.messager.alert('提示',"请将信息项填写完整！");
			return;
		}
	 //下拉框的值
	   var enabled = $('#ENABLED').combobox('getValue');
	   var sortno = $('#EDITMODE').combobox('getValue');
	   addDepartment();
}

function addDepartment(){
	$('#fm').form('submit', {
	    success: function(data){
	        var data = eval('(' + data + ')');  // change the JSON string to javascript object
	        if (!data.result){
	        	$.messager.alert('失败','新增数据字典失败，同一字典类型编码下字典编码不能重复!','error');
	        }else{
	        $.messager.alert('成功','新增数据字典成功!','info');
	        $('#dg').datagrid('reload');
	        $('#dlg').dialog('close');
	    }
	    }
	});
}

function getSelectionsIds () {
	var checkItems = $('#dg').datagrid('getSelections');
	var ids = "";
	$.each(checkItems, function (index, item) {
		ids +=  item.codeid + ",";
	});
	ids = ids.substring(0, ids.length-1);
	return ids;
}

//删除
function destroyUser() {
	var ids =getSelectionsIds ();
	if (ids.length <= 0) {
		$.messager.alert('提示','请选择要删除的内容!','warning');
		return;
	}
	if (ids.length != 0) {
		$.messager.confirm("提示", "确认删除数据字典吗？", function(r) {
		if (r) {
			$.post("${pageContext.request.contextPath}/dictionarys/a_removeList.action",  {"ids" : ids},
					function(data) {
						if (data.result == true) {
							$.messager.alert('提示', "数据字典删除成功！","info", function(r){
								$('#dg').datagrid('reload');
							});
						} else if (data.result == false)  {
							$.messager.alert('提示',"删除失败，该字典已被引用！","warning");
						} 
				}, "json");
			}
		});
	}
}
//点击修改的按钮
	function editUser(){
			var node = $('#dg').datagrid('getSelected');
			if(node != null){
               	$('#CODEID').val(getHtmlInfo(node.codeid));
               	$('#FIELD').val(getHtmlInfo(node.field));
               	$('#FIELDNAME').val(getHtmlInfo(node.fieldname));
               	$('#CODE').val(getHtmlInfo(node.code));
               	$('#CODEDESC').val(getHtmlInfo(node.codedesc));
               	$('#REMARK').val(getHtmlInfo(node.remark));
             	var en=	node.ENABLED;
             	var ed=node.EDITMODE;
               $("#ENABLED").combobox("setValue",en);
               $("#EDITMODE").combobox("setValue",ed);
               $.parser.parse('#winEdit'); 
               $('#winEdit').window({
    			modal:true
			});
				$('#winEdit').window('open');
			}else{
				$.messager.alert('选择','请先选择要编辑的信息!','info');
			}
		}
		
	//点击修改保存
	function editSubmit(){
        	$('#editForm').form('submit', {
        	    success: function(data){
        	        var data = eval('(' + data + ')');  // change the JSON string to javascript object
        	        if (!data.result){
        	        	$.messager.alert('失败','编辑数据字典失败，同一字典类型编码下字典编码不能重复!','error');
        	        }
        	        $.messager.alert('成功','编辑成功!','info');
        	        $('#dg').datagrid('reload');
        	        $('#winEdit').dialog('close');
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
 		setFirstPage("#dg");
		var orgName = $.trim($('#searchName').val());
		var organCode = $.trim($('#searchCode').val());
		var queryParams = $('#dg').datagrid('options').queryParams;
		queryParams["FIELD"] = orgName;
		queryParams["CODE"] = organCode;
		$('#dg').datagrid('options').queryParams = queryParams;
		$('#dg').datagrid('reload');
	}
	
//重置
function clearSearch(){
	$('#searchName').val('');
	$('#searchCode').val('');
}



</script>
 <style type="text/css">
 #fm{margin:0;
 padding:10px 30px;
 }
 .ftitle{
 font-size:14px;
 font-weight:bold;
 padding:5px 0;
 margin-bottom:10px;
 border-bottom:1px solid #ccc;
 }
 .fitem{
 margin-bottom:5px;
 }
 .fitem label{
 display:inline-block;
 width:80px;
 }
 .fitem input{
 width:160px;
 }
 </style>
</head>
<body style="height:450px;overflow:hidden;overflow-y:hidden;">
			<div class="padT23">
			<div id="tb" style="padding:5px;height:auto">
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-add" plain="true" onclick="newUser()">新增</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-edit" plain="true" onclick="editUser()">编辑</a>
            <a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-remove" plain="true" onclick="destroyUser()">删除</a>
            <div style="float: right;">
                                          字典类型名称：
         	<input id="searchName" class="easyui-input" style="width: 120px">&nbsp;&nbsp; 
         	字典名称：
         	<input id="searchCode" class="easyui-input" style="width: 120px">&nbsp;&nbsp;
			<a href="#" class="easyui-linkbutton" iconCls="icon-search" onclick="conditionSearch();">查询</a>
			<a href="#" class="easyui-linkbutton" iconCls="icon-refresh" onclick="clearSearch();">重置</a>
			</div>
        </div>
       		  <div class="place">
				<span>位置：</span>
				<ul class="placeul">
					<li><%=request.getAttribute("path") %></li>
				</ul>
			</div>
			<table id="dg"></table>
			</div>
	<!-- 弹出的新增窗口 -->
	<div id="dlg" class="easyui-dialog" style="width:400px;height:280px;padding:10px 20px"   closed="true" buttons="#dlg-buttons">
	
	  <form id="fm" method="post" action="add.action">
	 
	  <div class="fitem">
	  <label>字典类型编码:</label>
	  <input name="field" class="easyui-validatebox" data-options="required:true,validType:'length[0,15]'"  id="field" maxlength="15">
	  </div>
	  <div class="fitem">
	  <label>字典类型名称:</label>
	  <input name="fieldname" class="easyui-validatebox" data-options="required:true,validType:'length[0,20]'" id="fieldname" maxlength="20">
	  </div>
	  <div class="fitem">
	  <label>字典编码:</label>
	  <input name="code" class="easyui-validatebox" data-options="required:true,validType:'length[0,10]'" id="code" maxlength="10">
	  </div>
	  <div class="fitem">
	  <label>字典名称:</label>
	  <input name="codedesc" class="easyui-validatebox" data-options="required:true,validType:'length[0,100]'"  id="codedesc" maxlength="100">
	  </div>
	   <div style="display:none;">
	   <div class="fitem">
	  <label>启用状态:</label>
	  <select id="ENABLEDS" name="enabled"></select>
	  <!-- <select class="easyui-combobox" style="width:160px;" id="ENABLED">
	  <option value="1"  >启用</option>
	  <option value="0" >禁用</option>
	  </select> -->
	  
	  </div>
	   <div class="fitem">
	  <label>编辑状态:</label>
	  <select id="EDITMODES" name="editmode"></select>
	 	<!-- <select class="easyui-combobox" style="width:160px;" id="SORTNO">
	  <option value="1" >只读</option>
	  <option value="0" >可编辑</option>
	  </select> -->
	  </div></div>
	   <div class="fitem">
	  <label>备注:</label>
	  <input id="remark" name="remark" class="easyui-validatebox" data-options="required:true,validType:'length[0,200]'" maxlength="200">
	  </div>
	  </form>
	  </div>
	  <div id="dlg-buttons" style="text-align:center;padding:5px">
		<a href="javascript:void(0)" class="easyui-linkbutton"
			iconCls="icon-ok" onclick="submitForm()">确定</a> <a
			href="javascript:void(0)" class="easyui-linkbutton"
			iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')"
			style="width:66px">取消</a>
	  </div>
	  
	<!-- 弹出修改的窗口 -->
	<div id="winEdit" class="easyui-dialog" title="编辑数据字典"  
			data-options="iconCls:'icon-add', closed:true, border:false" 
			style="width:350px;height:280px;padding:10px 20px;">
        <form id="editForm" method="post" action="edit.action">
        	<input type="hidden" name="CODEID" id="CODEID" value="">
            <table style="border-collapse:separate; border-spacing:10px;">
                <tr style="line-height:10px;">	
                    <td align="right">字典类型编码:</td>
                    <td><input class="easyui-validatebox" type="text" id="FIELD" data-options="required:true,validType:'length[0,15]'" name="field" ></input></td>
                </tr>
                <tr style="line-height:10px;">
                    <td align="right">字典类型名称:</td>
                    <td>
                    	<input class="easyui-validatebox" type="text" id="FIELDNAME"  name="fieldname" data-options="required:true,validType:'length[0,20]'"></input>
            			</td>
                </tr>
                <tr>
                    <td align="right">字典编码:</td>
                    <td>
                    	<input class="easyui-validatebox" type="text" id="CODE" name="code" data-options="required:true,validType:'length[0,10]'"></input>
            			</td>
                </tr>
                <tr>
                    <td align="right">字典名称:</td>
                    <td>
                    	<input class="easyui-validatebox" type="text" id="CODEDESC" name="codedesc" data-options="required:true,validType:'length[0,100]'"></input>
            			</td>
                </tr>
                <tr style="display:none;">
                    <td align="right">启用状态:</td>
                    <td  disabled="disabled">
                    	<!-- <input class="easyui-combobox"  id="ENABLED" name="enabled" >  </input>-->
                    	<select id="ENABLED" class="easyui-combobox" style="width:80px;" name="enabled" panelHeight="auto">
                    	<option type="radio" value="1">启用</option>
						<option type="radio" value="0">禁用</option>
                    	</select>
            			</td>
                </tr>
                <tr style="display:none;">
                    <td align="right">编辑状态:</td>
                    <td>
                    	<!--  <input class="easyui-combobox"  id="EDITMODE" name="editmode" ></input>-->
                    	
                    	<select id="EDITMODE" class="easyui-combobox" style="width:80px;" name="editmode" panelHeight="auto">
                    	<option type="radio" value="1">只读</option>
						<option type="radio" value="0">可编辑</option>
                    	</select>
            			</td>
                </tr>
                <tr>
                    <td align="right">备注:</td>
                    <td>
                     <input id="REMARK" name="remark" class="easyui-validatebox" data-options="required:true,validType:'length[0,200]'" >
                  </td>
                </tr>
            </table>
        </form>
        <div id="edit-buttons" style="text-align:center;padding:5px">
		<a href="javascript:void(0)" class="easyui-linkbutton"
			iconCls="icon-ok" onclick="editSubmit()">确定</a> 
		<a href="javascript:void(0)" class="easyui-linkbutton"
			iconCls="icon-cancel" onclick="$('#winEdit').dialog('close');"
			style="width:66px">取消</a>
		</div>
	</div>
</body>
</html>