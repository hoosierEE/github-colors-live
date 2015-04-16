// app
var lc = Elm.fullscreen(Elm.LiveColor, { clrs: [] });


lc.ports.yamlTrig.subscribe(function(s) {
    var filt = [];
    if (s !== "") {
        var payload = jsyaml.safeLoad(s);
        for(var language in payload) {
            var justColor = payload[language].color;
            if (typeof justColor === "undefined") {
                justColor = "#ccc";
            }
            var thisEntry = [language, justColor];
            filt.push(thisEntry);
        }
        // console.log(filt);
        lc.ports.clrs.send(JSON.parse(JSON.stringify(filt)));
    }
});

