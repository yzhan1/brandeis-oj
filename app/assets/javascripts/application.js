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

$('document').ready(function() {
  var runField = $('input[id=run]');
  var jobID;

  $('.btn-run').on('click', function(event) {
    console.log('run clicked');
    runField.val(1);
    event.preventDefault();
    runCode();
  });

  $('.btn-save').on('click', function(event) {
    console.log('save clicked');
    runField.val(0);
  });

  function runCode() {
    $.ajax({
      beforeSend: function(xhr) {
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      },
      type: 'PATCH',
      url: '/save.json',
      data: $('form.edit_submission').serialize(),
      dataType: 'json',
      success: function(json) {
        setTimeout(getResult(json.id), 20000);
      }
    });
  }

  function getResult(jobID) {
    $.ajax({
      type: 'GET',
      url: '/progress/' + jobID + '.json',
      success: function(data) {
        console.log(data);
        if (data.message == "Processing") {
          console.log(data);
        } else {
          console.log(data.output);
          return false;
        }
        setInterval(getResult(jobID), 20000);
      }
    });
  }
});