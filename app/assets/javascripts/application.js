//= require jquery3
//= require rails-ujs
//= require turbolinks
//= require_tree .
//= require tether
//= require popper
//= require cable
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
  var numEnrolledStudents = 0;
  var averageScore = 0;
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
  const toggleAnnouncementForm = $('#toggle-announcement-form-link')
  const runLastButton = $('.button-last-row-run')
  const hideLastButton = $('.button-last-row-hide')
  const togglePreviousAnnouncements = $('#toggle-previous-announcements-link')

  togglePreviousAnnouncements.on('click', function(event) {
    var elem = $('#toggle-previous-announcements');
    if(elem.hasClass('ion-chevron-down')) {
      $('#previous-announcemnets').slideDown();
      elem.removeClass('ion-chevron-down').addClass('ion-chevron-up');
    } else {
      $('#previous-announcemnets').slideUp();
      elem.removeClass('ion-chevron-up').addClass('ion-chevron-down');
    }
  })

  runLastButton.on('click', function(event) {
    //remove round edges
    console.log('button was clicked!');
    document.getElementById('last-row').style.borderRadius = "0px 0px 0px 0px";
  })

  hideLastButton.on('click', function(event) {
    //add round edges
    document.getElementById('last-row').style.borderRadius = "0px 0px 15px 15px";
  })

  toggleAnnouncementForm.on('click', function(event) {
    console.log('Toggle announcement form');
    var elem = $('#toggle-announcement-form');
    if(elem.hasClass('ion-chevron-down')) {
      $('#announcement-form').slideDown();
      elem.removeClass('ion-chevron-down').addClass('ion-chevron-up');
    } else {
      $('#announcement-form').slideUp();
      elem.removeClass('ion-chevron-up').addClass('ion-chevron-down');
    }
  })

  exportSubmissionGrades.on('click', function(event) {
    console.log('exporting graded submissions...');

    // var text = document.getElementById('report-'+this.name+'-body').innerHTML;
    // console.log('Text to import: ' + text);
    // console.log('The length is: ' + text.length);
    // var splittedText = text.split("<br>");
    // console.log('array: ' + splittedText);
    // console.log('1: ' + splittedText[0]);
    // console.log('2: ' + splittedText[1]);
    // console.log('3: ' + splittedText[2]);
    // console.log('4: ' + splittedText[3]);
    // console.log('5: ' + splittedText[4]);
    // if (splittedText.length > 2) {
    //   console.log('Exporting submissions as CSV file...');
    //
    // } else {
    //   console.log('There are no submissions to export...');
    // }
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

  const getTestsValues = (id, data, type, url) => {
    $.ajax({
      beforeSend: (xhr) => {
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      }, type, url, data,
      dataType: 'json',
      success: json => updateTestValues(id, json.enrolled, json.average)
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
            getGrades(id, {id: id}, 'GET', '/grades')
            getTestsValues(id, {id: id}, 'GET', '/stats')
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
  }

  const updateTestResult = (id, output) => {
    var result = getStatistics(output);
    var numSubmissions = result[0];
    var correctSubmissions = result[1];
    console.log('getStatistics() result: ' + numSubmissions + ', ' + correctSubmissions);
    document.getElementById('report-'+id+'-body').innerHTML = `
      <br>
      <div class="row">
        <div class="col-4" style="text-align: center;">
          <h1><span id="submissions-${id}">${numSubmissions}</span></h1>
        </div>
        <div class="col-4" style="text-align: center;">
          <h1><span id="enrolled-${id}">-</span></h1>
        </div>
        <div class="col-4" style="text-align: center;">
          <h1><span id="av-score-${id}">-</span></h1>
        </div>
      </div>
      <div class="row">
        <div class="col-4" style="text-align: center;">
          <h3>Submissions</h3>
        </div>
        <div class="col-4" style="text-align: center;">
          <h3>Enrolled Students</h3>
        </div>
        <div class="col-4" style="text-align: center;">
          <h3>Average Score</h3>
        </div>
      </div>

      <div class="row" style="overflow-x: auto; white-space: nowrap">
        <div class="col" style="display: inline-block; float: none">${output}</div>
      </div>`
  }

  //
  const getGrades = (id, data, type, url) => {
    $.ajax({
      beforeSend: (xhr) => {
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      }, type, url, data,
      dataType: 'json',
      success: json => updateGraph(id, json.names, json.grades)
    })
  }

  const updateGraph = (id, names, grades) => {
    console.log('Output names: ' + names)
    // TODO need to make an AJAX call and get the list of grades and the list of names
    console.log('Output grades: ' + grades)
    $('#graph-'+id).replaceWith('<canvas id="graph-' + id + '" width="300" height="300"></canvas>');
    var ctx = document.getElementById('graph-'+id).getContext('2d');
    var myChart = new Chart(ctx, {
      type: 'line',
      data: {
          labels: names,
          datasets: [{
              label: 'Student Performance',
              data: grades,
              borderColor: [
                  'rgba(255,99,132,1)'
              ],
              borderWidth: 3
          }]
      },
      options: {
          legend: {
            labels: {
              fontColor: "white",
              fontSize: 16,
              backgroundColor: "rgb(34, 119, 221)"
            }
          },
          scales: {
              yAxes: [{
                  ticks: {
                      beginAtZero:true,
                      fontColor: "#FFFFFF"
                  },
                  gridLines: {
                      color: "#cfcfcf"
                  }
              }],
              xAxes: [{
                  ticks: {
                    display: false
                  },
                  gridLines: {
                      color: "#cfcfcf"
                  }
              }]
          }
      }
    });
  }

  const updateTestValues = (id, enrolled, average) => {
    document.getElementById('enrolled-'+id).innerHTML = `${enrolled}`
    document.getElementById('av-score-'+id).innerHTML = `${average}`
  }

  const updateResult = (output) => {
    $('.progress-msg').remove()
    $('.stdout').show()
    $('.row-num-col').empty()
    $('.line-col').empty()
    console.log(output)
    let lineNum = 1
    for (let i = 0; i < output.length; i++) {
      if (output[i].trim() === 'Picked up JAVA_TOOL_OPTIONS: -Xmx300m -Xss512k -Dfile.encoding=UTF-8') {
        console.log('equal')
        continue
      }
        
      line = output[i].trim() == '' ? '<br/>' : output[i]
      $('.row-num-col').append(`
        <div class="row">
          <div class="col"><b>${lineNum++}</b></div>
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
