
// array with default test values
// var filt = [["later","alligator"],["while","crocodile"]];

// app
var lc = Elm.fullscreen(Elm.LiveColor, { clrs: [["hi","world"]] });


// send and receive through ports
lc.ports.yamlReq.subscribe(function(s) {
    var filt = [];
    if (s !== "") {
        var payload = jsyaml.safeLoad(s);
        for(var language in payload) {
            var thisEntry = [language, payload[language].color];
            filt.push(thisEntry);
        }
        // debugging
        // console.log(filt);
        lc.ports.clrs.send(filt); // expecting a string but was given [["foo","bar"],["baz", ... (prints whole array)
        //lc.ports.clrs.send("hi"); // expecting an array but was given "hi"
    }
});


