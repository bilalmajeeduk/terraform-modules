### for unhealthy instances.
I have created index.html files is the instances, by following this resource.
- cd /etc/httpd/conf
- cd /var/www/html
- echo 'health check2' > index.html
[for reference:] (https://www.youtube.com/watch?v=192YG1_0Pcg)




## How the Setup Works:
The ALB, located in public subnets, acts as an intermediary between the internet and your instances in public subnets.
When a request hits the ALB via its DNS name, the ALB forwards that traffic to your EC2 instances, where i configured the index.html files differently in each instance
The EC2 instances handle the request and return the response to the ALB, which then forwards it back to the client (internet user).


## TO DO LIST 
1. create user data to add in .sh file to create a index.html file as mentioned above. 
2. deploy the database in the private subnet.