# cs4783 project spring2021
Author: Rongrong Wei (tyw061)  

## Port and API Paths
This project is pointed to port `12300`. It is a service at IP address: `10.100.126.27`.

To test the API, use [https://10.100.126.27:12300/swagger.json](https://10.100.126.27:12300/swagger.json) in Swagger UI.

**NOTE** I deleted my deployment after finishing the assignment so that others could use the cluster. To redeploy, please rerun the gitlab CI/CD pipeline for the latest commit to the branch in Assignment 5. It will deploy the DB and the API. To manually deploy to kubernetes:
```
kubectl --kubeconfig config apply -f k8s/db_deploy.yaml
kubectl --kubeconfig config apply -f k8s/api_deploy.yaml
```

## K8s
I have commented out the clean up job on my runner so that the API can be easily tested. Please make sure to remove the pod after done. You can do so by running the commands:

```
kubectl delete deployment tyw061-db-deployment
kubectl delete deployment tyw061-api-deployment
```

**IMPORTANT**
You need to be connected to the UTSA VPN and update your hosts file to access easel4 by url. You will need to add the line:  
```
10.100.201.3 easel4.cs.utsarr.net
```
to your hosts file (/etc/hosts) on linux/mac. On windows, the hosts file should be at:
`C:\Windows\System32\drivers\etc\hosts`

## Unit and `curl` Tests
Unit tests are in src directory of the project with the name `test_*.py`.  
Curl tests are in the tests directory.  

## Test Locally
If you want to use locally, test using assignment 4 branch.
*PORT* 
The project will be running on port `12300`

To see the endpoints, use swagger UI (`https://localhost:12300/swagger.json`) or use Postman. All endpoints have been described in the assignment handout.

*IMPORTANT*  
Note that all endpoints require `https`.  Note that this project is currently using a self-signed p12 certificate which means that Chrome will give you a lot of security warnings. Don't worry. It's ok. If Swagger UI won't load swagger.json right away, try this:
1. Visit hello endpoint (`https://localhost:12300/hello`) and accept certificate through Chrome using the advanced/proceed options. 
2. Then visit Swagger UI.

## SSL Notes
All of the SSL credentials have been committed to the repo and are located in the `/src/my_cert/` directory. The main p12 file has been converted to pem files to use with Flask.

## Setup
This project can use Docker and `docker-compose` to deploy the api. To build and run the project in a Docker environment, run the command:
```
docker-compose up
```

For troubleshooting, the shell script `redo.sh` can be run to totally delete any project related volumes and images for a clean build. Note that running this script will remove ALL local Docker images so make sure you actually want a totally clean environment before you run it.