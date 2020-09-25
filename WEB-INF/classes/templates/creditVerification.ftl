<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <style type="text/css">     
			body {     
			     font-family: SimSun;         
			} 
			.clear{height:20px}   
			.table{ width:100%;border-collapse:collapse}
			.table th{ font-weight:bold; font-size:18px; min-width:70px}
			.table th,.table td{font-size:16px; border:1px solid #000;height:24px; line-height:24px; padding:5px; text-align:center;table-layout:fixed;word-break:break-all; word-wrap:break-word; }
						
		</style> 
    </head>
    <body>
    
				<div style="width:100%;margin:0 auto;text-align:center"> 
					 <div id="div_print"> 
					   <p>
				       	<font style="font-size:30px;">${verificationinfo.qymc}</font><br /><br />
				       	<font style="font-size:25px;float:left">一、企业标识信息</font><br />
				       </p>
				       
					      <table class="table">
							    	<tr height="60px">
							    		<th width="40%" style="font-size:20px">企业名称</th>
							    		<th width="20%" style="font-size:20px">组织机构代码</th>
							    		<th width="20%" style="font-size:20px">工商注册号</th>
							    		<th width="20%" style="font-size:20px">法定代表人</th>
							    	</tr>
							      	<tr height="60px">
							    		<td width="40%" style="font-size:15px">${verificationinfo.qymc}</td>
							    		<td width="20%" style="font-size:15px">${verificationinfo.zzjgdm}</td>
							    		<td width="20%" style="font-size:15px">${verificationinfo.gszch}</td>
							    		<td width="20%" style="font-size:15px">${verificationinfo.fddbr}</td>
							    	</tr>  	
					      </table>
					      <div class="clear"></div>
					      
					      <div style="width:100%;height:140px">
					      	<p style="height:30px">
				       			<font style="font-size:25px;float:left">二、信用核查授权码</font>
				       		</p>
				 			<div class="clear"></div>
					      	<div style="float:left;font-size:20px">
								&nbsp;信用核查授权码：<font style="font-size:22px;font-weight:700">${verificationinfo.ccode}</font><br /><br />
								有效期：<font style="font-size:22px;font-weight:700">${verificationinfo.creattime}--${verificationinfo.validtime}</font>
							</div>
					      </div>  
					      
						  <div class="clear"></div>
					      
					      <div>
					      	<p style="height:30px">
				       			<font style="font-size:25px;float:left">使用说明：</font>
				       		</p>
				 			<div class="clear"></div>
					      	<div style="float:left;font-size:20px">
								<span style="float:left;font-size:20px">1、在信用核查码有效期内，被授权企业可以通过“企业通”在线核查授权企业</span><br />
								<span style="float:left;font-size:20px">的信用核查结果信息。</span><br />
								<span style="float:left;font-size:20px">2、超过信用核查授权码有效期，信用核查凭证单自动失效。</span><br />
								<span style="float:left;font-size:20px">3、授权企业对各自授权负责，请企业谨慎进行授权操作。</span>
							</div>
					      </div>  
					      
					      
					      <div style="margin-top:200px">
					      	<div style="float:right;font-size:20px;margin-right:200px">
								　授权人名称：（盖章）  <br />         
								日期：
							</div>
					      </div> 
					     </div>        	      
				      </div>
      <div class="clear"></div>                      
      
    </body>
</html>