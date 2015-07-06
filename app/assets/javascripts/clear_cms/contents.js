var ClearCMS = window.ClearCMS || {};

ClearCMS.e = (function() {
  'use strict';

  return {
    FORM_FIELDS_MODIFIED: 'form fields modified'
  };
}());

// Manages the content type metadata / form switching for edit pages
ClearCMS.ContentTypes = (function() {
  'use strict';

  var $typeSelect,
      currentType,
      allType = 'ClearCMS::Content';

  function displayMetaFields(thing) {
    /*jshint -W040 */
    var type = (typeof thing === 'string') ? thing : $(this).val();

    // loop though fieldset.general li and inspect the data('types') array
    // TBD: this may not be the final method of identifying these fields/areas
    $('.general li[data-types]').each(function(i) {

      if ((-1 !== $.inArray(type, $(this).data('types'))) || (-1 !== $.inArray(allType, $(this).data('types')))) {
        $(this).show();
      } else {
        $(this).hide();
      }
    });
  }

  return {
    initialize: function() {
      $typeSelect = $('#content__type');

      // STEP 0: Decide we're on a content edit page
      if ($typeSelect.length) {
        // STEP 1: Grab Types field and current value
        currentType = $typeSelect.val();
        // STEP 2: Set initial
        displayMetaFields(currentType);
        // STEP 3: Watch Chage of type field
        $typeSelect.on('change',displayMetaFields);

      }
      // TBD: what do we do with content in dropped fields - are those hidden and not submitted? zerod out?
    }
  };
}()); // ClearCMS.Types

