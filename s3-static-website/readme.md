Error I faced: 
index.html -: i have updated this file but it doesn't modified in the s3 so i have to delete the file and did terraform apply again and it works.
for cdn logging: follow the cdn complete module.
cdn file: response_page_path = "/error.html" -: I was using the source as described in the website-html.tf rather than using what is in the S3 bucket.

Todo 
error.html will be present if page didn't show up index.html - DONE
CDN logging - DONE

theory:
when changes the html files, cdn doesn't deployed again or it won't show you that it is modified.