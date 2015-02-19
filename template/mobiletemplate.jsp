<%
String stockEnquiryString = "For all stock enquiries relating to this product please enter your email address below:";
String categoryTitleText = "Product Categories";
website.setProductPageImageSize(400);
website.setAdditionalImageSize(90);
website.setUseShortNamesOnProductTabs(true); 
website.setAllowAddToBasketFromIndexPage(true);
website.setVersion2(true);
website.setLookForTabDefinitionsInFullText(true);
website.setChargeDeliveryOnZeroValueTransactions(true);
website.setBasketThumbSize(100);
%> 
<link rel="stylesheet" href="template/style_mobile.css" type="text/css"/>
<meta name = "viewport" content = "width = device-width, user-scalable=no" >
<body>  
<div id="mob_wrapper">
	<div id="mob_header">
		<%@include file="/mobile_header.html"%>
	</div>
	<div id="mob_nav">
		<%@include file="/topnav_mobile.html"%>
	</div>
	<div class="mob_article">
           <%@include file="components/componentcontroller_mobile.jsp"%> 
	</div>

</div>
	<div id="mob_footer">
		<%@include file="/footer_mobile.html"%>
		<%@include file="components/footer.jsp"%> 
	</div>

</body>



