<!-- start of flightdeck.jsp -->
<%@ page import="com.infosoftglobal.fusioncharts.FusionChartsCreator"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="co.simplypos.model.website.flightdeck.*"%>
<%@ taglib uri="http://ajaxtags.org/tags/ajax" prefix="ajax" %>
<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" />
<jsp:useBean id="flightDeckController" scope="application" class="co.simplypos.model.website.flightdeck.FlightDeckController"><%flightDeckController.initialise(website, "reportgateway/charts", "reportgateway/charts/DateSelector");%></jsp:useBean>
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession" />
<jsp:useBean id="flightDeckSession" scope="session" class="co.simplypos.model.website.flightdeck.FlightDeckSession"><%flightDeckSession.initialise(userSession);%></jsp:useBean>
<script LANGUAGE="Javascript" src="<%=flightDeckController.getChartLocation()%>/FusionCharts/FusionCharts.js"></script>
<script language="JavaScript" src="<%=flightDeckController.getDateSelectorLocation()%>/scripts/FSdateSelect.js"></script>
<link rel="stylesheet" HREF="<%=flightDeckController.getDateSelectorLocation()%>/styles/FSdateSelect.css" type="text/css">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr><td><img src="<%=website.getImagePath("spacer.gif")%>" width="900" height="4"></td></tr>
<tr><td>
<% 	// example: https://www.intelligentretail.co.uk/flightdeck.jsp?IR_FD-API-COMPANYNAME=INTELLIGENT&IR_AUTHCHECK=a2kklaW2;os*6
if (/*!request.getRequestURL().toString().startsWith("https") || */ !userSession.isLoggedIn()) { %>
	<center>
	<table border="0" width="98%">
		<tr>
			<td>	
				<br /><strong>Welcome to the Intelligent Retail Flight Deck.</strong>
		  		<br /><br />You need to be logged in and running over a secure channel to view the flight deck.
				<br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br />	
			</td>
		</tr>
	</table>
	</center>
	</td></tr></table>
<%
	return;	
} 
if (request.getParameter("IR_AUTHCHECK") == null || !request.getParameter("IR_AUTHCHECK").equals("a2kklaW2;os*6")) { 
%>
		<center>	
		<p>Not authorised!</p>
		</center>
		</td></tr></table>
<%		return;
}

String fromDateStr = request.getParameter("FromDate");
String toDateStr = request.getParameter("ToDate");

if (fromDateStr == null) fromDateStr = "None";
if (toDateStr == null) toDateStr = "None";

java.sql.Date fromDate = null;
java.sql.Date toDate = null;
      try {
	fromDate = new java.sql.Date(new SimpleDateFormat("dd/MM/yyyy").parse(fromDateStr).getTime());
	toDate = new java.sql.Date(new SimpleDateFormat("dd/MM/yyyy").parse(toDateStr).getTime());
} catch (ParseException e) {
	fromDate = null;
	toDate = null;
}

flightDeckSession.setFromDate(fromDate);
flightDeckSession.setToDate(toDate);
String salesOverlay = "avecustspend";
if (request.getParameter("IR_SALES_OVERLAY") != null) salesOverlay = request.getParameter("IR_SALES_OVERLAY");
flightDeckSession.setSalesOverlay(salesOverlay);

