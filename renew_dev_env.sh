#!/bin/sh

bundle install
bundle exec fastlane renew_codesign_debug
bundle exec fastlane renew_codesign_alpha
bundle exec fastlane renew_codesign_beta
bundle exec fastlane renew_codesign_release