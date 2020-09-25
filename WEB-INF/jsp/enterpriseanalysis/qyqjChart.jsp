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
   
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/themes/icon-suit-a.css">
    <script type="text/javascript" src="<%=basePath%>js/commonUtils.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.4/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.4/locale/easyui-lang-zh_CN.js"></script> 
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-extend.js"></script>
     <script type="text/javascript" src="<%=basePath%>js/base.js"></script>
    <script type="text/javascript"	src="<%=basePath%>js/jquery-easyui-1.4/extension/jquery-easyui-datagridview/datagrid-detailview.js"></script>
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
	
  });
  
  
	function getEnterpriseChat(){
		var qymc = $("#qymc").val();
		var str = "[@/'\"#$%&^*]+";
		 var reg = new RegExp(str);
		 if(reg.test(qymc))
		 {
		    alert("企业名称有非法字符,请重新输入!");
		    return false;
		 } 
		
		qymc=encodeURI(encodeURI(qymc, "UTF-8"), "UTF-8");
		var enterpriseUrl="<%=basePath%>enterpriseanalysis/enterpriseanalysisChat.action?qymc="+qymc;
		$.ajax({
                url: enterpriseUrl,
                dataType: 'json',
                beforeSend:ajaxLoading,//发送请求前打开进度条
                success:function(json){ 
                		//var s = "'"+json.rows[0].name+"','"+json.rows[1].name+"','"+ json.rows[2].name+"','"+json.rows[3].name+"'";
                		var len = json.rows.length;
                		var series = [];
                		var data = [];
                		var enterTablex = "<tr style='background-color:#81AACF'>"
                		var enterTabley = "<tr>"
                		for(var sd=0;sd<len;sd++){
                    		if(json.rows[sd].name!='企业名称'){
                			series.push(json.rows[sd].name);
                			data.push(json.rows[sd].value);
                			enterTablex = enterTablex+"<td width='150px' height='40px' align='center'>"+json.rows[sd].name+"</td>";
                			enterTabley =  enterTabley+"<td height='30px' align='center'><a href='#' onclick=\"toDetail('"+json.rows[sd].name+"')\" style=\"text-decoration:underline;color:blue\"> "+json.rows[sd].value+"</a></td>";
                    		}else{
                    			enterTablex = enterTablex+"<td width='150px' height='40px' align='center'>"+json.rows[sd].name+"</td>";
                    			enterTabley =  enterTabley+"<td height='30px' align='center'>"+json.rows[sd].value+"</td>";
                    		}
                			
                		} 
                		 var enterTable = "<table border='1' align='center'>"+enterTablex+"</tr>"+enterTabley+"</tr></table>"
				            $("#enterTable").html(enterTable);
                		$('#container').highcharts({
							    chart: {
							        polar: true,
							        type: 'line'
							    },
							    credits: {
					                enabled:false
					            },
							    
							    title: {
							    	text: '企业信用分析',
							        x: -80
							    },
							    
							    pane: {
							    	size: '80%'
							    },
							    
							    xAxis: {
							        categories: series,
							        tickmarkPlacement: 'on',
							        lineWidth: 0
							    },
							        
							    yAxis: {
							        gridLineInterpolation: 'polygon',
							        lineWidth: 0,
							        min: 0
							    },
							    
							    tooltip: {
							    	shared: true
							    },
							    
							    legend: {
							        align: 'right',
							        verticalAlign: 'top',
							        y: 70,
							        layout: 'vertical'
							    },
							    
							    series: [{
							        name: '次数',
							        data:data,
							        pointPlacement: 'on'
							    }]
							
							});
                		 ajaxLoadEnd();//任务执行成功，关闭进度条         
				}
	            });
	           
	}
	
	function toDetail(infoName){
		var qymc=$("#qymc").val();
		//infoName=encodeURI(encodeURI(infoName, "UTF-8"), "UTF-8");
		//qymc=encodeURI(encodeURI(qymc, "UTF-8"), "UTF-8");
		  $.ajax({
	             type: "GET",
	             url: "<%=basePath%>enterpriseanalysis/qyqjForDept.action",
	             data: {qymc:qymc,infoName:infoName },
	             dataType: "json",
	             beforeSend:ajaxLoading,//发送请求前打开进度条
	             success: function(ret){
	            	 var depts=[];
	            	 var amounts=[];
	            	 var pieData=[];
	            	 $.each(ret,function(i,d){
	                     depts.push(d.dept);
	                     amounts.push(parseInt(d.amount));
	                     pieData.push([d.dept,parseInt(d.amount)]); 
	                     
	            	 });
	            	 
	            	 
	            	 $('#container2').highcharts({ 
					 chart: { type: 'bar' }, 
						
					 credits: {
			                enabled:false
			            },
					 title: { text: '各部门数据统计' },
					  xAxis: {
						   categories: depts 
						}, 
					  yAxis: {allowDecimals:false, //是否允许刻度有小数 
						  min: 0, title: { text: '数据量' } }, 
					   legend: { enabled:false},
					   plotOptions: {
						   series: { stacking: 'normal',
						   events: { click: function(e)	 {//点击图上的值时会调用。this为series 
						   showPie(e.point.category,infoName);
					  } 
					  } } },
					    series: [
					             { name:infoName , data: amounts}
							    ]
								     });
	            	 //饼图
	            	 $('#container3').highcharts({ 
	    				 chart: { 
	    					plotBackgroundColor: null,
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
	    				   title: { text: '各部门数据占比图' }, 
	    				   tooltip: { pointFormat: '{series.name}: <b>{point.percentage:.2f}%</b>' },
	    				    plotOptions: { series: { stacking: 'normal',events: { click: function(e) {//点击图上的值时会调用。this为series 
	    				    	//alert(e.point.name);
	    						  } } }, pie: { size:'75%', allowPointSelect: true, cursor: 'pointer', 
	    					    dataLabels: { enabled: false, color: '#000000',
	    					     connectorColor: '#000000',
	    					      format: '<b>{point.name}</b>: {point.percentage:.2f} %' },
	    					      showInLegend: true //是否显示图例
	    				    } },
	    					       series: [{ 
	    						       type: 'pie', name: infoName, 
	    						       data: pieData }]  });
	            	 
	            	 
	            	 ajaxLoadEnd();//任务执行成功，关闭进度条 
	            	 $('#detailListwin').window({
                    	 top:'80px',
                         modal:true
                      });
	            	 $('#detailListwin').window('open');
	            	 
	             }
	    							     
	             });
		  
		  
		
	}
	
	function showPie(deptName,infoName){
		var qymc=$("#qymc").val();
		
		var enterpriseUrl="<%=basePath%>enterpriseanalysis/getPieForDept.action";
		$.ajax({
                url: enterpriseUrl,
                data: {qymc:qymc,deptName:deptName ,infoName:infoName},
                dataType: 'json',
                beforeSend:ajaxLoading,//发送请求前打开进度条
                success:function(ret){ 
		
				//饼图
			  var pieData = new Array();
              //迭代，把异步获取的数据放到数组中
              $.each(ret,function(i,d){
	             pieData.push([d.tableName,parseInt(d.amount)]); 
	            }); 

            
			 $('#container3').highcharts({ 
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
				   title: { text: '部门各类信息数据占比图' }, 
				   tooltip: { pointFormat: '{series.name}: <b>{point.percentage:.2f}%</b>' },
				    plotOptions: {series: { stacking: 'normal',events: { click: function(e) {//点击图上的值时会调用。this为series 
				    	showDetailList(e.point.name,deptName,infoName,qymc);
					    //alert(e.point.name);
						  } } }, pie: { size:'75%', allowPointSelect: true, cursor: 'pointer', 
					    dataLabels: { enabled: false, color: '#000000',
					     connectorColor: '#000000',
					      format: '<b>{point.name}</b>: {point.percentage:.2f} %' },
					      showInLegend: true //是否显示图例
				    } },
					       series: [{ 
						       type: 'pie', name: '部门各类信息数据占比 ', 
						       data: pieData }]  });	

			 ajaxLoadEnd();//任务执行成功，关闭进度条  
		}
		});
		
	}
	
	
	function showDetailList(tableName,deptName,infoName,qymc){
		  $.ajax({
	             type: "GET",
	             url: "<%=basePath%>enterpriseanalysis/getDetailListForQyqj.action",
	             data: {tableName:tableName,deptName:deptName,infoName:infoName,qymc:qymc},
	             dataType: "json",
	             beforeSend:ajaxLoading,//发送请求前打开进度条
	             success: function(data){
	                         $('#detailList').empty();   //清空detailList里面的所有内容
	                         var html = "<tr style='background-color:#81AACF'><td height='40px'>序号</td>"+
	                         "<td>企业名称</td><td>组织机构代码</td><td>工商注册号</td><td>事件发生时间</td><td>操作</td></tr>";
	                         $.each(data, function(i, d){
	                        		var	qymc=d.QYMC;
									var zzjgdm=d.ZZJGDM;
									var gszch=d.GSZCH;
									var sjfsxwrq=d.SJFSXWRQ;
		                        	 if (!d.QYMC) { qymc=""} 
		                        	 if(!d.ZZJGDM){zzjgdm=""}
		                        	 if(!d.GSZCH){gszch=""}
		                        	 if(!d.SJFSXWRQ){sjfsxwrq=""}
	                        	 
	                        	 html=html+"<tr><td height='30px'>"+(i+1)+"</td><td>"+qymc+"</td><td>"+
	                        	 zzjgdm+"</td><td>"+gszch+"</td><td>"+sjfsxwrq+"</td><td width='15%'> "+
	                             "<a href='#' onclick=\"toQyDetail('"+qymc+"')\" style=\"text-decoration:underline;color:blue\">查看</a>"+
	                            " </td></tr>";
	                         });
	                         var html2 = " <table border='1' style='width:900px;text-align:center;' align='center'>"+html+"</table>";
	                         $('#detailList').html(html2);
	                         ajaxLoadEnd();//任务执行成功，关闭进度条 
	                         $('#dListWin').window({
	                        	 title:'企业列表',
	                        	 top:'80px',
	                             modal:true
	                          });
	                         
	                         $('#dListWin').window('open');
	                         ajaxLoadEnd();//任务执行成功，关闭进度条  
	                      }
	         });
		 

		}
	
	
	function toQyDetail(qymc){
		window.open("<%=basePath%>/creditInfo/getDetailInfo.action?qymc="+qymc+"&zzjgdm=''&gszch=''");
		
	}
	
	
	function enterpriseSearch(){
		getEnterpriseChat();
	
	}
	
	function clearEnterpriseSearch(){
	  $("#qymc").val('');
	//  $("#zzjgdm").val('');	
	}


	function exportExcel(){
		//var zzjgdm = $("#zzjgdm").val();
		var qymc = $("#qymc").val();
		qymc=encodeURI(encodeURI(qymc, "UTF-8"), "UTF-8");
		window.location.href="<%=basePath%>enterpriseanalysis/enterpriseExport.action?qymc="+qymc;
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
				企业名称: <input id="qymc"  class="easyui-validatebox" 	style="width:150px"/>&nbsp;
				<a href="#"
					class="easyui-linkbutton" iconCls="icon-search"
					onclick="enterpriseSearch();">查询</a> <a href="#"
					class="easyui-linkbutton" iconCls="icon-refresh"
					onclick="clearEnterpriseSearch();">重置</a>
					 <a href="#"
					class="easyui-linkbutton" iconCls="icon-export"
					onclick="exportExcel();">导出</a>
		</div>
<div style="min-height:550px">
  <div id="container" style="min-width:750px;height:450px"></div>
  <div width="600px" id="enterTable" align="center">  </div>
    <div class="easyui-window" id="detailListwin"  style="width:1100px; height:500px;padding:10px 20px;" 
  		 data-options="iconCls:'icon-add',closed:true, border:false,title:'部门上报统计图'" >
  		 <div id="container2" style="width:540px;float:left;" ></div>
  		 <div id="container3" style="width:500px;float:left;" ></div>
     </div>
      <div class="easyui-window" id="dListWin"  style="width:960px; height:500px;padding:10px 20px;" 
  		 data-options="iconCls:'icon-add',closed:true, border:false" >
  		 <div id="detailList" style="width:900px;" ></div>
     </div>
  </div>
  
</body>
</html>




