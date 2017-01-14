#! /bin/bash

if [[ $IS_TAG -gt 0 ]]; then

  echo "Preparing to deploy";
  mkdir build
  mv * build
  tar -czf package.tgz build
  scp package.tgz $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_PATH
#   ssh $DEPLOY_USER@$DEPLOY_HOST $DEPLOY_PATH/deploy.sh
fi