%>

	

	<center>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr valign="top">
			<td width="180">
				<form action="#" method="POST" name="DateForm">
					<table border="0" cellspacing="0" cellpadding="0" >
						<tr> 
							<td><div id="flightdecktitle1">Connect Head Office</div><div id="flightdecktitle2">Flight Deck</div><div id="flightdecktitlelogo"><img src="../images/beta3.jpg"></div></td>
						</tr>
						<tr> 
    							<td height="" align="" valign="" class="boxspacing"></td>
						</tr>
						<tr> 
						   	<td width="100%" height="22" align="left" valign="middle" class="boxtop">Date Range</td>
						</tr>
						<tr>
							<td>
							   <table>
								<tr>
									<td><img src="<%=website.getImagePath("spacer.gif")%>" width="1" height="8"></td>
								</tr>

								<tr>
									<td width="20" nowrap>From:</td>
									<td><script languauge="JavaScript">FSfncWriteFieldHTML("DateForm","FromDate","<%=fromDateStr%>",100,"<%=flightDeckController.getDateSelectorLocation()%>/images/FSdateSelector/")</script></td>													
								</tr>
								<tr>
									<td><img src="<%=website.getImagePath("spacer.gif")%>" width="1" height="8"></td>
								</tr>
								<tr>
									<td width="20" nowrap>To:</td>
									<td><script languauge="JavaScript">FSfncWriteFieldHTML("DateForm","ToDate","<%=toDateStr%>",100,"<%=flightDeckController.getDateSelectorLocation()%>/images/FSdateSelector/")</script></td>
								</tr>
							   </table>
							</td>
						</tr>
						<tr>
							<td align="right">(both dates inclusive)</td>
						</tr>
						<tr> 
							<td height="5" align="left" valign="top" class="boxbot" width="180"></td>
						</tr>
						<tr> 
    							<td height="" align="" valign="" class="boxspacing"></td>
						</tr>
						<tr>
							<td>
							<table><tr><td>

								Sales Overlay Indicator:<br>
								<input type="radio" name="IR_SALES_OVERLAY" value="avecustspend" <%=(flightDeckSession.getSalesOverlay().equals("avecustspend")?"checked":"")%> >Ave Customer Spend<br />
								<input type="radio" name="IR_SALES_OVERLAY" value="margin" <%=(flightDeckSession.getSalesOverlay().equals("margin")?"checked":"")%> >Margin Percentage<br />
								<input type="radio" name="IR_SALES_OVERLAY" value="footfall" <%=(flightDeckSession.getSalesOverlay().equals("footfall")?"checked":"")%> >Footfall<br />								

							</td></tr></table>

							</td>
						</tr>
						<tr>
							<td><img src="<%=website.getImagePath("spacer.gif")%>" width="1" height="8"></td>
						</tr>
						<tr>
							<td>
							<table><tr><td>

								Inventory Overlay Indicator:<br>
								<input type="radio" name="IR_STOCK_OVERLAY" value="stockturn" checked >Stock Turn Rate<br />
							</td></tr></table>

							</td>
						</tr>
						<tr> 
    							<td height="" align="" valign="" class="boxspacing"></td>
						</tr>						
						<tr>
							<td align="CENTER"><input type="submit" value="Generate Graph"></td>
						</tr>	
						<tr>
							<td><img src="<%=website.getImagePath("spacer.gif")%>" width="1" height="170"></td>
						</tr>				
					</table>
					<input type="hidden" name="IR_FD-API-COMPANYNAME" value="<%=request.getParameter("IR_FD-API-COMPANYNAME")%>">
					<input type="hidden" name="IR_AUTHCHECK" value="<%=request.getParameter("IR_AUTHCHECK")%>">
					<input type="hidden" name="IR_SUBMENU1_SEL" value="<%=request.getParameter("IR_SUBMENU1_SEL")%>">
					<input type="hidden" name="IR_SUBMENU2_SEL" value="<%=request.getParameter("IR_SUBMENU2_SEL")%>">

				</form>
			</td>
			<td>
				<center><img src="<%=website.getImagePath("v_br.gif")%>" ></center>
	
			</td>
			<td width="100%">	
				
				
				<img src="<%=website.getImagePath("spacer.gif")%>" width="720" height="1">
				
				<table border="0" width="100%" cellpadding="0" cellspacing="0" style="border-width:0 0 0 1px;border-color:gray;border-style:solid solid dotted dotted;"><tr><td>
				   <table border="0" width="100%" cellpadding="0" cellspacing="0" style="border-width:0 0 1 0px;border-color:gray;border-style:solid solid dotted solid;"><tr><td>

				   <div id="header1" style="margin-top:0px;margin-left:0px;padding:0 0 0 0px;margin: 0 0 0 0px;">
					<ul style="margin-top:0px;margin-left:0px;padding:0 0 0 0px;margin: 0 0 0 0px;">
						<li style="margin-right:0px;margin-left:0px;padding:0 0 0 0px;"><a href="#" onClick="javascript:document.DateForm.IR_SUBMENU1_SEL.value=1; document.DateForm.submit(); return false;" style="<%=request.getParameter("IR_SUBMENU1_SEL")!=null && request.getParameter("IR_SUBMENU1_SEL").equals("1")?"color:white;text-decoration:bold;padding:5 15 3 9px;":"color:darkgray;padding:4 15 2 9px;margin-top:2px;"%>" >&nbsp;Inventory&nbsp;</a></li>
						<li style="margin-right:0px;margin-left:0px;padding:0 0 0 0px;"><a href="#" onClick="javascript:document.DateForm.IR_SUBMENU1_SEL.value=2; document.DateForm.submit(); return false;" style="<%=request.getParameter("IR_SUBMENU1_SEL")!=null && request.getParameter("IR_SUBMENU1_SEL").equals("2")?"color:white;text-decoration:bold;padding:5 15 3 9px;":"color:darkgray;padding:4 15 2 9px;margin-top:2px;"%>" >&nbsp;Sales&nbsp;</a></li>
					</ul>
				   </div> 
				   </td></tr></table>

