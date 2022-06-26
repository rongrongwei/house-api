
# DB Setup
docker build -t tyw061/tyw061_db:latest -f docker/Dockerfile_db .
docker push tyw061/tyw061_db:latest 
kubectl apply -f k8s/db_deploy.yaml
kubectl apply -f k8s/db_service.yaml

# log into instance of running container to check db
# kubectl exec -ti tyw061-db-deployment-67c47868cd-4xgj8 -c tyw061-db-c /bin/bash 
# mysql -u root -p # log into db to check table
# use cs4783_tyw061;
# select * from property;
# +-------------+------------------+---------------+-------+-------+
# | property_id | address          | city          | state | zip   |
# +-------------+------------------+---------------+-------+-------+
# |           1 | 567 Rongrong Way | UTSA City     | TX    | 78250 |
# |           2 | 999 Rongrong Way | San Antonio   | TX    | 78249 |
# |           3 | 123 UTSA Way     | San Antonio   | TX    | 78249 |
# |           4 | 111 HELLP        | AAAGH         | TX    | 77777 |
# |           5 | 321 Safe Rd.     | Rongrong City | TX    | 72222 |
# |           6 | Test Place       | Test City     | TX    | 78249 |
# |           7 | Test Place       | Test City     | TX    | 78249 |
# |           8 | Test Place       | Test City     | TX    | 78249 |
# |           9 | UTSA             | San Antonio   | TX    | 78249 |
# |          10 | Test Place       | Flavortown    | TX    | 78249 |
# +-------------+------------------+---------------+-------+-------+

# API Setup
# TODO: find out how to push as private repo (manually set on dockerhub)
# note password below has been committed to repo knowing this dockerhub account is for class only :)
docker build -t tyw061/tyw061_api -f docker/Dockerfile_api . 
docker push tyw061/tyw061_api:latest 
kubectl create secret docker-registry tyw061-dockerhub \
--docker-server=docker.io --docker-username=tyw061 \
--docker-password=d2176fcb-e39a-4b3d-b5be-b34dcc8ac5ac \
--docker-email=tyw061@my.utsa.edu
kubectl apply -f k8s/api_deploy.yaml
kubectl apply -f k8s/api_service.yaml 
# it worked!

# delete a k8s item 
kubectl delete service tyw061-api-service 
kubectl delete deployment tyw061-api-deployment 