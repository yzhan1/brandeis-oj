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
  "timeOut": "1500",
  "extendedTimeOut": "1000",
  "showEasing": "swing",
  "hideEasing": "linear",
  "showMethod": "fadeIn",
  "hideMethod": "fadeOut"
}

function getStatistics(output) {
  var splitted = output.split("<br/>");
  var result = "l1: " + splitted.length;
  var numSubmissions = null;
  var correctSubmissions = 0;
  console.log('arr: ' + splitted + '\n' + 'res: ' + result);
  if (splitted.length <= 2) {
    numSubmissions = 0;
    return [0, 0];
  } else {
    splitted = splitted.slice(1,splitted.length-1);
    numSubmissions = splitted.length;
    var curr = null;
    for(let i = 0; i < splitted.length; i++) {
      curr = splitted[i].split(": ");
      console.log(curr);
      console.log('XXX: '+curr[1].slice(length-(""+numSubmissions).length - 2));
      console.log('YYY: '+("/"+numSubmissions));
      if (curr.length >= 2 && curr[1].length > (""+numSubmissions).length + 1 && (curr[1].slice(curr[1].length-(""+numSubmissions).length - 2)+'') == ("/"+numSubmissions)) {
        correctSubmissions++;
      }
    }
    return [numSubmissions, correctSubmissions];
  }
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
  const hideReportSection = $('.hide-report')
  const exportSubmissionGrades = $('.download-report')

  exportSubmissionGrades.on('click', function(event) {
    console.log('exporting graded submissions');

    var text = document.getElementById('report-'+this.name+'-body').innerHTML;
    console.log('Text to import: ' + text);
    console.log('The length is: ' + text.length);
    var splittedText = text.split("<br>");
    console.log('array: ' + splittedText);
    console.log('1: ' + splittedText[0]);
    console.log('2: ' + splittedText[1]);
    console.log('3: ' + splittedText[2]);
    console.log('4: ' + splittedText[3]);
    console.log('5: ' + splittedText[4]);
    if (splittedText.length > 2) {
      console.log('Exporting submissions as CSV file...');

    } else {
      console.log('There are no submissions to export...');
    }
  })

  hideReportSection.on('click', function(event) {
    console.log('hidding report section');
    // document.getElementById('report-'+this.name).style.display = 'none';
    // document.getElementById('report-'+this.name).slideUp()
    $('#report-'+this.name).slideUp();
  })

  runTestsButton.on('click', function(event) {
    console.log('run tests clicked')
    event.preventDefault()
    //runField.val(1)
    updateTestResultsSection(this.id)
    console.log(event)
    console.log('ok...')
    console.log(this)
    console.log('bye....')
    // Then here we need to run an ajax action
    console.log('the assignment_id')
    console.log(this.href)
    // need to show the hidden td
    console.log('Trying to change style: report-' + this.id)

    runAllTests(this.id, { id: this.id }, 'GET', '/test')
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

  const runAllTests = (id, data, type, url) => {
    console.log('Hello there... The json is ')
    $.ajax({
      beforeSend: (xhr) => {
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      },
      type,
      url,
      data,
      dataType: 'json',
      success: json => getResults(id, json.id)
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

  const getResults = (id, jobID) => {
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
            updateTestResult(id, data.output)
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

  const updateTestResultsSection = (id) => {
    // var section = document.getElementById('report-'+id);
    // document.getElementById('report-'+id).style.display = '';
    // section.style.display = '';
    $('#report-'+id).slideDown();
    // TODO need to make sure that the code works if button is clicked again
    document.getElementById('report-'+id+'-body').innerHTML = `
      <br/>
      <div class="progress-msg">
        <p>Running...</>
        <div class="progress">
          <div class="progress-bar progress-bar-striped progress-bar-animated bg-info" role="progressbar" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100" style="width: 100%"></div>
        </div>
      </div>
      <br/>
      `
    // testsResultSection.append(`
    //   <div class="progress-msg">
    //     <p>Running...</>
    //     <div class="progress">
    //       <div class="progress-bar progress-bar-striped progress-bar-animated bg-info" role="progressbar" aria-valuenow="75" aria-valuemin="0" aria-valuemax="100" style="width: 100%"></div>
    //     </div>
    //   </div>`
    // )

  }

  const updateTestResult = (id, output) => {
    // const resultArea = document.getElementById('report-'+id+'-body');
    // resultArea.innerHTML = ``;
    // for (let i = 0; i < output.length; i++) {
    //   console.log('line: ' + output[i]);
    //   line = output[i].trim() == '\n' ? '<br/>' : output[i];
    //   resultArea.append(`<p>${line}</p>`);
    // }
    // TODO here we will extract statistics from resultArea
    var result = getStatistics(output);
    var numSubmissions = result[0];
    var correctSubmissions = result[1];
    console.log('getStatistics() result: ' + numSubmissions + ', ' + correctSubmissions);
    document.getElementById('report-'+id+'-body').innerHTML = `
      <p>Number of submissions: ${numSubmissions}. Correct Submissions: ${correctSubmissions}.</p>
      
      <div class="row" style="overflow-x: auto; white-space: nowrap">
        <div class="col" style="display: inline-block; float: none">${output}</div>
      </div>`


    // testsResultSection.hide()
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
      // testsResultUpdateSection.append(`
      //   <div class="row" style="overflow-x: auto; white-space: nowrap">
      //     <div class="col" style="display: inline-block; float: none">${output}</div>
      //   </div>`
      // )


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
