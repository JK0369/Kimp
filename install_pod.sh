#!/bin/sh

cp -rf .netrc ~/.netrc # mapbox 프레임워크 같은경우 새로운 버전으로 update가 필요할때, .netrc파일을 홈디렉토리에 복사해놓아야 가능
bundle install
bundle exec pod install --repo-update # update가 없으면 동기화문제 생기는 경우 존재