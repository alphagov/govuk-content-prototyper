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

  // image substitution for images loaded from integration in the source
  // these images might not exist, so fall back to a local copy
  var $images = $('.image.embedded').find('img');
  $images.each(function () {
    var src = $(this).attr('src')
    if (src.indexOf('https://assets.integration.publishing.service.gov.uk') !== -1) {
      var imagefile = src.split('/')
      imagefile = imagefile[imagefile.length - 1]
      $(this).attr('src', '/assets/dfe_images/integration/' + imagefile)
    }
  })
});
