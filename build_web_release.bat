@echo off
fvm flutter clean
fvm flutter pub get
fvm flutter build web --release
git status
git add .
git commit -m "update web"
git push