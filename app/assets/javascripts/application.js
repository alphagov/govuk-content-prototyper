//= require support
//= require browse-columns
//= require slidy-up
//= require subsection-view
//= require accordion-with-descriptions
//= require govuk-component/tasklist
//= require govuk-component/task-list-header
//= require govuk_publishing_components/components/step-by-step-nav

GOVUK.slidyNav.init()

$(document).ready(function() {
  $('#logo').attr('href', 'https://govuk-services-prototype.herokuapp.com');
});
