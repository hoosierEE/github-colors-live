
// array with default test values

// app
var lc = Elm.fullscreen(Elm.LiveColor, { clrs: [] });

// send and receive through ports
lc.ports.yamlReq.subscribe(function(s) {
    var filt = [];
    if (s !== "") {
        var payload = jsyaml.safeLoad(s);
        for(var language in payload) {
            var thisEntry = [language, JSON.stringify(language.color)];
            filt.push(thisEntry);
        }
        // debugging
        lc.ports.clrs.send(JSON.parse(JSON.stringify(filt)));
        // have to stringify and then un-stringify because:
        // lc.ports.clrs.send(filt); // expecting a string but was given
        // sendy2j.js:18
        // (anonymous function)elm.js:3504
        // (anonymous function)elm.js:4351
        // updateelm.js:4341
        // recvelm.js:4308
        // broadcastToKidselm.js:4342
        // recvelm.js:4308
        // broadcastToKidselm.js:4342
        // recvelm.js:4308
        // broadcastToKidselm.js:4322
        // recvelm.js:3618
        // notifyelm.js:3123
        // updateQueueelm.js:3144
        // (anonymous function)

    }
});


