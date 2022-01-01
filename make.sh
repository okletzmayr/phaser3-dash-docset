#!/usr/bin/env bash

# check for dashing
if ! command -v dashing &> /dev/null; then
  echo "could not find dashing. please install it."
  exit 1
fi

# check for required local submodules
if ! { [ -d ./phaser ] && [ -d ./phaser3-docs ]; }; then
  echo "could not find submodules. please pull them."
fi

# install with npm if required
if ! [ -d ./phaser3-docs/node_modules ]; then
  cd ./phaser3-docs
  npm install
  cd ..
fi

# generate docs if required
if ! [ -d ./phaser3-docs/out ]; then
  cd ./phaser3-docs
  npm run gen
  cd ../
fi

# generate with dashing
dashing build --source ./phaser3-docs/out

# get current tag of phaser submodule
cd ./phaser
TAG=$(git describe --tags)
cd ..

# check if current TAG has already been built
if [ -f ./docset/versions/$TAG/Phaser3.tgz ]; then
  echo "docsets have already been built for ${TAG}"
  exit 0
else
  mkdir -p ./docset/versions/${TAG}
  tar --exclude='.DS_Store' -cvzf ./docset/versions/${TAG}/Phaser3.tgz Phaser3.docset
fi

