<!-- start of components/stockdetailtellafriend.jsp -->
<tr>
	<td>
		<br />
		<form name='tellafriendform' valign='top' method='post' action='<%=request.getRequestURL()+"?"+request.getQueryString()+"#tellafriend"%>'>

		<div id='div_tellafriend' style='<%=pageModel.isTellAFriendVisible()?"":"display:none;"%>' class='stockcontainer'>

			<a name="tellafriend" class="pagetitle"> <%
		       pageTitle = website.getText("tellafriend","Tell a friend");
		       pageTitleText = "Fill in the details below and an e-mail will be sent to your friend telling them about this product. You can see an example of the email your friend will receive below.";
		       pageTitleImage = "";
			%> 
			<%@include file="../drawcontainerheader.html"%>

			<table width="90%" align="center">
				<tr>
					<td><br />
					</td>
				</tr>
				<tr>
					<td>Your Name</td>
					<td><input type="text" name="tellyourname" maxlength="50" size="25" value="<%=pageModel.getParamTellyourname()%>"></td>
					<td>Your Email</td>
					<td><input type="text" name="tellyouremail" maxlength="50" size="25" value="<%=pageModel.getParamTellyouremail()%>"></td>
				</tr>
				<tr>
					<td colspan="4"><img src="<%=website.getImagePath("spacer.gif")%>" alt="" class="width1 height10" /></td>
				</tr>
				<tr>
					<td>Friends Name</td>
					<td><input type="text" name="tellfriendsname" maxlength="50" size="25" value="<%=pageModel.getParamTellfriendsname()%>"></td>
					<td>Friends Email</td>
					<td><input type="text" name="tellfriendsemail" maxlength="50" size="25" value="<%=pageModel.getParamTellfriendsemail()%>"></td>
				</tr>
				<tr>
					<td colspan="4"><img src="<%=website.getImagePath("spacer.gif")%>" alt="" class="width1 height10" /></td>
				</tr>
				<tr>
					<td colspan="4">
						<table border="0" cellspacing="2" cellpadding="2" width="100%" style="border: 1px solid #999999; background-color: #FFFFFF;">
							<tr>
								<td bgcolor="#EEEEEE">
									<FONT SIZE="2" FACE="Verdana,Helvetica,Arial,MS Sans Serif" COLOR="#333333">
										<i><%=pageModel.getTellAFriendMessage()%></i> 
									</FONT>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="4"><img src="<%=website.getImagePath("spacer.gif")%>" alt="" class="width1 height5" />
					</td>
				</tr>
				<%		 		
		 		if (pageModel.isTellAFriendButton()) {
				%>
					<tr>
						<td colspan="4" align="center"><input type="hidden" name="action" value="tell"> <input type="submit" value="Tell your friend"></td>
					</tr>
				<% } %>

			</table>

			</a>
		</div>
		</form>
	</td>
</tr>
<!-- end of components/stockdetailtellafriend.jsp -->
