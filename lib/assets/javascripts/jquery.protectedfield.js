/*!
 * Protected Field
 *
 * Copyright (c) Chris Casciano
 */

/*
 * Protected Field is a jQuery plugin that attaches a lock
 * to fields that you want protected
 *
 * Authors        Chris Casciano
 */

 /*
  * TODO:
  * #
*/

(function($) {
  'use strict';
  $.fn.protectedfield = function(o){

    return this.each(function(i, el){
      var $el = $(el),
          $icon = $('<i class="icon-lock pf-trigger" title="unlock field"></i>'),
          confirmation = 'Are you sure you want to edit this field?',
          $trigger;

      if (!$el.next().is('.pf-trigger')) {
        // STEP 1: set protected field to disabled
        $el.attr('disabled','disabled');
        // STEP 2: draw lock icon
        $el.after($icon);
        $trigger = $el.next();
        // STEP 3: attach click events

        $trigger.on('click',function(e) {
          if (confirm(confirmation)) {
            $el.removeAttr('disabled');
          }
        });
      }
    });
  }
}(jQuery));
