/*!
 * Textcount
 *
 * Copyright (c) Chris Casciano
 */

/*
 * Textcount is a jQuery plugin that attaches text counters and max
 * character count limits on text input fields or textareas. It can
 * be configured to ignore HTML markup in its character counts
 *
 * Authors        Chris Casciano
 */

 /*
  * TODO:
  * # warn if over visible limit (c w/ ignore html > max-visible)
  * # warn if HTML parsing errors (length > 0 but c = 0) - does this work?
  *     perhaps make sure < and > count are equal is enough?
  * # store $hint so we don't break things if its removed elsewhere
*/

(function($) {
  'use strict';
  $.fn.textcount = function(o){
    //o = $.extend({}, $.fn.textcount.defaults, o);

    return this.each(function(i, el){
      var $el = $(el),
          $next = $(el).next(),
          $hint,
          maxLength = $el.attr('maxlength'),
          maxVisible = $el.data('tc-max-visible'),
          //ignoreHtml = $el.data('tc-ignore-html'),
          c,
          err = false;

      // STEP 1: Draw hint box
      if ($next && $next.is('.tc-hint')) {
        $hint = $next;
      } else {
        $hint = $('<span class="tc-hint">HINT!</span>').insertAfter($el);
      }

      // STEP 2: Determine type of counting
      // STEP 3: Do initial field evaluation
      if ($el.data('tc-ignore-html')) {
        c = $('<div>'+$el.val()+'</div>').text().length;
      } else {
        c = $el.val().length;
      }


      if (maxLength) {
        // counting characters w/ limit
        $hint.html((maxLength - c) + ' total characters left of ' + maxLength);
      } else if (maxVisible && $el.data('tc-ignore-html')) {
        // counting non-html characters w/ limit
        $hint.html((maxVisible - c) + ' visible characters left of ' + maxVisible);

        if (maxVisible - c < 0) {
          err = true;
        }
      } else if ($el.data('tc-ignore-html')) {
        // relaying non-html character count
        $hint.html(c + ' visible characters');
      } else {
        // relaying character count
        $hint.html(c + ' total characters');
      }


      // check for markup errors
      if ($el.data('tc-ignore-html')) {
        if (($el.val().match(/</g)||[]).length != ($el.val().match(/>/g)||[]).length) {
          err = true;
        }
      }


      if (err) {
        $hint.addClass('tc-error');
      } else {
        $hint.removeClass('tc-error');
      }


      // STEP 4: Watch for changes
      $el.keyup(function(e){
        var $el = $(this),
            $hint = $el.next('.tc-hint'),
            maxLength = $el.attr('maxlength'),
            maxVisible = $el.data('tc-max-visible'),
            c,
            err = false;

        if ($el.data('tc-ignore-html')) {
          c = $('<div>'+$el.val()+'</div>').text().length;
        } else {
          c = $el.val().length;
        }

        if (maxLength) {
          // counting characters w/ limit
          $hint.html((maxLength - c) + ' total characters left of ' + maxLength);
        } else if (maxVisible && $el.data('tc-ignore-html')) {
          // counting non-html characters w/ limit
          $hint.html((maxVisible - c) + ' visible characters left of ' + maxVisible);
          if (maxVisible - c < 0) {
            err = true;
          }

        } else if ($el.data('tc-ignore-html')) {
          // relaying non-html character count
          $hint.html(c + ' visible characters');
        } else {
          // relaying character count
          $hint.html(c + ' total characters');
        }

        // check for markup errors
        if ($el.data('tc-ignore-html')) {
          if (($el.val().match(/</g)||[]).length != ($el.val().match(/>/g)||[]).length) {
            err = true;
          }
        }


        if (err) {
          $hint.addClass('tc-error');
        } else {
          $hint.removeClass('tc-error');
        }

      });


    });
  }
}(jQuery));