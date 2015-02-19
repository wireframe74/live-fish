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
website.setUsingRefinementSearch(true);
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

	<div id="fb-root"></div>
<script>(function(d, s, id) {
  var js, fjs = d.getElementsByTagName(s)[0];
  if (d.getElementById(id)) return;
  js = d.createElement(s); js.id = id;
  js.src = "//connect.facebook.net/en_US/sdk.js#xfbml=1&appId=225449010959780&version=v2.0";
  fjs.parentNode.insertBefore(js, fjs);
}(document, 'script', 'facebook-jssdk'));</script>


<a id="skip-link" href="#nav">Skip to navigation</a>

	<div id="header">
		<%@include file="/header.html"%>
	</div>

	<div id="wrapper">



		<div class="hero-wrapper">
			<div class="text-valign">
			<h1>Running Shoes <br>
			Sold by Runners</h1>
			<button class="cta-home">View Products</button>
			</div>
		</div>



	<div class="container">
		

			<ul class="home-widgets">
				<li class="cta-1">Footwear</li>
				<li class="cta-2">Apparel</li>
				<li class="cta-3">Nutrition</li>
				<li class="cta-4">Hydration</li>
				<li class="cta-5">Accessories</li>
				<li class="cta-6">Watches</li>
			</ul>




			<div class="col-50 about-home">
				<h2>About</h2>
				<h3>We believe it's the little things THAT COUNT</h3>
				<p>At Northside Runners we provide quality product, expert knowledge and customer service to our running community. We are passionate about our running, and love to share that passion with you!</p>


			 <blockquote cite="http://knowyourmeme.com/memes/doge">

			        <p>&ldquo;Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut at maximus ipsum. &rdquo;</p>
			        <div class="arrow-down"></div>

				     <footer class="author">
				       &ndash; 
				       <strong>Doge</strong>, 
				       <a href="#">The Moon</a>
				     </footer>

			  </blockquote>


			</div><!-- col-50 -->





		<div class="col-50">
			<h2>Social</h2>

			<ul id="menu">
		    <li class="active"><a href="#twitter">Twitter</a></li>
		    <li><a href="#facebook">Facebook</a></li>
		  	</ul>
		 
			<div id="twitter" class="tab-content">
			jQuery is a cross-browser…
			</div>


			<div id="facebook" class="tab-content">
			<div class="fb-activity" data-app-id="127117850655750" data-site="http://www.northsiderunners.com.au/" data-action="likes, recommends" data-width="455px" 
			data-height="400px" data-colorscheme="light" data-header="true"></div>
			</div>
		</div><!-- col-50 -->



	</div><!-- .container -->




		<div class="container">

			<div class="article <% if (WebSite.isThisPageInList(request, "paysecure,detail,checkoutv2")){  %>full<% }%>">
				<%@include file="components/componentcontroller.jsp"%> 
			</div>

			<% if (!WebSite.isThisPageInList(request, "paysecure,detail,checkoutv2") && !userSession.isHomePage()) { %>
				<div class="aside">
					<jsp:include page="/template/components/leftmargin.jsp" />
				</div>
			<% }%>

		</div>
		
		<div class="cleardiv">&nbsp;</div>

	</div>

	<% if (!WebSite.isThisPageInList(request, "checkoutv2")) { %>
	
		<div id="footer">
			<div class="wrap960">
				<%@include file="/footer.html"%>
			
				<div class="copyright">

					<%@include file="components/footer.jsp"%>

					<div class="small">
						&copy; Intelligent Retail 2014 - <script type="text/javascript">document.write(new Date().getFullYear());</script> - All rights reserved. By <a href="http://www.intelligentretail.co.uk" target="_blank">Intelligent Retail ePos software &amp; eCommerce for retailers</a>
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