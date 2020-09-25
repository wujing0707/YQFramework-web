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
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/themes/icon-suit-a.css">
	
    <script type="text/javascript" src="<%=basePath%>js/commonUtils.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.4/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.4/locale/easyui-lang-zh_CN.js"></script> 
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-extend.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/base.js"></script>
	<style type="text/css">
				.datagrid-btable .datagrid-cell {
			/* padding: 6px 4px; */
			overflow: hidden;
			text-overflow: ellipsis;
			white-space: nowrap;
		}
		input {
			text-overflow:ellipsis;
		}
	</style>
<title>规则列表</title>
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
	$("#status").combobox({
	    editable: false,
	    panelHeight: "auto",
	    data:[{value:'1',text:'启用'},{value:'0',text:'禁用'}],
	    valueField: "value",
	    textField: "text"
	   
 	});
    $("#ruleList").datagrid({
    	height: 370,
		striped: true,
		rownumbers: true,
		singleSelect: false,
		checkOnSelect: true,
		pagination: true,
		queryParams: {},
        url: "${pageContext.request.contextPath}/rule/listRule.action",
		toolbar :'#td',
        loadMsg: "载入中...请等待.",
        columns:[[
            {field:"ck",checkbox:true,width:50},
            {field:"name",title:"规则名称",width:240,
										formatter : function(value) {
											return "<span title='"+value+"'>"+value+"</span>";
										}},
            {field:"formula",title:"规则公式",width:300
            ,
										formatter : function(value) {
											return "<span title='"+value+"'>"+value+"</span>";
										}
        	 },
            {field:"formulaDesc",title:"规则描述",width:240
            	,
										formatter : function(value) {
											return "<span title='"+value+"'>"+value+"</span>";
										}
            
            },
            {field:'status',title:'状态',width:100,
                formatter:function(value){
                    	 if (value == '1'){
                    		 return "启用";
                    	 } else {
                    		 return "<span style='color:red;'>禁用<span>";
                    	 }
                 }
             },
           
            {field:"edit",title:"操作选项",width:160,align:"center",
                formatter: function(value, rowData, index) {
               		//var path = "/rule/edit.action?id=" + rowData.id;
                   	var str = "<a href='javascript:queryById(&#039;"+rowData.id+"&#039;,&#039;"+rowData.name+"&#039;,&#039;"+rowData.formula+"&#039;,&#039;"+rowData.formulaDesc+"&#039;,&#039;"+rowData.status+"&#039;)' style='font-size:12px;color:blue'>编辑</a>&nbsp;&nbsp;"
                   			+ "<a href='javascript:removeRule(\"" + rowData.id + "\")' style='font-size:12px;color:blue'>删除</a>&nbsp;&nbsp;";
                   	return str;
                }
            }
        ]],
	        pagination: true,
	        rownumbers: true,
	        onLoadSuccess: function(data){
        	 $(this).datagrid("fixRownumber");
// 		    	$("#ruleList").datagrid("getPager").pagination({
// 		    		total: data.total
// 		    	});
// 		    	if (data.total == 0) {
// 		    		$("#ruleList").datagrid("getPager").pagination({ 
// 		    			displayMsg:"总计 {total} 条" 
// 			    	}); 
// 		    	} else {
// 		    		$("#ruleList").datagrid("getPager").pagination({ 
// 		    			displayMsg:"显示{from}到 {to},共{total}记录"
// 			    	}); 
// 		    	}
			},
        onClickRow: function (rowIndex, rowData) {
            $(this).datagrid('unselectRow', rowIndex);
        },
        onDblClickCell: function(index,field,value){
        	
            if(value==true || value==false){
            	$(this).datagrid('getEditor', {index:index,field:field});
              }
         }
    });
    
    var options = $("#ruleList").datagrid('getPager').data("pagination").options; 
    options.beforePageText = "页码";
    $("#ruleList").datagrid('getPager').data("pagination").options = options;
});
function getSelectionsIds () {
	var checkItems = $('#ruleList').datagrid('getSelections');
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

/**
 * 根据ID查询详细信息，转到详细页面
 
 function queryById(id){
		window.location.href = "${pageContext.request.contextPath}/rule/edits.action?id="+id;
} 
*/
 function queryById(id,name,formula,formulaDesc,status){
 	$('#ediId').val(id);
 	$.post("${pageContext.request.contextPath}/rule/edits.action",  {"id" : id},
	function(data) {
	$('#ediname').val(getHtmlInfo(data.name));
    $('#ediformula').val(getHtmlInfo(data.formula));
    $('#ediformulaDesc').val(getHtmlInfo(data.formulaDesc));
    $('#edistatus').combobox("setValue",status);
    //$.parser.parse('#edidlg'); 
 	$('#edidlg').window({
    			modal:true
	});
	$('#edidlg').dialog('open').dialog('setTitle','编辑校验规则');
				}, "json");
    
 }
 
 function getHtmlInfo(s){
 	s = s.replace(/&#92;/g, "\\"); 
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
}

 function removeRules() {
	var ids =getSelectionsIds ();
	if (ids.length <= 0) {
		$.messager.alert('提示',"请选择要删除的规则！");
		return;
	}
	if (ids.length != 0) {
		$.messager.confirm("提示", "确认删除规则吗？", function(r) {
		if (r) {
			$.post("${pageContext.request.contextPath}/rule/a_removeList.action",  {"ids" : ids},
					function(data) {
						if (data.result == true) {
							$.messager.alert("操作提示","规则删除成功！","info",function(){
								gotoPage('/rule/toRule.action');
							});
						} else if (data.result == false)  {
							$.messager.alert('提示',"规则删除失败！");
						} else {
							$.messager.alert('提示',"规则[" + data + "]已经有关联字段不能删除！");
						}
				}, "json");
			}else{
				 $("#ruleList").datagrid('uncheckAll');
			}
		});
	}
} 

 function removeRule(id) {
	if (id.length <= 0) {
		$.messager.alert('提示',"请选择要删除的规则！");
		return;
	}
	if (id.length != 0) {
		$.messager.confirm("提示", "确认删除规则吗？", function(r) {
		if (r) {
			$.post("${pageContext.request.contextPath}/rule/a_removeList.action",  {"ids" : id},
					function(data) {
						if (data.result == true) {
							$.messager.alert('提示', "规则删除成功！","info", function(r){
								gotoPage('/rule/toRule.action');
							}); 
						
						} else if (data.result == false)  {
							$.messager.alert('提示',"规则删除失败！");
						} else {
							$.messager.alert('提示',"规则[" + data + "]已经有关联字段不能删除！");
						}
				}, "json");
			}else{
				$("#ruleList").datagrid('uncheckAll');
			}
		});
	}
} 
//启用
 function enabled () {
	var ids =getSelectionsIds ();
	
	if (ids.length <= 0) {
		$.messager.alert('提示',"请选择要启用的规则！");
		return;
	}
	$.post("${pageContext.request.contextPath}/rule/a_enabled.action",  {"ids" : ids},function(data) {
		if (data.result == true) {
			$.messager.alert('提示',"规则启用成功！","info",
				function(){
					gotoPage('/rule/toRule.action');
				}
			)
		}else{
			$.messager.alert('提示',"规则[" + data + "]已经启用,请选择禁用！");
		}
	}, "json");
} 
//禁用
 function disable () {
	 var ids =getSelectionsIds ();
	if (ids.length <= 0) {
		$.messager.alert('提示',"请选择要禁用的规则！");
		return;
	}
	$.post("${pageContext.request.contextPath}/rule/a_disable.action",  {"ids" : ids},
		function(data) {
			if (data.result == true) {
				$.messager.alert('提示',"规则禁用成功！","info",function(){
				gotoPage('/rule/toRule.action');
				});
			}else if(data.result ==false){
				$.messager.alert('提示',"规则[" + data.message + "]已经禁用,请选择启用！");
			} else {
				$.messager.alert('提示',"规则[" + data + "]已经有关联字段不能禁用！");
			}
	}, "json");
} 

function submitForm() {	
	 //非空验证
	   if  ($("#addname").val() == "") {
			$.messager.alert('提示',"规则名称不能为空！");
			return;
		} else if  ($("#addformula").val() == "") {
			$.messager.alert('提示',"规则公式不能为空！");
			return;
		} else if  ($("#addformulaDesc").val() == "") {
			$.messager.alert('提示',"规则描述不能为空！");
			return;
		} 
	   var name=$("addname").val();
       var formula=$("#addformula").val();
       var miaoshu=$("#addformulaDesc").val();
       var regrule=/^[^]+[\S]+[$]+$/;
       var key = true;
   	   if(!regrule.test(formula)){  			
   			key = false;
   		}
   		if(!key && navigator.userAgent.indexOf('MSIE') >=0 && formula.indexOf('^')==0 && formula.indexOf('$')>1){
			key = true;
   		}
   		if(!key){
   			$.messager.alert('提示',"规则公式不正确",'info');
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
		{ id:$("#id").val(),name: $("#addname").val(), formula: $("#addformula").val(), enabled : statuss ,
		formulaDesc: $("#addformulaDesc").val()},
		function(data) {
			if (data.result == true) {
				 $.messager.alert("操作提示", "规则新增成功！","info",function(){
				 	$('#ruleList').datagrid('reload');
		        	$('#dlg').dialog('close');
				 });
			} else {
				$.messager.alert('提示',"规则保存失败,规则名称已经存在！");
			}
			$("#submitBtn").linkbutton("enable");
		}, "json");
}


//点击修改保存
	function edisubmitForm() {
		$('#edifm').form('submit', {
			success : function(data) {
				var data = eval('(' + data + ')'); // change the JSON string to javascript object
				if (!data.result) {
					$.messager.alert('失败', '规则名称不能重复!', 'error');
				} else {
					$.messager.alert('提示', '编辑成功!', 'info',function(){
						$('#ruleList').datagrid('reload');
						$('#edidlg').dialog('close');
					});
					
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

function add(){
	$("#status").combobox("setValue","1");
	$('#dlg').window({modal:true});
	$('#addname').val('');
	$('#addformula').val('');
	$('#addformulaDesc').val('');
	$('#dlg').dialog('open').dialog('setTitle','新增校验规则');
	
}

//条件查询
function query () {
	setFirstPage("#ruleList");
	var zhuangtai = $.trim($('#zhuangtai').combobox('getValue'));
    var queryParams = $('#ruleList').datagrid('options').queryParams;
    queryParams.name = $.trim($("#name").val());
    queryParams.formula = $("#formula").val();
    queryParams["zhuangtai"] = zhuangtai;
    $('#ruleList').datagrid('options').queryParams = queryParams;
    $("#ruleList").datagrid("reload");
} 

 function conditionReset(){
	 $("#zhuangtai").combobox("setValue","");
	$('#name').val('');
	$('#formula').val('');
} 
</script>
<style type="text/css">
#fm {
	margin: 0;
	padding: 10px 30px;
}
#edifm {
	margin: 0;
	padding: 10px 30px;
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
</style>
</head>
<body id="homepage" class="bodyBG">
	<div>
		<div class="place">
			<span>位置：</span>
			<ul class="placeul">
					<li><%=request.getAttribute("path") %></li>
			</ul>
		</div>
	</div>
	<div class="con" id="con">
		<div id="tab_zzjs_1">
			<div class="indexSearchBox push" id="td" style="padding:10px;">
				<a href="javascript:add();" class="easyui-linkbutton"
					iconCls="icon-add" plain="true">新增</a> <a
					href="javascript:removeRules();" class="easyui-linkbutton"
					iconCls="icon-remove" plain="true">删除</a> <a
					href="javascript:enabled ();" class="easyui-linkbutton"
					iconCls="icon-check" plain="true">启用</a> <a
					href="javascript:disable () ;" class="easyui-linkbutton"
					iconCls="icon-disable" plain="true">禁用</a>
				<div style="float: right;">
					规则名称： <input class="easyui-validatebox" id="name" size="15px;"
						data-options="required:false" />
<!-- 						&nbsp; 规则公式： <input
						class="easyui-validatebox" type="text" id="formula" size="15px;"
						data-options="required:false" /> -->
						&nbsp; 状态：<input id="zhuangtai"
						style="width:120px;" class="easyui-combobox" panelHeight="auto"
						data-options="editable:false,valueField:'value',textField:'text',data:[{'value':'true','text':'启用'},{'value':'false','text':'禁用'}]" />&nbsp;
					<a href="javascript:void(0);" onclick="query();"
						class="easyui-linkbutton" iconCls="icon-search">查询</a> <a
						href="#" class="easyui-linkbutton" iconCls="icon-refresh"
						onclick="conditionReset();">重置</a>
				</div>
			</div>
			<div class="padT23">
				<table id="ruleList"></table>
			</div>
		</div>
	</div>

	<div id="dlg" class="easyui-dialog"
		style="width:400px;height:280px;padding:10px 20px" closed="true"
		buttons="#dlg-buttons">
		<form id="fm" method="post" action="add.action">
			<input type="hidden" id="id" name="rule.id" value="${id}" /> <input
				type="hidden" id="status1" value="${status}" /> <input
				type="hidden" id="ruleName1" value="${ruleName}" />
			<div class="fitem">
				<label>规则名称:</label> <input name="rule.name"
					class="easyui-validatebox"
					data-options="required:true,validType:'length[0,50]'" id="addname"
					maxlength="50">
			</div>
			<div class="fitem">
				<label>规则公式:</label> <input name="rule.formula"
					class="easyui-validatebox"
					data-options="required:true,validType:'length[0,500]'"
					id="addformula" maxlength="500">
			</div>
			<div class="fitem">
				<label>规则描述:</label> <input name="rule.formulaDesc"
					class="easyui-validatebox"
					data-options="required:true,validType:'length[0,500]'"
					id="addformulaDesc" maxlength="500">
			</div>
			<div class="fitem">
				<label>状态:</label> <input id="status" name="sfqiyong" class="easyui-combobox"
					panelHeight="auto" style="width:80px"></input>
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

	<div id="edidlg" class="easyui-dialog"
		style="width:400px;height:280px;padding:10px 20px" closed="true"
		buttons="#edidlg-buttons">
		<form id="edifm" method="post" action="a_update.action">
			 <input type="hidden" id="ediId" name="id" />
			<div class="fitem">
				<label>规则名称:</label> <input name="name"
					class="easyui-validatebox"
					data-options="required:true,validType:'length[0,50]'" id="ediname"
					maxlength="50">
			</div>
			<div class="fitem">
				<label>规则公式:</label> <input name="formula"
					class="easyui-validatebox"
					data-options="required:true,validType:'length[0,500]'"
					id="ediformula" maxlength="500">
			</div>
			<div class="fitem">
				<label>规则描述:</label> <input name="formulaDesc"
					class="easyui-validatebox"
					data-options="required:true,validType:'length[0,1500]'"
					id="ediformulaDesc" maxlength="500">
			</div>
			<div class="fitem">
				<label>状态:</label> <select id="edistatus" class="easyui-combobox"
					style="width:120px;" name="status" panelHeight="auto">
					<option type="radio" value="1">启用</option>
					<option type="radio" value="0">禁用</option>
				</select>
			</div>
		</form>
	</div>
	<div id="edidlg-buttons" style="text-align:center;padding:5px">
		<a href="javascript:void(0)" class="easyui-linkbutton"
			iconCls="icon-ok" onclick="edisubmitForm()">确定</a> 
		<a href="javascript:void(0)" class="easyui-linkbutton"
			iconCls="icon-cancel" onclick="javascript:$('#edidlg').dialog('close')"
			style="width:66px">取消</a>
	</div>



</body>
</html>

