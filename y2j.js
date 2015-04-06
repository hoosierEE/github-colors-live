// app
var lc = Elm.fullscreen(Elm.LiveColor, { clrs: [] });

// pass the converted-to-JSON response back to Elm
var filt = [];

// send and receive through ports
lc.ports.yamlReq.subscribe(function(s) {
    if (s !== "") {
        var payload = jsyaml.safeLoad(s);
        for(var language in payload) {
            var kname = language; // JSON.stringify(language);
            filt.push([kname, payload[language].color]);
        }
        // debugging
        console.log(filt);
        lc.ports.clrs.send(filt);
        // lc.ports.clrs.send(payload);
    }
});

