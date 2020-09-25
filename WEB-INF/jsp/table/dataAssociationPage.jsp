<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>企业征信数据处理</title>
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/themes/bootstrap/easyui.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/themes/icon-suit-a.css">
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery-easyui-1.3.4/locale/easyui-lang-zh_CN.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/js/json2.js"></script>
	
	<script type="text/javascript">
	$(function(){
		$.post("${pageContext.request.contextPath}/system/data/dataAssociation.action", {}, 
				function(data){
					$('#list2').empty();
					var html = "";
					for(i = 0; i < data.length; i++){
						html += "<option value='"+data[i].tableName+"'>"+data[i].tableName+"</option>"
					}
					$('#list2').html(html);
				}
			,"json");
		
	});
	$(function(){
		$.post("${pageContext.request.contextPath}/system/data/albtEntityTables.action", {}, 
				function(data1){
					$('#list1').empty();
					var html = "";
					for(i = 0; i < data1.length; i++){
						html += "<option value='"+data1[i].tableName+"'>"+data1[i].tableName+"</option>"
					}
					$('#list1').html(html);
				}
			,"json");
		
	});
	function saveTableNames(){
		var size = $('#list2 option').size();
		var tableNames = "";
		for(i = 0; i < size; i++) {
			if(i < size - 1){
				tableNames += document.getElementById('list2').options[i].value + ",";
			}else{
				tableNames += document.getElementById('list2').options[i].value;
			}
		}
		$.messager.confirm("提示", "您确认要提交这些数据吗  ?", function(res){
          if (res) {
        	  $.post("${pageContext.request.contextPath}/system/data/savaTableNames.action", { tableNames: tableNames}, function(data){
                  if(data.result){
                      $.messager.alert("提示", data.message, "info")
                  }else{
                      $.messager.alert("提示", data.message, "info")
                  }
              },"json");
 			}
	  })
	}
	</script>
</head>  
<body>  
	<div class="easyui-panel" title="数据关联配置">
    <form method="post" name="myform">  
    <div style="width: 80%; padding: 15px;" align="left">
    <table border="0">  
<!--     	<tr><td colspan="3" align="center"><p style="font-size: 12px;padding: 10px;">操作提示：选定一项或多项然后点击添加或移除(按住shift或ctrl可以多选)，或在选择项上双击进行添加或移除。</p>  </td></tr> -->
    	<tr><td colspan="3" align="center"><p style="font-size: 12px;padding: 10px;">操作提示：选定一项然后点击新增或移除，或在选择项上双击进行新增或移除。</p>  </td></tr>
        <tr>  
            <td >  
                <select style="width:300px; height:400px"  multiple name="list1" id="list1"  ondblclick="ListBox_Move('list1','list2')">  
                </select>  
            </td>  
            <td  align="center">  
             	<a href="javascript: ListBox_Move('list1','list2');" class="easyui-linkbutton" data-options="iconCls:'icon-add'">新增</a>
             	<br/><br/>
        		<a href="javascript: ListBox_Move('list2','list1');" class="easyui-linkbutton" data-options="iconCls:'icon-remove'">移除</a>
                <%-- <input type="button" value=">>" onclick="ListBox_Move('list1','list2')"><br />  
                <br />  
                <input type="button" value="<<" onclick="ListBox_Move('list2','list1')">   --%>
            </td>  
            <td >  
                <select style="width:300px; height:400px"  multiple name="list2" id="list2"  ondblclick="ListBox_Move('list2','list1')">  
                </select>  
            </td>  
            <!-- <td>  
                <button onclick="ListBox_Order('list2','up')" type="button">  
                    ∧</button>  
                <br />  
                <button onclick="ListBox_Order('list2','down')" type="button">  
                    ∨</button>  
            </td>  --> 
        </tr>  
        <tr><td colspan="3" style="height: 40px;"></td></tr>
        <tr>
        	<td colspan="3" align="center">
		    	<a href="javascript: saveTableNames();" class="easyui-linkbutton" data-options="iconCls:'icon-save'">保存</a>
        	</td>
        </tr>
    </table>  
    </div>
<!--     <button onclick="saveTableNames()" type="button">确定</button>   -->
    </form>
    </div>
    <script language="JavaScript">
    function hasNeedColumn(tableName){
    	
    }
	function ListBox_Move(listfrom,listto)
	{
		var size = $("#" + listfrom + " option").size();
		var selsize = $("#" + listfrom + " option:selected").size();
		if(size>0 && selsize>0)
		{
			var tables = '';
			$.each($("#"+listfrom+" option:selected"), function(i,own){
				//console.info($(own).val());
		    	$.ajax({
		    		   type: "POST",
		    		   url: '${pageContext.request.contextPath}/system/data/hasNeedColumn.action',
		    		   data: {tableName: $(own).val()},
		    		   dataType: 'json',
		    		   async: false,
		    		   success: function(data){
		    			   if(data.result){
			    			   $(own).appendTo($("#" + listto));
			   				   $("#" + listfrom + "").children("option:first").attr("selected",true);
		    			   }else{
		    				   tables += '['+data.message+']<br/>';
		    			   }
		    		   }
		    	});
		    	//$.post('${pageContext.request.contextPath}/system/data/hasNeedColumn.action')
			});
			if(tables != '')
	    		$.messager.alert('提示', '您选择的以下表，没有 process_status 字段<br/>无法新增：<br/>'+ tables);
		}
	}

	function ListBox_Order(ListName,action)
	{
		var size = $("#"+ListName+" option").size();
		var selsize = $("#"+ListName+" option:selected").size();
		if(size > 0 && selsize > 0)
		{
			$.each($("#"+ListName+" option:selected"),function(i,own){
				if(action == "up")
				{
					$(own).prev().insertAfter($(own));
				}
				else if(action == "down")//down时选中多个连靠则操作没效果
				{
					$(own).next().insertBefore($(own));
				}
			})
		}
	}
    </script>  
</body>  
</html>  