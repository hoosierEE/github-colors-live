// app
var lc = Elm.fullscreen(Elm.LiveColor, { clrs: [] });

// send and receive through ports
lc.ports.yamlReq.subscribe(function(s) {
    var filt = [];
    if (s !== "") {
        var payload = jsyaml.safeLoad(s);
        for(var language in payload) {
            var thisEntry = [language, payload[language].color];
            filt.push(thisEntry);
        }
        // console.log(filt);
        lc.ports.clrs.send(JSON.parse(JSON.stringify(filt)));
    }
});

