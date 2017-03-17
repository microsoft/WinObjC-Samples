## File Activation
Install this app to open files with extension .faa.

Follow the steps from WinObjC (https://github.com/Microsoft/WinObjC/#getting-started-with-the-bridge) github repo documentation to create a visual studio solution.

#Pre requisites
Expand solution->FileActivation->FileActivation(Universal Windows)
open Package.appxmanifest

go to Declarations tab

select File Type Associations in Available Declarations
click Add

In properties add the following enter
Display Name: File Activation Sample app
Name: Fast

In supported file types enter
content ype : text/plain
File type: .faa

Now to use this first deploy and then open the .faa file by double clicking the file.