ClearCMS.Form = (function() {
  'use strict';

  var warnBeforeUnload = false;

  function warn() {
    if (warnBeforeUnload) {
      return 'There are unsaved changes.';
    }
  }

  function activateMarkItUp() {
    // quick hack to make sure we don't double initialize
    $('textarea.markitup').not('.markItUpEditor').markItUp(markItUpSettings).data('tc-ignore-html',true).textcount();
  }

  return {
    setUnsavedWarning: function() {
      ClearCMS.Interface.setStatus('unsaved','true');
      warnBeforeUnload = true;
    },

    initialize: function() {
      // set up protected fields
      // NOTE: don't protect things for new new special case
      $('#new_content .protected').removeClass('protected');
      $('.protected').protectedfield({lockClass:'glyphicon glyphicon-lock'});

      // set up tags completion
      $('#content_tags, #content_categories').map(function() {
        var startvals = null;

        if ($(this).val() === '[]' || $(this).val() === '') {
          startvals = null;
          $(this).val('');
        } else {
          startvals = $.parseJSON($(this).val());
        }

        $(this)
          .tagsManager({
            delimeters: [44],
            blinkBGColor_1: 'yellow',
            blinkBGColor_2: '#f5f5f5',
            replace: true,
            prefilled: startvals
          })
          .removeAttr('required')
          .attr('placeholder','press comma (,) to save entry to list')
          .css({
            'margin-left': '120px',
            'display': 'block'
          });
      });

      // set up categories completion
      // $("#content_categories").on('typeahead:selected',function(e, item) {
      //   console.log('selected something');
      // });

      // watch fields for changes
      // then watch window events for unload w/ unsaved changes
      $('input,select,textarea')
        .not('.hidefromstatus')
        .each(function() {
          $(this)
            .data('original-value',$(this).val())
            .data('original-state',$(this).is(':checked'));
        })
        .on('change keyup',function(e) {
          if (($(this).val() !== $(this).data('original-value')) || ($(this).is(':checked') !== $(this).data('original-state'))) {
            ClearCMS.Interface.setStatus('unsaved','true');
            warnBeforeUnload = true;
          }
        });
      // watch for (SUCCESSFUL?) submit to clear warning
      $('form').on('submit',function(e) {
        ClearCMS.Interface.setStatus('unsaved','false');
        warnBeforeUnload = false;
      });

      window.onbeforeunload = warn;

      // watch for ctrl-s to trigger save for primary page forms
      if ($('form.primary').length) {
        $('body').on('keydown',function(e) {
          if (e.ctrlKey || e.metaKey) {
            if (String.fromCharCode(e.which).toLowerCase() === 's') {
              e.preventDefault();
              if (confirm('Save your changes?')) {
                $('form.primary').submit();
              }
            }
          }
        });
      }

      // TODO: abstract this all
      // initialize sortable widgets - linked content
      $('#linkedContentSortable').sortable({
        revert: false,
        update: function(e,ui) {
          // loop thorugh items and update order field
          $('#linkedContentSortable .draggable').each(function(i) {
            $(this).find('[id$=_order]').val(i);
          });
          // TODO: why do i have to manually remove the jquery ui class?
          ui.item.removeClass('ui-draggable-dragging').effect('highlight');
        }
      });
      $('.draggable','#linkedContentSortable').draggable({
        connectToSortable: '#linkedContentSortable',
        helper: 'original',
        axis: 'x',
        revert: 'invalid',
        stop: function() {
          //alert('done');
        }
      });

      // initialize sortable widgets - media items
      $('#asset-sortable').sortable({
        revert: false,
        update: function(e,ui) {

          // loop thorugh items and update order field
          $('#asset-sortable .draggable').each(function(i) {
            $(this).find('[id$=_order]').val(i); //content[content_blocks_attributes][0][content_assets_attributes][0][order])
          });

          // TODO: why do i have to manually remove the jquery ui class?
          ui.item.removeClass('ui-draggable-dragging').effect('highlight');
        }
      });
      $( '.draggable','#asset-sortable').draggable({
        connectToSortable: '#asset-sortable',
        helper: 'original',
        axis: 'x',
        revert: 'invalid',
        stop: function() {
          //alert('done');
        }
      });

      // "Disabling text selection is bad. Don't use this." http://api.jqueryui.com/disableSelection/
      $('.draggable ul').disableSelection();

      // activate markitup widgets
      activateMarkItUp();
      //$(document).on(ClearCMS.e.FORM_FIELDS_MODIFIED,activateMarkItUp);
      $(document).on('nested:fieldAdded',activateMarkItUp);

      // activate field counters
      $('textarea').textcount();

      // activate special tab creation functionality
      $('#edit_content,#new_content').on('nested:fieldAdded',function(e) {
        var $tabBar = $('#myTab'),
            $newFields,
            $tabContainer,
            $newTab,
            id = Date.now();

        $tabContainer = $tabBar.parent();
        $newFields = $tabContainer.find('.fields').last();

        // wrap newly added content (todo: can we modify the template?)
        $newFields.wrap('<div class="tab-pane" id="content_block_added_'+id+'"></div>');

        // add associated tab
        $newTab = $tabBar.append('<li><a href="#content_block_added_'+id+'" data-toggle="tab">ADDED</a></li>');

        // update tab state showing new block
        $newTab.find('a').trigger('click');

      });

      // activate special datetimepickers
      // hack to make date field format so datepicker sees it
      $('.datetimepicker').each(function(i){
        var datetime_reformatted = '';

        if ($(this).val()) {
          datetime_reformatted =  moment($(this).val()).format('YYYY-MM-DDTHH:mm:00');
        }
        $(this).val(datetime_reformatted);
      });

      $('.datetimepicker').datetimepicker({
          format: 'yyyy-mm-ddThh:ii',
          autoclose: true,
          showMeridian: true,
          todayBtn: true,
          pickerPosition: 'bottom-left'
      });


      // hack to convert date to utc before submission
      $('form').on('submit',function(e) {

        // clean up datepicker data
        $('.datetimepicker').each(function(i){
          var datetime_unformatted = '';

          if ($(this).val()) {
            datetime_unformatted = moment($(this).val()).format('YYYY-MM-DDTHH:mm:00Z');
          }
          $(this).val(datetime_unformatted);
        });

      });


      // activate "save as next state" button (TODO: refactor)
      $('.form-action.next-state').bind('click', function(e) {
        //alert($(this).attr('data-next-state'));
        // console.log('save as next state');
        $('#content_state').val($(this).attr('data-next-state'));
        $('form.content').submit();
      });
    }
  };
}()); // ClearCMS.Form


