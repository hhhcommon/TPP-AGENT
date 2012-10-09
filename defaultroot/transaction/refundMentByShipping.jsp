<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c"%>
<%@ taglib uri="/WEB-INF/fmt.tld" prefix="fmt"%>
<%@taglib uri="/WEB-INF/struts-html-el.tld" prefix="html" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<!--JSP页面: transaction/refundMentByShipping.jsp -->

	<head>
<title>钱门支付！--网上支付！安全放心！</title>

		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		
		<link rel="stylesheet" href="../_css/qianmen.css" type="text/css" />
		<link rel="stylesheet" href="../_css/shining.css" type="text/css" />
		<script src="../_js/prototype.js"></script>
		<script language="javascript">
		
		function show_date_time(){
			var accountDate = "<fmt:formatDate pattern='yyyy/MM/dd HH:mm:ss' value='${transaction.accountDate}'/>";
			var timeDiv = document.getElementById("timeDiv");
			
			window.setTimeout("show_date_time()", 1000);
			var target=new Date(accountDate);
			target.setDate(target.getDate()+7);
			today=new Date();

			timeold=(target.getTime()-today.getTime());
			
			sectimeold=timeold/1000;
			secondsold=Math.floor(sectimeold);
			msPerDay=24*60*60*1000;
			e_daysold=timeold/msPerDay;
			daysold=Math.floor(e_daysold);
			e_hrsold=(e_daysold-daysold)*24;
			hrsold=Math.floor(e_hrsold);
			e_minsold=(e_hrsold-hrsold)*60;
			minsold=Math.floor((e_hrsold-hrsold)*60);
			seconds=Math.floor((e_minsold-minsold)*60);
			
			if (daysold<0) {
				timeDiv.innerHTML="交易自动关闭!";
			}
			else{
				if (daysold<10) {daysold="0"+daysold;}
				if (daysold<100) {daysold=daysold;}
				if (hrsold<10) {hrsold="0"+hrsold;}
				if (minsold<10) {minsold="0"+minsold;}
				if (seconds<10) {seconds="0"+seconds;}
				if (daysold<3) {
					timeDiv.innerHTML=daysold+"天"+hrsold+"小时"+minsold+"分"+seconds+"秒</font>";
				}
				else
					timeDiv.innerHTML=+daysold+"天"+hrsold+"小时"+minsold+"分"+seconds+"秒</font>";
			}
		}
		
			function userMark(tid,orderid){
				window.location.href="../transaction/transaction.do?thisAction=userMark&showTabMenuIdList=1,3&showSubMenuIdList=0,4,0,3&tid="+tid+"&orderid="+orderid;
			}
			
			function refundMentNext(tid,orderid){
				var ptype = document.form1.paytype.value;
				var num=0;
	
				for(var i=0;i<document.form1.paytype.length;i++){
		            if(document.form1.paytype[i].checked==true){
		              ptype = document.form1.paytype[i].value;
		              num++;
		              break;
		           	}
	       		} 
	       		if(num==0){
	       			document.getElementById("Error").style.display = "block";
	       			return false;
	       		}
	       		window.location.href="../transaction/transaction.do?thisAction=refundMent&flag=next&tid="+tid+"&orderid="+orderid+"&type=1&ptype="+ptype;
			}
			
			function checknum(){
				 var nn;
				 if(document.getElementById("refundsNote").value.length>200){
				      document.getElementById("refundsNote").value = document.getElementById("refundsNote").value.substring(0,200); 
				 }
				 else{
				    nn=200-document.getElementById("refundsNote").value.length;
				    document.getElementById("syzs").innerHTML="剩余字数："+nn;
				 }
			}
			
			function actionRefund1(){
				var refundsNote = document.getElementById("refundsNote");
				if(refundsNote.value==""){
					alert("必须填写退款理由!");
					refundsNote.focus();
					return false;
				}
				
					var IE_FIREFOX = navigator.appName.indexOf("Explorer" );
				    var payPassword = document.getElementById("payPassword").value;
					var myAjax = new Ajax.Request("../transaction/transaction.do?thisAction=checkPayPassword&payPassword="+payPassword,{method:"post", onComplete:function (originalRequest) {
					var result = originalRequest.responseText;
					var errorMessage = document.getElementById("errorMessage");
					if(result==0){
						errorMessage.innerHTML="<font color=red>支付密码错误!</font>";
					}
					else{
						document.forms[0].submit();
					}
				}, onException:showException});
			}
			
			function actionRefund(ptype){
				var refundsNote = document.getElementById("refundsNote");
				var amount = document.getElementById("amount").value;
				var oldamount = document.getElementById("oldamount").value;
				var sum = Number(oldamount) - Number(amount);
				var showErrorMsg = document.getElementById("showErrorMsg");
				showErrorMsg.innerHTML = "";
				if(amount==""){
					alert("必须填写您愿意向卖家支付的金额!");
					document.getElementById("amount").focus();
					return false;
				}
				else{
			    	var re=/^([1-9]|[0.])[0-9]{0,}(([.]*\d{1,2})|[0-9]{0,})$/;
					if(!re.test(amount)){
						showErrorMsg.innerHTML = "单价只能由数字组成且最多带有2位小数";
						document.getElementById("amount").focus();
						return false;
					}
					else{
						if(Number(amount)>=Number(oldamount)){
							alert("您愿意向卖家支付的金额不能大于或等于交易总金额");
							return false;
						}
					}
		    	}
		    	
		    	var ptype = document.getElementById("paytype").value;
				var num=0;
	
				for(var i=0;i<document.forms[0].paytype.length;i++){
		            if(document.forms[0].paytype[i].checked==true){
		              ptype = document.forms[0].paytype[i].value;
		              num++;
		              break;
		           	}
	       		} 
	       		if(num==0){
	       			alert("请选择是否需要退货");
	       			return false;
	       		}
				
				if(refundsNote.value==""){
					alert("必须填写退款理由!");
					refundsNote.focus();
					return false;
				}
				if (!confirm("你申请退款后,如果卖家同意,他将立即收到货款 "+amount+" 元,而你收到退回的 "+ sum +" 元,是否确认?")) return;
				
					var IE_FIREFOX = navigator.appName.indexOf("Explorer" );
				    var payPassword = document.getElementById("payPassword").value;
					var myAjax = new Ajax.Request("../transaction/transaction.do?thisAction=checkPayPassword&payPassword="+payPassword,{method:"post", onComplete:function (originalRequest) {
					var result = originalRequest.responseText;
					var errorMessage = document.getElementById("errorMessage");
					if(result==0){
						errorMessage.innerHTML="<font color=red>支付密码错误!</font>";
					}
					else{
					    document.forms[0].action="../transaction/transaction.do?thisAction=applicationRefundShop";
						document.forms[0].submit();
					}
				}, onException:showException});
			}
			
			function showException(originalRequest, ex) {
				alert("Exception:" + ex.message);
			}
			
		</script>
	</head>

	<body onload="show_date_time()">
		<div id="warp">
		<c:import url="/_jsp/topMenu.jsp?a=1,3&b=0,4,2,3" />
			<div class="main_top">
      <div class="main_bottom">
        <div class="main_mid">
           <div class="main_title">
        		<div class="main_title_right">
	              <p><strong>退款申请</strong> &nbsp;<html:link page="/transaction/transactionlist.do?thisAction=listTransactions&showTabMenuIdList=1,3&showSubMenuIdList=0,4,0,3&flag=1">返回交易管理</html:link></p>
	           </div>
     		</div>
     	
     	<c:if test="${flag==null}">
     	<img src="../_img/buzhou_1.gif" style="margin-top:12px;"/>
     	</c:if>
     	<c:if test="${flag!=null}">
     	<img src="../_img/buzhou_2.gif" style="margin-top:12px;"/>
     	</c:if>
		</div>
      </div>
    </div>
    <div class="main_top">
      <div class="main_bottom">
        <div class="main_mid">
		<div class="main_title2">
            <span class="right_span">我的账户：<c:out value="${transaction.fromAgent.loginName}"/> <a href="../agent/agent.do?thisAction=agentInfoById&showTabMenuIdList=1,6&showSubMenuIdList=0,7,0,6">查看账户余额</a></span>
            <span class="font_style7">
        		交易信息
           </span>
         </div>
     		
		<div class="refundAgreement">
                <ul>
                    <li><span>交易号：</span><c:out value="${transaction.orderDetails.orderDetailsNo}"/><a href="javascript:userMark('<c:out value="${transaction.id}" />','<c:out value="${transaction.orderDetails.id}" />')"><img src="../_img/beizhu.gif" style="margin-left:8px;"/></a></li>
                    <li><span>交易对方：</span><c:out value="${transaction.toAgent.loginName}"/></li>
                    <li><span>购买时间：</span><fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${transaction.accountDate}"/></li>
                    <li><span>商品名称：</span><c:out value="${transaction.orderDetails.shopName}"/></li>
                    <li><span>商品描述：</span><c:out value="${transaction.orderDetails.detailsContent}"/></li>
                    <li><span style="float:left">购物总价：</span>
                    	<div class="totlePriceTable" style="float: left; width: 442px;">
                        	<div class="totlePriceTitle">
                                <span>单价</span>
                                <span>数量</span>
                                <span>邮费</span>
                                <span>总价</span>
                            </div>
                        	<div class="totlePrice">
                            	<span><fmt:formatNumber pattern="0.00" value="${transaction.orderDetails.shopPrice}"/> 元</span>
                                <span><c:out value="${transaction.orderDetails.shopTotal}"/> 件</span>
                                <span>
                                <c:choose>
	                                <c:when test="${transaction.orderDetails.emailPrice==null}">
									0.00
						            </c:when>
						            <c:otherwise>
						            <fmt:formatNumber pattern="0.00" value="${transaction.orderDetails.emailPrice}"/>
						            </c:otherwise>
						            </c:choose> 元
						        </span>
                                <span><fmt:formatNumber pattern="0.00" value="${transaction.amount}"/> 元</span>
                            </div>
                        </div>
                        <div class="clear"></div>
                    </li>
                </ul>
              </div>	
 	
    
	 <div class="refundAgreement-right">
              	<span class="refundAgreement-right-title"><img src="../_img/ring.gif" style="vertical-align: middle; margin-right: 8px;"/>时间提醒</span>
                <p>您还有<img src="../_img/icon_timeout.gif" style="vertical-align: middle; margin: 0 8px;"/><strong style="margin-right:8px;"><label id="timeDiv"></label></strong>来完成本次交易的“确认到货”。</p>
                <p class="refundAgreement-right-down"> 如果期间您没有“确认到货”，也没有“申请退款”，本交易将自动结束，钱门将把货款支付给卖家（<c:out value="${transaction.toAgent.name}" />）。</p>
                <span class="refundAgreement-right-title"><img src="../_img/Arrow.gif" style="vertical-align: middle; margin-right: 8px;"/>操作提示</span>
                <p>卖家（<c:out value="${transaction.toAgent.name}"/>）已经于 <fmt:formatDate pattern="yyyy-MM-dd HH:mm:ss" value="${logistics.consignmentDate}"/> 发货，请确认收货。</p>
                <p style="margin:20px 12px;"><a href="#">查看留言</a>&nbsp;|&nbsp;<a href="javascript:userMark('<c:out value="${transaction.id}" />','<c:out value="${transaction.orderDetails.id}" />')">编辑备注</a></p>
     </div>
    <div class="clear"></div>
	
		<c:choose>
		<c:when test="${flag==null}">
		
		<div class="main_title2"></div>
              <div class="refundAgreementMore">
                <p style="font-size:14px;"><strong>退款信息</strong></p>
       </div>
       
