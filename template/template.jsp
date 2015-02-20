<!DOCTYPE html>
<html class="no-js">
<head>
	<%@include file="components/header.html"%>
	<% if (WebSite.isThisPageInList(request, "basket")) { %><script>function generateBasketProgressBar(per){$(document).ready(function(){basketBarCreate(per)})}</script><% }%>
</head>
<%
//Strings
String stockEnquiryString = "For all stock enquiries relating to this product please enter your email address below:";
String categoryTitleText = "";
website.setLinkedProductsText("Related products");
website.setZoomImageSettings("zoom-width:100%; zoom-height:420px; zoom-position:#magicZoomPos; opacity-reverse:true; hint-position:tr; show-title:false; buttons-position:top right; zoom-distance:0;");
website.setFeaturedItemsText("");
website.setInStockString("in stock");
website.setOutOfStockString("<span>Out of stock</span>");

//Images
website.setStockThumbSize(160);
website.setGroupThumbSize(160);
website.setProductPageImageSize(500);
website.setLinkedProductsStockThumbSize(140);
website.setAdditionalImageSize(75);
website.setAlsoBoughtStockThumbSize(128);
website.setRecentlyViewedStockThumbSize(128);
website.setTopSellingItemsImageSize(40);
website.setBasketThumbSize(40);

//Show Amounts
website.setNumRecentlyViewedItems(7);
website.setNumberOfLinkedProducts(6);
website.setTopSellingItemsNumToShow(6);
website.setNumGroupItemsAcross(4);
website.setNumStockItemsAcross(4);

//Booleans
website.setUseShortNamesOnProductTabs(true);
website.setAllowAddToBasketFromIndexPage(true);
website.setVersion2(true);
website.setUseQuickPayCheckout(false);
website.setUseSelectablePageNumbers(true);
website.setShowTellAFriend(false);
website.setAllowFullTextHTMLMarkup(true);
website.setUseMediaService(false);
website.setUseImageService(false);
website.setShowCategoriesOnHomepage(false);
website.setIncludeOneLevelOfSubCategoryOnly(true);
website.setUsePNGindicatorImages(true);
website.setIncludeBasketQtyWhenDisplayingOutOfStockMsg(false);
website.setShowQuantityAvailable(true);
website.setUseSecureRegistration(false);

//Refine By
website.setUsingRefinementSearch(false);
if(website.isUsingRefinementSearch()){
	website.setShowCategoriesInIndex(false);
	website.setShowRecursedArticlesInIndex(true);
	website.setNavigationRefinementAllowMultiChoicesWithinHeader(true);
}else{
	website.setShowCategoriesInIndex(true);
	website.setShowRecursedArticlesInIndex(false);
	website.setNavigationRefinementAllowMultiChoicesWithinHeader(false);
}

//Payment
//website.addPaymentProvider("PayPal","example@example.com",null,null);

String thisPgName = ""+request.getAttribute("origPageName");
if (thisPgName != null) {
	int idxpgnamedot = thisPgName.indexOf(".");
	if (idxpgnamedot > -1) thisPgName = thisPgName.substring(0,idxpgnamedot);
}
if (thisPgName == null || thisPgName.equals("null")) thisPgName = "unclassifiedpage";
%>

<body class="<% if (userSession.isHomePage()) { %>index<% }else{%>page-<%=thisPgName%> pageTemp-<%=userSession.getCurrentTemplatePage()%><%}%>">




