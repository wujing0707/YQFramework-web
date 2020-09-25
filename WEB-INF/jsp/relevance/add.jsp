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
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/themes/bootstrap/easyui.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/themes/icon-suit-a.css">
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/locale/easyui-lang-zh_CN.js"></script>
<title>规则关联管理</title>
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
    	height: 360,
		striped: true,
		rownumbers: true,
		singleSelect: true,
		//checkOnSelect: false,
		pagination: true,
		toolbar :'#td',
		queryParams: {enabled:1},
        url: "${pageContext.request.contextPath}/rule/listRule.action?zhuangtai=true",
        loadMsg: "载入中...请等待.",
        onLoadSuccess : function () {
			 $(this).datagrid("fixRownumber");
				    },
        columns:[[
          
            {field:"name",title:"规则名称",width:240,
										formatter : function(value) {
											return "<span title='"+value+"'>"+value+"</span>";
										}},
            {field:"formula",title:"规则公式",width:300,
										formatter : function(value) {
											return "<span title='"+value+"'>"+value+"</span>";
										}},
            {field:"formulaDesc",title:"规则描述",width:240,
										formatter : function(value) {
											return "<span title='"+value+"'>"+value+"</span>";
										}}/* ,
            {field:"ck",title:"操作",checkbox:true,width:100,
                formatter:function(value){
                	return '启用';
               }
            } */
        ]]/* ,
        onClickRow: function (rowIndex, rowData) {
            $(this).datagrid('unselectRow', rowIndex);
        },
        onDblClickCell: function(index,field,value){
        	
            if(value==true || value==false){
            	console.info(value);
            	$(this).datagrid('getEditor', {index:index,field:field});
              }
         }, */
    });
    
    $('#table').combobox({
	    url: '${pageContext.request.contextPath}/system/tablemapping/loadTableNames.action?t='+new Date(),
	    method: 'get',
	    valueField:'tableId',
	    textField:'tableName',
	    onSelect: function(rec){
	    	$('#column').combobox('setValue', '');
			var url = '${pageContext.request.contextPath}/system/tablemapping/loadColumnNamesByTableId.action?tableId=' + rec.tableId;
			$('#column').combobox('reload', url);
		}
    });
});
//添加
function submitForm() {
//非空验证
	var tableId = $("#table").combobox('getValue');
	var tableName = $("#table").combobox('getText');
	var columnId =  $("#column").combobox('getValue');
	var columnName = $("#column").combobox('getText');
	
	var ruleIds = getSelectionsIds();
	if (tableName.length==0||tableId.length==0) {
		$.messager.alert('提示',"表名不能为空！");
		return;
	}
	
	if (columnName.length==0||columnId.length==0) {
		$.messager.alert('提示',"字段名不能为空！");
		return;
	}
	if (ruleIds.length==0){
		$.messager.alert('提示',"必须选中一条规则！");
		return;
	}
	
	$("#submitBtn").linkbutton("disable");
	$.post("${pageContext.request.contextPath}/relevance/a_save.action", 
		{ tableId: tableId,tableName: tableName,
		columnId:columnId,columnName: columnName,
		ruleIds:ruleIds
		 },
		function(data) {
			if (data.result == true) {
				$.messager.alert('提示',"关联规则保存成功！",'info',function(){
					gotoPage('/relevance/listPage.action');
				});
				
			} else {
				$.messager.alert('提示',"关联规则不能添加重复！",'info',function(){
					
				});
			}
			$("#submitBtn").linkbutton("enable");
		}, "json");
}

//获得被选中的规则id
 function getSelectionsIds() {
	var checkItems = $('#dg').datagrid('getSelections');
	var ids = "";
	$.each(checkItems, function (index, item) {
		ids +=  item.id + ",";
	});
	ids = ids.substring(0, ids.length-1);
	return ids;
}
function gotoPage(path) {
	window.location.href = "${pageContext.request.contextPath}"  + path ;
}

//返回列表
function backListPage () {
	gotoPage('/relevance/listPage.action');
}
//条件查询
function query () {
    var queryParams = $('#dg').datagrid('options').queryParams;
    queryParams.name = $("#name").val();
    $('#dg').datagrid('options').queryParams = queryParams;
    $("#dg").datagrid("reload");
}

function conditionReset(){
	$('#table').combobox('setValue','');
	$('#column').combobox('setValue','');
	$('#name').val('');
	
}
function addpg(){
$.messager.alert('提示',"请先对表进行去重配置后，再进行规则映射！");

}
</script>
</head>
<body id="homepage" class="bodyBG" onload="addpg();">
	<div class="con" id="con">
		<div id="tab_zzjs_1">
			<div class="indexSearchBox push" id="td"style="padding:10px;">
			   <!-- 通用的头，开始 -->
			        表名：
			  	 <input class="easyui-combobox"   id="table"  style="width:155px;"  data-options="editable:false">&nbsp;&nbsp;
			        字段名：
			      <input class="easyui-combobox" id="column"  data-options="valueField:'columnId',textField:'columnName',editable:false"> 
			  <div style="float: right;">    
			  
			       规则名称：
			    <input class="easyui-validatebox" type="text" id="name" size="15px;"/>&nbsp;
			      <!-- 结束 -->
			    <a href="#"
					class="easyui-linkbutton" iconCls="icon-search"
					onclick="query();">查询</a>&nbsp;
			     <a href="#" class="easyui-linkbutton" iconCls="icon-refresh" onclick="conditionReset();">重置</a> 
			  </div>
		    </div>
			<div class="padT23">
				<table id="dg"></table>
			</div>
			<div style="text-align:center;padding:5px">
	            <a href="javascript:void(0)" id="submitBtn" class="easyui-linkbutton" onclick="submitForm()">确定</a>
	            <a href="javascript:void(0)" class="easyui-linkbutton" onclick="backListPage()">返回</a>
        </div>
		</div>
	</div>
</body>
</html>

