var timeoutId

function autosave() {
  $.ajax({
    type: 'PATCH',
    url: '/autosave',
    data: $('form').serialize(),
    dataType: 'script',
    success: data => $('#notification').html(`<div class="alert alert-success autosave-indicator" role="alert">Changes saved</div>`)
  })
}

editor.getSession().on('change', () => {
  $('#notification').html(`<div class="alert alert-warning autosave-indicator" role="alert">Save pending...</div>`)
  if (timeoutId) clearTimeout(timeoutId)
  timeoutId = setTimeout(() => autosave(), 3500)
})