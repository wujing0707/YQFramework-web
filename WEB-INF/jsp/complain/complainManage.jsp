<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/tlds/WaFramework.tld" prefix="wf"%>
<%@ taglib uri="http://java.sun.com/jstl/fmt_rt" prefix="fmt" %>   
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String basePath = request.getScheme() + "://" + request.getServerName() 
			+ ":" + request.getServerPort() + request.getContextPath() + "/";
	pageContext.setAttribute("basePath", basePath);
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>异议申诉</title>
	 <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css" />
	<link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.4/themes/bootstrap/easyui.css">
    <link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.4/themes/icon.css">
    <link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.4/themes/color.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/themes/icon-suit-a.css">
    
     <script type="text/javascript" src="<%=basePath%>js/commonUtils.js"></script>
     <script type="text/javascript" src="<%=basePath%>js/jquery-1.10.2.min.js"></script>

    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.4/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.4/locale/easyui-lang-zh_CN.js"></script> 
     <script type="text/javascript" src="<%=basePath%>js/base.js"></script>
     <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-extend.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.4/extension/jquery-easyui-datagridview/datagrid-detailview.js"></script>
	<style type="text/css">
		td {
			padding-right: 10px;
		}
		.datagrid-btable .datagrid-cell {
			padding: 6px 4px;
			overflow: hidden;
			text-overflow: ellipsis;
			white-space: nowrap;
		}
	</style>
