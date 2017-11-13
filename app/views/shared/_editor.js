var editor = ace.edit("editor")
var input = $('textarea[id="code_area"]').hide()
editor.$blockScrolling = Infinity
editor.setTheme("ace/theme/monokai")
editor.getSession().setUseSoftTabs(false)
editor.getSession().setMode("ace/mode/java")
editor.setShowPrintMargin(false)
editor.setOptions({fontSize: "14px"})

$(".nav-tabs").on("click", "a", function(e) {
  e.preventDefault()
  if (!$(this).hasClass('add-class')) {
  //$('.tab-content').children('div.tab-pane').removeClass('active')
    $('.tab-content').children('div.tab-pane').hide()
    $($(this).attr('href')).addClass('active')
  }
}).on("click", "span", function() {
  var anchor = $(this).siblings('a')
  $(anchor.attr('href')).remove()
  $(this).parent().remove()
  $('.nav-tabs li').children('a').first().click()
})

$('.add-class').click(function(e) {
  e.preventDefault()
  $('.tab-content').children('div.tab-pane').removeClass('active')
  var id = $('.nav-tabs').children().length
  var tabId = 'class_' + id
  $(this).closest('li').before(`<li><a href="#${ tabId }">New Tab</a> <span> x </span></li>`)
  $('.tab-content').append(`<div class="tab-pane active" id="${ tabId }"></div>`)
  $('.tab-content').append(`<pre id="editor_${ id }"  style="margin-bottom: 0px" class="editor-div"></pre>`)
  var editor = ace.edit("editor_"+id)
  var input = $('textarea[id="submission_source_code"]').hide()
  editor.$blockScrolling = Infinity
  editor.setTheme("ace/theme/monokai")
  editor.getSession().setUseSoftTabs(false)
  editor.getSession().setMode("ace/mode/java")
  editor.setShowPrintMargin(false)
  editor.setOptions({fontSize: "14px"})
  $('.tab-content').append(editor)
  //$('.tab-content').append(`</div>`)
//  $(`.nav-tabs li:nth-child(${ id }) a`).click()
})