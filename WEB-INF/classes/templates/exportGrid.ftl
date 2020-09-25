<a 
<#if id?? && id != ""> 
  id ="${id}"
</#if> 
href="#" class="easyui-linkbutton" 
data-options="iconCls: 'icon-search', plain: true" onclick="exportData('${gridId}');">导出</a>

<div style="display: none">
    <form id="ablg" action="${exportUrl}" method="post">
        <input type="hidden" name="excelField" id="excelField"></input>
        <input type="hidden" name="excelValues" id="excelValues"></input>
        <input type="hidden" name="titleArr" id="titleArr"></input>
        <input type="hidden" name="fieldArr" id="fieldArr"></input>
    </form>
</div>