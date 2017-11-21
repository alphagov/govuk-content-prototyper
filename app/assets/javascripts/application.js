//= require support
//= require browse-columns
//= require slidy-up
//= require subsection-view
//= require accordion-with-descriptions
//= require govuk-component/tasklist
//= require govuk-component/task-list-header

GOVUK.slidyNav.init()

$(document).ready(function() {
  $('#logo').attr('href', 'https://govuk-services-prototype.herokuapp.com');
});