<div class="refundAgreementModified">
              	<form name="form1" method="post" action=""  id="tt">
              	<table cellpadding="0" cellspacing="0" width="100%" class="information_table">
                    <tr>
                      <td class="right_td right_td_1">购买时间：</td>
                      <td><fmt:formatDate pattern="yyyy年MM月dd日 HH:mm:ss" value="${transaction.accountDate}"/></td>
                    </tr>
                    <tr>
                      <td class="right_td right_td_1">卖家：</td>
                      <td><c:out value="${transaction.toAgent.loginName}"/>（<c:out value="${transaction.toAgent.name}"/>）</td>
                    </tr>
                    <tr>
                      <td class="right_td right_td_1" valign="top">请选择退款情况：</td>
                      <td><input type="radio" value="0" name="paytype" id="paytype1" onclick="javascript:document.getElementById('paytype1_info').style.display = 'block';document.getElementById('paytype2_info').style.display = 'none';" style="font-size: 14px; height: 23px;  width: 25px;" />已经收到货
                      	<div class="haveReceived" id="paytype1_info" style="display:none;">
                        	钱门提醒您：<span class="R">不要因为卖家的折扣，在“没有收到货”的情况下，点<div>此按钮，将导致钱货两空！
                        </div>
                      </td>
                    </tr>
                    <tr>
                      <td>&nbsp;</td>
                      <td><input type="radio" value="1" name="paytype" id="paytype2" onclick="javascript:document.getElementById('paytype2_info').style.display = 'block';document.getElementById('paytype1_info').style.display = 'none';" style="font-size: 14px; height: 23px;  width: 25px;"/>没有收到货
                      	<div class="haveReceived noReceived" id="paytype2_info" style="display:none;">
                        	钱门建议您联系卖家咨询货物是否已经发出。
                        </div>
                      </td>
                    </tr>
               		<tr>
              		  <td colspan="2" style="padding-left:200px;"><span class="simplyBtn_1"><input type="button" class="buttom_middle" value="下一步" onclick="refundMentNext('<c:out value="${transaction.id}" />','<c:out value="${transaction.orderDetails.id}" />')"/></span>
              		  <p>
              		  	<div id="Error" style="display:none;color:red;">请仔细选择您要申请的退款情况！</div>
              		  </td>
            		</tr>
                 </table>
                 </form>
              </div>
