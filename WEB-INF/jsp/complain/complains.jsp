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
	 <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/styles1.css" />
	<link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.4/themes/bootstrap/easyui.css">
    <link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.4/themes/icon.css">
    <link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.4/themes/color.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/themes/icon-suit-a.css">
    
     <script type="text/javascript" src="<%=basePath%>js/commonUtils.js"></script>
     <script type="text/javascript" src="<%=basePath%>js/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.4/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.4/locale/easyui-lang-zh_CN.js"></script> 
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-extend.js"></script>
     <script type="text/javascript" src="<%=basePath%>js/base.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.4/extension/jquery-easyui-datagridview/datagrid-detailview.js"></script>
	<style type="text/css">
		td {
			padding-right: 10px;
		}
		.datagrid-btable .datagrid-cell{padding:6px 4px;overflow: hidden;text-overflow:ellipsis;white-space: nowrap;}
	</style>
</head>
<body style="width:100%;height:100%;">
	<div>
	  	<div style="height:auto">
		<div style="margin-bottom:5px">
			<form id="qform">
				  主题：
         	<input id="searchName" class="easyui-input" style="width: 120px">&nbsp;&nbsp;
			<a href="#" class="easyui-linkbutton" iconCls="icon-search" onclick="conditionSearch();">查询</a>
			<a href="#" class="easyui-linkbutton" iconCls="icon-refresh" onclick="clearSearch();">重置</a>
			<form>
			<input type="hidden" id="type" value="${type }">
			<input type="hidden" id="idnumber" value="${idnumber }">
			</div>
		</div>
		<table id="complainGrid">
		</table>
	</div>
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
	//?type=${type}&idnumber=${idnumber}
	$(function() {
		
	
	$("#complainGrid").datagrid({
    	height:360,
		striped: true,
		rownumbers: true,
		checkOnSelect:false,
		pagination: true,
		toolbar: '#tb',
		iconCls:'icon-user',
		fitColumns: true,
		singleSelect:true ,
        url:'${pageContext.request.contextPath}/complain/applyedComplains.action?type=${type}&idnumber=${idnumber}', 
        loadMsg: "载入中...请等待.",
        onLoadSuccess : function () {
			 $(this).datagrid("fixRownumber");
				    },
        columns:[[
            {field:"name",
             title:"申诉人",
             width:120,
             align:'left',										
             formatter : function(value) {return "<span title='"+value+"'>"+value+"</span>";}
			},
            {field:"company",
             title:"申诉人单位",
             width:120,
             align:'left'
			},
         	{field:"subject",title:"申诉主题",width:150,align:'left',formatter : function(value,row) {
         		return "<span title='"+value+"'><a class='tablelink' href='javascript:viewComplain(&#039;"+row.id+"&#039;)'>"+value+"</a></span>";}},
         	
         	{field:"complainTime",title:"申诉时间",width:180,align:'left'},
        
         	{field:"handleStatus",title:"处理状态",width:150,align:'left',formatter:handleStatusFormater},
         	{field:"id",title:"操作",width:150,align:'left',formatter:function(value, row, index){
         		var depid=$("#cdepid").val();
         		var hhtml="";
         		var vhtml = "<span><a class='tablelink' style='color:blue' href='javascript:viewComplain(&#039;"+value+"&#039;)'>查看</a></span>";
         		return vhtml+hhtml;
         	}},
         	
        ]]
      
    });
	
});
	
	function viewComplain(cid){
		var node = $('#complainGrid').datagrid('getSelected');
		if(node!=null){
		   var check = '${check}';
           if (check == 'Y') {
	          window.open("<%=basePath%>complain/viewComplain.action?CHECK=Y&cid=" + cid, 'newwindow','height=900,width=1000,top='+(window.screen.availHeight-30-900)/2+
	            ',left='+(window.screen.availWidth-10-1000)/2+
	            ',toolbar=no,menubar=no,scrollbars=yes,resizable=yes,location=no,status=no');
	       } else {
	         window.location.href = "<%=basePath%>complain/viewComplain.action?cid=" + cid;
	       }
		}
	}
	
	
	function handleComplain(cid){
		var node = $('#complainGrid').datagrid('getSelected');
		if(node!=null){
			window.location.href='<%=basePath%>complain/handleComplain.action?cid=' + cid;
		}
	}
	
	function conditionSearch() {
 		setFirstPage("#complainGrid");
		var name = $.trim($('#searchName').val());
		var type = $.trim($('#idnumber').val());
    	var idnumber = $.trim($('#idnumber').val());
		var queryParams = new Object();
		queryParams["subject"] = name;
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