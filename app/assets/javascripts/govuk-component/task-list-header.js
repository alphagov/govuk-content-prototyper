function makeSticky() {
  var stickyNavOffset;
  var resizeTimer;

  var $stickyWrap = $('<div/>').addClass('sticky-wrapper');
  var $stickyInner = $('<div/>').addClass('sticky-inner');
  var $header = $('.gem-c-task-list-header');
  $header.wrap($stickyWrap);
  $header.wrapInner($stickyInner);

  setStickyOffset();
  setStickyWrapHeight();

  $(window).scroll(function() {
    $header.toggleClass("sticky", $(window).scrollTop() >= stickyNavOffset);
  });

  $(window).resize(function() {
    clearTimeout(resizeTimer);
    resizeTimer = setTimeout(resize,400);
  });

  function resize() {
    setStickyOffset();
    setStickyWrapHeight();
  }

  function setStickyOffset() {
    stickyNavOffset = $header.parent().offset().top;
  }

  function setStickyWrapHeight() {
    $header.parent().height($header.outerHeight());
  }
}

$(document).ready(function() {
  makeSticky();
});
/* original, proper version as a GOV.UK module...
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
*/