ClearCMS.Interface = (function() {
  'use strict';

  function drawStatus(uploads,unsaved) {
    uploads = uploads ? uploads : '0';
    unsaved = unsaved ? 'yes' : 'no';

    if ($('#template-status-bar').length) {
      $('body').append(tmpl('template-status-bar',{'uploads': uploads,'unsaved': unsaved}));
    }
  }

  function updateStatus(which, val) {
    $('#status-bar .val-'+which).html(val);
  }

  return {
    setStatus: function(which, val) {
      updateStatus(which, val);
    },

    initialize: function() {
      // activate tooltips
      $('.category_listings').tooltip({trigger: 'hover'});


      // initialize status bar
      drawStatus();

      // initialize type ahead find dialogs
      // $('#linkedLookup').typeahead({
      //   source: function(query, process) {
      //     return $.ajax({
      //       //url: $(this)[0].$element[0].data.link,
      //       url: '/clear_cms/sites/51e59961b50f1e24db000002/contents.json',
      //       type: 'get',
      //       data: {
      //         'filters[type]': 'Product',
      //         query: query
      //       },
      //       dataType: 'json',
      //       success: function(json) {
      //         return typeof json.options == 'undefined' ? false : process(json.options);
      //       }
      //     });
      //   }
      // });

      // re-route lookup field form submission to adding content item
      // $('#linkedLookup').on('keyup',function(e) {
      //   if (e.keyCode == 13) {
      //     e.stopPropagation();
      //     e.preventDefault();
      //   }
      // });

      // $('#linkedLookup')
    }
  };
}()); // ClearCMS.UI

ClearCMS.Linking = (function() {
  'use strict';

  var _dataCache,
      _lastOrderIndex = 50;

  // adds a new record to the collection of linked items
  // $block = .lookupWrap block
  // ui == jQuery UI autocomplete output
  function _addTemplate($block,ui) {
    var which,
        data,
        img_src = null;

    // circuitous route to image thumb
    if (ui.item.all.content_blocks[0].content_assets) {
      img_src = ui.item.all.content_blocks[0].content_assets[0].mounted_file.thumb.url;
    }

    //val = $block.find('input').val();
    which = $block.data('lookup-success-tmpl');
    data = {
      //'fiters[type]': $block.data('lookup-filter-type'),
      content_id: ui.item.all._id.$oid,
      title: ui.item.all.title,
      media_src: img_src,
      order: _lastOrderIndex++
    };
    $block.prev('.lookupSuccessTarget').append(tmpl(which,data));

    $block.find('.lookupField').val('');

    ClearCMS.Form.setUnsavedWarning();
  }

  // updates the filter type based on selection
  // NOTE: currently dumb, changes ALL linked content blocks on a page
  function _updateFitlerType(val) {
    $('.lookupWrap').data('lookup-filter-type',val);
  }

  return {
    initialize: function() {
      var $blocks;
          //$field,
          // $button;

      // look up linkage blocks and attach needed event handlers
      $blocks = $('.lookupWrap');

      // prevent some edge cases / form submits
      $('input',$blocks).addClass('hidefromstatus').on('keyup',function(e) {
        if (e.keyCode === 13) {
          //_addTemplate($(this).parents('.lookupWrap'));
          e.preventDefault();
          e.stopPropagation();
        }
      });

      // manage button events
      $('button',$blocks).on('click',function(e) {
        e.preventDefault();
        if ($(this).siblings('input').val()) {
          //_addTemplate($(this).parents('.lookupWrap'));
        }
      });

      // watch type selector for changes
      $('.linkedFiltersTypeMonitor').on('change',function(e) {
        _updateFitlerType(linkedFiltersType[$(this).val()]);
      });

      // initialize jquery autocomplete widget and outputs
      $('input',$blocks).each(function(i) {
        var $input = $(this),
            $block = $input.parents('.lookupWrap');

        $input.autocomplete({
          source: function(request, response) {
            $.ajax({
              url: $block.data('lookup-url'),
              data: {
                'filter[types]': $block.data('lookup-filter-type'),
                q: request.term
              }
            }).success(function(data){
              var results = $.map(data, function(content) {
                return {
                  label: content.title,
                  value: content._id.$oid,
                  all: content
                };
              });
              _dataCache = data;
              response(results);
            });
          },
          minLength: 4,
          select: function( event, ui ) {
            event.preventDefault();
            // console.log(ui);
            // TBD: auto _addTemplate on selection?
            _addTemplate($(this).parents('.lookupWrap'),ui);
          }
        });
      });
    }
  };
}()); // ClearCMS.Linking

