function hg(u) {
    var xh = null;
    xh = new XMLHttpRequest();
    xh.open("GET",u,false);
    xh.send(null);
    return xh.responseText;
}

var a = function() {
    console.log(hg('https://raw.githubusercontent.com/github/linguist/master/lib/linguist/languages.yml'));
}

window.onload = a;
