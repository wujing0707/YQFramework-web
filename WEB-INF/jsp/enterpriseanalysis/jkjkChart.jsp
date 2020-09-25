<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page language="java" import="com.wa.framework.user.model.SysUser"%>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core" %> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String basePath = request.getScheme() + "://" + request.getServerName() 
			+ ":" + request.getServerPort() + request.getContextPath() + "/";
	pageContext.setAttribute("basePath", basePath);
	SysUser user=(SysUser)session.getAttribute("user");
	
	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css" />
	<link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.3.4/themes/bootstrap/easyui.css">
    <link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.3.4/themes/icon.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/themes/icon-suit-a.css">
    <script type="text/javascript" src="<%=basePath%>js/commonUtils.js"></script>
    <script type="text/javascript" src="http://cdn.hcharts.cn/jquery/jquery-1.8.3.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.3.4/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.3.4/locale/easyui-lang-zh_CN.js"></script> 
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-extend.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/base.js"></script>
   
    <script type="text/javascript" src="http://cdn.hcharts.cn/highcharts/highcharts.js"></script>
    <link rel="stylesheet" type="text/css" href="<%=basePath%>js/datepicker/skin/WdatePicker.css">
	<script type="text/javascript" src="<%=basePath%>js/datepicker/WdatePicker.js"></script>
  <script>
//采用jquery easyui loading css效果
  function ajaxLoading(){
      $("<div class=\"datagrid-mask\"></div>").css({display:"block",width:"100%",height:$(window).height()}).appendTo("body");
      $("<div class=\"datagrid-mask-msg\"></div>").html("正在处理，请稍候...").appendTo("body").css({display:"block",left:($(document.body).outerWidth(true) - 190) / 2,top:($(window).height() - 45) / 2});
   }
   function ajaxLoadEnd(){
       $(".datagrid-mask").remove();
       $(".datagrid-mask-msg").remove();            
  }
    $(function () {
     getEnterpriseChat();
    });
	function getEnterpriseChat(){
		var queryDate=$("#queryDate").val();
		var url="<%=basePath%>enterpriseanalysis/jkjk.action?queryDate="+queryDate;
		$.ajax({
            url: url,
            dataType: 'json',
            beforeSend:ajaxLoading,//发送请求前打开进度条
            success:function(ret){
			var week = ['第一周', '第二周', '第三周', '第四周'];
			var dycs=new Array();
			var dysjl= new Array();
			var totalSum=parseInt(0);
			var totalCount=parseInt(0);
			$.each(ret,function(i,d){
				 dysjl.push(parseInt(d.sum));
				 dycs.push(parseInt(d.count));
				 totalSum+=parseInt(d.sum);
				 totalCount+=parseInt(d.count);
			 });
			$('#container').highcharts({ 
			    chart: { type: 'column' }, 
			    credits: {
	                enabled:false
	            },
			    title: { text: '接口监控(调用次数)' },
			    xAxis: {
				    labels: {    
			      //  rotation: -45
			    },
				categories: week
				}, 
			    yAxis: { min: 0, title: { text: '调用次数' } }, 
			    legend: { backgroundColor: '#FFFFFF', reversed: true },
			    plotOptions: { series: { stacking: 'normal' } },
			    series: [
						    { name: '调用次数', data: dycs}
					    ]
						     });
			$('#container1').highcharts({ 
			    chart: { type: 'column' }, 
			    credits: {
	                enabled:false
	            },
			    title: { text: '接口监控(调用数据量)' },
			    xAxis: {
				    labels: {    
			      //  rotation: -45
			    },
				categories: week
				}, 
			    yAxis: { min: 0, title: { text: '调用数据量' } }, 
			    legend: { backgroundColor: '#FFFFFF', reversed: true },
			    plotOptions: { series: { stacking: 'normal' } },
			    series: [
						    { name: '调用数据量', data: dysjl}
					    ]
						     });
			var htmlStr = "<tr style='background-color:#81AACF'><td height='40px'>时间</td><td>调用次数</td><td>调用数据量</td></tr>";
			htmlStr =htmlStr+"<tr><td height='30px'>第一周</td><td>"+dycs[0]+"</td><td>"+dysjl[0]+"</td></tr>";
			htmlStr =htmlStr+"<tr><td height='30px'>第二周</td><td>"+dycs[1]+"</td><td>"+dysjl[1]+"</td></tr>";
			htmlStr =htmlStr+"<tr><td height='30px'>第三周</td><td>"+dycs[2]+"</td><td>"+dysjl[2]+"</td></tr>";
			htmlStr =htmlStr+"<tr><td height='30px'>第四周</td><td>"+dycs[3]+"</td><td>"+dysjl[3]+"</td></tr>";
			htmlStr =htmlStr+"<tr><td height='30px'>合计</td><td>"+totalCount+"</td><td>"+totalSum+"</td></tr>";
			htmlStr ="<table border='1' style='width:800px;text-align:center;' align='center'>"+htmlStr+"</table>";
			$("#enterTable").html(htmlStr);
			ajaxLoadEnd();//任务执行成功，关闭进度条   
		}
		}); 
	}
	
	function enterpriseSearch(){
		getEnterpriseChat();
	}
	
	function clearEnterpriseSearch(){
	  $("#queryDate").val('');
	}
  </script>
</head>
<body>
	<div class="place">
		<span>位置：</span>
		<ul class="placeul">
			<li><%=request.getAttribute("path") %></li>
		</ul>
	</div>
	<div id="tb" style="padding:5px;height:auto">
		查询时间：&nbsp;<input  class="Wdate" type="text"  id="queryDate" onfocus="WdatePicker({dateFmt:'yyyy-MM'})"/>&nbsp; 
		<a href="#" class="easyui-linkbutton" iconCls="icon-search" onclick="enterpriseSearch();">查询</a>
		<a href="#" class="easyui-linkbutton" iconCls="icon-refresh" onclick="clearEnterpriseSearch();">重置</a>
	</div>
	<div style="min-height:700px;width:100%;">	
		<div id="container" style="width:45%;height:500px;float:left;padding-right:40px;"></div>
		<div id="container1" style="width:45%;height:500px;float:left;padding-right:40px;"></div>
		<div id="enterTable" align="center" style="margin-bottom:20px;" ></div>
	</div>
</body>
</html>