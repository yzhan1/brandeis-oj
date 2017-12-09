$(document).on('turbolinks:load', () => {
  let assignmentId = $('#assignment-id').data('assignment-id');
  App.messages = App.cable.subscriptions.create(
    {
      channel: 'SubmissionsChannel',
      assignment: assignmentId
    }, 
    {
      connected: () => {
        console.log(`connected to submissions channel with assignment id = ${ assignmentId }`);
      },
    
      received: submission => {
        console.log(submission);
        console.log(`#submission-table-${ submission.assignment_id }`);
        let grade = submission.grade ? grade : '---';
        $(`#submission-table-${ submission.assignment_id }`).append(`
          <tr>
            <td>${ submission.from }</td>
            <td>${ submission.date }</td>
            <td><a href="${ submission.link }" class="btn btn-outline-primary btn-sm">Show</a></td>
            <td>${ grade }</td>
          </tr>`
        );
      }
    }
  );
});