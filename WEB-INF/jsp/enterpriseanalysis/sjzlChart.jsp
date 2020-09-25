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

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	 <link type="text/css" rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css" />
	<link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.3.4/themes/bootstrap/easyui.css">
    <link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.3.4/themes/icon.css">
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/themes/icon-suit-a.css">
    <script type="text/javascript" src="<%=basePath%>js/commonUtils.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.3.4/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.3.4/locale/easyui-lang-zh_CN.js"></script> 
     <script type="text/javascript" src="<%=basePath%>js/base.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-extend.js"></script>
    <script type="text/javascript"
	src="<%=basePath%>js/jquery-easyui-1.4/extension/jquery-easyui-datagridview/datagrid-detailview.js"></script>
   <script type="text/javascript" src="<%=basePath%>js/jquery-highcharts-3.0.6/highcharts.js"></script>
  <script type="text/javascript" src="<%=basePath%>js/jquery-highcharts-3.0.6/highcharts-more.js"></script>
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

  
	function getEnterpriseChat(){
		var deptName=$("#dept").combobox('getValues');
		var infoName=$("#info").combobox('getValues');
		var timeBegin=$("#timeBegin").val();
		var timeEnd=$("#timeEnd").val();
		deptName=encodeURI(encodeURI(deptName, "UTF-8"), "UTF-8");
		infoName=encodeURI(encodeURI(infoName, "UTF-8"), "UTF-8");
		var enterpriseUrl="<%=basePath%>enterpriseanalysis/sjzl.action?deptName="+deptName+"&timeBegin="+timeBegin+"&timeEnd="+timeEnd+"&infoName="+infoName;
		$.ajax({
                url: enterpriseUrl,
                dataType: 'json',
                beforeSend:ajaxLoading,//发送请求前打开进度条
                success:function(ret){ 
            var depts=new Array();
            var amount=new Array();
            var browsers=[];
            var totalSum=0;   
            $.each(ret.columnChart,function(i,d){
            	depts.push(d.dept);
				amount.push(parseInt(d.tiaoshu));
				totalSum= totalSum+parseInt(d.tiaoshu);
            });
            if(totalSum==0){
              	$('#container').hide();
              	$('#container2').hide();
              	$('#hint').show();
              	$('#zhu').hide();
              }else{
              	$('#hint').hide();
              	$('#container').show();
              	$('#container2').show();
              	$('#zhu').show();
              }
            $.each(ret.pieChart,function(i,d){
                browsers.push([d.servicename,parseInt(d.amount)]);
            });
            $('#container').highcharts({ 
				 chart: { type: 'bar' }, 
				 credits: {
		                enabled:false
		            },
				 title: { text: '部门数据上报量图 ' },
				  xAxis: {lables:{overflow:'justify'},
					   categories: depts 
					}, 
				  yAxis: {lables:{overflow:'justify'}, min: 0, title: { text: '数据上报量' } }, 
				  legend: { backgroundColor: '#FFFFFF', reversed: true },
				   plotOptions: {
					   series: 
				   		{ 
						   stacking: 'normal',	
						   events: {
		              click: function(e) {
					  getDataByDept(e.point.category);
		              }
		           	 }
		            } 
					 
					   },
				    series: [
							    
							    { name: '上报数', data: amount}
						    ]
							     });
			
			 $('#container2').highcharts({ 
				 chart: { plotBackgroundColor: null,
				  plotBorderWidth: null,
				   plotShadow: false }, 
				   credits: {
		                enabled:false
		            },
		            legend: { 
		            	backgroundColor:'#ffffff',
		            	labelFormatter:function(){
		            		return this.name+'('+this.percentage.toFixed(2)+'%)';
		            	}	
		            },
				   title: { text: '信息类上报数据占比图' }, 
				   tooltip: { pointFormat: '{series.name}: <b>{point.percentage:.2f}%</b>' },
				    plotOptions: {
					     pie: { allowPointSelect: true,
					      cursor: 'pointer', 
					      events: {
				              click: function(e) {
					   getDataByInfoClass(e.point.name);
				              }
				            },
					    dataLabels: { 
					     enabled: false, color: '#000000',
					     connectorColor: '#000000',
					      format: '<b>{point.name}</b>: {point.percentage:.2f} %' 
						      },
						      showInLegend: true //是否显示图例
				      } 
				      },
					       series: [{ 
						       type: 'pie', name: '信息分类 ', 
						       data: browsers }] });
			 ajaxLoadEnd();//任务执行成功，关闭进度条  
				}
	            });

        
	           
	}


	 function getDataByDept(dept){
			var timeBegin=$("#timeBegin").val();
			var timeEnd=$("#timeEnd").val();
			var infoName=$("#info").combobox('getValues');
			var deptName=encodeURI(encodeURI(dept, "UTF-8"), "UTF-8");
			infoName=encodeURI(encodeURI(infoName, "UTF-8"), "UTF-8");
			var enterpriseUrl="<%=basePath%>enterpriseanalysis/sjzlForDept.action?deptName="+deptName+"&timeBegin="+timeBegin+"&timeEnd="+timeEnd+"&infoName="+infoName;
			$.ajax({
	                url: enterpriseUrl,
	                dataType: 'json',
	                beforeSend:ajaxLoading,//发送请求前打开进度条
	                success:function(ret){ 
	            var depts=new Array();
	            var amount=new Array();
	            var browsers=[];
	            $.each(ret.barList,function(i,d){
	            	depts.push(d.servicename);
					amount.push(parseInt(d.amount));
	            });

	            $.each(ret.pieList,function(i,d){
	                browsers.push(['有效数据',parseInt(d.有效数据)]);
	                browsers.push(['疑问数据',parseInt(d.疑问数据)]);
	                browsers.push(['错误数据',parseInt(d.错误数据)]);
	                browsers.push(['重复数据',parseInt(d.重复数据)]);
	                
	            });
	            $('#container').highcharts({ 
					 chart: { type: 'bar' }, 
					 credits: {
			                enabled:false
			            },
					 title: { text: '('+dept+')数据上报量图 ' },
					  xAxis: {
						   categories: depts 
						}, 
					  yAxis: { min: 0, title: { text: '数据上报量' } }, 
					  legend: { backgroundColor: '#FFFFFF', reversed: true },
					   plotOptions: { series: { stacking: 'normal' } },
					    series: [
								    
								    { name: '上报数', data: amount}
							    ]
								     });
				
				 $('#container2').highcharts({ 
					 chart: { plotBackgroundColor: null,
					  plotBorderWidth: null,
					   plotShadow: false }, 
					   credits: {
			                enabled:false
			            },
			            legend: { 
			            	backgroundColor:'#ffffff',
			            	labelFormatter:function(){
			            		return this.name+'('+this.percentage.toFixed(2)+'%)';
			            	}	
			            },
					   title: { text: '('+dept+')数据处理状态占比图' }, 
					   tooltip: { pointFormat: '{series.name}: <b>{point.percentage:.2f}%</b>' },
					    plotOptions: {
						     pie: { allowPointSelect: true,
						      cursor: 'pointer', 
						    dataLabels: { 
						     enabled: false, color: '#000000',
						     connectorColor: '#000000',
						      format: '<b>{point.name}</b>: {point.percentage:.2f} %' 
							      },
							      showInLegend: true //是否显示图例
					      } 
					      },
						       series: [{ 
							       type: 'pie', name: '信息分类 ', 
							       data: browsers }] });
				 ajaxLoadEnd();//任务执行成功，关闭进度条   
					}
		            });

		 }
	

	 function getDataByInfoClass(infoName){
	
			var deptName=$("#dept").combobox('getValues');
			var timeBegin=$("#timeBegin").val();
			var timeEnd=$("#timeEnd").val();
		   deptName=encodeURI(encodeURI(deptName, "UTF-8"), "UTF-8");
			var info=encodeURI(encodeURI(infoName, "UTF-8"), "UTF-8");
			var enterpriseUrl="<%=basePath%>enterpriseanalysis/sjzlForInfo.action?deptName="+deptName+"&timeBegin="+timeBegin+"&timeEnd="+timeEnd+"&infoName="+info;
			$.ajax({
	                url: enterpriseUrl,
	                dataType: 'json',
	                beforeSend:ajaxLoading,//发送请求前打开进度条
	                success:function(ret){ 
	            var depts=new Array();
	            var amount=new Array();
	            var browsers=[];
	            $.each(ret.barList,function(i,d){
	            	depts.push(d.dept);
					amount.push(parseInt(d.tiaoshu));
	            });

	            $.each(ret.pieList,function(i,d){
	                browsers.push(['有效数据',parseInt(d.有效数据)]);
	                browsers.push(['疑问数据',parseInt(d.疑问数据)]);
	                browsers.push(['错误数据',parseInt(d.错误数据)]);
	                browsers.push(['重复数据',parseInt(d.重复数据)]);
	                
	            });
	            $('#container').highcharts({ 
					 chart: { type: 'bar' }, 
					 credits: {
			                enabled:false
			            },
					 title: { text: '各部门('+infoName+')数据上报量图 ' },
					  xAxis: {
						   categories: depts 
						}, 
					  yAxis: { min: 0, title: { text: '数据上报量' } }, 
					  legend: { backgroundColor: '#FFFFFF', reversed: true },
					   plotOptions: { series: { stacking: 'normal' } },
					    series: [
								    
								    { name: '上报数', data: amount}
							    ]
								     });
				
				 $('#container2').highcharts({ 
					 chart: { plotBackgroundColor: null,
					  plotBorderWidth: null,
					   plotShadow: false }, 
					   credits: {
			                enabled:false
			            },
			            legend: { 
			            	backgroundColor:'#ffffff',
			            	labelFormatter:function(){
			            		return this.name+'('+this.percentage.toFixed(2)+'%)';
			            	}	
			            },
					   title: { text: '('+infoName+')数据处理状态占比图' }, 
					   tooltip: { pointFormat: '{series.name}: <b>{point.percentage:.2f}%</b>' },
					    plotOptions: {
						     pie: { allowPointSelect: true,
						      cursor: 'pointer', 
						    dataLabels: { 
						     enabled: false, color: '#000000',
						     connectorColor: '#000000',
						      format: '<b>{point.name}</b>: {point.percentage:.2f} %' 
							      },
							      showInLegend: true //是否显示图例
					      } 
					      },
						       series: [{ 
							       type: 'pie', name: '信息分类 ', 
							       data: browsers }] });
				 ajaxLoadEnd();//任务执行成功，关闭进度条   
					}
		            });

		 }
	
	function enterpriseSearch(){
		getEnterpriseChat();
	
	}
	
	function clearEnterpriseSearch(){
	if($("#dept").combobox('getData').length>1){
	  		$("#dept").combobox('setValues',[]);
	}
	  $("#info").combobox('setValues',[]);
	  $("#timeBegin").val('');
	  $("#timeEnd").val('');	
	}


	function exportExcel(){
		var deptCode=$("#dept").combobox('getValues');
		var timeBegin=$("#timeBegin").val();
		var timeEnd=$("#timeEnd").val();
		var infoName= $("#info").combobox('getValues');
		deptCode=encodeURI(encodeURI(deptCode, "UTF-8"), "UTF-8");
		infoName=encodeURI(encodeURI(infoName, "UTF-8"), "UTF-8");
		window.location.href="<%=basePath%>enterpriseanalysis/sbzlExport.action?deptName="+deptCode+"&timeBegin="+timeBegin+"&timeEnd="+timeEnd+"&infoName="+infoName;
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
				<label for="depts">请选择部门:</label> <input 
					class="easyui-combobox" id="dept" editable="false"
					data-options="valueField:'name', textField:'name',multiple:true,
					url:'<%=basePath%>enterpriseanalysis/getDetpList.action?deptId=<%=user.getDepartmentId() %>',
					onLoadSuccess:function(data){ if(data.length==1) {$('#dept').combobox('setValue',data[0].name);}
                	getEnterpriseChat();
                }"	/>
				<label for="depts">信息类:</label> <input 
					class="easyui-combobox" id="info" editable="false"
					url='<%=basePath%>enterpriseanalysis/getInfoclassList.action' 
					data-options="valueField:'name', textField:'name',multiple:true">
				
				</input>
				上报起始时间:&nbsp;<input  class="Wdate" type="text"  id="timeBegin"
	   		onfocus="WdatePicker({skin:'whyGreen',maxDate:'#F{$dp.$D(\'timeEnd\')}'})"/>&nbsp; 
				上报截止时间:&nbsp;<input  class="Wdate" type="text"  id="timeEnd"
	   		onfocus="WdatePicker({skin:'whyGreen',minDate:'#F{$dp.$D(\'timeBegin\')}'})"/>&nbsp; 
				<a href="#"
					class="easyui-linkbutton" iconCls="icon-search"
					onclick="enterpriseSearch();">查询</a> <a href="#"
					class="easyui-linkbutton" iconCls="icon-refresh"
					onclick="clearEnterpriseSearch();">重置</a>
				 <a href="#"
					class="easyui-linkbutton" iconCls="icon-export"
					onclick="exportExcel();">导出</a>
		</div>
	<div style="min-height:800px;width:100%;">
	<div id='hint' style="display:none;"><br>	
	<font color="red" size="5">&nbsp;&nbsp;&nbsp;此查询条件无统计结果，请重新选择条件后查询，谢谢！</font>
	</div>	
	<div id='zhu'><font color="#008080">&nbsp;&nbsp;&nbsp;注：此统计只统计今天以前的数据，今天上传的数据需要等明天统计</font></div><br/>
  <div id="container" style="height:800px;width:55%;float:left;padding-right:40px;"></div>
  <div id="container2" style="height:600px;width:35%;float:left;"></div>
  </div>
</body>
</html>




