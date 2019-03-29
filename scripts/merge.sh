#!/bin/bash

TARGET=$1

if [[ `git status` == *"Changes to be committed"* ]]; then
	echo "Checkout not clean, please commit your changes."
fi

./paper p

cd Paper-Server
git tag -fam tmp tmp
cd ..

git fetch
git merge $TARGET

git status
echo "Waiting on conflict resolution..."
while [[ `git status` == *"You have unmerged paths"* ]]; do
  sleep 2
done
echo "...conflict resolution done."

./paper p

cd Paper-Server
git status
echo "Waiting on patch conflict resolution..."
while [[ `git status` == *"You have unmerged paths"* ]]; do
  sleep 2
done
echo "...patch conflict resolution done."
cd ..

./paper rb

git commit -m "Patch merge $TARGET" -a  