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
	<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css" />
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.4/themes/bootstrap/easyui.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.4/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.4/themes/icon-suit-a.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/autocomplete.css">
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-easyui-1.4/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-easyui-1.4/locale/easyui-lang-zh_CN.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.autocomplete.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/browser.js"></script>
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
    	height: 390,
		striped: true,
		rownumbers: true,
		singleSelect: false,
		checkOnSelect: false,
		pagination: true,
        url: "${pageContext.request.contextPath}/relevance/a_listPage.action",
		toolbar :'#td',
        loadMsg: "载入中...请等待.",
        onLoadSuccess : function () {
			 $(this).datagrid("fixRownumber");
				    },
        columns:[[
            {field:"ck",checkbox:true,width:50},
            {field:"tableName",title:"表名",width:190},
            {field:"columnName",title:"字段名",width:150},
            {field:"rName",title:"规则名称",width:150},
            {field:"rformula",title:"规则公式",width:230},
            {field:"rformulaDesc",title:"规则描述",width:190},
            {field:'enabled',title:'状态',width:100,
                formatter:function(value){
                	if (value == '1'){
	               		 return "启用";
	               	 } else {
	               		 return "<span style='color:red;'>禁用<span>";
	               	 }
                	/* if (value){
                    		 return st[0].text;
                    	 } else {
                    		 return st[1].text;
                    	 } */
                 }
             }
        ]],
        onClickRow: function (rowIndex, rowData) {
            $(this).datagrid('unselectRow', rowIndex);
        }
    });
    

/*     $('#table').combobox({
	    url: '${pageContext.request.contextPath}/system/tablemapping/loadTableNames.action?t='+new Date(),
	    method: 'get',
	    valueField:'tableId',
	    textField:'tableName',
	    onSelect: function(rec){
	    	$('#column').combobox('setValue', '');
			var url = '${pageContext.request.contextPath}/system/tablemapping/loadColumnNamesByTableId.action?tableId=' + rec.tableId;
			$('#column').combobox('reload', url);
		}
    }); */

    
    var lsurl = '${pageContext.request.contextPath}/system/tablemapping/loadTableNames.action?t='+new Date();
        $("#table").autocomplete(lsurl,{
              minChars: 0,//自动完成激活之前填入的最小字符
              max:300,//列表条目数
              width: 300,//提示的宽度
              scrollHeight: 300,//提示的高度
              matchContains: true,//是否只要包含文本框里的就可以
              autoFill:false,//自动填充
              //需要把data转换成json数据格式                        
                        parse: function(data) {  
                           return $.map(eval(data), function(row) {  
                               return {  
                                data: row,  
                                value: row.tableName,
                                result: row.tableId   
                              }  
                        });  
                 }, 
              formatItem: function(data, i, max) {//格式化列表中的条目 row:条目对象,i:当前条目数,max:总条目数
				return data.tableName;
            },
            formatMatch: function(data, i, max) {//配合formatItem使用，作用在于，由于使用了formatItem，所以条目中的内容有所改变，而我们要匹配的是原始的数据，所以用formatMatch做一个调整，使之匹配原始数据
				return data.tableName;
            },
            formatResult: function(data) {//定义最终返回的数据，比如我们还是要返回原始数据，而不是formatItem过的数据
				return data.tableName;
            }
        }).result(function(event,data,formatted){
        	$("#table").val(data.tableName);
        	tableId = data.tableId;
            $('#column').combobox('setValue', '');
			var url = '${pageContext.request.contextPath}/system/tablemapping/loadColumnNamesByTableId.action?tableId=' + data.tableId;
			$('#column').combobox('reload', url);
        });
    
});
var st = [{value:'true',text:'启用'},{value:'false',text:'禁用'}];

var tableId;

function gotoPage(path) {
	window.location.href = "${pageContext.request.contextPath}"  + path ;
}
function getSelectionsIds () {
	var checkItems = $('#dg').datagrid('getSelections');
	var ids = "";
	$.each(checkItems, function (index, item) {
		ids +=  item.rlId + ",";
	});
	ids = ids.substring(0, ids.length-1);
	return ids;
}
function removeRuleColumn() {
	var ids =getSelectionsIds ();
	if (ids.length <= 0) {
		$.messager.alert('提示',"请选择要删除规则关联！");
		return;
	}
	if (ids.length != 0) {
		$.messager.confirm("提示", "确认要删除规则关联吗？", function(r) {
			if (r) {
				$.post("${pageContext.request.contextPath}/relevance/a_removeList.action",  {"ids" : ids},
						function(data) {
							if (data.result == true) {
								gotoPage('/relevance/listPage.action');
							
							} else    {
								$.messager.alert('提示',"规则关联删除失败！");
							} 
					}, "json");
			}
			});
		}
}

