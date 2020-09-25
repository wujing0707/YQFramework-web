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
    <link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.3.4/themes/icon.css">
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

   $(function(){
		getEnterpriseChat();
	})

  
	function getEnterpriseChat(){
		$('#toList').show();
		 $("#searchForList").hide();
		$('#detailList').hide();
		var deptCode=$("#dept").combobox('getValues');
		var timeBegin=$("#timeBegin").val();
		var timeEnd=$("#timeEnd").val();
		
		var enterpriseUrl="<%=basePath%>enterpriseanalysis/ryxx.action?deptCode="+deptCode+"&timeBegin="+timeBegin+"&timeEnd="+timeEnd;
		$.ajax({
                url: enterpriseUrl,
                dataType: 'json',
                beforeSend:ajaxLoading,//发送请求前打开进度条
                success:function(ret){ 
            
			  var browsers = new Array();
              //迭代，把异步获取的数据放到数组中
              
              var htmlStr = "<tr style='background-color:#81AACF'><td height='40px'>序号</td><td>部门</td>"+
                  "<td>表彰数量</td></tr>";
			var depts=new Array();
			var amounts=new Array();
               var totalSum=0;   
              $.each(ret,function(i,d){
                  depts.push(d.codedesc);
                  amounts.push(parseInt(d.amounts));
                  totalSum=  totalSum+parseInt(d.amounts);
                  if(d.amounts!=0)
                  browsers.push([d.codedesc,parseInt(d.amounts)]);
                  htmlStr=htmlStr+"<tr><td height='30px'>"+(i+1)+"</td><td>"+d.codedesc+"</td><td>"+
                 "<a href='#' onclick=\"showDetailList('"+d.codedesc+"')\" style=\"text-decoration:underline;color:blue\">"+d.amounts+"</a></td></tr>";
              });
              if(totalSum==0){
              	$('#container').hide();
              	$('#container2').hide();
              	$('#hint').show();
              	$('#toList').hide();
              }else{
              	$('#hint').hide();
              	$('#container').show();
              	$('#container2').show();
              }
              var enterTable = "<span>荣誉表彰信息统计表</span><table border='1' style='width:700px;text-align:center;' align='center'>"+htmlStr+"</table>";
	            $("#enterTable").html(enterTable);
			 $('#container').highcharts({ 
				 chart: { type: 'bar' }, 
				 credits: {
		                enabled:false
		            },
				 title: { text: '部门荣誉表彰信息统计' },
				  xAxis: {
					   categories: depts 
					}, 
				  yAxis: { min: 0, title: { text: '荣誉表彰信息数量' } }, 
				  legend: { backgroundColor: '#FFFFFF', reversed: true },
				   plotOptions: { series: { stacking: 'normal',events: { click: function(e) {//点击图上的值时会调用。this为series 
					   showAreaPie(e.point.category);
					  } } } },
				    series: [
							    
							    { name: '表彰数量', data: amounts}
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
		            		return this.name+'('+this.percentage.toFixed(1)+'%)';
		            	}	
		            },
				   title: { text: '各部门荣誉表彰信息占比图' }, 
				   tooltip: { pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>' },
				    plotOptions: { pie: { allowPointSelect: true, cursor: 'pointer', 
					    dataLabels: { enabled: false, color: '#000000',
					     connectorColor: '#000000',
					      format: '<b>{point.name}</b>: {point.percentage:.1f} %' },
					      showInLegend: true //是否显示图例      
				    } },
					       series: [{ 
						       type: 'pie', name: '荣誉表彰信息数量 ', 
						       data: browsers }] });
			 ajaxLoadEnd();//任务执行成功，关闭进度条  

				}
	            });
	}

  function showAreaPie(dept){
	  //$("#container3").show();
		$("#detailList").hide();
		var timeBegin=$("#timeBegin").val();
		var timeEnd=$("#timeEnd").val();
		dept=encodeURI(encodeURI(dept, "UTF-8"), "UTF-8");
		var enterpriseUrl="<%=basePath%>enterpriseanalysis/getAreaRybzDataByDept.action?deptName="+dept+"&timeBegin="+timeBegin+"&timeEnd="+timeEnd;
		$.ajax({
              url: enterpriseUrl,
              dataType: 'json',
              beforeSend:ajaxLoading,//发送请求前打开进度条
              success:function(ret){ 
          
			  var bros = new Array();
            //迭代，把异步获取的数据放到数组中
             
            $.each(ret,function(i,d){
                bros.push([d.area,parseInt(d.amount)]);
            });

          
		 $('#container2').highcharts({ 
			 chart: { plotBackgroundColor: null,
			  plotBorderWidth: null,
			   plotShadow: false }, 
			   credits: {
	                enabled:false
	            },
			   title: { text: '部门荣誉表彰信息区域统计' }, 
			   tooltip: { pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>' },
			    plotOptions: { pie: { allowPointSelect: true, cursor: 'pointer', 
				    dataLabels: { enabled: false, color: '#000000',
				     connectorColor: '#000000',
				      format: '<b>{point.name}</b>: {point.percentage:.1f} %' },
				      showInLegend: true //是否显示图例
			    } },
				       series: [{ 
					       type: 'pie', name: '表彰数量 ', 
					       data: bros }] });
				 ajaxLoadEnd();//任务执行成功，关闭进度条   
				// window.location.hash = "#container3";  

		}
      });
	       
		
	}


	function showDetailList(deptName){
		//$("#container3").hide();
		$("#detailList").show();
		  $.ajax({
	             type: "GET",
	             url: "<%=basePath%>enterpriseanalysis/getRybzqyListBydept.action",
	             data: {deptName:deptName,timeBegin:$("#timeBegin").val(),timeEnd:$("#timeEnd").val() },
	             dataType: "json",
	             beforeSend:ajaxLoading,//发送请求前打开进度条
	             success: function(data){
	                         $('#detailList').empty();   //清空detailList里面的所有内容
	                         var html = "<tr style='background-color:#81AACF'><td height='40px' width='10%'>序号</td>"+
	                         "<td width='30%'>企业名称</td><td width='15%'>组织机构代码</td><td width='15%'>工商注册号</td><td width='15%'>表彰时间</td></tr>";
	                         $.each(data, function(i, d){
									var	qymc=d.QYMC;
									var zzjgdm=d.ZZJGDM;
									var gszch=d.GSZCH;
									var bzrq=d.BZRQ;
		                        	 if (!d.QYMC) { qymc=""} 
		                        	 if(!d.ZZJGDM){zzjgdm=""}
		                        	 if(!d.GSZCH){gszch=""}
		                        	 if(!d.BZRQ || d.BZRQ.length==5){bzrq=""}
		                        	//bzrq= bzrq.replace('年','-').replace('月','-').replace('日','').replace('.','-').replace('.','-');
	                        	 html=html+"<tr><td height='30px'>"+(i+1)+"</td><td><a href='#' onclick=\"toDeail('"+d.QYMC+"')\" style=\"text-decoration:underline;color:blue\"> "+qymc+"</a></td><td>"+
	                            zzjgdm+"</td><td>"+gszch+"</td><td>"+bzrq+"</td></tr>";
	                         });
	                         var html2 = "<table border='1' style='width:900px;text-align:center;' align='center'>"+html+"</table>";
	                         $('#detailList').html(html2);
	                         $('#detailList').show();
	                         ajaxLoadEnd();//任务执行成功，关闭进度条
	                       //  window.location.hash = "#detailList";  
	                         $('#detailListWin').window({
	                        	 title:'荣誉表彰企业列表',
	                        	 top:'80px',
	                             modal:true
	                          });
	                         
	                         $('#detailListWin').window('open');
	                         $('#deptForExport').val(deptName);
	                      }
	         });
		 

		}
	
	function enterpriseSearch(){
		getEnterpriseChat();
	
	}
	
	function enterpriseSearch2(){
			var deptCode=$("#dept").combobox('getValues');
			var timeBegin=$("#timeBegin").val();
			var timeEnd=$("#timeEnd").val();
			
			var enterpriseUrl="<%=basePath%>enterpriseanalysis/ryxx.action?deptCode="+deptCode+"&timeBegin="+timeBegin+"&timeEnd="+timeEnd;
			$.ajax({
	                url: enterpriseUrl,
	                dataType: 'json',
	                beforeSend:ajaxLoading,//发送请求前打开进度条
	                success:function(ret){ 
	            
				  var browsers = new Array();
	              //迭代，把异步获取的数据放到数组中
	              
	              var htmlStr = "<tr style='background-color:#81AACF'><td height='40px'>序号</td><td>部门</td>"+
	                  "<td>表彰数量</td></tr>";
				var depts=new Array();
				var amounts=new Array();
	               var totalSum=0;   
	              $.each(ret,function(i,d){
	                  depts.push(d.codedesc);
	                  amounts.push(parseInt(d.amounts));
	                  totalSum=  totalSum+parseInt(d.amounts);
	                  if(d.amounts!=0)
	                  browsers.push([d.codedesc,parseInt(d.amounts)]);
	                  htmlStr=htmlStr+"<tr><td height='30px'>"+(i+1)+"</td><td>"+d.codedesc+"</td><td>"+
	                 "<a href='#' onclick=\"showDetailList('"+d.codedesc+"')\" style=\"text-decoration:underline;color:blue\">"+d.amounts+"</a></td></tr>";
	              });
	            
	              var enterTable = "<span>荣誉表彰信息统计表</span><table border='1' style='width:700px;text-align:center;' align='center'>"+htmlStr+"</table>";
		            $("#enterTable").html(enterTable);
				 $('#container').highcharts({ 
					 chart: { type: 'bar' }, 
					 credits: {
			                enabled:false
			            },
					 title: { text: '部门荣誉表彰信息统计' },
					  xAxis: {
						   categories: depts 
						}, 
					  yAxis: { min: 0, title: { text: '荣誉表彰信息数量' } }, 
					  legend: { backgroundColor: '#FFFFFF', reversed: true },
					   plotOptions: { series: { stacking: 'normal',events: { click: function(e) {//点击图上的值时会调用。this为series 
						   showAreaPie(e.point.category);
						  } } } },
					    series: [
								    
								    { name: '表彰数量', data: amounts}
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
			            		return this.name+'('+this.percentage.toFixed(1)+'%)';
			            	}	
			            },
					   title: { text: '各部门荣誉表彰信息占比图' }, 
					   tooltip: { pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>' },
					    plotOptions: { pie: { allowPointSelect: true, cursor: 'pointer', 
						    dataLabels: { enabled: false, color: '#000000',
						     connectorColor: '#000000',
						      format: '<b>{point.name}</b>: {point.percentage:.1f} %' },
						      showInLegend: true //是否显示图例      
					    } },
						       series: [{ 
							       type: 'pie', name: '荣誉表彰信息数量 ', 
							       data: browsers }] });
				 ajaxLoadEnd();//任务执行成功，关闭进度条  

					}
		            });
	}
	
	function toDeail(qymc){
		window.open("<%=basePath%>/creditInfo/getDetailInfo.action?qymc="+qymc+"&zzjgdm=''&gszch=''");
		
	}
	
	function clearEnterpriseSearch(){
		  $("#dept").combobox('setValues',[]);
		  $("#timeBegin").val('');
		  $("#timeEnd").val('');	
	}


	function exportExcel(){
		var dept=  $('#deptForExport').val();
		var timeBegin=$("#timeBegin").val();
		var timeEnd=$("#timeEnd").val();
		window.location.href="<%=basePath%>enterpriseanalysis/ryxxExport.action?dept="+dept+"&timeBegin="+timeBegin+"&timeEnd="+timeEnd;
	}

	function exchange(type){
		if(type=='1'){//切换到列表
			$("#toList").hide();
			$("#toPicture").show();
			$("#searchForChart").hide();
			$("#searchForList").show();
			$("#container").hide();
			$("#container2").hide();
			$("#enterTable").show();
			$("#detailList").hide();
			//$("#container3").hide();
			
		}
		if(type=='2'){//切换到图
			$("#toList").show();
			$("#toPicture").hide();
			$("#searchForChart").show();
			$("#searchForList").hide();
			$("#container").show();
			$("#container2").show();
			$("#enterTable").hide();
			$("#detailList").hide();
			//$("#container3").hide();
		}
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
					url='<%=basePath%>enterpriseanalysis/getDetpList.action' 
					data-options="valueField:'code', textField:'name',multiple:true">
				
				</input>
				
				上报起始时间:&nbsp;<input  class="Wdate" type="text"  id="timeBegin"
	   		onfocus="WdatePicker({skin:'whyGreen',maxDate:'#F{$dp.$D(\'timeEnd\')}'})"/>&nbsp; 
				上报截止时间:&nbsp;<input  class="Wdate" type="text"  id="timeEnd"
	   		onfocus="WdatePicker({skin:'whyGreen',minDate:'#F{$dp.$D(\'timeBegin\')}'})"/>&nbsp; 
				
				<a href="#" id="searchForChart"
					class="easyui-linkbutton" iconCls="icon-search"
					onclick="enterpriseSearch();">查询</a> 
					
					<a href="#" id="searchForList"
					class="easyui-linkbutton" iconCls="icon-search"
					onclick="enterpriseSearch2();">查询</a>
					
					<a href="#"
					class="easyui-linkbutton" iconCls="icon-refresh"
					onclick="clearEnterpriseSearch();">重置</a>
					
					 <a href="#" id="toList"
					class="easyui-linkbutton" iconCls="icon-refresh"
					onclick="exchange(1);">列表</a>
					
					<a href="#" id="toPicture" style="display:none;"
					class="easyui-linkbutton" iconCls="icon-refresh"
					onclick="exchange(2);">图表</a>
		</div>
		<div style="min-height:800px;width:100%;">	
		<div id='hint' style="display:none;"><br>
	<font color="red" size="5">&nbsp;&nbsp;&nbsp;此查询条件无统计结果，请重新选择条件后查询，谢谢！</font>
	</div>
	<input type="hidden" id="deptForExport"/>
  <div id="container" style="width:55%;min-height:800px;float:left;padding-right:40px;"></div>
  <div id="container2" style="width:35%;min-height:700px;float:left;"></div>
   <div width="600px" id="enterTable" align="center" style="margin-top:30px;margin-bottom:20px;display:none;">  </div>
  <div class="easyui-window" id="detailListWin"  style="width:960px; height:500px;padding:10px 20px;" 
  		 data-options="iconCls:'icon-add',tools:'#tool',closed:true, border:false" >
  		 <div id="detailList" style="width:900px;" ></div>
 	 	<div id="tool">
			<a href="javascript:void(0)" class="icon-export" onclick="exportExcel()"
				title="导出"></a>
		</div>
     </div>
  <!-- <div id="container3" style="width:600px;min-height:600px;margin-bottom:200px;display:none;"></div>
  -->
  </div>
</body>
</html>




