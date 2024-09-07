@echo off
fvm flutter clean
fvm flutter pub get
fvm flutter build web --release
git status
git add .