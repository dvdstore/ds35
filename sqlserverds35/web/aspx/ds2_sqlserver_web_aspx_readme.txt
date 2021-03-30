ds2_sqlserver_web_aspx_readme.txt

aspx interface to the SQL Server DVD Store database

To set up ds2 aspx pages on W2K3R2/.NET 2.0/ASP.NET 2.0/VS2005:

1) Install ds2 on SQL Server

2) Give write permission to the NETWORK SERVICE user to
C:\WINDOWS\Microsoft.NET\Framework\v2.0.50727\Temporary ASP.NET Files
(the exact version 2.0.xxxxx may be different in this command and those those follow)

3) In IIS Manager double click on the server name (top line, then double click on Web
Service Extensions)
Select Add a new Web service extension, then fill in
Extension name: ASP.NET v2.0.50727
Required files: C:\WINDOWS\Microsoft.NET\Framework\v2.0.50727\aspnet_isapi.dll
Then click on Allow

4) Create new directory, say c:\ds2web

5) Copy following 10 files from C:\ds2\sqlserverds2\web\aspx to c:\ds2web:
dsbrowse.aspx
dsbrowse.aspx.cs
dscommon.cs
dslogin.aspx
dslogin.aspx.cs
dsnewcustomer.aspx
dsnewcustomer.aspx.cs
dspurchase.aspx
dspurchase.aspx.cs
index.html

6) Open up VS2005, select File->New->Web Site->ASP.NET Web Site, location: c:\ds2web
You will see a message, There is already a web site containing files at this location
Select: Create a new web site in this location

7) In Solution Explorer, rename folder App_Data to App_Code, move dscommon.cs into it

8) Delete default.aspx

9) (Optional) Turn off HTML validation: Tools->Options->Text Editor->HTML->Validation->unselect Show Errors

10) Build->Build Web Site

11) In IIS Manager, Web Sites->Default Web Site->right click New->Virtual Directory
Virtual Directory Creation Wizard:
Alias: ds2
Path: c:\ds2web
Permissions: Read, Run Scripts

12) In IIS Manager, under Default Web Site, right click on ds2->Properties->
ASP.NET->ASP.NET Version->select 2.0.50727, OK
Documents: Add->index.html, move to top of list, OK

13) Test with local browser: http://localhost/ds2
should see login page

14) Test with remote browser: http://hostname/ds2

<dave_jaffe@dell.com> and <tmuirhead@vmware.com>  12/2/07
