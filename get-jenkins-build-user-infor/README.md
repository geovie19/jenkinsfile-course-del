## Requirement
build user vars plugin

https://www.jenkins.io/doc/pipeline/steps/build-user-vars-plugin/

```
wrap([$class: 'BuildUser']): Set jenkins user build variables
This plugin is used to set user build variables:
BUILD_USER -- full name of user started build,
BUILD_USER_FIRST_NAME -- first name of user started build,
BUILD_USER_LAST_NAME -- last name of user started build,
BUILD_USER_ID -- id of user started build.
BUILD_USER_EMAIL -- email of user started build.
```