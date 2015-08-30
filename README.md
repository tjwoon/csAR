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

```
cloudSky.ar.canDoAr(
    function (canDoAr) {
        // canDoAr == true if we can do AR on this device, false otherwise.
    },
    function () {
        // Error retrieving AR capability.
        // Optional.
    }
)
```

### showGeolocationsForSelection

```
cloudSky.ar.showGeolocationsForSelection(
    {
        maxDistance: 1000, // OPTIONAL, defaults to 1000
        geoLocations: [
            {
                latitude: 1.2345,
                longitude: 101.2345678,
                name: "Location name"
            },
            ...
        ]
    },
    function (location) {
        // location is a new object with the same latitude, longitude, and name
        // as the location which the user tapped on.
        // If the AR view was dismissed using the Cancel button,
        // location === undefined.
    },
    function () {
        // Error launching the AR view.
        // Optional.
    }
)
```

Where:

- `maxDistance` is the maximum distance from the device's current coordinates to
  a geolocation before it is no longer displayed.
- `geoLocations` is an array of locations to display. Any location not matching
  the given format will be ignored / not displayed.


Credits
-------

iOS native AR implementation is based on [my fork](https://github.com/tjwoon/iPhone-AR-Toolkit) of @chrjs's
(fork of the) iPhone AR Kit.
