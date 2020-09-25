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
	<title>查看日志管理</title>
	<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css" />
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/themes/icon-suit-a.css">
    <link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.4/themes/bootstrap/easyui.css">
    <link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.4/themes/icon.css">
    <link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.4/themes/color.css">
    
    <script type="text/javascript" src="<%=basePath%>js/commonUtils.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.4/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.4/locale/easyui-lang-zh_CN.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/base.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-extend.js"></script>
    <script type="text/javascript"
	src="<%=basePath%>js/jquery-easyui-1.4/extension/jquery-easyui-datagridview/datagrid-detailview.js"></script>
</head>
<body>
	<div>
			<div class="place">
				<span>位置：</span>
				<ul class="placeul">
					<li><%=request.getAttribute("path") %></li>
				</ul>
			</div>
	<table id="logGrid"  class="easyui-datagrid" 
			style="height:360px" width="100%"
	 		data-options="rownumbers:true, pagination:true, 
	 		singleSelect:true, collapsible:true, fitColumns:true, 
	 		pageSize:10, url:'list.action', method:'post', 
	 		iconCls:'icon-user', toolbar:'#tb' ,onDblClickRow:showParams">
        <thead>
            <tr>
                <th field="id" hidden="true">id</th>
                <th field="username" width="15" align="left">用户名</th>
                <th field="realname" width="15" align="left">姓名</th>
                <th field="deptname" width="15" align="left">部门</th>
                <th field="cxrk" width="20" align="left">查询入口</th>
                <th field="qymc" width="30" align="left">查看企业</th>
                <th field="ip" width="15" align="left">IP</th>
                <th field="createtime" width="15" align="left">操作时间</th>
            </tr>
        </thead>
    </table>
    </div>
    <div id="tb" style="padding:5px;height:auto">
        <div style="margin-bottom:5px">
           	<label>用户名：</label>
           	<input id="conditionUsername" class="easyui-textbox" style="width:80px" data-options="prompt: ''"> 
           	<label>开始时间：</label>
           	<input id="conditionStartDate" class="easyui-datebox" data-options="onSelect:onSelect" editable="false"  style="width:100px">
           	<label>结束时间：</label>
           	<input id="conditionEndDate" class="easyui-datebox" data-options="onSelect:onSelect" editable="false"  style="width:100px">
            <a href="#" class="easyui-linkbutton" iconCls="icon-search" onclick="conditionSearch();">查询</a>
            <a href="#" class="easyui-linkbutton" iconCls="icon-refresh" onclick="conditionReset();">重置</a>
            <a href="#" class="easyui-linkbutton" iconCls="icon-redo" onclick="conditionLogExport();">日志导出</a>
        </div>
    </div>
	
	<script type="text/javascript">
var sd;
var ed;
function onSelect(d)
{
	switch(this.id)
	{
		case 'conditionStartDate':
		  sd = d;
		  break;
		case 'conditionEndDate':
		  ed = d;
		  break;
	}
	
	if((sd != '' && sd != null && sd != 'undefined') && (ed != '' && ed != null && ed != 'undefined'))
	{
		var sdtime = sd.getTime();
		var edtime = ed.getTime();
		
		if(edtime-sdtime < 0)
		{
			$.messager.alert('选择','结束日期小于开始日期!','info');
	        //只要选择了日期，不管是开始或者结束都对比一下，如果结束小于开始，则清空结束日期的值并弹出日历选择框
	        $('#conditionStartDate').datebox('setValue', '');
	        sd = null;
	        $('#conditionEndDate').datebox('setValue', '');
	        ed = null;
		}
	}
}
		//双击时显示参数
		function showParams(){
		}
		
		var dvalueUsername = "用户名";
		var dvalueIp = "IP";
		var dvalueRealName = "姓名";
		var dvalueStartDate = "开始时间";
		var dvalueEndName = "结束时间";
		jQuery(function(){
			$("#conditionStartDate").next().find("input").first().autoTip({dvalue:"",tip:'0'});
			$("#conditionEndDate").next().find("input").first().autoTip({dvalue:"",tip:'0'});
		});
		
		/**
		* 条件查询
		*/
        function conditionSearch(){
        	var userName = $.trim(jQuery("#conditionUsername").textbox('getValue'));
        	
        	var startDate = jQuery("#conditionStartDate").datebox('getValue');
        	var endDate = jQuery("#conditionEndDate").datebox('getValue');

            userName = userName == dvalueUsername ? '' : userName;
            startDate = startDate == dvalueStartDate ? '' : startDate;
            endDate = endDate == dvalueEndName ? '' : endDate;

            var queryParams = jQuery('#logGrid').datagrid('options').queryParams;
           queryParams["userName"] = userName;
            queryParams["startDate"] = startDate;
            queryParams["endDate"] = endDate;
            
            jQuery('#logGrid').datagrid('options').queryParams = queryParams;
            jQuery('#logGrid').datagrid('options').pageNumber = 1;
            jQuery('#logGrid').datagrid('getPager').pagination({pageNumber: 1});
            jQuery('#logGrid').datagrid('reload');
        }
        //重置
        function conditionReset(){
        	
    		jQuery("#conditionUsername").textbox('setValue',"");
        	jQuery("#conditionStartDate").datebox('setValue',"");
        	jQuery("#conditionEndDate").datebox('setValue',"");
    	}
    	
    	//log导出
    	function conditionLogExport(){
    		
    		var userName = jQuery("#conditionUsername").textbox('getValue');
    		var startDate = jQuery("#conditionStartDate").datebox('getValue');
        	var endDate = jQuery("#conditionEndDate").datebox('getValue');

			userName = userName == dvalueUsername ? '' : userName;
        	startDate = startDate == dvalueStartDate ? '' : startDate;
            endDate = endDate == dvalueEndName ? '' : endDate;
            
            
           var url ="logExportToTxt.action?userName=" + userName + "&startDate=" + startDate + "&endDate=" + endDate;
           window.open(url);
 			
    	}
    	

		$.extend(
						$.fn.datagrid.methods,
						{
							fixRownumber : function(jq) {
								return jq
										.each(function() {
											var panel = $(this).datagrid(
													"getPanel");
											//获取最后一行的number容器,并拷贝一份
											var clone = $(
													".datagrid-cell-rownumber",
													panel).last().clone();
											//由于在某些浏览器里面,是不支持获取隐藏元素的宽度,所以取巧一下
											clone.css({
												"position" : "absolute",
												left : -1000
											}).appendTo("body");
											var width = clone.width("auto")
													.width();
											//默认宽度是25,所以只有大于25的时候才进行fix
											if (width > 25) {
												//多加5个像素,保持一点边距
												$(
														".datagrid-header-rownumber,.datagrid-cell-rownumber",
														panel).width(width + 5);
												//修改了宽度之后,需要对容器进行重新计算,所以调用resize
												$(this).datagrid("resize");
												//一些清理工作
												clone.remove();
												clone = null;
											} else {
												//还原成默认状态
												$(
														".datagrid-header-rownumber,.datagrid-cell-rownumber",
														panel).removeAttr(
														"style");
											}
										});
							}
						});

		$("#logGrid").datagrid({
			onLoadSuccess : function() {
				$(this).datagrid("fixRownumber");
			}
		});
	</script>
    
    <!-- rownumbe宽度 -->
    <style>
    	.datagrid-header-rownumber,.datagrid-cell-rownumber{
   			width:40px;
 		}
 		.pagination-page-list,
.pagination .pagination-num {
  width:50px;
}

    </style>
</body>
</html>