</c:when>
<c:otherwise>
	 <div class="main_title2"></div>
              <div class="refundAgreementMore">
                <p style="font-size:14px;"><strong>填写退款协议</strong></p>
     </div>
    <div class="refundAgreementModified">
    <html:form action="transaction/transaction.do?thisAction=applicationRefundMent" method="post">
   
    <input type="hidden" name="tid" value="<c:out value="${transaction.id}"/>"/>
    <input type="hidden" name="orderid" value="<c:out value="${transaction.orderDetails.id}"/>"/>
    <table cellpadding="0" cellspacing="0" width="100%" class="information_table">
          <tr>
          <td class="right_td right_td_1">卖家：</td>
          <td ><c:out value="${transaction.toAgent.loginName}"/>(<c:out value="${transaction.toAgent.name}"/>)</td>
       	  </tr>
       	  <c:if test="${ptype==1}"> <!-- 选择没有收到货 -->
       	  		<tr>
		          <td class="right_td right_td_1">已支付金额：</td>
		          <td><fmt:formatNumber pattern="0.00" value="${transaction.amount}"/> 元</td>
		        </tr>
		        <tr>
		          <td class="right_td right_td_1">我愿意向卖家支付：</td>
		          <td>0.00元（我没有收到货，全额退款）</td>
		        </tr>
		         <input type="hidden" name="amount" id="amount" value="<c:out value="${transaction.amount}"/>"/>
       	  </c:if>
       	  
       	  
       	  <c:if test="${ptype==0}"> <!-- 选择已收到货 -->
       	  <tr>
          <td class="right_td right_td_1">已支付金额：</td>
          <td><fmt:formatNumber pattern="0.00" value="${transaction.amount}"/> 元</td>
        </tr>
        <tr>
          <td class="right_td right_td_1">我愿意向卖家支付：</td>
          <td><input type="text" class="text_style" name="amount" id="amount" onKeyUp="value=value.replace(/[^.0-9]/g,'')" onchange="value=value.replace(/[^.0-9]/g,'')"/> 元 <div id="showErrorMsg" style="color: red"></div></td>
        </tr>
         <tr>
         	<td class="right_td right_td_1">是否需要退货：</td>
         	<td><input type="radio" id="paytype" name="paytype" value="0" onclick="javascript:document.getElementById('tr1').style.display = 'block';document.getElementById('tr2').style.display = 'none';"/>我要退货</td>
         </tr>
         <tr id="tr1" style="display:none;">
         	<td></td>
         	<td>&nbsp;&nbsp;<font color="red">当卖家同意该退货申请后，退货协议将立即生效，交易进入退货流程。</font></td>
         </tr>
         <tr>
         	<td></td>
         	<td><input type="radio" id="paytype" name="paytype" value="1" onclick="javascript:document.getElementById('tr2').style.display = 'block';document.getElementById('tr1').style.display = 'none';"/>不用退货</td>
         </tr>
          <tr id="tr2" style="display:none;">
         	<td><br /></td>
         	<td>&nbsp; <font color="red">当卖家同意该退款申请后，您愿意支付的金额将立即到达卖家账户，退款金额返回您的账户，交易结束。</font><br /></td>
         </tr>
         <input type="hidden" name="oldamount" id="oldamount" value="<c:out value="${transaction.amount}"/>"/>
         </c:if>
         
	 <tr>
      <td class="right_td right_td_1">退款说明：</td>
      <td> 
      	
      	<textarea id="refundsNote" class="text_style" name="orderDetails.refundsNote" cols="60" rows="8" onPropertyChange="checknum()"></textarea>
      	（留言字数不超过200字） <span name="syzs" id="syzs"></span>
      		</td>
    		</tr>
    	<tbody  id="PayPasswordDiv">
		<tr>
			<td class="right_td right_td_1">请输入钱门账户的支付密码：</td>
			<td>
			<input type="password" name="payPassword" class="text_style" id="payPassword" /> &nbsp;<html:link page="/agent/agent.do?thisAction=forgetPassword&type=paypassword" style="margin:0; line-height:0;">找回支付密码</html:link>
			<span id="errorMessage"></span>
			</td>
		</tr>
		</tbody>                     						
		<tr>
      <td class="right_td right_td_1">&nbsp;</td>      
      <td>
      <c:if test="${ptype==0}"> <!-- 选择已收到货 -->
        <span class="simplyBtn_1"><input type="button" class="buttom_middle" value="立即申请退款" onclick="actionRefund('<c:out value="${ptype}"/>')"/></span>
     </c:if>
     
      <c:if test="${ptype==1}"> <!-- 选择没有收到货 -->
        <span class="simplyBtn_1"><input type="button" class="buttom_middle" value="立即申请退款" onclick="actionRefund1()"/></span>
     </c:if>
     </td>
      </tr>
  </table>
</html:form>
</div>
</c:otherwise>
</c:choose>
        </div>
      </div>
    </div>
 <c:import url="/_jsp/footer.jsp"/>
</div>
  </body>
</html>

