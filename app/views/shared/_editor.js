var editor = ace.edit("editor")
editor.$blockScrolling = Infinity
editor.setTheme("ace/theme/monokai")
editor.getSession().setUseSoftTabs(false)
editor.getSession().setMode("ace/mode/java")
editor.setShowPrintMargin(false)
editor.setOptions({fontSize: "14px"})

var temp_id = 20

$(".nav-tabs").on("click", "a", function(e) {
  e.preventDefault()
  if (!$(this).hasClass('add-class')) {
    $('a').removeClass('active');
    $(this).addClass('active');
  }
}).on("click", "span", function() {
  var anchor = $(this).siblings('a')
  $(anchor.attr('href')).remove()
  $(this).parent().remove()
  console.log()
  $('.nav-tabs li').children('a').first().click()
  $(this).addClass('active');
})

$('.add-class').click(function(e) {
  e.preventDefault()
  $('a').removeClass('active')
  $('div').removeClass('active')
  var id = temp_id++
  var tabId = 'class_' + id
  var tabName = document.getElementById('file_name_input').value
  var submissionId = document.getElementById('submission_id').value

  $('.nav-tabs').append(`<li class="nav-item"><a id="tab_${ tabId }" class="nav-link active" href="#${ tabId }" data-toggle="tab">${tabName}</a> <span> x </span></li>`)
  $('.tab-content').append(`<div class="tab-pane active" id="${ tabId }"><pre id="editor_${ id }"  style="margin-bottom: 0px" class="editor-div"></pre></div>`)
  var editor = ace.edit("editor_"+id)
  editor.$blockScrolling = Infinity
  editor.setTheme("ace/theme/monokai")
  editor.getSession().setUseSoftTabs(false)
  editor.getSession().setMode("ace/mode/java")
  editor.setShowPrintMargin(false)
  editor.setOptions({fontSize: "14px"})
  $('.tab-content').append(editor)
  document.getElementById("tab_"+tabId).click()
  document.getElementById('file_name_input').value=''
  $('#create_tab_button').attr('disabled',true);
  $.ajax({
    type: 'POST',
    url: '/new_code',
    data: {filename: tabName, submission_id: submissionId}
  })
})

$('.delete-file').click(function(e) {
  e.preventDefault()
  var fileName = $(this).attr("value");
  var submissionId = document.getElementById('submission_id').value
  $.ajax({
    type: 'POST',
    url: '/delete_code',
    data: {filename: fileName, submission_id: submissionId}
  })
  //Delete from page
  $(this).parent('.row').remove();
})
