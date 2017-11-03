// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require rails-ujs
//= require turbolinks
//= require_tree .
//= require tether
//= require popper
//= require bootstrap-sprockets
//= require toastr

toastr.options = {
  "closeButton": false,
  "debug": false,
  "newestOnTop": false,
  "progressBar": false,
  "preventDuplicates": false,
  "onclick": null,
  "showDuration": "1000",
  "hideDuration": "1000",
  "timeOut": "2500",
  "extendedTimeOut": "1000",
  "showEasing": "swing",
  "hideEasing": "linear",
  "showMethod": "fadeIn",
  "hideMethod": "fadeOut"
}

document.addEventListener("turbolinks:load", () => {
  const runField = $('input[id=run]')
  const runButton = $('.btn-run')
  const saveButton = $('.btn-save')
  const buttonList = [runButton, saveButton]
  const stdoutSection = $('.stdout-section')

  runButton.on('click', function(event) {
    console.log('run clicked')
    event.preventDefault()
    runField.val(1)
    changeButtonState(buttonList, true)
    updateStdoutSection()
    if (this.id == "teacher-run") {
      runCode({ id: this.name }, 'POST', '/run.json')
    } else {
      runCode($('form.edit_submission').serialize(), 'PATCH', '/save.json')
    }
  })

  saveButton.on('click', (event) => {
    console.log('save clicked')
    runField.val(0)
  })

  const changeButtonState = (buttonList, bool) => {
    buttonList.forEach(button => button.prop('disabled', bool))
  }

  const runCode = (data, type, url) => {
    $.ajax({
      beforeSend: (xhr) => {
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      }, type, url, data,
      dataType: 'json',
      success: (json) => { getResult(json.id) }
    })
  }

  const getResult = (jobID) => {
    const poller = () => {
      $.ajax({
        type: 'GET',
        url: '/progress/' + jobID + '.json',
        success: (data) => {
          if (data.message == "Processing") {
            console.log(data)
          } else {
            console.log(data.output)
            clearInterval(pollInterval)
            changeButtonState(buttonList, false)
            updateResult(data.output)
            return false
          }
        }
      })
    }
    var pollInterval = setInterval(() => poller(), 2000)
    poller()
  }

  const updateStdoutSection = () => {
    $('.empty-msg').remove()
    $('.stdout').hide()
    stdoutSection.append(`
      <div class="progress-msg">
        <p>Running...</>
        <div class="progress">
          <div class="progress-bar progress-bar-striped progress-bar-animated bg-info" role="progressbar" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100" style="width: 100%"></div>
        </div>
      </div>`
    )
  }

  const updateResult = (output) => {
    $('.progress-msg').remove()
    $('.stdout').show()
    $('.row-num-col').empty()
    $('.line-col').empty()
    for (let i = 0; i < output.length; i++) {
      line = output[i]
      $('.row-num-col').append(`
        <div class="row">
          <div class="col"><b>${i + 1}</b></div>
        </div>`
      )
      if (line.trim() == "") line = '<br/>'
      $('.line-col').append(`
        <div class="row" style="overflow-x: auto; white-space: nowrap">
          <div class="col" style="display: inline-block; float: none">${line}</div>
        </div>`
      )
    }
  }
})