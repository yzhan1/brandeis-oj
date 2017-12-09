$(document).on('turbolinks:load', () => {
  $('select[id=assignment_lang]').on('change', function() {
    editor.getSession().setMode(`ace/mode/${this.value}`);
  });
});