ClearCMS.Image = (function() {
  'use strict';

  // function internal_sample() {

  // }


  return {
    initialize: function() {
      //sample
    },

    insert: function(imageInsertButton) {
      //alert(this);
      //console.log($(image).parent('.content-form-asset'));
      //var modal=$(imageInsertButton).parent('#modal-image-insert');
/*


      var src=modal.find('#image-url').html();
      var alt=src;


*/
      var modal=$('#modal-image-insert'),
          src=$.trim($(modal).find('#image-url').html()),
          alignment=$(modal).find('input[name=image_alignment]:checked').val(),
          image_size=$(modal).find('input[name=image_size]:checked').val(),
          path=$(modal).find('input[name=path]').val(),
          file=$(modal).find('input[name=file]').val(),
          srchost = $('<a>').prop('href', src).prop('hostname'),
      /* var alt=src; */
          alt='';

      //var title=
      //var caption=
      //var description=

      $.markItUp({ replaceWith:'<img src="//'+srchost+'/'+path+'/'+image_size+'_'+file+'" alt="'+alt+'" class="'+alignment+'" />' });
      modal.modal('hide');
      return false;
    },
    insertWizard: function(imageInsertButton) {
      var assetDiv=$(imageInsertButton).parent('.content-form-asset'),
          src=$(assetDiv).find('img').data('orig-src'),
          path=$(assetDiv).find('input.path').val(),
          file=$(assetDiv).find('input.file').val();
      $('#modal-image-insert > .modal-body').html(tmpl('template-insert-wizard',{'url': src,'path': path, 'file': file}));
      $('#modal-image-insert').modal();
      return false;
    }
  };

}()); // ClearCMS.Image


ClearCMS.ImageQueue = (function() {
  'use strict';

  var assetList={},
      _lastOrderIndex = 50;


  return {
    addAsset: function(asset,upload_data){
      assetList[asset._id.$oid]={asset: asset, upload_data: upload_data};
      window.setTimeout(function(){ ClearCMS.ImageQueue.checkProcessing(asset._id.$oid); },2000);
      // TDDO: update this:
      ClearCMS.Form.setUnsavedWarning();
      //window.warnBeforeUnload=true;
      return assetList;
    },
    getAssets: function() {
      return assetList;
    },
    checkProcessing: function(asset_id) {
      $.ajax('/clear_cms/assets/'+asset_id,{
        success: function(data) {
          if(data.processed_at) {
            if(assetList[data._id.$oid].upload_data.context) {
              assetList[data._id.$oid].upload_data.context.remove();
            }

            $.extend(data,{order: _lastOrderIndex++});
            $('#asset-sortable').append(tmpl('template-asset-form',data));
            delete assetList[data._id.$oid];
            window.uploadsCount--;
            ClearCMS.Interface.setStatus('uploads',window.uploadsCount);
          } else {
            window.setTimeout(function(){ ClearCMS.ImageQueue.checkProcessing(data._id.$oid); },2000);
          }
        }
      });
    }

  };

}()); // ClearCMS.ImageQueue








// On Load, Initilize sites
(function($){
  'use strict';

  ClearCMS.Form.initialize();
  ClearCMS.Interface.initialize();
  ClearCMS.ContentTypes.initialize();
  ClearCMS.Linking.initialize();

})(jQuery);

