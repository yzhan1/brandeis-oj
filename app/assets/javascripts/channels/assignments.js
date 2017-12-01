App.messages = App.cable.subscriptions.create('AssignmentsChannel', {
  connected: () => {
    console.log('connected to assignment channel');
  },

  received: (assignment) => {
    console.log(assignment);
    $('#assignment-list').append(`
      <div class="row better-row" style="padding-top: 25px; padding-bottom: 25px; background-color: rgb(242, 242, 242)">
        <div class="col-6">
          <a href="${ assignment.link }">${ assignment.name }</a>
        </div>
        <div class="col-3">
          ${ assignment.due_date }
        </div>
        <div class="col-3">
          <a href="${ assignment.link }" class="btn btn-outline-primary btn-sm">Show</a>
        </div>
      </div>`
    );
  }
});