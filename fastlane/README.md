fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## iOS
### ios renew_codesign_debug
```
fastlane ios renew_codesign_debug
```

### ios renew_codesign_alpha
```
fastlane ios renew_codesign_alpha
```

### ios renew_codesign_beta
```
fastlane ios renew_codesign_beta
```

### ios renew_codesign_release
```
fastlane ios renew_codesign_release
```

### ios sync_codesign_debug
```
fastlane ios sync_codesign_debug
```

### ios sync_codesign_alpha
```
fastlane ios sync_codesign_alpha
```

### ios sync_codesign_beta
```
fastlane ios sync_codesign_beta
```

### ios sync_codesign_release
```
fastlane ios sync_codesign_release
```

### ios common_build
```
fastlane ios common_build
```
common build
### ios build_debug
```
fastlane ios build_debug
```

### ios build_alpha
```
fastlane ios build_alpha
```

### ios build_beta
```
fastlane ios build_beta
```

### ios build_release
```
fastlane ios build_release
```

### ios build_number_bump
```
fastlane ios build_number_bump
```

### ios upload_to_firebase
```
fastlane ios upload_to_firebase
```

### ios upload_firebase_alpha
```
fastlane ios upload_firebase_alpha
```

### ios upload_firebase_beta
```
fastlane ios upload_firebase_beta
```

### ios upload_testflight
```
fastlane ios upload_testflight
```

### ios upload_appstore
```
fastlane ios upload_appstore
```


----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
