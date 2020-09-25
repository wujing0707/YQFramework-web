function AccordionMenu(options) {
	this.config = {
		containerCls : '.wrap-menu', // �������
		menuArrs : '', // Json�����������
		type : 'click', // Ĭ��Ϊclick Ҳ����mouseover
		renderCallBack : null, // ��Ⱦhtml�ṹ��ص�
		clickItemCallBack : function(){
			var li = document.getElementsByTagName("li");  //获取页面所有li节点  
			  for(var i=0;i<li.length;i++)                                     //循环li节点  
			  {  
				   li[i].onclick=function(){   
				   if ( $(this).is(':has(li)') ) {
			    	    // Code
			    	}
			    	else
			    	{//为循环的li节点绑定 onclick事件  
					    for(var j=0;j<li.length;j++)  
					    {  
					    	li[j].style.backgroundColor="#f0f9fd";                  //将所有li背景颜色修改  
					    	this.style.backgroundColor="#c6e5f5";                //将当前点击的li背景颜色修改  
					    }  
			    	}
			   }  
			  }  
		}
	// ÿ���ĳһ��ʱ��ص�
	};
	this.cache = {

	};
	this.init(options);
}
$('.menuson li a').click(function(){
	alert();
    $('.menuson li').removeClass('bs');
    //$(this).parent().addClass('bs');
    $(this).parent().css("backgroundColor","#c6e5f5");
   })
AccordionMenu.prototype = {

	constructor : AccordionMenu,

	init : function(options) {
		this.config = $.extend(this.config, options || {});
		var self = this, _config = self.config, _cache = self.cache;

		// ��Ⱦhtml�ṹ
		$(_config.containerCls).each(function(index, item, path) {
			self._renderHTML(item);

			// �������¼�
			self._bindEnv(item);
		});
	},
	_renderHTML : function(container) {
		var self = this, _config = self.config, _cache = self.cache;
		var ulhtml = $('<dl class="leftmenu"></dl>');
		$(_config.menuArrs)
				.each(
						function(index, item) {
							var picIndex = index + 1;
							var url = item.url || 'javascript:void(0)';
							var lihtml = $('<dd><div class="title"><span><img src="../../images/leftico0'+picIndex+'.png" /></span>'
									+ item.name + '</div></dd>');
							// var lihtml =
							// $('<li><h2>'+item.name+'</h2></li>');
							if (item.submenu && item.submenu.length > 0) {
								self._createSubMenu(item.submenu, lihtml);
							} else {
								// 没有子菜单也要展开
								self._createMainMenu(item, lihtml);
							}
							$(ulhtml).append(lihtml);
						});
		$(container).append(ulhtml);

		_config.renderCallBack && $.isFunction(_config.renderCallBack)
				&& _config.renderCallBack();

		// ����㼶����
		self._levelIndent(ulhtml);
	},
	/**
	 * �����Ӳ˵�
	 * 
	 * @param {array}
	 *            �Ӳ˵�
	 * @param {lihtml}
	 *            li��
	 */
	_createSubMenu : function(submenu, lihtml) {
		var self = this, _config = self.config, _cache = self.cache;
		var subUl = $('<ul class="menuson"></ul>'), callee = arguments.callee, subLi;
		$(submenu).each(
				function(index, item) {
					var url = item.url || 'javascript:void(0)';

					subLi = $('<li><cite></cite><a href="' + url + '" target="iframeCon">'
							+ item.name + '</a><i></i></li>');
					if (item.submenu && item.submenu.length > 0) {
						$(subLi).children('a').prepend(
								'<img src="../../images/blank.gif" alt=""/>');
						callee(item.submenu, subLi);
					}
					$(subUl).append(subLi);
				});
		$(lihtml).append(subUl);
	},
	/**
	 * 展开没有子菜单的主菜单
	 * 
	 * @param {array}
	 *            �Ӳ˵�
	 * @param {lihtml}
	 *            li��
	 */
	_createMainMenu : function(item, lihtml) {
		var self = this, _config = self.config, _cache = self.cache;
		var subUl = $('<ul class="menuson"></ul>'), callee = arguments.callee, subLi;
		var url = item.url || 'javascript:void(0)';

		subLi = $('<li><cite></cite><a href="' + url + '" target="iframeCon">' + item.name
				+ '</a><i></i></li>');
		$(subLi).children('a').prepend(
				'<img src="../../images/blank.gif" alt=""/>');
		//callee(item.submenu, subLi);
		$(subUl).append(subLi);
		$(lihtml).append(subUl);
	},
	/**
	 * ����㼶����
	 */
	_levelIndent : function(ulList) {
		var self = this, _config = self.config, _cache = self.cache, callee = arguments.callee;

		var initTextIndent = 2, lev = 1, $oUl = $(ulList);

		while ($oUl.find('ul').length > 0) {
			initTextIndent = parseInt(initTextIndent, 10) + 2 + 'em';
			$oUl.children().children('ul').addClass('lev-' + lev)
					.children('li').css('text-indent', initTextIndent);
			$oUl = $oUl.children().children('ul');
			lev++;
		}
		$(ulList).find('ul').hide();
		$(ulList).find('ul:first').show();
	},
	/**
	 * ���¼�
	 */
	_bindEnv : function(container) {
		var self = this, _config = self.config;

		$('h2,a', container).unbind(_config.type);
		$('h2,a', container).bind(
				_config.type,
				function(e) {
					if ($(this).siblings('ul').length > 0) {
						$(this).siblings('ul').slideToggle('slow').end()
								.children('img').toggleClass('unfold');
					}

					$(this).parent('li').siblings().find('ul').hide().end()
							.find('img.unfold').removeClass('unfold');
					_config.clickItemCallBack
							&& $.isFunction(_config.clickItemCallBack)
							&& _config.clickItemCallBack($(this));

				});
	}
};
