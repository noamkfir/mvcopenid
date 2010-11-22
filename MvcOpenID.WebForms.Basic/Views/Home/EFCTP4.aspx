﻿<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Switch To EFCTP4
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<h1>OpenID Starter Kit for ASP.NET MVC with Entity Framework CTP4</h1>

<p><strong><em>Last updated on: 21/11/2010</em></strong></p>

<h2>Why Entity Framework CTP4?</h2>

<p>Microsoft ADO.NET Entity Framework 4.0 was released as part of .NET 4.0 on 12 April 2010. The CTP4 version is the latest preview version of Entity Framework 4.0. It is an early preview of the Code First Programming Model and Productivity Improvements for Entity Framework 4.</p>

<h2>Installing EFCTP4</h2>

<p>There are 2 main ways of including EFCTP4:</p>

<ul>
<li>Download and install <a href="http://www.microsoft.com/downloads/en/details.aspx?FamilyID=4e094902-aeff-4ee2-a12d-5881d4b0dd3e">Microsoft ADO.NET Entity Framework Feature Community Technology Preview 4 </a>. After the installation is complete add a reference to Microsoft.Data.Entity.CTP.</li>
<li>If you have <a href="http://nuget.codeplex.com/">NuGet</a> installed you can download and add the required resources using it. NuGet has two ways for adding packages:
<ul>
<li><strong>Console</strong>: Open you Pacakge Manager Console (View -> Other Windows -> Pacakge Manager Console) and type in 'Install-Package EFCTP4'.</li>
<li><strong>GUI</strong>: You can also do this by right clicking the References folder in Solution Explorer of your project and selecting <em>Add Library Package Reference...</em>. In the popup windows choose Online and enter EFCTP4 in the search field. Select EFCTP4 and click the Install button.</li>
</ul></li>
</ul>

<h2>Requirements</h2>

<p>Entity Framework CTP4 does require some version of SQL Server. The simplest one to get is the SQL Server Compact Edition (SQLCE). It can be installed via <a href="http://nuget.codeplex.com/">NuGet</a>. The package for this is called <em>SQLCE.EntityFramework</em>. The installation goes the same as the installation of EFCTP4 with NuGet described in the previous section.</p>

<p>EFCTP4 also works great with <a href="http://www.microsoft.com/sqlserver/2008/en/us/express.aspx">Microsoft SQL Server 2008 R2 Express Edition</a>. It comes with Microsoft SQL Server Management Studio which is a really great tool for browsing around you database. This is also the only version of SQL Server I've tested this with. If you have any other version of SQL Server on your machine please let me know how it works at <a href="http://mvcopenid.codeplex.com/discussions">MvcOpenID's CodePlex discussion board</a>.</p>

<h2>Replacing the Model</h2>

<p>Now you have to replace the ADO.NET Entity Data Model with POCO (Plain Old CLR Object) classes and the context class files. These files are already included in the source, but are not part of the project. Here is the list of the needed files:</p>

<ul>
<li>OpenId.cs</li>
<li>User.cs</li>
<li>UserContext.cs</li>
</ul>

<p>To see these files click the <em>Show All Files</em> icon at the top of the Solution Explorer and then navigate to the Models folder. You will see these three files but they won't have the nice icons. Now select them (use Ctrl + Left Mouse Click for multi-select), left click on them and from the menu select <em>Include In Project</em>.</p>

<p>The build would fail at this point because there are duplicate definitions of <em>OpenId</em>, <em>User</em> and <em>UserContext</em> classes. To fix this we'll have to remove UserDB.edmx from the project. This is done in a similar fashion as we did with the POCO files. Left click on UserDB.edmx and select <em>Exclude From Project</em>.</p>

<h2>Modifying the UserRepository</h2>

<p>The build still failes at this point. The reason for this is that EF4.0 and EFCTP4 do not use the same base class for UserContext. As UserRepository is using the UserContext the build fails there. So you'll have to modify it a bit. Open the UserRepository.cs file.</p>

<p>In the <em>AddOpenId</em> function you'll see two lines of code just before the end. One is commented out and the other isn't. They both have a comment at the end to let you know to which EF version they apply to. Comment out the EF4 line and decomment the EFCTP4 line. You see a similar situation in the <em>RemoveOpenId</em> function. Do the same there as well.</p>

<h2>Optional Steps</h2>

<h3>Setting the Database Initializer</h3>

<p>If you never ran any of the MvcOpenID projects using EFCTP4 this (probably) won't affect you. The problem will occur when you change the model. This will break the project at runtime and throw the following exception:</p>

<p><code>The model backing the 'UserContext' context has changed since the database was created.  Either manually delete/update the database, or call Database.SetInitializer with an IDatabaseInitializer instance.  For example, the RecreateDatabaseIfModelChanges strategy will automatically delete and recreate the database, and optionally seed it with new data.</code></p>

<p>To fix this we must allow EFCTP4 to rebuild out database model. You'll achieve this by opening the Global.asax.cs file located at the root of the project. At the top of the <code>Application_Start()</code> function you see a line of code commented out:</p>

<p><code>//Database.SetInitializer&lt;UserContext&gt;(new RecreateDatabaseIfModelChanges&lt;UserContext&gt;());</code></p>

<p>Uncomment this and run the application again. The model in the database will be updated now. Note that some people say that it's best to run the application in debug mode after you make any data model changes. But you will loose all the data that was stored in there. So make sure you comment this out again when you finalize your data model. Entity Framework CTP5 should bring quite a lot more functionality to this part. I'll do an update as soon as it's out.</p>

<h3>Remove MvcOpenID.mdf</h3>

<p>The database inside App_Data is no longer needed. So you can remove it without any worries. You can also just excluded from the project as we did with the entity data model.</p>

<h3>Deleting the UserContext Connection String</h3>

<p>There is a connection string inside web.config that is setup by the Entity Framework for the model. This is no longer needed when using EFCTP4 as you can remove it by going to Web.config file at deleting the following connection string:</p>

<p><code>&lt;add name="UserContext" connectionString="metadata=res://*/Models.UserDB.csdl|res://*/Models.UserDB.ssdl|res://*/Models.UserDB.msl;provider=System.Data.SqlClient;provider connection string=&amp;quot;Data Source=.\SQLEXPRESS;AttachDbFilename=|DataDirectory|\MvcOpenID.mdf;Integrated Security=True;User Instance=True;MultipleActiveResultSets=True&amp;quot;" providerName="System.Data.EntityClient" /&gt;</code></p>

<p>You can of course just comment it out using XML comment tags <code>&lt;!-- Commented text --&gt;</code>.</p>

<h2>The End</h2>

<p>You can now run your application. Everything should work fine. If not please see the next section on how to report the problem.</p>

<h2>Troubleshooting</h2>

<p>If anything goes wrong or if it doesn't work even after you've done all the steps here please report this at <a href="http://mvcopenid.codeplex.com/workitem/list/basic">MvcOpenID CodePlex Issue Tracker</a>.</p>

</asp:Content>
