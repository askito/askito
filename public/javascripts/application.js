// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function adjustTextarea(textarea, collapsed) {
  var lines = textarea.value.split("\n");
  var count = lines.length;
  lines.each(function(line) { count += parseInt(line.length / 70); });

  var rows = parseInt(collapsed / 20);

  if (count > rows) {
    textarea.style.height = (collapsed * 2) + 'px';
  }

  if (count <= rows) {
    textarea.style.height = collapsed + 'px';
  }
}