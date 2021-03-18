#!/bin/sh
set -e

echo "Deploying NUXT application ..."

# Copy and build new version
cd ..
cp -r deploy-nuxt-test deploy-nuxt-test-new
cd deploy-nuxt-test-new

git config --local user.email "action@github.com"
git config --local user.name "GitHub Action"
git checkout -B deploy
git fetch origin deploy
git reset --hard origin/deploy

/home/david/.nvm/versions/node/v14.16.0/bin/npm install --only=production
/home/david/.nvm/versions/node/v14.16.0/bin/npm run build

# Replace current version with the new one

cd ..
mv deploy-nuxt-test deploy-nuxt-test-old
mv deploy-nuxt-test-new deploy-nuxt-test

# Restart server

cd deploy-nuxt-test
/home/david/.nvm/versions/node/v14.16.0/bin/pm2 kill
/home/david/.nvm/versions/node/v14.16.0/bin/pm2 start "npm run start" --name App
rm -rf ../deploy-nuxt-test-old
echo "Deployment finished"