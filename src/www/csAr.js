var argscheck = require('cordova/argscheck'),
    exec      = require('cordova/exec');

function AR () {};

AR.prototype = {

    canDoAr: function (success, failure)
    {
        argscheck.checkArgs('fF', 'CsAR.canDoAR', arguments);
        exec(success, failure, 'CsAR', 'canDoAR', []);
    },

    showWithGeolocations: function (params, success, failure)
    {
        argscheck.checkArgs('ofF', 'CsAR.showWithGeolocations', arguments);

        // Perform all input validation here (native does not check) - - - - - -

        var maxDistance;
        var locs = [];

        if(params.maxDistance === undefined) maxDistance = 1000;
        else maxDistance = params.maxDistance;

        if(params.geoLocations === undefined) locs = [];
        params.geoLocations.forEach(function (loc) {
            if(typeof loc.latitude == "number" &&
               typeof loc.longitude == "number" &&
               typeof loc.name == "string"
            ) {
                locs.push(loc);
            }
        });

        exec(success, failure, 'CsAR', 'showWithGeolocations', [{
            maxDistance: maxDistance,
            geoLocations: locs,
        }]);
    },

};

module.exports = new AR;
