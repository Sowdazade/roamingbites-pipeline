#!/bin/bash

DRONE_SERVER=http://drone.sowdazade.ir
DRONE_TOKEN=1d0822dbbf41318f699cecbfc8b7e202

drone secret add --repository=roamingbites/pipeline --name=DB_PASSWORD --value=StrongPass123
drone secret add --repository=roamingbites/pipeline --name=MINIO_ACCESS_KEY --value=admin
drone secret add --repository=roamingbites/pipeline --name=MINIO_SECRET_KEY --value=StrongPass123
drone secret add --repository=roamingbites/pipeline --name=REGISTRY_USER --value=admin
drone secret add --repository=roamingbites/pipeline --name=REGISTRY_PASS --value=13680509
drone secret add --repository=roamingbites/pipeline --name=SSH_KEY --value="$(cat ~/.ssh/id_rsa)"
