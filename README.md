# Synthetic

Synthetic is a web app to map users to Docker containers running a RStudio Shiny app
where they can design linear and logistic regression models to be fit against
synthetic data.

Synthetic data is used to allow regression modeling of datasets while preserving 
privacy - we restrict the sorts of regression models that are allowed using parameters
set based on differential privacy concerns. To do this, we use Shiny to construct
a user interface where the regression model is built by selecting terms and operations
from menus.

Once a regression model has been built, the user can test it against a synthetic dataset.
If the model looks interesting, the user may then want to see what the residuals are
when the regression is run against the real data. But we don't want to provide users
with un-mediated access to the (sensitive) real data, so the application allows them to
submit their regression model the app, and a private backend then processes the model
against the sensitive data without providing the user with direct access. 

Since the regression model is limited to fields and operations that will not exceed 
the differential privacy limits established for this data, we have some assurance that
individually identifiable private data is not being leaked as a side effect of running
the regression against the actual sensitive data. 

After the user's regression is run on the private backend, it then reports back to 
the user the residuals for their model when run against the actual data.

The synthetic app acts as the coorintation point for all this. Users log into synthetic,
and are mapped to a personal Docker container which runs the RStudio Shiny app. From the
Shiny app they can request their model be submitted to the private backend. Their regression
models, the residuals calculated from running the regression against the synthetic data, and 
the residuals calculated from running the model against the actual (sensitive) data are
stored in the synthetic web app so that users can refer to the results after the jobs have
been run.

## architecture
There are several components that make up the system
- synthetic-data   https://github.com/mccahill/synthetic-data 
- synthetic-shiny-container   https://github.com/mccahill/synthetic-shiny-container
- synthetic-verification   https://github.com/mccahill/synthetic-verification
- synthetic-verification-measures   https://github.com/mccahill/synthetic-verification-measures


Synthetic-data (this application) is presumed to have an authentication sertvice in 
front of it (in our case Shibboleth) which passes to the Apache web server some environment
variables with the user's netID. We use the netID to track which user is mapped to which
Docker container (i.e. synthetic-shiny-container) with the shiny_dockers mySQL table.
When setting the app up you will need to use the admin interface to populate this table
with the host/port/password/job_submit_token for the synthetic-shiny-container instances
where the Shiny app is run for each user.

After users are redirected to their synthetic-shiny-container, the Shiny app knows the
job_submit_token to be used when posting jobs back to the synthetic-data application,
and this token is used to identify which user the job came from.

A cron task runs periodically to launch the synthetic-verification application, and this
app processes the submitted model against the real data, then posts the results back to
the synthetic-data app.


## model verification REST calls
Here is the messaging lifecycle for a model verification job:

1.) user develops a model using the Shiny container and tells the container to submit
submit it for processing. Note that we can accept an image upload of the synthetic
model's residuals - this is useful for comparing with the verification residuals image
later in the process.

```
curl -X POST \
-H "Content-Type: multipart/form-data" \
-H "Accept: application/json" \
--form "job_submit_token=ggKFH29QUvdHuP4Fd4wrzukJkoTm" \
--form "model=this ~ is^2 + a * model" \
--form "epsilon=0.9" \
--form "output_unit=1000" \
 --form "syntheticfile=@human-genome.png" \
https://synthetic.oit.duke.edu/app_install/remote_jobs
```

2.) the backend processing service running in the secure bastion periodically
fetches a list of jobs awaiting processing. It identifies itself by sending a 
secret verification_processor_token parameter in the request

```
curl -X POST \
-H "Content-Type: multipart/form-data" \
-H "Accept: application/json" \
--form "verification_processor_token=dYGrAGpr1OYydhgf87y4dhurg87h4HsKxL5" \
https://synthetic.oit.duke.edu/app_install/awaiting_remote_processing
```

3.) the backend processing service tells synthetic.oit.duke.edu 
that it is starting to work on a job

```
curl -X PUT \
-H "Content-Type: multipart/form-data" \
-H "Accept: application/json" \
--form "opaque_id=0345e4-0691-4f4a-ac89-386072748" \
--form "verification_processor_token=dYGrAGpr1OYydhgf87y4dhurg87h4HsKxL5" \
https://synthetic.oit.duke.edu/app_install/starting_remote_processing
```

4.) the backend processing service has completed the job and returns
results to synthetic.oit.duke.edu
```
 curl -X PUT \
 -H "Content-Type: multipart/form-data" \
 -H "Accept: application/json" \
 --form "opaque_id=0345e4-0691-4f4a-ac89-386072748" \
 --form "verificationfile=@DevOps.png" \
 --form "verification_processor_token=dYGrAGpr1OYydhgf87y4dhurg87h4HsKxL5" \
https://synthetic.oit.duke.edu/app_install/completed_remote_processing
```





