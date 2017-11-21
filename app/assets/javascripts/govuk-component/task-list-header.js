(function (Modules) {
  "use strict";
  window.GOVUK = window.GOVUK || {};

  Modules.Tasklistheader = function () {
    var stickyNavOffset;
    var resizeTimer;

    this.start = function ($element) {
      var $stickyNav = $element.find(".pub-c-task-list-header");

      setStickyOffset($element);
      setStickyWrapHeight($element);

      $(window).scroll(function() {
        $stickyNav.toggleClass("sticky", $(window).scrollTop() >= stickyNavOffset);
      });

      $(window).resize(function() {
        clearTimeout(resizeTimer);
        resizeTimer = setTimeout(resize,400);
      });

      function resize() {
        setStickyOffset($element);
        setStickyWrapHeight($element);
      }

      function setStickyOffset() {
        stickyNavOffset = $element.offset().top;
      }

      function setStickyWrapHeight() {
        $element.height($stickyNav.outerHeight());
      }
    }
  };
})(window.GOVUK.Modules);
