<%@page import="co.simplypos.model.website.*, co.simplypos.model.utils.*, co.simplypos.model.utils.helpers.*, co.simplypos.persistence.Address, co.simplypos.persistence.*, co.simplypos.model.*, co.simplypos.model.website.utils.Logger, co.simplypos.persistence.Currency, java.text.*, javax.mail.*, java.io.*, java.awt.*, java.util.*, java.sql.*, java.net.*, java.util.Date, javax.imageio.ImageWriter, com.sun.imageio.plugins.jpeg.JPEGImageWriter, java.math.BigDecimal, javax.net.ssl.HttpsURLConnection, javax.swing.table.DefaultTableModel, co.simplypos.model.website.page.view.*, co.simplypos.model.website.page.controller.*, co.simplypos.model.website.page.model.*, javax.swing.text.html.HTML, com.clearcommerce.CpiTools.security.HashGenerator"%><jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" /><jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession" />
<%@include file="/secure-shopping.html" %>