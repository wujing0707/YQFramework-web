<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"/>
<%    
	String path = request.getContextPath();    
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";    
	pageContext.setAttribute("basePath", basePath);
%> 
<title>苏州工业园区社会信用信息平台</title>
<meta content="苏州工业园区社会信用信息平台" name="keywords">
<link type="text/css" rel="stylesheet" href="<%=basePath%>css/style.css" />
<link type="text/css" rel="stylesheet" href="<%=basePath%>css/zzsc.css" />
<link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.4/themes/bootstrap/easyui.css">
<link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.4/themes/icon.css">
<link rel="stylesheet" type="text/css" href="<%=basePath%>js/jquery-easyui-1.4/themes/color.css">
<style>
 #stateBut {
	cursor: pointer;
	font-style:oblique;
	font-size:8px;
	color:blue;
  	display:-moz-inline-box;
  	display:inline-block;
}
.normal{background-color:#D4E7F0}
.change{background-color:white}
.butDIV {
	cursor: pointer;
	background-color:#D4E7F0;
}
#dlg label {
	float: left;
	width: 120px;
}
#dlg div {
	padding: 5px;
}
</style>
<script type="text/javascript" src="<%=basePath%>js/jquery-1.10.2.min.js"></script>
<script type="text/javascript" src="<%=basePath%>js/zzsc.js"></script>
<script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.4/jquery.easyui.min.js"></script>
<script type="text/javascript" src="<%=basePath%>js/jquery-easyui-1.4/locale/easyui-lang-zh_CN.js"></script>

<script type="text/javascript">

function changePwd(){
	openover();
	$("#dlg").dialog('open');
	$('#oldPwd').val('');
	$('#newPwd').val('');
	$('#newPwdSure').val('');
}


function SetiframeCon() {
	var height = 500;
	var win = document.getElementById('iframeCon'); 
	if (document.getElementById) {    
		if (win && !window.opera) {
			if (win.contentDocument && win.contentDocument.body && win.contentDocument.body.offsetHeight) {
				if (win.contentDocument.body.offsetHeight > height)
					win.height = win.contentDocument.body.offsetHeight;
				else
					win.height = height;
			} else if (win.contentWindow.document && win.contentWindow.document.body && win.contentWindow.document.body.scrollHeight) {
				if (win.contentWindow.document.body.scrollHeight > height)
					win.height = win.contentWindow.document.body.scrollHeight;
				else
					win.height = height;
			} else if (win.document && win.document.body && win.document.body.scrollHeight) {
				if (win.document.body.scrollHeight > height)
					win.height = win.document.body.scrollHeight;
				else
					win.height = height;
			}
		}   
	}   
}
//window.setInterval("SetiframeCon()", 200);


function $D(){
 var d=document.getElementById('leftTDID');
 var h=d.offsetWidth;
 var maxw=220;//设置Div展开的最高随度
 //每次展开Div时被调用的方法
 function dmove(){
  h+=20; //设置层展开的速度
  if(h>=maxw){
   d.style.width='220px';
   clearInterval(iIntervalId);
  }else{ 
   d.style.width=h+'px';
   $('#leftTDID').show();
  }
 }
 iIntervalId=setInterval(dmove,50);//设置对方法的调用的时间
}
function $D2(){
 var d=document.getElementById('leftTDID');
 var h=d.offsetWidth;
 var maxw=220;
 function dmove(){
  h-=20;//设置层收缩的速度
  if(h<=0){
   $('#leftTDID').hide();
   clearInterval(iIntervalId);
  }else{
   d.style.width=h+'px';
  }
 }
 iIntervalId=setInterval(dmove,20);
}
//点击是执行的方法
function $use(){
	var img = document.getElementById("stateBut");
	if(img.alt == "left"){
		$("#leftTDID").hide();
		img.alt = "right";
		img.src = "../../images/mini-right.gif";
	}
	else{
		$("#leftTDID").show();
		img.alt = "left";
		img.src = "../../images/mini-left.gif";
	}
}

function openover(){
	if(openwinBUT.style.visibility=="visible")
		openwinBUT.style.visibility='hidden';
}
function submitPass(){
	if(!$("#pdform").form("validate")){
	    	$.messager.alert("提示", '请正确填写信息!','info');
	    	return ;
	    }  
	var oldpd = $('#oldPwd').val();
	var newpd = $('#newPwd').val();
	var repd = $('#newPwdSure').val();
	if(!oldpd || !newpd || !repd){
		$.messager.alert('提示',"输入项填写完整!",'info');
		return;
	}
	if(repd!=newpd){
		$.messager.alert('提示',"确认密码与新密码输入不一致!",'info');
		return;
	}
	$.ajax({
			type : 'POST',
			url : '${pageContext.request.contextPath}/system/user/updatePassword.action',
			data:{oldpd:oldpd,newpd:newpd},
			error : function() {$.messager.alert("提示", "网络错误")},
			success : function(data, status) {
						var json = eval('(' + data + ')');
						if (json.success == true) 
							$.messager.alert("提示", "密码修改成功！请重新登录！","info",function(){
									window.location.href="${pageContext.request.contextPath}/login.jsp";
							});
					 	else 
							$.messager.alert("提示", json.msg);
							}
			});
}

