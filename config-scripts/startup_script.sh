#!/bin/bash
yc compute instance create \
  --name reddit-app \
  --hostname reddit-app \
  --memory=4 \
  --core-fraction=20 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=14GB \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --metadata-from-file user-data=/home/alex/Alexander-High_infra/metadata.yaml \
  --metadata serial-port-enable=1
