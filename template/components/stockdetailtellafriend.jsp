	<% if (website.isShowTellAFriend()) { %>
		<form name="tellafriendform" method="post" action="<%=request.getRequestURL()+"?"+StringHelper.replace(request.getQueryString(), "&", "&amp;")+"#tellafriend"%>">

		<div id="div_tellafriend" style="<%=pageModel.isTellAFriendVisible()?"":"display:none;"%>" class="stockcontainer componentBorder">

			<a name="tellafriend" > </a>
				<%
		       	 String pageTitleTellAFriend = website.getText("tellafriend","Tell a friend");
			       String pageTitleTextTellAFriend = "Fill in the details below and an e-mail will be sent to your friend telling them about this product. You can see an example of the email your friend will receive below.";
				%> 
				
				<h3><%=pageTitleTellAFriend%></h3>
				<p class="tellafriendtagline"><%=pageTitleTextTellAFriend%></p>
				<div id="tellafriendyourdetails">
					<label class="yourname">Your Name</label>
					<input type="text" name="tellyourname" maxlength="50" size="25" value="<%=pageModel.getParamTellyourname()%>" />
					<label class="youremail">Your Email</label>
					<input type="text" name="tellyouremail" maxlength="50" size="25" value="<%=pageModel.getParamTellyouremail()%>" />
				</div>
				

				
				<div id="tellafriendfrienddetails">
					<label class="friendname">Friends Name</label>
					<input type="text" name="tellfriendsname" maxlength="50" size="25" value="<%=pageModel.getParamTellfriendsname()%>" />
					<label class="friendemail">Friends Email</label>
					<input type="text" name="tellfriendsemail" maxlength="50" size="25" value="<%=pageModel.getParamTellfriendsemail()%>" />
				</div>
				<div id="tellafriendmessage">
						<%=pageModel.getTellAFriendMessage()%>
				</div>
					
				<%	if (pageModel.isTellAFriendButton()) {%>
					<input type="hidden" name="action" value="tell" /> 
					<a href="javascript:tellafriendform.submit()" name="Tell your friend" class="buttontellyourfriend actionbutton">
						<%=website.getText("detailTellaFriendUpdate","<span>Update</span>")%>
					</a>					
				<% } %>


			</div>
		</form>
	<% } %>


