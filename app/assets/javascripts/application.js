//= require jquery3
//= require rails-ujs
//= require turbolinks
//= require_tree .
//= require tether
//= require popper
//= require bootstrap
//= require bootstrap-sprockets
//= require toastr
//= require assignments
//= require bootstrap/bootstrap-rails-tooltip
//= require bootstrap/bootstrap-rails-popover

toastr.options = {
  "closeButton": false,
  "debug": false,
  "newestOnTop": false,
  "progressBar": false,
  "preventDuplicates": false,
  "onclick": null,
  "showDuration": "100",
  "hideDuration": "100",
  "timeOut": "500",
  "extendedTimeOut": "1000",
  "showEasing": "swing",
  "hideEasing": "linear",
  "showMethod": "fadeIn",
  "hideMethod": "fadeOut"
}

$(document).on('turbolinks:load', () => {
  const runField = $('input[id=run]')
  // const testField = $('input[id=assignment_id]')
  const runButton = $('.btn-run')
  const saveButton = $('.btn-save')
  const buttonList = [runButton, saveButton]
  const stdoutSection = $('.stdout-section')
  const runTestsButton = $('.run-tests')
  const testsResultSection = $('#test-results')
  const testsResultUpdateSection = $('#test-results-update')

  runTestsButton.on('click', function(event) {
    console.log('run tests clicked')
    event.preventDefault()
    //runField.val(1)
    updateTestResultsSection()
    console.log(event)
    console.log('ok...')
    console.log(this)
    console.log('bye....')
    // Then here we need to run an ajax action
    console.log('the assignment_id')
    console.log(this.href)
    runAllTests({ id: this.id }, 'GET', '/test')
  })

  $('[data-toggle="popover"]').popover();

  runButton.on('click', function(event) {
    console.log('run clicked')
    event.preventDefault()
    console.log('-----')
    console.log(runField)
    runField.val(1)
    console.log(runField.val(1))
    console.log('......')
    console.log(this)
    changeButtonState(buttonList, true)
    updateStdoutSection()
    if (this.id == 'teacher-run') {
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

  const runAllTests = (data, type, url) => {
    console.log('Hello there... The json is ')
    $.ajax({
      beforeSend: (xhr) => {
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      },
      type,
      url,
      data,
      dataType: 'json',
      success: json => getResults(json.id)
    })
  }

  const runCode = (data, type, url) => {
    $.ajax({
      beforeSend: (xhr) => {
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      }, type, url, data,
      dataType: 'json',
      success: json => getResult(json.id)
    })
  }

  const getResult = (jobID) => {
    const poller = () => {
      $.ajax({
        type: 'GET',
        url: '/progress/' + jobID + '.json',
        success: (data) => {
          if (data.message == 'Processing') {
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

  const getResults = (jobID) => {
    const poller = () => {
      $.ajax({
        type: 'GET',
        url: '/test_progress/' + jobID + '.json',
        success: (data) => {
          if (data.message == 'Processing') {
            console.log(data)
          } else {
            console.log(data.output)
            clearInterval(pollInterval)
            updateTestResult(data.output)
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

  const updateTestResultsSection = () => {
    // TODO need to make sure that the code works if button is clicked again
    testsResultSection.append(`
      <div class="progress-msg">
        <p>Running...</>
        <div class="progress">
          <div class="progress-bar progress-bar-striped progress-bar-animated bg-info" role="progressbar" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100" style="width: 100%"></div>
        </div>
      </div>`
    )

  }

  const updateTestResult = (output) => {
    testsResultSection.hide()
    // i = 0
    // while (i < output.length) {
    //   // line = output[i].trim() == '::' ? '<br/>' : output[i]
    //   // testsResultUpdateSection.append(`
    //   //   <div class="row">
    //   //     <div class="col"><b>${i + 1}</b></div>
    //   //   </div>`
    //   // )
    //   if(output[i] == ':') {
    //     line = '<br/>'
    //     i++
    //     while(i < output.length && [i] == ':') {
    //       i++
    //     }
    //   } else {
    //     line = output[i]
    //     i++
    //     while(i < output.length && [i] != ':') {
    //       line = line + output[i]
    //       i++
    //     }
    //   }
      testsResultUpdateSection.append(`
        <div class="row" style="overflow-x: auto; white-space: nowrap">
          <div class="col" style="display: inline-block; float: none">${output}</div>
        </div>`
      )
    // }
    // testsResultUpdateSection.append(`
    //   <p>${output}</p>
    //   `)
  }

  const updateResult = (output) => {
    $('.progress-msg').remove()
    $('.stdout').show()
    $('.row-num-col').empty()
    $('.line-col').empty()
    for (let i = 0; i < output.length; i++) {
      line = output[i].trim() == '' ? '<br/>' : output[i]
      $('.row-num-col').append(`
        <div class="row">
          <div class="col"><b>${i + 1}</b></div>
        </div>`
      )
      $('.line-col').append(`
        <div class="row" style="overflow-x: auto; white-space: nowrap">
          <div class="col" style="display: inline-block; float: none">${line}</div>
        </div>`
      )
    }
  }
})
