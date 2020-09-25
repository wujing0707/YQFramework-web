<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jstl/core" %> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String basePath = request.getScheme() + "://" + request.getServerName() 
			+ ":" + request.getServerPort() + request.getContextPath() + "/";
	pageContext.setAttribute("basePath", basePath);
%>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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
    <script type="text/javascript"
	src="<%=basePath%>js/jquery-easyui-1.4/extension/jquery-easyui-datagridview/datagrid-detailview.js"></script>
   <script type="text/javascript" src="<%=basePath%>js/jquery-highcharts-3.0.6/highcharts.js"></script>
  <script type="text/javascript" src="<%=basePath%>js/jquery-highcharts-3.0.6/highcharts-more.js"></script>
   <script type="text/javascript" src="${pageContext.request.contextPath}/js/browser.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery.autocomplete.js"></script>
     <link rel="stylesheet" type="text/css" href="<%=basePath%>css/autocomplete.css">
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

  $(function(){
		getEnterpriseChat();
		 var lsurl = '${pageContext.request.contextPath}/enterpriseanalysis/qymcAutoComplete.action?t='+new Date();
	       $('#qymc').autocomplete(lsurl,{
	                 minChars: 0,//自动完成激活之前填入的最小字符
	                 max:10,//列表条目数
	                 width: 150,//提示的宽度
	                 scrollHeight: 300,//提示的高度
	                 matchContains: true,//是否只要包含文本框里的就可以
	                 autoFill:false,//自动填充
	                 //需要把data转换成json数据格式                        
	                           parse: function(data) { 
	                              return $.map(eval(data), function(row) {  
	                                  return {  
	                                   data: row,  
	                                   value: row.qymc,
	                                   result: row.qymc   
	                                 }  
	                           });  
	                    }, 
	                 formatItem: function(data, i, max) {//格式化列表中的条目 row:条目对象,i:当前条目数,max:总条目数
	   				return data.qymc;
	               },
	               formatMatch: function(data, i, max) {//配合formatItem使用，作用在于，由于使用了formatItem，所以条目中的内容有所改变，而我们要匹配的是原始的数据，所以用formatMatch做一个调整，使之匹配原始数据
	   				return data.qymc;
	               },
	               formatResult: function(data) {//定义最终返回的数据，比如我们还是要返回原始数据，而不是formatItem过的数据
	   				return data.qymc;
	               }
	           }).result(function(event,data,formatted){
	           	$("#qymc").val(data.qymc);
	           });
		
		
	})

  
	function getEnterpriseChat(){
		var qymc=$("#qymc").val();
		qymc=encodeURI(encodeURI(qymc, "UTF-8"), "UTF-8");
		var enterpriseUrl="<%=basePath%>enterpriseanalysis/xyqsAnalysisChat.action?qymc="+qymc;
		$.ajax({
                url: enterpriseUrl,
                dataType: 'json',
                beforeSend:ajaxLoading,//发送请求前打开进度条
                success:function(ret){ 
				var sxxx=new Array();
				var rybz=new Array();
				  $.each(ret.失信行为信息,function(i,d){
				  sxxx.push(parseInt(d));
					
				 })
				 $.each(ret.荣誉表彰信息,function(i,d){
					 rybz.push(parseInt(d));
					
				 })
				 
			 $('#container').highcharts({ 
				 title: { text: '信用趋势', x: -20 //center
				  }, 
				   xAxis: { 
					   title:{text:'年度'},
					   categories: ret.years
						    }, 
						  
					   yAxis: {
						 min:0,
					title: { text: '信息项数' },
					 plotLines: [{ value: 0, width: 1, color: '#808080' }] }, 
					 tooltip: { valueSuffix: '项' }, 
					 credits: {
			                enabled:false
			            },
					 legend: { layout: 'vertical', 
						 align: 'right', 
						 verticalAlign: 'middle', 
						 borderWidth: 0 },
						  series: [
							    {
								name: '失信行为信息', 
								data: sxxx 
								},
								{ name: '荣誉表彰信息', 
									data: rybz }
									]
			 });

			 ajaxLoadEnd();//任务执行成功，关闭进度条
				}
	            });




        
	           
	}
	
	function enterpriseSearch(){
		getEnterpriseChat();
	
	}
	
	function clearEnterpriseSearch(){
	  $("#qymc").val('');
	}

	function exportExcel(){
		var qymc=$("#qymc").val();
		window.location.href="<%=basePath%>enterpriseanalysis/xyqsExport.action?qymc="+qymc;
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
				企业名称:&nbsp;<input id="qymc" class="easyui-input"
					style="width: 150px">&nbsp;
				<a href="#"
					class="easyui-linkbutton" iconCls="icon-search"
					onclick="enterpriseSearch();">查询</a> <a href="#"
					class="easyui-linkbutton" iconCls="icon-refresh"
					onclick="clearEnterpriseSearch();">重置</a>
							 <a href="#"
					class="easyui-linkbutton" iconCls="icon-export"
					onclick="exportExcel();">导出</a>
		</div>
  <div id='zhu'><font color="#008080">&nbsp;&nbsp;&nbsp;注：企业信用趋势分析只统计行为发生时间不为空的纪录！</font></div><br/>
  <div id="container" style="width:1000px;height:420px;float:left;"></div>
</body>
</html>