<%				   if (request.getParameter("IR_SUBMENU1_SEL") != null && request.getParameter("IR_SUBMENU1_SEL").equals("2")) { %>
					<br/>
					<table border="0" width="100%" cellpadding="0" cellspacing="0" style="border-width:0 0 1 0px;border-color:gray;border-style:solid solid dotted solid;"><tr><td>
					<div id="header1" style="margin-top:25px;margin-left:0px;padding:0 0 0 0px;margin: 0 0 0 0px;">
					<ul style="margin-top:0px;margin-left:0px;padding:0 0 0 0px;margin: 0 0 0 0px;">
						<li style="margin-right:0px;padding:0 0 0 0px;"><a href="#" onClick="javascript:document.DateForm.IR_SUBMENU2_SEL.value=1; document.DateForm.submit(); return false;" style="<%=request.getParameter("IR_SUBMENU2_SEL")!=null && request.getParameter("IR_SUBMENU2_SEL").equals("1")?"color:white;text-decoration:bold;padding:5 15 3 9px;":"color:darkgray;padding:4 15 2 9px;margin-top:2px;"%>" >&nbsp;Today&nbsp;</a></li>
						<li style="margin-right:0px;padding:0 0 0 0px;"><a href="#" onClick="javascript:document.DateForm.IR_SUBMENU2_SEL.value=2; document.DateForm.submit(); return false;" style="<%=request.getParameter("IR_SUBMENU2_SEL")!=null && request.getParameter("IR_SUBMENU2_SEL").equals("2")?"color:white;text-decoration:bold;padding:5 15 3 9px;":"color:darkgray;padding:4 15 2 9px;margin-top:2px;"%>">&nbsp;This Week&nbsp;</a></li>
						<li style="margin-right:0px;padding:0 0 0 0px;"><a href="#" onClick="javascript:document.DateForm.IR_SUBMENU2_SEL.value=3; document.DateForm.submit(); return false;" style="<%=request.getParameter("IR_SUBMENU2_SEL")!=null && request.getParameter("IR_SUBMENU2_SEL").equals("3")?"color:white;text-decoration:bold;padding:5 15 3 9px;":"color:darkgray;padding:4 15 2 9px;margin-top:2px;"%>">&nbsp;Given Period&nbsp;</a></li>
						<li style="margin-right:0px;padding:0 0 0 0px;"><a href="#" onClick="javascript:document.DateForm.IR_SUBMENU2_SEL.value=4; document.DateForm.submit(); return false;" style="<%=request.getParameter("IR_SUBMENU2_SEL")!=null && request.getParameter("IR_SUBMENU2_SEL").equals("4")?"color:white;text-decoration:bold;padding:5 15 3 9px;":"color:darkgray;padding:4 15 2 9px;margin-top:2px;"%>" >&nbsp;This Year&nbsp;</a></li>


					</ul>
					</div> 
					</td></tr></table>

				   <% } %>
				</td></tr></table>
				<center>
				<br/><br/>
<%
if (flightDeckSession.getFromDate() == null) {
	// no date selected yet
	out.write("<p>Select a date range from the left hand menu then press Generate Graph</p>");
	return;
}

