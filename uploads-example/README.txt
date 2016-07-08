This is an example of how the uploads directory should be configured.

However, the real directory should be named 
     "uploads" 
instead of 
     "uploads-example"
	 
The reason for putting a directory with a fake name into git is to keep 
git from stepping on the real directory during deploys, and illustrate
how things should be configured. 

When run in production, the rails app is not run as the owner of the files 
in the heirarchy (capdeploy), but is a member of the apache group,
so we need to be sure that two directories are group writable:
     dukeapps/uploads/phoneupload/uploadfile
	 dukeapps/uploads/phoneupload-cache

Also, we want uploaded files to persist across new version of the app, it is 
important to avoid blowing away the uploads directory heirarchy where 
the files are stored...

Note that dsomeone should periodically clear out the directory where failed 
uploads gather (dukeapps/uploads/phoneupload-cache)