function getSelectionsNodes () {
	var checkItems = $('#dg').datagrid('getSelections');
	var trueName = "";
	var falseName = "";
	$.each(checkItems, function (index, item) {
		if(item.enabled){
			trueName += item.rname + ",";
		}else{
			falseName +=item.rname + ",";
		}
	});
	trueName = trueName.substring(0, trueName.length-1);
	falseName = falseName.substring(0, falseName.length-1);
	var val = {"trueName":trueName,"falseName":falseName};
	return val;
}


//启用
function enabled () {
	var ids =getSelectionsIds();
	var nodes = getSelectionsNodes ();
	if (ids.length <= 0) {
		$.messager.alert('提示',"请选择要启用的规则关联！");
		return;
	}else if(nodes.trueName != ""){
		$.messager.alert('提示',"规则["+nodes.trueName+"]已经启用,请先选择禁用！");
		return;
	}else{
		$.post("${pageContext.request.contextPath}/relevance/a_enabled.action",  {"ids" : ids},
			function(data) {
				gotoPage('/relevance/listPage.action');
		}, "json");
	
	}
}
//禁用
function disable () {
	var ids =getSelectionsIds ();
	var nodes = getSelectionsNodes ();
	if (ids.length <= 0) {
		$.messager.alert('提示',"请选择要禁用的规则关联！");
		return;
	}else if(nodes.falseName == ""){
		$.post("${pageContext.request.contextPath}/relevance/a_disable.action",  {"ids" : ids},
			function(data) {
				gotoPage('/relevance/listPage.action');
		}, "json");
	
	}else{
		$.messager.alert('提示',"规则["+nodes.falseName+"]已经禁用,请先选择启用！");
		return;
	}
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
//条件查询
function query () {
	setFirstPage("#dg");
	var zhuangtai = $('#zhuangtai').combobox('getValue');
    var queryParams = $('#dg').datagrid('options').queryParams;
    var tableId = $("#table").val();
	var columnId =  $("#column").combobox('getValue');
	var columnName =  $("#column").combobox('getText').trim();
	queryParams["zhuangtai"] = zhuangtai;
    queryParams.columnId = columnId;
    queryParams.columnName = columnName;
    queryParams.tableId =  tableId;
    queryParams.rname = $("#rname").val();
    queryParams.rformula= $("#gz").val();
    $('#dg').datagrid('options').queryParams = queryParams;
    $("#dg").datagrid("reload");
}


function conditionReset(){
	$('#table').val('');
	$("#zhuangtai").combobox("setValue","");
	$('#column').combobox('setValue','');
	$('#statusSch').combobox('clear');
	$('#gz').val('');
	$('#rname').val('');
	tableId ='';
	
}
</script>
</head>
<body id="homepage" class="bodyBG" >
<div  class="padT23">
	<div class="con" id="con">
		<div id="tab_zzjs_1">
			<span class="positon">
			</span>
			<div class="indexSearchBox push"  id="td"style="padding:10px;">
				<div>
				<a href="javascript:gotoPage('/relevance/edit.action');" class="easyui-linkbutton" iconCls="icon-add" plain="true">新增</a>
				<a href="javascript:removeRuleColumn();" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除</a>
				<a href="javascript:enabled ();" class="easyui-linkbutton" iconCls="icon-check" plain="true">启用</a>
				<a href="javascript:disable () ;" class="easyui-linkbutton" iconCls="icon-disable" plain="true">禁用</a>
				</div>
			    <!-- 通用的头，开始 -->
			       表名：
			  	 <input id="table"  type="text" style="width:120px;"  class="easyui-validatebox" />
			        字段名：
			      <input class="easyui-combobox" id="column"  data-options="valueField:'columnId',textField:'columnName'" style="width:120px;"/>
			       规则名称：
			    <input class="easyui-validatebox" type="text" id="rname" size="15px;" />&nbsp;
			        规则公式：
			    <input class="easyui-validatebox" type="text" id="gz" size="15px;"/>&nbsp;
			      状态：<input id="zhuangtai" class="easyui-combobox" panelHeight="auto" style="width:120px;" data-options="editable:false,valueField:'value',textField:'text',data:[{'value':'true','text':'启用'},{'value':'false','text':'禁用'}]"/>&nbsp;
			      <!-- 结束 -->
			     <a href="javascript:void(0);"  onclick="query();" class="easyui-linkbutton" iconCls="icon-search" >查询</a>
			     <a href="#" class="easyui-linkbutton" iconCls="icon-refresh" onclick="conditionReset();">重置</a>
		    </div>
		    <div class="place">
				<span>位置：</span>
				<ul class="placeul">
						<li><%=request.getAttribute("path") %></li>
				</ul>
			</div>
			<table id="dg" class="easyui-datagrid"></table>
		</div>
	</div>
	</div>
</body>
</html>

