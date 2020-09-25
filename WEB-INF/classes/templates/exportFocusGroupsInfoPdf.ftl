<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <style type="text/css">     
			body {font-family: SimSun;}
			.clear{height:8px}
			
			table {table-layout:fixed;width:100%; color:black; text-align:center; border-collapse:collapse;font-size:15px;}
			td {border:1px solid black; height:25px;font-size:10px;}
		</style> 
    </head>
    <body>
    
		<div>
			
			<div style="font-size:32px;padding:100px 0 300px 0;text-align:center;font-weight:700">重点人群信用查询报告</div>
			
			<div style="font-size:22px;padding:0 0 500px 0;text-align:center">苏州市工业园区信用办<br /><br />查询日期：${archivesinfo.downtime}</div>
		
		</div>
		       
      <div>    
       	<font style="font-size:30px;"><center>${archivesinfo.xm}</center></font><br /><br />
       	<font style="font-size:20px;">一、重点人群标识信息</font>
	      <table style="table-layout:fixed;">
			    	<tr>
			    		<td width="15%">姓名</td>
			    		<td width="30%">身份证号</td>
			    		<td width="30%">注册证书号</td>
			    		<td width="25%">执业类别</td>
			    	</tr>
			    	
			      	<tr>
			    		<td width="30%"  height="30px" style="word-wrap:break-word;word-break:break-all;">${archivesinfo.xm}</td>
			    		<td width="20%">${archivesinfo.sfzh}</td>
			    		<td width="25%">${archivesinfo.zczsh}</td>
			    		<td width="25%">${archivesinfo.zylb}</td>
			    	</tr>  	
	      </table>
      </div>
      <div class="clear"></div>
      
      <div>
          <#list archivesinfo.tablelist as info>
              <br/>
              <font style="font-size:20px;">
                  <#if (info_index + 2) == 2>二、</#if>
                  <#if (info_index + 2) == 3>三、</#if>
                  <#if (info_index + 2) == 4>四、</#if>
                  <#if (info_index + 2) == 5>五、</#if>
                  <#if (info_index + 2) == 6>六、</#if>
                  <#if (info_index + 2) == 7>七、</#if>
                  <#if (info_index + 2) == 8>八、</#if>
                  <#if (info_index + 2) == 9>九、</#if>
                  ${info.name}
              </font>
              <br/>
              <#if (info.list?size > 0)>
                  <#list info.list as deptInfo>
                      <font>${deptInfo.deptName}-${deptInfo.tableName}</font>
                      
                      <table bordercolor="black" border="1" cellspacing="0" 
                          style="word-break:break-all;word-wrap:break-word;
                          width:100%;text-align:center;margin:0 auto;font-size:14px">
                          
                          <tr>
                              <#list deptInfo.columnName as titleInfo>
                                  <td style="word-break:break-all;word-wrap:break-word;">${titleInfo}</td>
                              </#list>
                          </tr>
                          
                          <#if (deptInfo.columnVal?size > 0)>
                              <#list deptInfo.columnVal as vals>
                                  <tr style="word-break:break-all word-wrap:break-word;">
                                      <#list vals as val>
                                          <td width="100px">${val}</td>
                                      </#list>
                                  </tr>
                              </#list>
                          <#else>
                              <tr>
                                  <td colspan="${deptInfo.columnName?size}" width="120">暂无信息</td>
                              </tr>
                          </#if>
                      </table>
                  </#list>
              </#if>
          </#list>
      </div>
      
      <div class="clear"></div>                      
      
    </body>
</html>