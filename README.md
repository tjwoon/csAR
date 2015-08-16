CloudSky AR Plugin for Cordova
==============================

This plugin makes it easy to display AR overlays onto the device's live camera
feed. Currently supported features:

- Location based points (with names)


Installation
------------

### Using the Cordova CLI

```
cordova plugins add org.cloudsky.cordovaplugins.ar \
    --variable IOS_PERMISSION_DESCRIPTION="Description when requestion Location Permission from user (on iOS)"
```


Usage
-----

### canDoAr

`cloudSky.ar.canDoAr(...)`

### showWithGeolocations

`cloudSky.ar.showWithGeolocations(...)`


Credits
-------

iOS native AR implementation is based on @chrjs's
(fork)[https://github.com/chrjs/iPhone-AR-Toolkit] of the iPhone AR Kit.
