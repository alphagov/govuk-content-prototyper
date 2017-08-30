function SubsectionView ($subsectionElement) {
  var that = this;

  // The 'Content' is the container of links to guides
  this.$subsectionContent = $subsectionElement.find('.js-subsection-content');
  // The 'Button' is a button element that is wrapped around the title for
  // accessibility reasons
  this.$subsectionButton = $subsectionElement.find('.js-subsection-button');

  this.title = that.$subsectionButton.text();

  this.toggle = function () {
    if (that.isClosed()) {
      that.open();
    } else {
      that.close();
    }
  }

  this.open = function () {
    // Show the subsection content
    that.$subsectionContent.removeClass('js-hidden');
    // Swap the plus and minus sign
    $subsectionElement.removeClass('subsection');
    $subsectionElement.addClass('subsection--is-open');
    // Tell impaired users that the section is open
    that.$subsectionButton.attr("aria-expanded", "true");
  }

  this.close = function () {
    // Hide the subsection content
    that.$subsectionContent.addClass('js-hidden');
    // Swap the plus and minus sign
    $subsectionElement.removeClass('subsection--is-open');
    $subsectionElement.addClass('subsection');
    // Tell impaired users that the section is closed
    that.$subsectionButton.attr("aria-expanded", "false");
  }

  this.isClosed = function () {
    return that.$subsectionContent.hasClass('js-hidden');
  }
}
