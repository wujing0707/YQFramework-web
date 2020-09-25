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
  <script type="text/javascript" src="http://cdn.hcharts.cn/jquery/jquery-1.8.3.min.js"></script>
  <!--  <script type="text/javascript" src="<%=basePath%>js/jquery-1.10.2.min.js"></script> --> 
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.3.4/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.3.4/locale/easyui-lang-zh_CN.js"></script> 
    <script type="text/javascript" src="<%=basePath%>js/jquery-easyui-extend.js"></script>
     <script type="text/javascript" src="<%=basePath%>js/base.js"></script>
    <!-- <script type="text/javascript" src="<%=basePath%>js/jquery-highcharts-3.0.6/highcharts.js"></script>-->
   
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

 //$(function(){
//	 getEnterpriseChat();
//	 });
	 
	function getEnterpriseChat(){
		$("#container2").hide();
		$("#enterTable").hide();
		var depts=$("#dept").combobox('getValues');
		var timeBegin=$("#timeBegin").val();
		var timeEnd=$("#timeEnd").val();
		depts=encodeURI(encodeURI(depts, "UTF-8"), "UTF-8");
		var url="<%=basePath%>enterpriseanalysis/sbsj.action?deptName="+depts+"&timeBegin="+timeBegin+"&timeEnd="+timeEnd;
		$.ajax({
                url: url,
                dataType: 'json',
                beforeSend:ajaxLoading,//发送请求前打开进度条
                success:function(ret){ 
			var depts=new Array();
			var cishu=new Array();
			var tiaoshu=new Array();
			 $.each(ret,function(i,d){
				 depts.push(d.dept);
				 cishu.push(parseInt(d.cishu));
				 tiaoshu.push(parseInt(d.tiaoshu));
				 
				 })
				
				  
	
            $('#container').highcharts({ 
                chart: { zoomType: 'xy' }, 
                title: { text: '上报数据统计图' },
                plotOptions: { 
                	series: { cursor: 'pointer', 
                		events: {
                		click: function(e) {//点击图上的值时会调用。this为series 
					  	getlineChart(e.point.category,this.name);
					 	 } 
                } }
                },
				  credits: {
		                enabled:false
		            },
                  xAxis: [{ labels: {step:1,
                	  rotation:-70
                  },
                      categories: depts }], 
                      yAxis: [{ // Primary yAxis 
                    	  allowDecimals:false, //是否允许刻度有小数 
                    	   min: 0, 
                          labels: {
                           format: '{value}',
                           style: { color: '#89A54E' } 
                          },
                          title: { 
                            text: '上报条数', 
                            style: { color: '#89A54E' } 
                          } 
                         	 }, 
                          { // Secondary yAxis
                         		allowDecimals:false, //是否允许刻度有小数 
                         		   min: 0, 
                               title: { 
                              text: '上报次数',
                               style: { color: '#4572A7' } 
                         		 }, 
                         		 labels: { format: '{value}',
                             		  style: { color: '#4572A7' }
                        		   },
                        		    opposite: true 
                      	  	}], 
                        	 tooltip: { shared: true },
                     		     legend: { layout: 'vertical', 
                        		  align: 'left',
                        		  x: 120, 
                        		 verticalAlign: 'top', 
                        		   y: 100,
                        		  floating: true, 
                           		   backgroundColor: '#FFFFFF' },
                           		  series: [
                                 		        {   name: '上报次数', 
                                     		        color: '#4572A7',
                                     		         type: 'column', 
                                     		         yAxis: 1, 
                                     		         data: cishu, 
                                     		         tooltip: { valueSuffix: ' 次' } 
                                		         }, { name: '上报条数',
                                    		          color: '#89A54E', 
                                    		          type: 'spline', 
                                    		          data: tiaoshu, 
                                    		          tooltip: { valueSuffix: '条' } 
                               		          }
                              		        ] 
                                });
			 ajaxLoadEnd();//任务执行成功，关闭进度条   
		}
			 
		});
				

        
	           
	}


	function getlineChart(dept,type){
		$("#container2").show();
		$("#enterTable").show();
		
		var url;
		var timeBegin=$("#timeBegin").val();
		var timeEnd=$("#timeEnd").val();
		var deptName=encodeURI(encodeURI(dept, "UTF-8"), "UTF-8");
		if(type=='上报次数'){
			var url="<%=basePath%>enterpriseanalysis/sbcs.action?deptName="+deptName+"&timeBegin="+timeBegin+"&timeEnd="+timeEnd;
			}else if(type=='上报条数'){
			var url="<%=basePath%>enterpriseanalysis/sbts.action?deptName="+deptName+"&timeBegin="+timeBegin+"&timeEnd="+timeEnd;
				}
		var infoClass=[];
		$.ajax({
               url: url,
                dataType: 'json',
                beforeSend:ajaxLoading,//发送请求前打开进度条
                success:function(ret){ 
			  var htmlStr = "<tr style='background-color:#81AACF'><td height='40px'>部门</td><td>信息类</td>"+
              "<td >时间</td><td>"+type+"</td></tr>";
              var flag='1';
                for(var n=0;n<ret.seriesData.length;n++){
              for(var m=0;m<ret.month.length;m++){
            	  if(ret.seriesData[n].data[m]!=0){
            		  infoClass.push(ret.seriesData[n].name);
            		  flag='0';
					 htmlStr=htmlStr+"<tr><td height='30px'>"+dept+"</td><td>"+ret.seriesData[n].name+"</td><td>"+
		             +ret.month[m]+"</td><td>"+ret.seriesData[n].data[m]+"</td></tr>";
            	  }
              }
              }
                if(flag=='1'){
                	 htmlStr=htmlStr+"<tr><td height='30px' colspan='4'>没有数据</td></tr>";
                }

             var enterTable = "<table border='1' style='width:450px;text-align:center;' align='center'>"+htmlStr+"</table>";
	            $("#enterTable").html(enterTable);
	            //alert(infoClass);
	            var result=[];
	            for(var k=0;k<ret.seriesData.length;k++){
	            	for(var v=0;v<infoClass.length;v++)
	            	if(infoClass[v]==ret.seriesData[k].name){
	            		result.push(ret.seriesData[k]);
	            	}
	            }
		
	            $('#container2').highcharts({ title: { text: dept+type, x: 0 //center
	  		  }, 
	  		   xAxis: { 
	  			   title:{text:'月份 '},
	  			   categories: ret.month
	  				    }, 
	  			   yAxis: {
	  			title: { text: type },
	  			   min: 0, 
	  			 plotLines: [{ value: 0, width: 1, color: '#808080' }] }, 
	  			 credits: {
	  	                enabled:false
	  	            },
	  			 legend: { layout: 'vertical', 
	  				 align: 'right', 
	  				 verticalAlign: 'middle', 
	  				 borderWidth: 0 },
	  				  series:result
	  	 });
		 ajaxLoadEnd();//任务执行成功，关闭进度条 
		 window.location.hash = "#container2";  
	      }
		});
	}

	 
	
	function enterpriseSearch(){
		getEnterpriseChat();
		aa=new Array();
	
	}
	
	function clearEnterpriseSearch(){
		if($("#dept").combobox('getData').length>1){
	  		$("#dept").combobox('setValues',[]);
	}
	  $("#timeBegin").val('');
	  $("#timeEnd").val('');	
	}

	function exportExcel(){
		var depts=$("#dept").combobox('getValues');
		var timeBegin=$("#timeBegin").val();
		var timeEnd=$("#timeEnd").val();
		depts=encodeURI(encodeURI(depts, "UTF-8"), "UTF-8");
		window.location.href="<%=basePath%>enterpriseanalysis/sbsjExport.action?deptName="+depts+"&timeBegin="+timeBegin+"&timeEnd="+timeEnd;
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
				<label for="depts">上报部门:</label> <input 
					class="easyui-combobox" id="dept" editable="false"
					data-options="valueField:'name', textField:'name',multiple:true,
					url:'<%=basePath%>enterpriseanalysis/getDetpList.action?deptId=<%=user.getDepartmentId() %>',
					onLoadSuccess:function(data){if(data.length==1) {$('#dept').combobox('setValue',data[0].name);}
                	getEnterpriseChat();
                }"	/>
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
			<div style="min-height:600px;width:100%;">	
  <div id="container" style="height:500px;width:100%;"></div>
  <div id="container2" style="width:550px;min-height:400px;float:left;"></div>
  <div id="enterTable" align="center" style="margin-bottom:20px;" ></div>
  </div>
</body>
</html>