Connection conn = null;
FileOutputStream fos = null;
try {
	//fos = new FileOutputStream("fd.log");
	//if (flightDeckSession.getCompanyName == null) {
		flightDeckSession.setCompanyName(request.getParameter("IR_FD-API-COMPANYNAME"));
		try {
			conn = flightDeckSession.getConnection();
		} catch (Exception ee2) {
			out.write(ee2.getMessage());
			return;
		}		
	//}
%>


<% if (request.getParameter("IR_SUBMENU1_SEL") != null && request.getParameter("IR_SUBMENU1_SEL").equals("2")) {
	if (request.getParameter("IR_SUBMENU2_SEL") != null && request.getParameter("IR_SUBMENU2_SEL").equals("1")) { 
		%>
		<jsp:include page="/template/components/fd_charts/sales_today_by_site.jsp" flush="true" />
		<%
	} else if (request.getParameter("IR_SUBMENU2_SEL") != null && request.getParameter("IR_SUBMENU2_SEL").equals("2")) { 
		%>
		<table>
			<tr>
				<td>
					<jsp:include page="/template/components/fd_charts/sales_last_7_days_by_site_pie.jsp" flush="true" />
					<jsp:include page="/template/components/fd_charts/sales_last_7_days_by_cat_pie.jsp" flush="true" />
				</td>
				<td>
					<jsp:include page="/template/components/fd_charts/sales_last_7_days_summary.jsp" flush="true" />
				</td>
			</tr>
		</table>

		<jsp:include page="/template/components/fd_charts/sales_last_7_days_by_site.jsp" flush="true" />

		<br /><br /><br />
		<%
	} else if (request.getParameter("IR_SUBMENU2_SEL") != null && request.getParameter("IR_SUBMENU2_SEL").equals("3")) { 
		%>		
		<table>
			<tr>
				<td>
					<jsp:include page="/template/components/fd_charts/sales_period_by_site_pie.jsp" flush="true" />
					<jsp:include page="/template/components/fd_charts/sales_period_by_cat_pie.jsp" flush="true" />
				</td>
				<td>
					<jsp:include page="/template/components/fd_charts/sales_period_summary.jsp" flush="true" />
				</td>
			</tr>
		</table>

		<jsp:include page="/template/components/fd_charts/sales_period_by_site.jsp" flush="true" />

		<br /><br /><br />
		<%
	} else if (request.getParameter("IR_SUBMENU2_SEL") != null && request.getParameter("IR_SUBMENU2_SEL").equals("4")) { 
		%>
		<jsp:include page="/template/components/fd_charts/sales_last_12_months_summary.jsp" flush="true" />
		<jsp:include page="/template/components/fd_charts/sales_last_12_months_by_site.jsp" flush="true" />
		<%
	}
   } else if (request.getParameter("IR_SUBMENU1_SEL") != null && request.getParameter("IR_SUBMENU1_SEL").equals("1")) { %>

		<table>
			<tr>
				<td>
					<jsp:include page="/template/components/fd_charts/stock_current_by_site_pie.jsp" flush="true" />
					<jsp:include page="/template/components/fd_charts/stock_current_by_cat_pie.jsp" flush="true" />
				</td>
				<td>
					<jsp:include page="/template/components/fd_charts/stock_last_12_months_summary.jsp" flush="true" />
				</td>
			</tr>
		</table>

		<jsp:include page="/template/components/fd_charts/stock_last_12_months_by_site.jsp" flush="true" />

		<jsp:include page="/template/components/fd_charts/stock_last_12_months_by_site_cat.jsp" flush="true" />

		<jsp:include page="/template/components/fd_charts/stock_last_12_months_by_site_month.jsp" flush="true" />

		<br /><br /><br />


<%

if (1==0) {
//------------------------------------- STOCK ANALYSIS ------------------------------------------------------


	ArrayList<FlightDeckSeries> seriesList = new ArrayList<FlightDeckSeries>();
	String subSql = "";
	String sql = "select va.short_description, 'sum(case when fdsa.category_va_id = '||va.vendor_article_id||' then case when (fdsa.quantity_in_stock * fdsa.purchase_price) is null then 0 else (fdsa.quantity_in_stock * fdsa.purchase_price) end else 0 end)' from vendor_article va, article a, vendor_article_clsfn vac "+
			" where va.vendor_article_id = vac.vendor_article_id2 and vac.vendor_article_id1 = 1 and a.article_id = va.article_id and a.article_type_domain_id = 1013 ";
	Statement stmt = null;
	try {
		stmt = conn.createStatement();
		ResultSet rs = stmt.executeQuery(sql);	
		while (rs.next()) {
			seriesList.add(new FlightDeckSeries(rs.getString(1), true));

			subSql += rs.getString(2)+",";
		}

	} catch (Exception e) {
		out.write(e.getMessage());
		return;
	} finally {
		if (stmt != null) {
			try {
				stmt.close();
			} catch (Exception eesd) {}
		}
	}

	seriesList.add(new FlightDeckSeries("Stock Turn Rate", false));

	sql = " select fdsa.site_name, "+subSql+" case when avg(fdsa.stock_turn_rate) is null then 0 else avg(fdsa.stock_turn_rate) end "+
		" from sp_fd_stock_analysis('"+flightDeckSession.getFromDate().toString()+"', '"+flightDeckSession.getToDate().toString()+"') fdsa "+
		" group by 1 ";

	FlightDeckModel flightDeckModel = new FlightDeckModel("STOCK ANALYSIS", "Current Stock Value", "Stock Turn Rate", seriesList);
	flightDeckModel.populate(flightDeckController,conn,sql); 
	String strXML = null;
	String chartCode = null;

	out.write("<table cellpadding='5'><tr><td>");

	int palette = 4;
	strXML = flightDeckModel.toSeriesSummaryXMLString(true,FlightDeckModel.MATH_TYPE_ADD, "Current Company Stock Value: &pound;", palette, "&pound;", "0", "0", "0", FlightDeckModel.X_AXIS_LABEL_DISPLAY_NONE, 0, 0, 1, " showBorder='0' bgColor='FFFFFF' showPercentValues='0' showPercentInToolTip='1' showLabels='1' showValues='1' ");
	chartCode= FusionChartsCreator.createChartHTML(flightDeckController.getChartLocation()+"/FusionCharts/Doughnut2D.swf", "", strXML, "stockAnalysis1", 600, 400, false);
	out.write("<center>"+chartCode+"</center>");

	out.write("</td><td>");
	
	strXML = flightDeckModel.getStockTurnWidgetXML("",palette, false, FlightDeckModel.MATH_TYPE_AVERAGE, " showBorder='0' bgColor='FFFFFF' lowerLimit='0' upperLimit='12' gaugeStartAngle='240' gaugeEndAngle='-60' gaugeInnerRadius='60' gaugeFillMix='{light-10},{light-30},{light-20},{dark-5},{color},{light-30},{light-20},{dark-10}' gaugeFillRatio='' ");

	chartCode= FusionChartsCreator.createChartHTML(flightDeckController.getChartLocation()+"/FusionWidgets/AngularGauge.swf", "", strXML, "stockAnalysis2", 300, 250, false);
	out.write("<center>"+chartCode+"</center>");
	out.write("<br /><center><b>Stock Turn Rate</b></center>");
	
	out.write("</td></tr><tr><td colspan='2'>");

	strXML = flightDeckModel.toXMLString(palette, "&pound;", "0", "0", "0", FlightDeckModel.X_AXIS_LABEL_DISPLAY_ROTATE, 1, 0, 1, " use3DLighting='1' showSum='1' ");
	chartCode= FusionChartsCreator.createChartHTML(flightDeckController.getChartLocation()+"/FusionCharts/StackedColumn3DLineDY.swf", "", strXML, "stockAnalysis3", 1000, 500, false);
	out.write("<center>"+chartCode+"</center>");

	

	out.write("</td></tr><tr><td colspan='2'>");
%>
Choose colour:&nbsp;
  <br/>
<ajax:anchors target="ajaxFrame3" ajaxFlag="ajaxFrame3">
  <a href="flightdeck.jsp?pic=ajaxpic1.jpeg"> Beige1 </a>&nbsp;&nbsp;&nbsp;&nbsp;
  <a href="flightdeck.jsp?pic=ajaxpic2.jpeg"> Black1 </a>
<%
out.write("<a href='/template/components/fd_charts/stock_12m_by_site.jsp?"+request.getQueryString()+"&ajaxStockYearChoice=1'>Company View NEW</a>&nbsp;&nbsp;&nbsp;&nbsp;");

%>  	
  <br/>
</ajax:anchors> 
  
<br /><br />

<ajax:area id="ajaxFrame3" style="background:#eee; width:300px; min-height:100px; height:100px;" styleClass="textArea" ajaxAnchors="true" ajaxFlag="ajaxFrame3">
	<img src='images/<%=request.getParameter("pic")%>'>
</ajax:area>

<%

	out.write("<h1>Last 12 Months</h1>");
	out.write("<ajax:anchors target='ajaxFrame2' ajaxFlag='ajaxFrame2'>");
  	out.write("<br />");
  	out.write("<a href='flightdeck.jsp?"+request.getQueryString()+"&ajaxStockYearChoice=1'>Company View</a>&nbsp;&nbsp;&nbsp;&nbsp;");
  	out.write("<a href='flightdeck.jsp?"+request.getQueryString()+"&ajaxStockYearChoice=2'>Site View</a>");
 	out.write("<br />");
	out.write("</ajax:anchors>"); 

	//out.write("<ajax:area id='ajaxStockYear' styleClass='textArea' style='min-height:150px;'>");
	out.write("<ajax:area id='ajaxFrame2' style='background:#eee; width:1000px; min-height:500px; height:500px;' styleClass='textArea' ajaxAnchors='true' ajaxFlag='ajaxFrame2'>");

	if (request.getParameter("ajaxStockYearChoice") != null && request.getParameter("ajaxStockYearChoice").equals("1")) {

		sql = "  select fdsa.site_name, case when sum(fdsa.month1_ave_stock_value) is null then 0 else sum(fdsa.month1_ave_stock_value) end, case when sum(fdsa.month2_ave_stock_value) is null then 0 else sum(fdsa.month2_ave_stock_value) end, case when sum(fdsa.month3_ave_stock_value) is null then 0 else sum(fdsa.month3_ave_stock_value) end, case when sum(fdsa.month4_ave_stock_value) is null then 0 else sum(fdsa.month4_ave_stock_value) end, case when sum(fdsa.month5_ave_stock_value) is null then 0 else sum(fdsa.month5_ave_stock_value) end, case when sum(fdsa.month6_ave_stock_value) is null then 0 else sum(fdsa.month6_ave_stock_value) end, case when sum(fdsa.month7_ave_stock_value) is null then 0 else sum(fdsa.month7_ave_stock_value) end, case when sum(fdsa.month8_ave_stock_value) is null then 0 else sum(fdsa.month8_ave_stock_value) end, case when sum(fdsa.month9_ave_stock_value) is null then 0 else sum(fdsa.month9_ave_stock_value) end, case when sum(fdsa.month10_ave_stock_value) is null then 0 else sum(fdsa.month10_ave_stock_value) end, case when sum(fdsa.month11_ave_stock_value) is null then 0 else sum(fdsa.month11_ave_stock_value) end, case when sum(fdsa.month12_ave_stock_value) is null then 0 else sum(fdsa.month12_ave_stock_value) end,  case when avg(fdsa.stock_turn_rate) is null then 0 else avg(fdsa.stock_turn_rate) end "+
 			" from sp_fd_stock_analysis('"+flightDeckSession.getFromDate().toString()+"', '"+flightDeckSession.getToDate().toString()+"') fdsa "+
			" group by 1 ";

		seriesList = new ArrayList<FlightDeckSeries>();
		seriesList.add(new FlightDeckSeries("Jan", true));
		seriesList.add(new FlightDeckSeries("Feb", true));
		seriesList.add(new FlightDeckSeries("Mar", true));
		seriesList.add(new FlightDeckSeries("Apr", true));
		seriesList.add(new FlightDeckSeries("May", true));
		seriesList.add(new FlightDeckSeries("Jun", true));
		seriesList.add(new FlightDeckSeries("Jul", true));
		seriesList.add(new FlightDeckSeries("Aug", true));
		seriesList.add(new FlightDeckSeries("Sep", true));
		seriesList.add(new FlightDeckSeries("Oct", true));
		seriesList.add(new FlightDeckSeries("Nov", true));
		seriesList.add(new FlightDeckSeries("Dec", true));

		seriesList.add(new FlightDeckSeries("Stock Turn Rate", false));

		FlightDeckModel flightDeckModelStock2 = new FlightDeckModel("SALES ANALYSIS", "Sales (excl. VAT)", "Average Customer Spend (inc. VAT)", seriesList);
		flightDeckModelStock2.populate(flightDeckController,conn,sql); 

		strXML = flightDeckModelStock2.toXMLString(palette, "&pound;", "0", "0", "0", FlightDeckModel.X_AXIS_LABEL_DISPLAY_ROTATE, 1, 0, 1, " use3DLighting='1' showSum='1' ");
		chartCode= FusionChartsCreator.createChartHTML(flightDeckController.getChartLocation()+"/FusionCharts/MSColumn3DLineDY.swf", "", strXML, "stockAnalysis4", 1000, 500, false);
		out.write("<center>"+chartCode+"</center>");

	} else if (request.getParameter("ajaxStockYearChoice") == null || request.getParameter("ajaxStockYearChoice").equals("2")) {

		out.write("</td></tr><tr><td colspan='2'>");
		String categoriesXML = "";
		String categoriesSQL = "";
		int monthNow = new GregorianCalendar().get(Calendar.MONTH);
		int monthNum = monthNow+2;
		for (int monthCount=0;monthCount<12;monthCount++) {
			if (monthNum > 12) monthNum = 1;
			categoriesXML += "\n   <category name='"+new java.text.DateFormatSymbols().getShortMonths()[monthNum-1]+"' />";  
			if (monthNum != monthNow+1) categoriesSQL += "cast(case when sum(fdsa.month"+monthNum+"_ave_stock_value) is null then 0 else sum(fdsa.month"+monthNum+"_ave_stock_value) end as integer),";
			monthNum++;		
		}
		categoriesSQL += "cast(case when sum(fdsa.current_stock_value) is null then 0 else sum(fdsa.current_stock_value) end as integer),";
		sql = "  select "+categoriesSQL + " cast(case when sum(fdsa.annual_ave_stock_value) is null then 0 else sum(fdsa.annual_ave_stock_value) end as integer), case when avg(fdsa.stock_turn_rate) is null then 0 else avg(fdsa.stock_turn_rate) end "+
 			" from sp_fd_stock_analysis('"+flightDeckSession.getFromDate().toString()+"', '"+flightDeckSession.getToDate().toString()+"') fdsa ";
			//" group by 1 ";

		//out.write("<p>"+sql );
		//out.write("<p>"+categoriesXML );

		seriesList = new ArrayList<FlightDeckSeries>();
		FlightDeckModel flightDeckModelStock3 = new FlightDeckModel("SALES ANALYSIS", "Sales (excl. VAT)", "Average Customer Spend (inc. VAT)", seriesList);
		flightDeckModelStock3.populate(flightDeckController,conn,sql); 

		//out.write("<p>"+flightDeckModelStock3.getDataSet());
		//strXML = flightDeckModelStock3.toSingleRowXMLString("Month", palette, "&pound;", "0", "0", "0", FlightDeckModel.X_AXIS_LABEL_DISPLAY_ROTATE, 1, 0, 1, " use3DLighting='1' showSum='1' ");
 		//strXML  = "<chart caption='Stock Holding' subcaption='Last 12 Months' xAxisName='Month' yAxisName='Stock Value' numberPrefix='£' showNames='1' showValues='1' rotateNames='0' showColumnShadow='1' animation='1' showAlternateHGridColor='1' AlternateHGridColor='ff5904' divLineColor='ff5904' divLineAlpha='20' alternateHGridAlpha='5' canvasBorderColor='666666' baseFontColor='666666' lineColor='FF5904' lineAlpha='85'>";

		strXML  = "<chart caption='Stock Holding' subcaption='Last 12 Months' yAxisName='Stock Value' numberPrefix='£'>";
    		strXML += "\n <categories>";
    		strXML += categoriesXML;   		
    		strXML += "\n </categories>";    		
		strXML += "\n <dataset seriesName='Stock Value'>";
    		ArrayList dataRow = (ArrayList)flightDeckModelStock3.getDataSet().get(0);
		for (int rows=0;rows<dataRow.size()-2;rows++) {
			//strXML += "\n   <set label='"+labels[rows]+"' value='"+dataRow.get(rows)+"' />";
			strXML += "\n   <set value='"+dataRow.get(rows)+"' />";
		}
		strXML += "\n </dataset>";
		//strXML += "\n <dataset seriesName='Average Stock Value' showValues='0'>";
 		//for (int rows=0;rows<dataRow.size();rows++) {
		//	strXML += "\n   <set value='"+dataRow.get(12)+"' />";	
		//}
		//strXML += "\n </dataset>";
		strXML += "\n <trendLines><line startValue='"+dataRow.get(12)+"' color='359A35' displayvalue='Annual Average' valueOnRight='1' /></trendLines>";
    		strXML += "\n</chart>";

		//out.write("<p>"+strXML.replace('<', '[').replaceAll(">", "]<br />")+"<br /><br />"); 

		chartCode= FusionChartsCreator.createChartHTML(flightDeckController.getChartLocation()+"/FusionCharts/MSLine.swf", "", strXML, "stockAnalysis5", 500, 300, false);
		out.write("<center>"+chartCode+"</center>");

	}
	out.write("</ajax:area>");

//------------------------------------- REVENUE/MARGIN ANALYSIS ------------------------------------------------------//


	seriesList = new ArrayList<FlightDeckSeries>();
	seriesList.add(new FlightDeckSeries("Purchase Cost",true));
	seriesList.add(new FlightDeckSeries("Gross Profit",true));
	seriesList.add(new FlightDeckSeries("Average Customer Spend",false));

/*	sql = "select  s.site_name,  "+
		"        sum(sp.purchase_price) cost,  "+
		"       sum(case when sp.transaction_type_domain_id <> 1031 and sp.transaction_type_domain_id < 1035 then sp.sales_allocation_gross - sp.sales_allocation_vat - sp.purchase_price else 0 end) gross_profit_net,  "+
		"        case when count(distinct case when sp.transaction_type_domain_id <> 1031 and sp.transaction_type_domain_id < 1035 and sp.sales_allocation_gross <> 0 then sp.trans_id else null end) > 0 then  "+
		"            sum(case when sp.transaction_type_domain_id <> 1031 and sp.transaction_type_domain_id < 1035 then sp.sales_allocation_gross else 0 end)  "+
		"            / count(distinct case when sp.transaction_type_domain_id <> 1031 and sp.transaction_type_domain_id < 1035 and sp.sales_allocation_gross <> 0 then sp.trans_id else null end)  "+
		"        else 0 end ave_cust_spend  "+
		" from SP_TILL_TRANS_READINGS('"+flightDeckSession.getFromDate().toString()+" 00:00', '"+flightDeckSession.getToDate().toString()+" 23:59', -1, -1, 22,0) sp "+
		"        inner join site s on s.site_id = sp.trans_site_id "+
		" group by 1 ";*/

	sql = "  select tsa.site_name, "+
		"   sum(case when tsa.cost_of_goods_sold > 0 then tsa.cost_of_goods_sold else 0 end) cost_of_goods_sold,  "+
		//"        sum(case when tsa.payment_received_value_nett > 0 then tsa.payment_received_value_nett else 0 end) sales_net, "+
		//"        sum(tsa.payment_received_value_gross) sales_gross, sum(tsa.total_sold) num_sold, "+
		//"        avg(tsa.stock_turn_rate) stock_turn_rate, avg(tsa.stock_turn_days_to_zero_stock) stock_turn_days_to_zero_stock, "+
		"        sum(case when tsa.payment_received_value_nett > 0 then tsa.payment_received_value_nett else 0 end) - sum(case when tsa.cost_of_goods_sold > 0 then tsa.cost_of_goods_sold else 0 end) gross_profit , "+
		//"        100 - (sum(tsa.cost_of_goods_sold) / sum(tsa.payment_received_value_nett) * 100) margin "+
		"	avg(case when tsa.ave_customer_spend > 0 then tsa.ave_customer_spend else 0 end) ave_customer_spend "+
		" from sp_stock_analysis('"+flightDeckSession.getFromDate().toString()+" 00:00', '"+flightDeckSession.getToDate().toString()+" 23:59',0) tsa, site s "+
		" where tsa.site_id = s.site_id "+
		" group by 1 ";

	out.write("<p>"+sql);  
	
	FlightDeckModel flightDeckModelRev = new FlightDeckModel("SALES ANALYSIS", "Sales (excl. VAT)", "Average Customer Spend (inc. VAT)", seriesList);

	//out.write("<p>10"); 
	//flightDeckModelRev.populate(flightDeckController,conn,sql); 
	//out.write("<p>"+flightDeckModelRev.getDataSet());
	//out.write("<p>20"); 


	strXML = flightDeckModelRev.toXMLString(palette, "&pound;", "0", "0", "0", FlightDeckModel.X_AXIS_LABEL_DISPLAY_ROTATE, 1, 0, 1, " use3DLighting='1' showSum='1' ");
	chartCode= FusionChartsCreator.createChartHTML(flightDeckController.getChartLocation()+"/FusionCharts/StackedColumn3DLineDY.swf", "", strXML, "productSales", 1000, 500, false);
	out.write("<center>"+chartCode+"</center>");





	out.write("</td></tr></table>");

	out.write("<br /><br /><br /><br /><br /><br /><br /><br />");

	//chartCode= FusionChartsCreator.createChartHTML(flightDeckController.getChartLocation()+"/FusionCharts/MSBar3D.swf", "", strXML, "productSales", 600, 300, false);
	//out.write(chartCode);

	//chartCode= FusionChartsCreator.createChartHTML(flightDeckController.getChartLocation()+"/FusionCharts/StackedBar3D.swf", "", strXML, "productSales", 600, 300, false);
	//out.write(chartCode);

}

}
} catch (Exception e) {
	out.write("<p>Error: "+e.getMessage());
	website.writeToLog(e);
} finally {
	if (fos != null)
		try {
			fos.close();
		} catch (IOException e) {}
	if (conn != null)
		try {
			conn.close();
		} catch (Exception e) {}
}


		

	

%> 



				</center>
			</td>
		</tr>
	</table>
	</center>


</td></tr>
</table>
<!-- end of flightdeck.jsp -->