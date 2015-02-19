<%@ page import="java.sql.Connection,
                 java.sql.Statement,
                 co.simplypos.model.website.utils.Logger,
                 co.simplypos.model.website.WebSite,
                 javax.mail.MessagingException,
                 java.sql.SQLException,
                 co.simplypos.model.website.ShoppingBasket,
                 co.simplypos.model.TransactionManager,
                 co.simplypos.persistence.TransactionLine,
		 co.simplypos.persistence.TransactionLineDiscount, 
                 co.simplypos.model.utils.helpers.HTMLHelper,
		 co.simplypos.model.utils.helpers.StringHelper,
                 java.util.ArrayList,
                 java.util.Vector,
                 java.util.Hashtable,
                 co.simplypos.model.website.ArticleDetail,
                 co.simplypos.model.website.error.ErrorPageServlet,
                 co.simplypos.persistence.PersistenceManager,
                 co.simplypos.persistence.Currency,
			co.simplypos.model.website.payment.PaymentProviderFactory,
			co.simplypos.model.website.payment.PaymentProviderPayPal,
			co.simplypos.model.website.payment.PaymentProviderHSBC,
			co.simplypos.model.website.payment.PaymentProviderWorldpay,
			co.simplypos.model.website.payment.PaymentProvider,
			co.simplypos.model.website.ProtxHelper,
                 java.util.Enumeration, 
                 java.net.*,
                 java.io.*,
		   java.math.BigDecimal,
		co.simplypos.model.utils.helpers.MailHelper,
		 com.clearcommerce.CpiTools.security.HashGenerator  "
                 %>
