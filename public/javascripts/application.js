// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var pos = 0;
function newpos() {
    var n = $('tbody.template tr').clone();
    $(n).find('.number').val(pos);
    $(n).find('input, textarea, select').each(function(i) {
        var old = $(this).attr('name');
        $(this).attr('name', old.replace(/0/, pos));

    });
    $('tbody.positions').append(n);
    ++pos;
}
