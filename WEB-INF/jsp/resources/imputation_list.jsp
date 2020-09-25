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
<link type="text/css" rel="stylesheet" 	href="${pageContext.request.contextPath}/css/styles.css" />
<link rel="stylesheet" type="text/css" 	href="${pageContext.request.contextPath}/js/jquery-easyui-1.4/themes/bootstrap/easyui.css">
<link rel="stylesheet" type="text/css" 	href="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/themes/icon.css">
<link rel="stylesheet" type="text/css" 	href="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/themes/icon-suit-a.css">
<script type="text/javascript" 	src="${pageContext.request.contextPath}/js/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-easyui-1.4/jquery.easyui.min.js"></script>
<script type="text/javascript" 	src="${pageContext.request.contextPath}/js/jquery-easyui-1.4/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" 	src="${pageContext.request.contextPath}/js/commonUtils.js"></script>
<script type="text/javascript" 	src="${pageContext.request.contextPath}/js/commonCheck.js"></script>
<title>元数据管理</title>
<script type="text/javascript">
var oldCount;
var editIndex = undefined;
var yesOrNo = [{ "value": "1", "text": "是" }, { "value": "2", "text": "否" }];
function yesNoformatter(value, rowData, rowIndex) {
    if (value == 0) {
        return;
    }
    for (var i = 0; i < yesOrNo.length; i++) {
        if (yesOrNo[i].value == value) {
            return yesOrNo[i].text;
        }
    }
}
var openClose = [{ "value": "1", "text": "授权公开" }, { "value": "2", "text": "全公开" }];
function openformatter(value, rowData, rowIndex) {
    if (value == 0) {
        return;
    }
    for (var i = 0; i < openClose.length; i++) {
        if (openClose[i].value == value) {
            return openClose[i].text;
        }
    }
}


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
    	height:370,
		striped: true,
		rownumbers: true,
		checkOnSelect:false,
		pagination: true,
		toolbar: '#tb',
		iconCls:'icon-user',
		singleSelect:true ,
        url:"${pageContext.request.contextPath}/imputation/list.action", 
        loadMsg: "载入中...请等待.",
        onLoadSuccess : function () {
			 $(this).datagrid("fixRownumber");
			 $(this).datagrid("resize");
				    },
        columns:[[
            {field:"bumen",title:"部门",width:'20%',align:'left'},
            {field:"guijimc",title:"归集名称",width:'30%',align:'left',formatter : function(value) {return "<span title='"+value+"'>"+value+"</span>";}},
            {field:"zhouqi",title:"归集周期",width:'10%',align:'left'},
            {field:"biaoshi",title:"实体名",width:'20%',align:'left'},
            {field:"sfqiyong",title:"状态",width:'10%',align:'left',formatter:function(value){if(value==0)return '启用';else return '禁用';}},
            {field:"opr",title:"操作",width:'10%',align:'left',formatter: function (value, row, index) {
            	return "<a href='#' class='tablelink' style='font-size:12px;color:blue' onclick='showQueryTip(&#039;"+row.id+"&#039;,&#039;"+row.biaoshi+"&#039;)'>"+"字段维护 "+"</a>";
                }
            }
        ]]
      
    });
    
    $("#ENABLEDS").combobox({
	    editable: false,
	    panelHeight: "auto",
	    data:[{value:'0',text:'启用'},{value:'1',text:'禁用'}],
	    valueField: "value",
	    textField: "text"
	   
 	});
});
var bumenURL = "${pageContext.request.contextPath}/system/guijixx/getDepartment.action";
jQuery(function(){
	$.getJSON(bumenURL, function(json) {
		$("#bmName").combobox({
			data : json.rows,
			valueField:'value',
			textField:'text'
		});
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


function conditionSearch(){
	setFirstPage("#dg");
	var gjxxmc = $.trim($('#conditionName').val());
	var codeId = $.trim($('#bmName').combobox('getValue'));
	var status = $.trim($('#statusSch').combobox('getValue'));
	var queryParams = $('#dg').datagrid('options').queryParams;
	queryParams["bmName"] = codeId;
	queryParams["conditionName"] = gjxxmc;
	queryParams["status"] = status;
    $('#dg').datagrid('options').queryParams = queryParams;
    $("#dg").datagrid('reload');
}
//重置
function clearSearch(){
	$('#conditionName').val('');
	$('#bmName').combobox('clear');
	$('#statusSch').combobox('clear');
}
//点击添加
function newUser(){
	$('#fm').form('clear');
	$('#dlg').window({
    			modal:true
			});
	$('#dlg').dialog('open').dialog('setTitle','新增归集信息');
	var urls = "${pageContext.request.contextPath}/system/guijixx/getDepartment.action";
	jQuery(function(){
		$.getJSON(urls, function(json) {
			$("#suosubumen").combobox({
				data : json.rows,
				valueField:'value',
				textField:'text'
			});
		});
	});
	var url="${pageContext.request.contextPath}/imputation/getDate.action";
	jQuery(function(){
		$.getJSON(url, function(json) {
			$("#guijizhouqi").combobox({
				data : json.rows,
				valueField:'value',
				textField:'text'
			});
		});
	});
	$("#ENABLEDS").combobox("setValue","0");
	
}
//点击添加确定
function submitForm() {
	$('#fm').form('submit', {
	    success: function(data){
	        var data = eval('(' + data + ')');  // change the JSON string to javascript object
	       
	        if (!data.result){
	        	$.messager.alert('失败','新增归集信息维护失败,实体名不能重复!','error');
	        }
	        else{
	        	$.messager.alert('提示',"新增归集信息成功！");
	        	$('#dg').datagrid('reload');
		        $('#dlg').dialog('close');
	        }
	        
	    }
	});
}

//删除
function destroyUser() {
	var ids =getSelectionsIds ();

	if (ids.length <= 0) {
		$.messager.alert('提示',"请选择要删除的内容！");
		return;
	}
	if (ids.length != 0) {
		$.messager.confirm("提示", "确认删除归集信息吗？字段维护的信息也会被删除！", function(r) {
		if (r) {
			$.post("${pageContext.request.contextPath}/imputation/a_removeList.action",  {"ids" : ids},
					function(data) {
						if (data.result == true) {
							$.messager.alert('提示', "归集信息删除成功！");
							$('#dg').datagrid('reload');
						} else if (data.result == false)  {
							$.messager.alert('提示',"归集信息删除失败！");
						} 
				}, "json");
			}
		});
	}
}

function getHtmlInfo(s){
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

//取多个combox
function getSelectionsIds () {
	var checkItems = $('#dg').datagrid('getSelections');
	var ids = "";
	$.each(checkItems, function (index, item) {
		ids +=  item.id + ",";
	});
	
	ids = ids.substring(0, ids.length-1);

	return ids;
}
//点击修改的按钮
function editUser(){
	var dep = "${pageContext.request.contextPath}/system/guijixx/getDepartment.action";
	$.ajaxSettings.async = false; 
	jQuery(function(){
		$.getJSON(dep, function(json) {
			$("#bumen").combobox({
				data : json.rows,
				valueField:'value',
				textField:'text'
			});
		});
	});
	var url="${pageContext.request.contextPath}/imputation/getDate.action";
	jQuery(function(){
		$.getJSON(url, function(json) {
			$("#guizhou").combobox({
				data : json.rows,
				valueField:'value',
				textField:'text'
			});
		});
	});
   	
		var node = $('#dg').datagrid('getSelected');
		if(node != null){
			$('#ID').val(node.id);  
           	$("#guiji").val(getHtmlInfo(node.guijimc));
           	$("#guiji").attr("readonly", true);
         	$("#bumen").combobox("setText",node.bumen);
         	$("#bumen").combobox("setValue",node.bumenId);
         	$("#guizhou").combobox("setValue",node.zhouqivalue);
         	$("#guizhou").combobox("setText",node.zhouqi);
         	$("#biaoshiedi").val(node.biaoshi);
         	$("#biaomingshiti_edit").val(node.biaoshi);
         	$("#biaoshiedi").attr("readonly", true);
          	$("#sfq").combobox("setValue",node.sfqiyong);
          	$('#winEdit').window({
    			modal:true
			});
			$('#winEdit').window('open');
			$.ajaxSettings.async = true;
		}else{
			$.messager.alert('选择','请先选择要编辑的归集信息!','info');
		}
	}
//点击修改保存
function editSubmit(){
    	$('#editForm').form('submit', {
    	    success: function(data){
    	        var data = eval('(' + data + ')');  // change the JSON string to javascript object
    	     
    	        if (!data.result){
    	        	$.messager.alert('失败','编辑归集信息失败!','error');
    	        }else{
    	        	$.messager.alert('提示',"归集信息编辑成功！");
    	        	 $('#dg').datagrid('reload');
    	    	     $('#winEdit').dialog('close');
    	        }
    	       
    	    }
    	});
   
    }
    

function endEditing(){
	if (editIndex == undefined){return true;}
	if ($('#Zddg').datagrid('validateRow', editIndex)){
		$('#Zddg').datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}

function newtable(){
	if (endEditing()){
		$('#Zddg').datagrid('appendRow',{status:'P',length:'200',isnull:'1', isopen:'1'});
		//editIndex = $('#dg').datagrid('getRows').length-1;
		//$('#Zddg').datagrid('selectRow', editIndex)
				//.datagrid('beginEdit', editIndex);
	}
}
//字段维护
 function showQueryTip(id,biaoshi){
 	$('#winZdHandle').window({
    			modal:true
			});
	 $('#winZdHandle').window('open');
	 $("#delBtn").linkbutton("enable");
	 $("#addBtn").linkbutton("enable");
	 $("#saveBtn").linkbutton("enable");
	 $("#cancelId").linkbutton("enable");
	 editIndex=undefined;
	 $('#tableid').val(id); 
	 $('#biaoshi').val(biaoshi); 
	 $("#Zddg").datagrid({
	    	height:330,
			striped: true,
			rownumbers: true,
			checkOnSelect:false,
			pagination: false,
			toolbar: '#zd',
			iconCls:'icon-user',
			singleSelect:true ,
	        url:"${pageContext.request.contextPath}/imputation/tablelist.action?id="+id, 
	        loadMsg: "载入中...请等待.",
	       
	        columns:[[
	            {field:"excelziduan",title:"字段名",width:120,align: 'center',editor: { type: 'validatebox', options: { required: true,validType:['length[0,20]','englishCheckSub'] } } ,
										formatter : function(value) {
											if (typeof(value) == "undefined") { 
												return "";
											}else{
												return "<span title='"+value+"'>"+value+"</span>";
											}
										}},
	            {field:"ziduanming",title:"字段描述",width:120,align: 'center',editor: { type: 'validatebox', options: { required: true,validType:'length[0,32]' } } ,
										formatter : function(value) {
											if (typeof(value) == "undefined") { 
												return "";
											}else{
												return "<span title='"+value+"'>"+value+"</span>";
											}
										}},
	            {field:"length",title:"字段长度",width:120,align: 'center', editor: { type: 'validatebox', options: { required: true,min:2,max:3000,editable:false} } },
	            {field:"isnull",title:"允许为空",width:120,formatter: yesNoformatter, align: 'center', editor: { type: 'combobox', options: { data: yesOrNo, valueField: "value", textField: "text",required: true,editable:false } } },
	            {field:"isopen",title:"允许公开",width:120,formatter: openformatter, align: 'center', editor: { type: 'combobox', options: { data: openClose, valueField: "value", textField: "text",required: true,editable:false } } }
	        ]],
	        onLoadSuccess: function(){
				 $(this).datagrid("fixRownumber");
				oldCount = $('#Zddg').datagrid("getRows").length;	// 原来的行数
			}
	    });
 }
 
 function onClickRow(index){
	if (editIndex != index){
		if (endEditing()){
			if(index < oldCount){
				// 原来你存在的字段，部分列不让编辑
				$('#Zddg').datagrid('selectRow', index).datagrid('beginEdit', index);
				var ed_excelziduan = $('#Zddg').datagrid('getEditor', {index: index,field:'excelziduan'});
				$(ed_excelziduan.target).attr("disabled","disabled");
				var ed_ziduanming = $('#Zddg').datagrid('getEditor', {index: index,field:'ziduanming'});
				$(ed_ziduanming.target).attr("disabled","disabled");
				var ed_fieldlength = $('#Zddg').datagrid('getEditor', {index: index,field:'length'});
				$(ed_fieldlength.target).attr("disabled","disabled");
				var ed_isNull = $('#Zddg').datagrid('getEditor', {index: index,field:'isnull'});
				$(ed_isNull.target).combobox("disable");
				var ed_isOpen = $('#Zddg').datagrid('getEditor', {index: index,field:'isopen'});
				$(ed_isOpen.target).combobox("disable");
				editIndex = index;
			}else{
				$('#Zddg').datagrid('selectRow', index).datagrid('beginEdit', index);
				editIndex = index;
			}
		} else {
			$('#Zddg').datagrid('selectRow', editIndex);
		}
	}
}

 
// 提交保存
	function submitSave(){
		$("#Zddg").datagrid('endEdit', editIndex);
		var fields = new Array();
		var zdmingfields = new Array();
		var allRows = $("#Zddg").datagrid('getRows');
        //如果调用acceptChanges(),使用getChanges()则获取不到编辑和新增的数据。
        //使用JSON序列化datarow对象，发送到后台。
        var changeRows = $("#Zddg").datagrid('getChanges');
        if(changeRows.length == 0){
			$.messager.alert('提示','请至少新增一个列');
			return;
		}
		for(var i = 0; i < changeRows.length; i++){
			if(changeRows[i].excelziduan == null || changeRows[i].ziduanming == null || changeRows[i].isnull == null || changeRows[i].isopen == null){
				$.messager.alert('提示',"存在未输入的必输项或者输入项不符合验证规则！");
				return; 
			}
			
		}
        for (var j = 0; j < changeRows.length; j++){
            if(changeRows[j].length <= 0 || changeRows[j].length > 4000){
                $.messager.alert('提示',"字段长度最大为4000！");
                return;
            }
        }
		// 判断 字段名 是否有重复
//		var newfields = fields.sort();
//		if(newfields.length > 1){
//		for (var i = 0; i < newfields.length-1; i++) {
//			if (newfields[i].toLowerCase() == newfields[i + 1].toLowerCase()) {
//				$.messager.alert('提示',"字段名'"+newfields[i]+"'有重复");
				//$('#Zddg').datagrid('cancelEdit', editIndex).datagrid('deleteRow', editIndex);
//				editIndex = undefined;
//				return;
//			}
//		}
//		}
		  for(var i = 0; i < allRows.length; i++){
				fields.push(allRows[i].excelziduan);
			}
		if(fields.length > 1){
		var s = fields.join(",")+",";
		for(var i=0;i<fields.length;i++) {
		if(s.replace(","+fields[i]+",","").indexOf(","+fields[i].toUpperCase()+",")>-1) {
			$.messager.alert('提示',"字段名'"+fields[i]+"'有重复");
			//$('#Zddg').datagrid('cancelEdit', editIndex).datagrid('deleteRow', editIndex);
			editIndex = undefined;
			return;
		}

		}
		}
		//中文名重复判断
		for(var i = 0; i < allRows.length; i++){
				zdmingfields.push(allRows[i].ziduanming);
			}
			if(zdmingfields.length > 1){
				var zds = zdmingfields.join(",")+",";
				for(var i=0;i<zdmingfields.length;i++) {
				if(zds.replace(","+zdmingfields[i]+",","").indexOf(","+zdmingfields[i]+",")>-1) {
					$.messager.alert('提示',"字段描述'"+zdmingfields[i]+"'有重复");
					//$('#Zddg').datagrid('cancelEdit', editIndex).datagrid('deleteRow', editIndex);
					editIndex = undefined;
					return;
				}

				}
				}
		
		
		$("#delBtn").linkbutton("disable");
		$("#addBtn").linkbutton("disable");
		$("#saveBtn").linkbutton("disable");
		$("#cancelId").linkbutton("disable");
        // 将 datagrid 中的数据构建成 json 格式的数据
		var jsonColumns = JSON.stringify(changeRows);
		// console.info(jsonColumns);
		var url = "${pageContext.request.contextPath}/system/guijixx/addColumns.action";
		$.post(url, {tableId: $("#tableid").val(), tableName: $.trim($("#biaoshi").val()), columns: jsonColumns}, 
			function(data){
				if(data.result){
					$.messager.alert('提示',"保存成功,并且保存后不能删除","info",function(){
						$('#winZdHandle').dialog('close');
					});
				}else{
					$.messager.alert('提示',"保存失败","warning"
					,function(){
						$('#winZdHandle').dialog('close');
					});
				}
			}
		,"json");
	}
	
 
//点击字段维护的确定
function tablesubmitForm() {

	$('#newtfrm').form('submit', {
	    success: function(data){
	        var data = eval('(' + data + ')');  // change the JSON string to javascript object
	        if (!data.result){
	        	$.messager.alert('失败','新增字段名称不能重复 !','error');
	        }
	        else{
	        	$.messager.alert('提示',"归集信息字段新增成功！");
	        	$('#Zddg').datagrid('reload');
		        $('#newtables').dialog('close');
	        }
	        
	    }
	});
	
}



//删除字段维护
function destroytable() {
	var zddg = $('#Zddg').datagrid('getSelected');
	var shitim=$('#biaoshi').val(); 
	var ids =getSelectionsId ();
	if (ids.length <= 0) {
		$.messager.alert('提示',"请选择要删除的内容！");
		return;
	}
	if(oldCount>editIndex){
		$.messager.alert('提示',"已有的列不可删除！");
		return;
	}
	$('#Zddg').datagrid('cancelEdit', editIndex).datagrid('deleteRow', editIndex);
	editIndex = undefined;
}
//取多个combox
function getSelectionsId () {
	var checkItem = $('#Zddg').datagrid('getSelections');
	var ids = "";
	$.each(checkItem, function (index, item) {
		ids +=  item.id + ",";
	});
	ids = ids.substring(0, ids.length-1);
	return ids;
}

//点击修改的按钮
function edittable(){
	
		var node = $('#Zddg').datagrid('getSelected');

		if(node != null){
			//alert(node.ziduanming);
			//$("#zc").combobox("setValue",node.ziduanming);
			$("#zc").val(node.ziduanming);
           	$('#zdKey').val(node.id);
        	//$('#guiid').val(node.guijixinxiid);
        	$('#zdOldLength').val(node.length);
        	//$('#zdLength').val(node.length);
        	$("#zdLength").numberbox('setValue', node.length);
           	$('#ziduanms').val(node.excelziduan);
           	$('#zdCode').val(node.excelziduan);
           	$('#isopen').combobox("setValue", node.isopen);
         //	var en=	node.sfqiyong;
          // $("#qiyong").combobox("setValue",en);
           $.ajaxSettings.async = true; 
			$('#tableEdit').window('open');
		}else{
			$.messager.alert('选择','请先选择要编辑的字段维护!','info');
		}
	}
//点击修改保存
function edittableSubmit(){
	if(parseInt($("#zdLength").numberbox('getValue'))<parseInt($("#zdOldLength").val())){
		alert('字段长度修改只能增大不能缩短');
	}else{
		$('#edittableForm').form('submit', {
	    success: function(data){
	        var data = eval('('+data+')');  // change the JSON string to javascript object
	        if (!data.result){
	        	$.messager.alert('失败','编辑字段维护失败!','error');
	        }else{
	        	$.messager.alert('提示',"编辑字段维护成功！");
	        	 $('#Zddg').datagrid('reload');
	    	     $('#tableEdit').dialog('close');
	        }
	       
	    }
	});
	
	}
    	
    }
    
    //启用禁用
    function userEnable(){
			var node = $('#dg').datagrid('getSelected');
			if(node != null){
               	$.post("${pageContext.request.contextPath}/imputation/enable.action" ,{"id" : node.id}, function(data){
               		if (!data){
        	        	$.messager.alert('失败','启用/禁用失败!','error');
        	        } else {
        	        	$.messager.alert('成功','启用/禁用成功!','info');
	           	        $('#dg').datagrid('reload');
        	        }
               	});
			}else{
				$.messager.alert('选择','请先选择要启用/禁用的归集信息!','warning');
			}
		}

    //删除
    function deleteImpu(){
        alert(1);
			var node = $('#dg').datagrid('getSelected');
			if(node != null){
               	$.post("${pageContext.request.contextPath}/imputation/delete.action" ,{"id" : node.id}, function(data){
               		if (!data){
        	        	$.messager.alert('失败','删除失败!','error');
        	        } else {
        	        	$.messager.alert('成功','删除成功!','info');
	           	        $('#dg').datagrid('reload');
        	        }
               	});
			}else{
				$.messager.alert('选择','请先选择要删除的归集信息!','warning');
			}
		}
</script>

<style type="text/css">
#fm {
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
<body style="height:450px">
	<div class="padT23">
		<div id="tb" style="padding:5px;height:auto">
			<a href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-add" plain="true" onclick="newUser()">新增</a> <a
				href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-edit" plain="true" onclick="editUser()">编辑</a> <a
				href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-disable" plain="true" onclick="userEnable()">启用/禁用</a>
				<!--<a
				href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-disable" plain="true" onclick="deleteImpu()">删除</a>-->

			<div style="float: right;">
				请选择部门：<input id="bmName" class="easyui-combobox" style="width:120px"
					data-options="editable:false">&nbsp;&nbsp; 归集名称：<input
					id="conditionName" class="easyui-input" style="width:120px">
					状态：<input id="statusSch" style="width:120px" class="easyui-combobox" panelHeight="auto" data-options="editable:false,valueField:'value',textField:'text',data:[{'value':'0','text':'启用'},{'value':'1','text':'禁用'}]"/>
				<a href="#" class="easyui-linkbutton" iconCls="icon-search"
					onclick="conditionSearch();">查询</a> <a href="#"
					class="easyui-linkbutton" iconCls="icon-refresh"
					onclick="clearSearch();">重置</a>
			</div>
		</div>
		<div class="place">
			<span>位置：</span>
			<ul class="placeul">
					<li><%=request.getAttribute("path") %></li>
			</ul>
		</div>
		<table id="dg" style="width:100%;"></table>
	</div>
	
	<!-- 弹出的新增归集信息窗口 -->
	<div id="dlg" class="easyui-window"
		style="width:500px;height:280px;padding:10px 20px" closed="true"
		buttons="#dlg-buttons">

		<form id="fm" method="post" action="add.action">

			<div class="fitem">
				<label>归集信息名称:</label> <input name="guijixinximingcheng"
					class="easyui-validatebox" id="guijixinximingcheng"
					data-options="required:true,validType:'length[0,50]'"
					maxlength="50" style="width:250px">
			</div>
			<div class="fitem">
				<label>部门:</label> <input name="suosubumen" class="easyui-textbox"
					id="suosubumen" data-options="required:true,editable:false"
					data-options="editable:false" style="width:180px">
			</div>
			<div class="fitem">
				<label>实体名:</label> <input name="biaomingshiti"
					class="easyui-validatebox" id="biaomingshiti"
					data-options="required:true,validType:['length[0,20]','englishCheckSub']"
					maxlength="20" style="width:190px">
			</div>
			<div class="fitem">
				<label>归集周期:</label> <input name="guijizhouqi"
					class="easyui-textbox" id="guijizhouqi"
					data-options="required:true,editable:false" panelHeight="auto" style="width:80px">
			</div>
			<div class="fitem">
				<label>状态:</label> <select id="ENABLEDS" name="sfqiyong"
					panelHeight="auto" style="width:80px"></select>
			</div>
		</form>
	 
		<div id="add-buttons" style="text-align:center;padding:5px">
			<a href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-ok" onclick="submitForm()">确定</a> 
			<a href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-cancel" onclick="javascript:$('#dlg').dialog('close')"
				style="width:66px">取消</a>
		</div>
		
	</div>

	<!-- 弹出修改归集信息的窗口 -->
	<div id="winEdit" class="easyui-window" title="编辑归集信息"
		data-options="iconCls:'icon-add', closed:true, border:false"
		style="width:500px;height:300px;padding:10px 20px;">
		<form id="editForm" method="post" action="edit.action">
			<input type="hidden" name="ID" id="ID" value="">
			<input  id="biaomingshiti_edit" type="hidden" name="biaomingshiti"></input>
			<table style="border-collapse:separate; border-spacing:10px;">
				<tr>
					<td align="right">归集信息名称:</td>
					<td><input class="easyui-validatebox" type="text" id="guiji" disabled="true"
						name="guijixinximingcheng" data-options="editable:false" style="width:250px"></input>
					</td>
				</tr>
				<tr>
					<td align="right">部门:</td>
					<td><input class="easyui-textbox" id="bumen" name="suosubumen" 
						data-options="required:true,editable:false"  style="width:180px"></input>
					</td>
				</tr>
				<tr>
					<td align="right">归集周期:</td>
					<td><input class="easyui-textbox" id="guizhou"
						style="width:80px;" name="guijizhouqi"
						data-options="required:true" panelHeight="auto" ></input></td>
				</tr>
				<tr>
					<td align="right">实体名:</td>
					<td><input class="easyui-validatebox" id="biaoshiedi" type="text" disabled="true"
						name="biaoshieditor" data-options="editable:false" style="width:190px"></input>
					</td>
				</tr>
				<tr>
					<td align="right">状态:</td>
					<td><select id="sfq" class="easyui-combobox"
						style="width:80px;" name="sfqiyong" panelHeight="auto">
							<option type="radio" value="0">启用</option>
							<option type="radio" value="1">禁用</option>
					</select></td>
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


	<!-- 字段维护页面 -->
	<div id="winZdHandle" class="easyui-window" title="字段维护"
		data-options="iconCls:'icon-add', closed:true, border:false"
		style="width:600px;height:400px;padding:10px 20px;">

		<div>
			<table id="Zddg" class="easyui-datagrid"
				data-options="onClickRow: onClickRow"></table>
			<div id="zd" style="padding:5px;height:auto">
				<a href="javascript:void(0)" class="easyui-linkbutton"
					iconCls="icon-add" plain="true" onclick="newtable()" id="addBtn">新增</a>
				<a href="javascript:void(0)" class="easyui-linkbutton"
					iconCls="icon-remove" plain="true" onclick="destroytable()"
					id="delBtn">删除</a> 
					<a href="javascript:void(0)" class="easyui-linkbutton"
					iconCls="icon-edit" plain="true" onclick="edittable()"
					id="delBtn">修改</a>
				<a href="javascript:void(0)"
					class="easyui-linkbutton" iconCls="icon-save" plain="true"
					onclick="submitSave()" id="saveBtn">确定</a>
			</div>

		</div>
	</div>

	<!-- 弹出的字段维护的新增-->

	<div id="newtables" class="easyui-dialog"
		style="width:400px;height:280px;padding:10px 20px" closed="true"
		buttons="#dlg-buttons">

		<form id="newtfrm" method="post" action="tableadd.action">
			<input type="hidden" name="tableid" id="tableid" value="">
			<div class="fitem">
				<label>字段描述:</label> <input name="zdms" class="easyui-validatebox"
					id="zdms" data-options="required:true,validType:['length[0,100]','symbolCheckSub']">

			</div>
			<div class="fitem">
				<label>字段名称:</label> <input name="zdmc" class="easyui-textbox"
					id="zdmc" data-options="required:true,editable:false">
			</div>
			<div class="fitem">
				<label>是否查询:</label> <select id="sfqiyong" class="easyui-combobox"
					style="width:120px;" name="sfqiyong" panelHeight="auto">
					<option type="radio" value="1">是</option>
					<option type="radio" value="0">否</option>
				</select>
			</div>
		</form>

		<div id="dlg-buttons">
			<a href="javascript:void(0)" class="easyui-linkbutton c6"
				iconCls="icon-ok" onclick="tablesubmitForm()" style="width:66px">保存</a>
			<a href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-cancel"
				onclick="javascript:$('#newtables').dialog('close')"
				style="width:66px">关闭</a>
		</div>
	</div>

	<!-- 弹出修改的字段维护的窗口 -->
	<div id="tableEdit" class="easyui-window" title="编辑字段维护信息"
		data-options="iconCls:'icon-add', closed:true, border:false"
		style="width:500px;height:250px;padding:10px 20px;">
		<form id="edittableForm" method="post" action="edittable.action">
			<input type="hidden" name="zdKey" id="zdKey" value="">
			<!-- <input type="hidden" name="guiid" id="guiid" value=""> --> 
			<input	type="hidden" name="biaoshi" id="biaoshi" value="">
			<input	type="hidden" name="zdOldLength" id="zdOldLength" value=""><!-- 字段原长度 -->
			<input	type="hidden" name="zdCode" id="zdCode" value="">
			<table style="border-collapse:separate; border-spacing:10px;">
				<tr>
					<td align="right">字段名:</td>
					<td><input class="easyui-validatebox" id="ziduanms"
						name="ziduanms" disabled="disabled"
						data-options="required:true,validType:'length[0,100]'"></input>
					</td>
				</tr>
				<tr>
					<td align="right">字段描述:</td>
					<td><input name="zdmc" class="easyui-validatebox" id="zc" 
					disabled="disabled"
						data-options="required:true"></td>
				</tr>
				<tr>
					<td align="right">字段长度:</td>
					<td><input name="zdLength" class="easyui-numberbox" id="zdLength" 
					min="1" max="4000"  required="true" missingMessage="必须填写1~4000之间的整数"
						></td>
				</tr>
				<tr>
					<td align="right">允许公开:</td>
					<td><select id="isopen" class="easyui-combobox" data-options="required:true,editable:false" style="width:130px" name="isopen" panelHeight="auto">
						<option value="1">授权公开</option>
						<option value="2">全公开</option>
					</select><td>
				</tr>
			</table>
		</form>
		<div style="text-align:center;padding:5px">
			<a href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-ok" onclick="edittableSubmit()">确定</a> <a
				href="javascript:void(0)" class="easyui-linkbutton"
				iconCls="icon-cancel" onclick="$('#tableEdit').dialog('close');">关闭</a>
		</div>
	</div>
</body>