<jsp:useBean id="website" scope="application" class="co.simplypos.model.website.WebSite"><%website.initialise(request.getRequestURL().toString(), application.getRealPath("/"), 186);%></jsp:useBean>
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession"><%userSession.initialise(website);%></jsp:useBean>
<html>   
<head>
<title><%=website.getWebsiteName()%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="pragma" content="nocache">
<meta http-equiv="expires" content="Sun, 4 Oct 1998 15:00:00 GMT">
<meta name="<%=website.getWebsiteName()%>" content="Gift ideas complemented with beautiful handcrafted cards and giftwrap">
<meta name="keywords" content="gift, gifts, gift shop, present, presents, card, cards, giftwrap, handcrafted, hand-crafted, hand crafted, handmade, hand-made, unusual, unique, gift ideas">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" href="cc.css" type="text/css">
</head>
<body>
<table width="100%" celpadding="0" cellspacing="0" align="center">
<tr><td>
<%
try {
	
	website.writeToLog("post_pp start");

    Float authAmount = null;
    Integer cartId = null;
    Integer tr1ansId = null;
    String transStatus = null;
    String callbackPW = null;
    String emailAddress = null;
    String desc = null;
    String HTMLReceipt = null;
    String testMode = null;
    String txnId = null;
    //double deliveryCharge = 0;
	boolean authorised = false;
	boolean inTestMode = true;
	boolean accepted = false;
	String notAcceptedReason = "";
	String paymentProvider = "unknown";
	
	String params = "";
	Enumeration enum1 = request.getParameterNames();
	while(enum1.hasMoreElements()) {
		String el = ""+enum1.nextElement();
		params += el+" = "+request.getParameter(el)+"\n";
	}
	
	if (request.getParameter("transId") != null && request.getParameter("transStatus") != null) {	
		paymentProvider = "worldpay";
	} else if (request.getParameter("OrderHash") != null && request.getParameter("CpiResultsCode") != null) {
		paymentProvider = "HSBC";
	} else if (request.getParameter("txn_id") != null && request.getParameter("mc_gross") != null) {
		paymentProvider = "paypal";
	}
	
	try {
		MailHelper.sendEmailFromWebsite("nmackley@intelligentretail.co.uk", "paymentProvider: "+paymentProvider,params,params,"support@intelligentretail.co.uk", "nmackley@intelligentretail.co.uk", website.getWebSitePath(), null);
	} catch (Exception sdsd8938949sf) { website.writeToLog(sdsd8938949sf); }

	//website.sendEmail("nmackley@intelligentretail.co.uk","paymentProvider: "+paymentProvider,params,params);
	//website.sendEmail("nmackley@intelligentretail.co.uk","paymentProvider: "+paymentProvider,params,params);
	//System.out.println("paymentProvider: "+paymentProvider);
	
	if (paymentProvider.equals("worldpay")) {
		ArrayList<PaymentProvider> paymentProviders = userSession.getWebSite().getPaymentProviders();
        	for (PaymentProvider provider : paymentProviders) {
        		if (provider.getPaymentProviderKey() == PaymentProviderWorldpay.PAYMENT_PROVIDER_KEY) {
        			userSession.setCurrentPaymentProvider(provider);
        		}
        	}
        	
		// Presume Worldpay		
  	  	if (request.getParameter("testMode") != null) testMode = request.getParameter("testMode");
  	  	if (request.getParameter("transId") != null) txnId = request.getParameter("transId");
    		if (request.getParameter("transStatus") != null) transStatus = request.getParameter("transStatus");
    		if (request.getParameter("authAmount") != null) authAmount = new Float(Float.parseFloat(request.getParameter("authAmount")));
    		if (request.getParameter("cartId") != null) cartId = new Integer(Integer.parseInt(request.getParameter("cartId")));
    		if (request.getParameter("callbackPW") != null) callbackPW = request.getParameter("callbackPW");
    		if (request.getParameter("email") != null) emailAddress = request.getParameter("email");
    		if (request.getParameter("desc") != null) desc = request.getParameter("desc");

		authorised = (transStatus.equalsIgnoreCase("y") && callbackPW.equals("tcennoc") && cartId != null && cartId.intValue() > 0);
		inTestMode = testMode.equals("100");
		accepted = true;
	} else if (paymentProvider.equals("HSBC")) {
		ArrayList<PaymentProvider> paymentProviders = userSession.getWebSite().getPaymentProviders();
        	for (PaymentProvider provider : paymentProviders) {
        		if (provider.getPaymentProviderKey() == PaymentProviderHSBC.PAYMENT_PROVIDER_KEY) {
        			userSession.setCurrentPaymentProvider(provider);
        		}
        	}

		Vector v = new Vector();
        	Enumeration names = request.getParameterNames();
        	while (names.hasMoreElements()) {
            		String name = (String)names.nextElement();
            		String value = request.getParameter(name);
            		if ((value.length() > 0) && (!name.equals("OrderHash"))) {
                		v.add(value);
            		}
        	}
		String generatedHash = HashGenerator.generateHash(v, userSession.getCurrentPaymentProvider().getSecurityKey());
	        String receivedHash = request.getParameter("OrderHash");
		authorised = generatedHash.equals(receivedHash);

		transStatus = request.getParameter("CpiResultsCode");

		accepted = false;
		if (transStatus.equals("0")) {
			accepted = true;
		} else if (transStatus.equals("1")) {
			notAcceptedReason = "HSBC reported the payment was cancelled by the cardholder.";
		} else if (transStatus.equals("2")) {
			notAcceptedReason = "HSBC reported the processor declined the transaction for an unknown reason.";
		} else if (transStatus.equals("3")) {
			notAcceptedReason = "HSBC reported the transaction was declined because of a problem with the card. For example, an invalid card number or expiration date was specified.";
		} else if (transStatus.equals("4")) {
			notAcceptedReason = "HSBC reported the processor did not return a response.";
		} else if (transStatus.equals("5")) {
			notAcceptedReason = "HSBC reported the amount specified in the transaction was either too high or too low for the processor.";
		} else if (transStatus.equals("6")) {
			notAcceptedReason = "HSBC reported the specified currency is not supported by either the processor or the card.";
		} else if (transStatus.equals("7")) {
			notAcceptedReason = "HSBC reported the order is invalid because the order ID is a duplicate.";
		} else if (transStatus.equals("8")) {
			notAcceptedReason = "HSBC reported the transaction was rejected by FraudShield.";
		} else if (transStatus.equals("9")) {
			notAcceptedReason = "HSBC reported the payment transaction was placed in Review state by FraudShield.";
			accepted = true;
		} else if (transStatus.equals("10")) {
			notAcceptedReason = "HSBC reported the transaction failed because of invalid input data.";
		} else if (transStatus.equals("11")) {
			notAcceptedReason = "HSBC reported the transaction failed because the CPI was configured incorrectly.";
		} else if (transStatus.equals("12")) {
			notAcceptedReason = "HSBC reported the transaction failed because the Storefront was configured incorrectly.";
		} else if (transStatus.equals("13")) {
			notAcceptedReason = "HSBC reported the connection timed out.";
		} else if (transStatus.equals("14")) {
			notAcceptedReason = "HSBC reported the transaction failed because the cardholders browser refused a cookie.";
		} else if (transStatus.equals("15")) {
			notAcceptedReason = "HSBC reported the customers browser does not support 128-bit encryption.";
		} else if (transStatus.equals("16")) {
			notAcceptedReason = "HSBC reported the CPI cannot communicate with the Secure ePayment engine.";
		}



		String merchantData = null;
 	  	if (request.getParameter("MerchantData") != null) merchantData = request.getParameter("MerchantData");
		if (merchantData != null) {
			String[] tokens = StringHelper.split(merchantData,"$");
			testMode = tokens[0];
			emailAddress = tokens[1];
			desc = tokens[2];

			if (testMode == null) testMode = "100";
			inTestMode = testMode.equals("100");

			if (transStatus.equals("9")) {
	                    	try {
        	                	String textEmailBody = website.getWebsiteName()+"\nOrder of "+desc+"\n\nThis email is to notify you that "+notAcceptedReason+".\nThis is not uncommon and maybe a simple discrepancy between your card address and billing address.\n\nThe merchant has also been notified and will contact you if there is a problem with your order.\n\n"+website.getWebSiteURL();
                	        	String htmlEmailBody = "<br>Order of "+desc+"<BR><BR>This email is to notify you that "+notAcceptedReason+"<BR><BR>This is not uncommon and maybe a simple discrepancy between your card address and billing address.\n\nThe merchant has also been notified and will contact you if there is a problem with your order.<BR><BR><a href='"+website.getWebSiteURL()+"'>"+website.getWebsiteName()+"</a>";
                        		if (emailAddress != null && !emailAddress.equals("")) website.sendEmail(emailAddress, "Payment Warning", textEmailBody, htmlEmailBody);
	                    	} catch (Exception e3) {
        	            	    Logger ppLogger = new Logger(website.getWebSitePath(), "logPP_"+txnId);
                	    	    ppLogger.write(e3);
                  	 	}
			}
		} else {
			accepted = false;
			notAcceptedReason = "HSBC sent no merchant data.";
		}	

		if (!accepted) authorised = false;

//website.sendEmail("nmackley@intelligentretail.co.uk","debug info","authorised: "+authorised+"   accepted: "+accepted+"   CpiResultsCode: "+transStatus, "authorised: "+authorised+"   CpiResultsCode: "+transStatus+" - "+notAcceptedReason+"     Test Mode: "+testMode+"   email: "+emailAddress+"    desc: "+desc);
  	  	if (request.getParameter("PurchaseDate") != null) txnId = request.getParameter("PurchaseDate");
    		if (request.getParameter("PurchaseAmount") != null) authAmount = new Float(Float.parseFloat(request.getParameter("PurchaseAmount"))/100);
    		if (request.getParameter("OrderId") != null) cartId = new Integer(Integer.parseInt(request.getParameter("OrderId")));

	} else if (paymentProvider.equals("paypal")) {

		// Presume PayPal
		ArrayList<PaymentProvider> paymentProviders = userSession.getWebSite().getPaymentProviders();
        	for (PaymentProvider provider : paymentProviders) {
        		if (provider.getPaymentProviderKey() == PaymentProviderPayPal.PAYMENT_PROVIDER_KEY) {
        			userSession.setCurrentPaymentProvider(provider);
        		}
        	}
  	  	 
		String res = ProtxHelper.verifyPayPalPayment(userSession, request);
		
		website.writeToLog("post_pp postback res: "+res);

		String paymentCurrency = null;
		String receiverEmail = null;
  	  	if (request.getParameter("custom") != null) testMode = request.getParameter("custom");
  	  	if (request.getParameter("txn_id") != null) txnId = request.getParameter("txn_id");
    		if (request.getParameter("payment_status") != null) transStatus = request.getParameter("payment_status");
    		if (request.getParameter("mc_gross") != null) authAmount = new Float(Float.parseFloat(request.getParameter("mc_gross")));
		if (request.getParameter("mc_currency") != null) paymentCurrency = request.getParameter("mc_currency");
    		if (request.getParameter("item_number") != null) cartId = new Integer(Integer.parseInt(request.getParameter("item_number")));
    		if (request.getParameter("payer_email") != null) emailAddress = request.getParameter("payer_email");
    		if (request.getParameter("item_name") != null) desc = request.getParameter("item_name");
		if (request.getParameter("receiver_email") != null) receiverEmail = request.getParameter("receiver_email");

		//transId = cartId;
		
		//voucherBarcode = (Voucher.VOUCHER_BARCODE_PREFIX + "0000000000").substring(0, ModelConstants.LOCAL_BAR_CODE_LENGTH - voucherBarcode.length()) + voucherBarcode;
		

		if (authAmount < 0) { // refunds were cancelling the orginal order.
			website.writeToLog("post_pp refund detected exiting.   authAmount: "+authAmount+"   cartId: "+cartId+"    res: "+res+"   transStatus: "+transStatus);
			return;
		}


		if (!res.equals("VERIFIED")) {
			try {
				String textEmailBody = website.getWebsiteName()+"\nOrder of "+desc+"\n\nThis email is to notify you that the merchant website could not obtain verification of the completed payment from PayPal.\n\nThe merchant has also been notified who will now manually verify payment via PayPal and will contact you if there are any problems with your order.\n\n"+website.getWebSiteURL();
				String htmlEmailBody = "<br>Order of "+desc+"<BR><BR>This email is to notify you that the merchant website could not obtain verification of the completed payment from PayPal.<BR><BR>The merchant has also been notified who will now manually verify payment via PayPal and will contact you if there are any problems with your order.<BR><BR><a href='"+website.getWebSiteURL()+"'>"+website.getWebsiteName()+"</a>";
				if (emailAddress != null && !emailAddress.equals("")) website.sendEmail(emailAddress, "Pending Payment Warning", textEmailBody, htmlEmailBody);
				website.writeToLog(emailAddress+": "+textEmailBody);

				try {
					MailHelper.sendEmailFromWebsite("nmackley@intelligentretail.co.uk", "Pending Payment Warning: "+res, textEmailBody, htmlEmailBody,"support@intelligentretail.co.uk", "yzhou@intelligentretail.co.uk", website.getWebSitePath(), null);
				} catch (Exception sdsd8938949sf) { website.writeToLog(sdsd8938949sf); }

			} catch (Exception e3) {
				Logger ppLogger = new Logger(website.getWebSitePath(), "logPP_"+txnId);
				ppLogger.write(e3);
			}
		}

		authorised = res.equals("VERIFIED")||res.equals("INVALID");  // was true;
		accepted =  (transStatus.equalsIgnoreCase("completed") || transStatus.equalsIgnoreCase("pending")) && (receiverEmail != null && receiverEmail.equalsIgnoreCase(userSession.getCurrentPaymentProvider().getUserId()));    // && paymentCurrency.equals("GBP");

		website.writeToLog("post_pp postback res: "+res+"   transStatus: "+transStatus+"     accepted: "+accepted);

		if (!transStatus.equalsIgnoreCase("completed")) {
			if (!transStatus.equalsIgnoreCase("pending")) {			
				notAcceptedReason = "PayPal reported the payment status as incomplete";
			} else {
				// Pending
				try {
        	                	String textEmailBody = website.getWebsiteName()+"\nOrder "+txnId+" ("+cartId+") at &pound;"+authAmount+" of "+desc+"\n\nThis email is to notify you that PayPal reported your payment status as 'Pending'.\n\nThe merchant has also been notified and will contact you if there is a problem with your order.\n\n"+website.getWebSiteURL();
                	        	String htmlEmailBody = "<br>Order "+txnId+" ("+cartId+") at &pound;"+authAmount+" of "+desc+"<BR><BR>This email is to notify you that PayPal reported your payment status as 'Pending'.<BR><BR>The merchant has also been notified and will contact you if there is a problem with your order.<BR><BR><a href='"+website.getWebSiteURL()+"'>"+website.getWebsiteName()+"</a>";
                        		if (emailAddress != null && !emailAddress.equals("")) website.sendEmail(emailAddress, "Pending Payment Warning", textEmailBody, htmlEmailBody);
					website.writeToLog(emailAddress+": "+textEmailBody);

					try {
						MailHelper.sendEmailFromWebsite("nmackley@intelligentretail.co.uk", "Pending Payment Warning", textEmailBody, htmlEmailBody,"support@intelligentretail.co.uk", "yzhou@intelligentretail.co.uk", website.getWebSitePath(), null);
					} catch (Exception sdsd8938949sf) { website.writeToLog(sdsd8938949sf); }

	                    	} catch (Exception e3) {
        	            	    Logger ppLogger = new Logger(website.getWebSitePath(), "logPP_"+txnId);
                	    	    ppLogger.write(e3);
                  	 	}

			}	
		} else if (receiverEmail == null || !receiverEmail.equalsIgnoreCase(userSession.getCurrentPaymentProvider().getUserId())) {
			notAcceptedReason = "The merchant email address does not match the receiver email address within PayPal";
		} else if (!paymentCurrency.equals("GBP")) {
			notAcceptedReason = "Incorrect currency specified of "+paymentCurrency;
		}

		if (testMode == null) testMode = "100";
		inTestMode = testMode.equals("100");

		// check that paymentStatus=Completed - y
		// check that txnId has not been previously processed   - n
		// check that receiverEmail is your Primary PayPal email  - y
		// check that paymentAmount/paymentCurrency are correct   - y
		// process payment
		//if(res.equals("INVALID")) {
		// log for investigation

	} else { 
		float authAmount1 = (float)0; 

		Connection conn = website.getConnection();
        	PersistenceManager pm = website.getPersistenceManager();
        
		// did not detect payment provider
			if (userSession != null) userSession.clearSessionInfo(conn);
        	int ppTransId = userSession.getShoppingBasket().performPostPaymentProcessing(pm, conn, cartId.intValue(), authAmount1, "");
        	conn.commit();

        	if (ppTransId == 0 && website.getWebSiteURL().indexOf("localhost") == -1) {
           		try {
              		String textEmailBody = website.getWebsiteName()+"\nThis email is to inform you that your order of "+desc+" was cancelled for the following reason:\nCould not detect payment provider.\n\nThough we could not be of help to you on this occasion we sincerely hope that you will shop with us again.\nIf you experienced any problems or have any complaints about our service, please let us know using the 'Contact' link on our website.\n"+website.getWebSiteURL();
              		String htmlEmailBody = "<br>This email is to inform you that your order of "+desc+" was cancelled for the following reason:<BR>Could not detect payment provider.<BR><BR>Though we could not be of help to you on this occasion we sincerely hope that you will shop with us again.<BR><BR>If you experienced any problems or have any complaints about our service, please let us know using the <i>'Contact'</i> link on our website.<BR><BR><a href='"+website.getWebSiteURL()+"'>"+website.getWebsiteName()+"</a>";
				//website.sendEmail("neil.mackley@virgin.net", "Could not detect payment provider", textEmailBody, htmlEmailBody);
				website.writeToLog(emailAddress+": "+textEmailBody);

				try {
					MailHelper.sendEmailFromWebsite("nmackley@intelligentretail.co.uk", "Could not detect payment provider", textEmailBody, htmlEmailBody,"support@intelligentretail.co.uk", "yzhou@intelligentretail.co.uk", website.getWebSitePath(), null);
				} catch (Exception sdsd8938949sf) { website.writeToLog(sdsd8938949sf); }


           		} catch (Exception e3) {
           	    		Logger ppLogger = new Logger(website.getWebSitePath(), "logPP_"+txnId);
           	    		ppLogger.write(e3);
           		}
        	}
	}
    //if (transId == null) transId = new Integer(0);

	website.writeToLog("post_pp txnId: "+txnId+"  cartId: "+cartId+"  authAmount : "+authAmount+"  testMode: "+testMode+"  authorised: "+authorised+"  accepted: "+accepted);

    if (!inTestMode) {
        
	BigDecimal sbAuthAmount = userSession.getShoppingBasket().getAuthorisedAmount();
	int sbPPTransId = userSession.getShoppingBasket().getPpTransId();

	try {
		sbPPTransId = userSession.actionNotification(paymentProvider, new BigDecimal(authAmount.floatValue()), cartId, authorised, accepted, txnId, emailAddress, new PrintWriter(out), request, desc, notAcceptedReason);
	} catch (Exception ee1212ab) {
		website.writeToLog(ee1212ab);
	}	
       if (authorised) {
		try {
			userSession.clearShoppingBasket();
		} catch (Exception ee1212a) {
			website.writeToLog(ee1212a);
		}
		String forwardPageURI = "host.jsp?pg=thankyou.html&ot="+sbAuthAmount.setScale(2, BigDecimal.ROUND_HALF_EVEN)+"&ref=P"+sbPPTransId;
		try {
      			response.sendRedirect(forwardPageURI);
		} catch (Exception e102) {
			out.write("<script type='text/javascript'>document.location.href='"+forwardPageURI+"';</script>");
		}	
		
		//out.write(userSession.getTrackingController().getScript(request,true)); -- no need for this as it will be processed on the thankyou page
		website.writeToLog("post_pp end");
	
       	return;  // use thankyou.html page so google ppc scripts can be added for each website
       } else {
		
%>

<font face="sans-serif">
<table width=770 border=0 cellpadding=0 cellspacing=0 align=center valign=center>
    <tr>
        <td width=100% align=center>
            <br><br><font style="font.size:28px" color="#5164A6"><b>Order Cancelled</b></font><br><br>
            <br><br>
            <%if (paymentProvider.equals("worldpay")) { 
               		out.write("<WPDISPLAY ITEM=banner>");
               	  } else {
               		out.write("");
               	  }
        	  %>
            <br><br><a href="<%=website.getWebSiteURL()%>"><font color="#5164A6">Continue Shopping at <%=website.getWebsiteName()%></font></a>
            <br><br>
            <form>
                <input type=button value="Close Window" onClick="javascript:window.close();">
            </form>
        </td>
    </tr>
</table>
</font>
<%
        }
    } else {
		if (!accepted) {
			
                    	try {
                        	String textEmailBody = website.getWebsiteName()+"\nThis email is to inform you that your order of "+desc+" was cancelled for the following reason:\n"+notAcceptedReason+"\n\nThough we could not be of help to you on this occasion we sincerely hope that you will shop with us again.\nIf you experienced any problems or have any complaints about our service, please let us know using the 'Contact' link on our website.\n"+website.getWebSiteURL();
                        	String htmlEmailBody = "<br>This email is to inform you that your order of "+desc+" was cancelled for the following reason:<BR>"+notAcceptedReason+"<BR><BR>Though we could not be of help to you on this occasion we sincerely hope that you will shop with us again.<BR><BR>If you experienced any problems or have any complaints about our service, please let us know using the <i>'Contact'</i> link on our website.<BR><BR><a href='"+website.getWebSiteURL()+"'>"+website.getWebsiteName()+"</a>";
                        	if (emailAddress != null && !emailAddress.equals("")) website.sendEmail(emailAddress, "TEST MODE - Canceled Order Confirmation", textEmailBody, htmlEmailBody);
				website.writeToLog(emailAddress+": "+textEmailBody);

				try {
					MailHelper.sendEmailFromWebsite("nmackley@intelligentretail.co.uk", "TEST MODE - Canceled Order Confirmation", textEmailBody, htmlEmailBody,"support@intelligentretail.co.uk", "yzhou@intelligentretail.co.uk", website.getWebSitePath(), null);
				} catch (Exception sdsd8938949sf) { website.writeToLog(sdsd8938949sf); }

                    	} catch (Exception e3) {
                    	    Logger ppLogger = new Logger(website.getWebSitePath(), "logPP_"+txnId);
                    	    ppLogger.write(e3);
                   	}
                }

		if (userSession.getCurrentPaymentProvider().isDemo()) {
			authAmount = new Float(Float.parseFloat(transStatus));
			authorised = true ;
			accepted = true;
			userSession.actionNotification(paymentProvider, new BigDecimal(authAmount.floatValue()), cartId, authorised, accepted, txnId, emailAddress, new PrintWriter(out) , request, desc, notAcceptedReason);
		}

%>
    <font face="sans-serif">
    <table width=770 border=0 cellpadding=0 cellspacing=0 align=center valign=center>
        <tr>
            <td align=center width=100%>

                <br><br><font style="font.size:28px" color="#5164A6"><b>Thank you</b></font><br><br>

                <br><font style="font.size:18px">Thank you for your payment
                <%if (paymentProvider.equals("worldpay")) { 
               		out.write(" of <WPDISPLAY ITEM=amountString>");
               	  } else {
               		out.write("");
               	  }
               	  %>
                <br>Your order is now complete</font>

                <br>
                <br><br>
                <%
                if (paymentProvider.equals("worldpay")) { 
               		out.write("<WPDISPLAY ITEM=banner>");
               	} else {
               		out.write("");
               	}
               	%>
                <br><br><p align=center>
                <% if (userSession.getCurrentPaymentProvider().isDemo()) { %>
                		DEMO MODE --- DEMO MODE --- DEMO MODE --- DEMO MODE
			<% } else { %>
                		TEST MODE --- TEST MODE --- TEST MODE --- TEST MODE
			<% } %>

                <br><br>
                <form>
                    <input type=button value="Close Window" onClick="javascript:window.close();">
                </form>
            </td>
        </tr>
    </table>
    </font>

<%  } %>

<% response.setStatus(HttpServletResponse.SC_OK); %>

</td></tr><tr><td>

<% if (paymentProvider.equals("paypal")) { %>
	<script language="JavaScript">
	<!-- close the session
	  self.close();
	</script>
<% } 

 website.writeToLog("post_pp end");

 } catch (Exception eeeds23) { 

	website.writeToLog(eeeds23);
 } %>
</td></tr></table>

</body>
</html>
