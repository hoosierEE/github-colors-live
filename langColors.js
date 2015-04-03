function hg(aUrl) {
    var xh = null;
    xh = new XMLHttpRequest();
    xh.open("GET",aUrl,false);
    xh.send(null);
    return xh.responseText;
}
var yml = "https://rawgit.com/github/linguist/master/lib/linguist/languages.yml";
var langs = jsyaml.safeLoad(hg(yml));
var a = function() { console.log(langs); }
window.onload = a;

