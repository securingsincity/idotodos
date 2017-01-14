#! /bin/bash
export IS_TAG=$([[ ! -z "$TRAVIS_TAG" ]] && echo "1" || echo "0")

if [[ $IS_TAG -gt 0 ]]; then

  echo "Preparing to deploy";
  mkdir build
  mv * build
  tar -czf $TRAVIS_TAG.tgz build
  scp -P $DEPLOY_PORT $TRAVIS_TAG.tgz $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_PATH
#   ssh $DEPLOY_USER@$DEPLOY_HOST $DEPLOY_PATH/deploy.sh
fi