</head>
<body style="width:100%;height:100%;">
  		<div class="place">
			<span>位置：</span>
			<ul class="placeul">
				<li><%=request.getAttribute("path") %></li>
			</ul>
		</div>
	<div style="padding:5px;height:auto">
		<div style="margin-bottom:5px">
			<form id="qform">
				  申诉人：
         	<input id="searchName" class="easyui-input" style="width: 90px">&nbsp;
         	 申诉类型：
         	<select name="comptype" id="comptype" class="easyui-combobox" style="width:90px" data-options="editable:false"  >
         		<option value="">--请选择--</option>
         		<option value="P">个人</option>
         		<option value="C">企业</option>
         		
         	</select> &nbsp;
			 <label>开始时间：</label>
           	<input id="conditionStartDate" class="easyui-datetimebox" editable="false"  style="width:150px">&nbsp;
           	<label>结束时间：</label>
           	<input id="conditionEndDate" class="easyui-datetimebox" editable="false"  style="width:150px" > &nbsp;
                                          处理状态：                      
         	<select name="handleStatus" id="handleStatus" class="easyui-combobox"  style="width:90px" data-options="editable:false" >
         		<option value="">--请选择--</option>
         		<option value="NONE">未处理</option>
         		<option value="HANDLING">处理中</option>
         		<option value="CHECKED">已处理</option>
         		<option value="DONE">已完成</option>
         	</select> 
			<a href="#" class="easyui-linkbutton" iconCls="icon-search" onclick="conditionSearch();">查询</a>
			<a href="#" class="easyui-linkbutton" iconCls="icon-refresh" onclick="clearSearch();">重置</a>
			<form>
			<input type="hidden" id="cdepid" value="${depid }">
			<input type="hidden" id="currentDepName" value="${currentDepName }">
			</div>
		</div>
	</div>
	
		<div>
		<table id="complainGrid">
		</table>
	</div>

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
	
	function clearSearch(){
	 
		$('#qform').form('reset');
	}
	function formatTitle(value){
		return "<span title='"+value+"'>"+value+"</span>";
	}
	$(function() {
	
	$("#complainGrid").datagrid({
    	height:380,
		striped: true,
		rownumbers: true,
		checkOnSelect:false,
		pagination: true,
		toolbar: '#tb',
		iconCls:'icon-user',
		fitColumns: true,
		singleSelect:true ,
        url:'${pageContext.request.contextPath}/complain/complainlist.action', 
        loadMsg: "载入中...请等待.",
        onLoadSuccess : function () {
			 $(this).datagrid("fixRownumber");
				    },
        columns:[[
            {field:"name",
             title:"申诉人",
             width:100,
             align:'left',										
             formatter : function(value) {return "<span title='"+value+"'>"+value+"</span>";}
			},
            {field:"phoneNumber",
			 title:"电话",
			 width:100,
			 align:'left', 
			 formatter : function(value) {return "<span title='"+value+"'>"+value+"</span>";}
			},
         	{field:"subject",title:"申诉主题",width:250,align:'left',formatter:formatTitle},
         	{field:"type",title:"申诉类型",width:80,align:'left',formatter : function(value) {
											if(value=="P"){
													return "个人";
											}else if (value=="C"){
													return "企业";
											}
										}
			},
         	{field:"complainTime",title:"申诉时间",width:150,align:'left'},
         	{field:"handleDep",title:"处理部门",width:150,align:'left'},
         	{field:"handleStatus",title:"处理状态",width:150,align:'left',formatter:handleStatusFormater},
         	{field:"id",title:"操作",width:150,align:'left',formatter:function(value, row, index){
         		var depid=$("#cdepid").val();
         		var currentDepName = $("#currentDepName").val();
         		var hhtml="";
         		if(depid=="999"&&row.handleStatus!='DONE'){
         		//if(depid=="999"&&row.handleDep==''){
         			hhtml= "&nbsp;&nbsp;&nbsp;<span><a class='tablelink' style='font-size:12px;color:blue' href='javascript:handleComplain(&#039;"+value+"&#039;)'>处理</a></span>";
         		}
         		if(depid!="999"&&row.handleStatus=="HANDLING"&&row.handleDep==currentDepName){//如果不是xyb，那么只能处理HANDLing状态
         			//if(depid!="999"){
         			hhtml= "&nbsp;&nbsp;&nbsp;<span><a class='tablelink' style='font-size:12px;color:blue' href='javascript:handleComplain(&#039;"+value+"&#039;)'>处理</a></span>";
         		}
         		var vhtml = "<span><a class='tablelink' style='font-size:12px;color:blue' href='javascript:viewComplain(&#039;"+value+"&#039;)'>查看</a></span>";
         		return vhtml+hhtml;
         	}},
         	
        ]]
      
    });
	
});
	
	function viewComplain(cid){
		var node = $('#complainGrid').datagrid('getSelected');
		if(node!=null){
			window.location.href='<%=basePath%>complain/viewComplain.action?cid=' + cid;
		}
	}
	
	
	function handleComplain(cid){
		var node = $('#complainGrid').datagrid('getSelected');
		if(node!=null){
			window.location.href='<%=basePath%>complain/handleComplain.action?cid=' + cid;
		}
	}
	
	function conditionSearch() {
    var startTime2 = $('#conditionStartDate').datetimebox('getValue');
    var endTime2 = $('#conditionEndDate').datetimebox('getValue');
    
	    if(startTime2){
			var d1 = $.fn.datebox.defaults.parser(startTime2);
			var d2 = $.fn.datebox.defaults.parser(endTime2);
			var nw = new Date();
		if(d1>nw){
			$.messager.alert('警告','开始时间不能大于当前时间','warning');
			return;
		}
		if(d1>d2){
			$.messager.alert('警告','结束时间要大于开始时间','warning');
			return;
			}
		}
		
 		setFirstPage("#complainGrid");
		var name = $.trim($('#searchName').val());
		var status = $.trim($('#handleStatus').combobox('getValue'));
    	var comptype = $.trim($('#comptype').combobox('getValue'));
		var queryParams = new Object();
		queryParams["name"] = name;
		queryParams["status"] = status;
		queryParams["comptype"] = comptype;
		if(startTime2&&startTime2.length>0){
			queryParams["startDate"] = startTime2;
		}
		if(endTime2&&endTime2.length>0){
			queryParams["endDate"] = endTime2;
		}
		$('#complainGrid').datagrid('options').queryParams = queryParams;
		$('#complainGrid').datagrid('reload');
	}
	
	function handleStatusFormater(value,row,index){
		if(value=="NONE"){
			return "未处理";
		}else if (value=="HANDLING"){
			return "处理中";
		}else if (value=="DONE"){
			return "已完成";
		}else if (value=="CHECKED"){
			return "已处理";
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


    </script>	
</body>
</html>