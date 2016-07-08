This is an example of how the uploads directory should be configured.

However, the real directory should be named 
     "uploads" 
instead of 
     "uploads-example"
	 
The reason for putting a directory with a fake name into git is to keep 
git from stepping on the real directory during deploys, but still illustrate
how things should be configured. 

We want uploaded files to persist across new version of the app, it is 
important to avoid blowing away the uploads directory heirarchy where 
the files are stored...
