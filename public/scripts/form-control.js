/* form-control.js */
$('.form-control').each(function () {
  var form = $(this);
  form.submit(function (event) {
    if (!form[0].checkValidity()) {
      event.preventDefault();
      event.stopPropagation();
      form.addClass('has-error');
    }
  });
});