</script>

</head>

<body class="bodyBG" style='overflow:auto;overflow-y:auto'>
	<div id="dlg" class="easyui-dialog" title="修改密码" data-options="modal: true" closed="true" style="width:400px;height:200px;padding:10px">
	    <form id="pdform" method="post">
	    <div align="left">
	    			<label for="oldPwd">旧密码:</label>
	    			<input class="easyui-validatebox" type="password" id="oldPwd" name="oldPwd" data-options="required:true,validType:'length[6,8]'"></input></div>
	    			<div align="left">
	    			<label for="newPwd">新密码:</label>
	    			<input class="easyui-validatebox" type="password" id="newPwd" name="newPwd" data-options="required:true,validType:'length[6,8]'"></input></div>
	    			<div align="left">
	    			<label for="newPwdSure">确认密码:</label>
	    			<input class="easyui-validatebox" type="password" id="newPwdSure" name="newPwdSure" data-options="required:true,validType:'length[6,8]'"></input></div>
	    </form>
	    <div></div>
	    <div style="text-align:center;padding:10px">
	    	<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-ok" onclick="submitPass();">确定</a>
	    	<a href="javascript:void(0)" class="easyui-linkbutton" iconCls="icon-cancel" onclick="$('#dlg').dialog('close');">取消</a>
	    </div>
	</div>
<div class="container">
  <div id="top">
    <div class="topright">
      
          <div class="user"><span>${SESSION_USERNAME}</span>
		  <i><img src="../../images/bullet_arrow_down.png"  onmouseover="openwinBUT.style.visibility='visible'" onmouseout="setTimeout('openover()',5000)"/>	
 		  	<div id="openwinBUT"  style="position:absolute;z-index:2;visibility:hidden;border: 1px;">
				<a href="#" id="updateID" style="border:2px solid #CCC;background:#FFF;" onclick="changePwd()"><font color="blue">&nbsp;修改密码 &nbsp;</font></a>
		  	</div>
</i>
		 <i>
           <a href="#" title="退出登录" onclick="outLogin()">退出登录</a>
           </i>
   	  </div>
    
    </div>
  </div>
   </div>
  <div>
      <iframe id="iframeCon2" name="iframeCon2" src="<%=basePath%>top.jsp" frameborder="0" height="120px" width="100%" scrolling="no" allowtransparency="true" onload=""  style="background-color:transparent;"></iframe>
  </div>
  <script type="text/javascript">
function outLogin(){
	$.messager.confirm('确定', '确认要退出吗?', function(r){
		  if (r){
			  location='logOut.action';
		  }
	})
}
	
	$(function(){
		var testMenu = ${SESSION_MENUS};
		new AccordionMenu({
			menuArrs: testMenu
		});
		
		$('.title').click(function(){
		var $ul = $(this).next('ul');
		$('dd').find('ul').slideUp();
		if($ul.is(':visible')){
			$(this).next('ul').slideUp();
		}else{
			$(this).next('ul').slideDown();
		}
	});
	});

	//显示时间
	function add0(m){return m<10?'0'+m:m }
	function currentTime(){
		var time = new Date();
		var y = time.getFullYear();
		var m = time.getMonth()+1;
		var d = time.getDate();
		var h = time.getHours();
		var mm = time.getMinutes();
		var s = time.getSeconds();
		return y+'-'+add0(m)+'-'+add0(d)+' '+add0(h)+':'+add0(mm)+':'+add0(s);
	}
	
/* 	function showTime(){
		document.getElementById('timer').innerHTML=currentTime();
	}
	setInterval('showTime()',1000); */

    </script>
    
  <table width="100%" border="0" cellspacing="0" cellpadding="0" >
    <tr>
      <td valign="top" align="left" id="leftTDID" width="220px;"><div id="leftmenu"> 
          <!-- 左侧栏开始--->
            <div class="lefttop"><span></span>栏目菜单</div>
			<div class="wrap-menu">
			</div>
			<div style="text-align:center;clear:both;"></div>
            <div class="menuBottom"></div>
          <!--左侧栏结束---> 
          
        </div>
        
        </td>
        <td width="6px;" class="butDIV" onmouseout="this.className='normal'"><div ><span id="" >
        	<img id="stateBut" alt="left" src="../../images/mini-left.gif"/ onclick="$use()"></span></div></td>
      	<td style="position: relative;" valign="top" align="left">
      	<div >
          <iframe id="iframeCon" name="iframeCon" src="<%=basePath%>welcome.jsp" frameborder="0" onload="SetiframeCon()" height="100%" width="100%" scrolling="auto" allowtransparency="true" onload=""  style="background-color:transparent;"></iframe>
        </div>
      <br /></td>
    </tr>
  </table>
</body>
</html>
