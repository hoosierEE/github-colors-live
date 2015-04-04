// app
var lc = Elm.fullscreen(Elm.LiveColor, { clrs: {} });
// pass the converted-to-JSON response back to Elm

var payload = {};
lc.ports.yamlReq.subscribe(function(s) {
    if (s !== "") {
        payload = jsyaml.safeLoad(s);
    }
    lc.ports.clrs.send(payload);
});

