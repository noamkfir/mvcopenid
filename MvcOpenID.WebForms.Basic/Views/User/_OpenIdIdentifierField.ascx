﻿<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>

<div>Enter your OpenID provider: <input id="openid_identifier" name="openid_identifier" /> <%: Html.ValidationMessage("openid_identifier") %></div>