<a id="skip-link" href="#nav">Skip to navigation</a>

	<div id="header">
		<%@include file="/header.html"%>
	</div>

	<div id="wrapper">

		<% if (userSession.isHomePage()) { %> 
	
	

	<section class="homepage-area">
		
			    <div class="slider">
				        <div class="flexslider">
							    <ul class="slides">


							            <li>

										<div class="text-wrap">
										  <h3 class="alt-font">It has Finally started...</h3>
									      <h1 class="h-large">WINTER SALE</h1>
									      <h1>UP TO 80% OFF</h1>
									      <a href="/shop/programmes/30-days-to-a-new-you/" class="button  alt-button white">View Product</a>
									     </div>

							            <img src="images/slider1.jpg" />

							  	    	</li>

							  	    	  <li>

							  	    	  <div class="text-wrap">
							  	    	  <h3 class="alt-font">It has Finally started...</h3>
									      <h1 class="h-large">WINTER SALE</h1>
									      <h1>UP TO 80% OFF</h1>
									      <a href="/shop/programmes/30-days-to-a-new-you/" class="button  alt-button white">View Product</a>
									      </div>

							  	    	  <img src="images/slider1.jpg" />
							  	    	  </li>
					
							  	    		
							   </ul>
				        </div><!-- flexslider -->
		      </div><!-- slider -->




<div class="container-fluid module-wrap white-module">
			<div class="container">
			
				<ul class="ctas row">
					<li class="col-xs-12 col-md-4 cta1"><a href="#">Freshwater</a></li>
					<li class="col-xs-12 col-md-4 cta2"><a href="#">Marine Fish</a></li>
					<li class="col-xs-12 col-md-4 cta3"><a href="#">Plants, Rocks, <br>Gravel, Driftwood</a></li>
				</ul>

		</div>


</div>


	



	<div class="container ">
		

	








	</div><!-- .container -->

		</section>


		<% }%> <!-- .END HOME PAGE CONDITIONAL -->



		<div class="container <% if (userSession.isHomePage()) { %> homepage-area  module-wrap <% }%> ">

				<% if (userSession.isHomePage()) { %>
 <h3 class="section-title clearfix title_center "><span>Featured Products</span>  </h3>

<!-- 					<ul class="sale">
					<li class="widget-1"><a href="/brands-cinnamon-placemats-coasters.irc">Placemats</a></li>
					<li class="widget-2"><a href="/brands-penny-scallan.irc">Penny Scallan </a></li>
					<li class="widget-3"><a href="/lamps-art-deco-cold-cast-bronze-lamps.irc">Art Deco Lamps</a></li>
					<li class="widget-4 last"><a href="/home-and-garden-for-the-garden-garden-wall-decor.irc">Garden Décor</a></li>	
					<li class="widget-5"><a href="/sale.irc">On Sale</a></li>
				</ul> -->

				<% }%> <!-- .END HOME PAGE CONDITIONAL -->


			


			<div class="article <% if (WebSite.isThisPageInList(request, "paysecure,detail,checkoutv2")){  %>full<% }%>">
				<%@include file="components/componentcontroller.jsp"%> 
			</div>

			<% if (!WebSite.isThisPageInList(request, "paysecure,detail,checkoutv2") && !userSession.isHomePage()) { %>
				<div class="aside">
					<jsp:include page="/template/components/leftmargin.jsp" />
				</div>
			<% }%>

		</div>


			<% if (userSession.isHomePage()) { %> 

			<div class="module-wrap white-module guarantees">

					 <h3 class="section-title clearfix title_center "><span>Our Guarantees</span>  </h3>

			<div class="container">
				
					<ul>

					<li class="icon1">
						<h3>FREE SHIPPING - ORDERS OVER $150</h3>
						<p>Aquarium fish professionally home delivered for only $18.50  -  or free for orders over $150!</p>
					</li>

					<li class="icon2">
						<h3>MONEY BACK GUARANTEE</h3>
						<p>We offer you a comprehensive Moneyback Guarantee on all fish and plants!</p>
					</li>

					<li class="icon3">
						<h3>COMPANY PROFILE</h3>
						<p>Find out how passionate we are about our business.</p>
					</li>
				</ul>



			</div>



		     </div>




		<% }%> <!-- .END HOME PAGE CONDITIONAL -->
		




	<div class="cleardiv">&nbsp;</div>

	</div>

	<% if (!WebSite.isThisPageInList(request, "checkoutv2")) { %>
	
				<div class="module-wrap white-module color-2">
					<h2>Join Mailing List</h2>
					<p>Join our Mailing List to receive exclusive offers & discounts.</p>
					<%@include file="/newsletter.html"%>
				</div>



		<div id="footer">
			<div class="wrap960 footer-top">
				<%@include file="/footer.html"%>

			</div>



				

				<div class="footer-secondary">

							<div class="wrap960">

												<div class="copyright">

														<%@include file="components/footer.jsp"%>

														<div class="small">

										
	
	
	



															&copy; Intelligent Retail 2014 - <script type="text/javascript">document.write(new Date().getFullYear());</script> - All rights reserved. By <a href="http://www.intelligentretail.com.au" target="_blank">Intelligent Retail ePos software &amp; eCommerce for retailers</a>
														</div>
												</div>

							</div>


					
				</div>







		</div>

		<div class="wrap960">
			<div id="nav">
				<%@include file="/topnav.html"%>
				<%@include file="/salesmessages.html"%>
			</div>
		</div>
		
	<% } %>

	<%out.write(userSession.getTrackingController().getScript(request, userSession.getWebController().isThankYouPage()));%>

	<%@include file="/analytics.html"%>

	<%@include file="/javascript.html"%>

</body>
</html>
