ds35mysqldrvierlinux_readme.txt - TM 6/3/21

DVD Store 3.5 includes a prebuilt binary mysql driver for linux - ds35mysqldriverlinux
This driver should run on linux without the need to install .Net for Linux or 
the MySQL .Net Connector. It is possible that in the future it might be necessary to 
recompile to support other Linux versions or other Operating Systems. 

It is based on the ds35xdriver.cs and ds35mysqlfns.cs source files.  The detailed steps
to build this same binary or run with .Net 5.x for Linux installed are included below.

Linux setup example tested using a CentOS 7 VM.

Microsoft Website with instructions on installing
https://docs.microsoft.com/en-us/dotnet/core/install/linux-centos

Setup repository with this rpm:
sudo rpm -Uvh https://packages.microsoft.com/config/centos/7/packages-microsoft-prod.rpm

Install SDK:
sudo yum install dotnet-sdk-5.0

Copy the .cs source files into /ds35/mysqlds35/dotnet directory - ds35mysqlfns.cs  ds35xdriver.cs

Establish the dotnet project:
cd /ds35/mhysqlds35/dotnet
dotnet new console

Delete the Program.cs file from the ds35/mysqlds35/dotnet directory:
rm Program.cs

Install mysql .Net/Connector from Oracle / MySql - MySql.Data: 
dotnet add package MySql.Data

Run the driver:
dotnet run

Run the driver with parameters example:
dotnet run --target=localhost --n_threads=2 --db_size=1GB --n_stores=2

Compile / Build linux driver executable that isn't dependent on dotnet being installed:
dotnet publish -r linux-x64 -c Release -o publish -p:PublishReadyToRun=true -p:PublishSingleFile=true -p:PublishTrimmed=true --self-contained true -p:IncludeNativeLibrariesForSelfExtract=true -p:IncludeAllContentForSelfExtract=true -p:PublishReadyToRunShowWarnings=true
This creates a file called dotnet located at ds35/mysqlds35/dotnet/publish

Rename dotnet to ds35mysqldriverlinux