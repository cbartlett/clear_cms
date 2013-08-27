'use strict';

var ClearCMS = Window.ClearCMS || {};

ClearCMS.e = function() {
  return {
    FORM_FIELDS_MODIFIED: "form fields modified"
  }
}();

// Manages the content type metadata / form switching for edit pages
ClearCMS.ContentTypes = function() {
  var $typeSelect,
      currentType,
      allType = 'ClearCMS::Content';

  function displayMetaFields(thing) {
    var type = (typeof thing == 'string') ? thing : $(this).val();

    // loop though fieldset.general li and inspect the data('types') array
    // TBD: this may not be the final method of identifying these fields/areas
    $('.general li[data-types]').each(function(i) {

      if ((-1 != $.inArray(type, $(this).data('types'))) || (-1 != $.inArray(allType, $(this).data('types')))) {
        $(this).show();
      } else {
        $(this).hide();
      }

    });
  };

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
        $typeSelect.on('change',displayMetaFields)

        }
      // TBD: what do we do with content in dropped fields - are those hidden and not submitted? zerod out?
    }
  }
}(); // ClearCMS.Types

ClearCMS.Form = function() {
  var warnBeforeUnload = false;

  function warn() {
    if (warnBeforeUnload) {
      return 'There are unsaved changes.';
    }
  };

  function activateMarkItUp() {
    $('textarea.markitup').markItUp(markItUpSettings);
  };

  return {
    setUnsavedWarning: function() {
      ClearCMS.Interface.setStatus('unsaved','true');
      warnBeforeUnload = true;
    },

    initialize: function() {
      // watch window events for unload / unsaved changes
      $('input,select,textarea').on('change keyup',function(e) {
        if (!$(this).is('.hidefromstatus')) {
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

      // initialize sortable widgets
      $( "#asset-sortable" ).sortable({
        revert: true,
        update: function() {

          // loop thorugh items and update order field
          $('#asset-sortable .draggable').each(function(i) {
            $(this).find('[id$=_order]').val(i); //content[content_blocks_attributes][0][content_assets_attributes][0][order])
          });

        }
      });
      $( ".draggable" ).draggable({
        connectToSortable: "#asset-sortable",
        helper: "original",
        axis: "x",
        revert: "invalid",
        stop: function() {
          //alert('done');
        }
      });

      // "Disabling text selection is bad. Don't use this." http://api.jqueryui.com/disableSelection/
      $( ".draggabke ul" ).disableSelection();

      // activate markitup widgets
      activateMarkItUp();
      //$(document).on(ClearCMS.e.FORM_FIELDS_MODIFIED,activateMarkItUp);
      $(document).on('nested:fieldAdded',activateMarkItUp);

      // activate field counters
      $('textarea').textcount();

      // activate special datetimepickers
      // hack to make date field format so datepicker sees it
      $('.datetime_picker').each(function(i){
        var datetime = moment($(this).val()),
            datetime_reformatted = "";

        if (datetime) {
          datetime_reformatted = datetime.format('YYYY-MM-DDTHH:mm:00');
        }
        $(this).val(datetime_reformatted);
      })

      $('.datetime_picker').datetimepicker({
        format: 'yyyy-mm-ddThh:ii',
        autoclose: true,
        showMeridian: true,
        todayBtn: true,
        pickerPosition: "bottom-left"
      });


      // hack to convert date to utc before submission
      $('form').on('submit',function(e) {
        $('.datetime_picker').each(function(i){
          var datetime = moment($(this).val()),
            datetime_unformatted = "";

          if (datetime) {
            datetime_unformatted = datetime.format('YYYY-MM-DDTHH:mm:00Z');
          }
          $(this).val(datetime_unformatted);
        });

      })
      //$('.datetime_picker').


      // activate "save as next state" button (TODO: refactor)
      $(".form-action.next-state").bind('click', function(e) {
        //alert($(this).attr('data-next-state'));
        // console.log('save as next state');
        $('#clear_cms_content_state').val($(this).attr('data-next-state'));
        $('form.clear_cms_content').submit();
      });
    }
  }
}(); // ClearCMS.Form


ClearCMS.Interface = function() {
  function drawStatus(uploads,unsaved) {
    var uploads = uploads ? uploads : "0",
        unsaved = unsaved ? "yes" : "no";

    if ($('#template-status-bar').length) {
      $('body').append(tmpl('template-status-bar',{"uploads": uploads,"unsaved": unsaved}));
    }
  };

  function updateStatus(which, val) {
    $('#status-bar .val-'+which).html(val);
  };

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
  }
}(); // ClearCMS.UI

ClearCMS.Linking = function() {
  var _dataCache;

  function _addTemplate($block) {
    var which,
        val,
        data;

    val = $block.find('input').val();
    $block.find('input').val('');
    which = $block.data('lookup-success-tmpl');
    data = {
      //'fiters[type]': $block.data('lookup-filter-type'),
      content_id: val
    }
    $block.next('.lookupSuccessTarget').prepend(tmpl(which,data));
  };

  return {
    initialize: function() {
      var $blocks,
          $field,
          $button;

      // look up linkage blocks and attach needed event handlers
      $blocks = $('.lookupWrap');

      // prevent some edge cases / form submits
      $('input',$blocks).addClass('hidefromstatus').on('keyup',function(e) {
        if (e.keyCode == 13) {
          //_addTemplate($(this).parents('.lookupWrap'));
          e.preventDefault();
          e.stopPropagation();
        }
      });

      // manage button events
      $('button',$blocks).on('click',function(e) {
        e.preventDefault();
        if ($(this).siblings('input').val()) {
          _addTemplate($(this).parents('.lookupWrap'));
        }
      })

      $('input',$blocks).each(function(i) {
        var $input = $(this),
            $block = $input.parents('.lookupWrap');

        $input.autocomplete({
          source: function(request, response) {
            $.ajax({
              url: $block.data('lookup-url'),
              data: {
                'fiters[type]': $block.data('lookup-filter-type'),
                q: request.term
              }
            }).success(function(data){
              var results = $.map(data, function(content) {
                return {
                  label: content.title,
                  value: content._id
                }
              });
              _dataCache = data;
              response(results);
            });
          },
          minLength: 2,
          select: function( event, ui ) {
            console.log(ui);
            // TBD: auto _addTemplate on selection?
          }
        });
      });
    }
  }
}(); // ClearCMS.Linking

ClearCMS.Image = function() {

  function internal_sample() {


  };


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
      var modal=$('#modal-image-insert');
      var src=$.trim($(modal).find('#image-url').html());

      var alignment=$(modal).find('input[name=image_alignment]:checked').val();
      var image_size=$(modal).find('input[name=image_size]:checked').val();

      var path=$(modal).find('input[name=path]').val();
      var file=$(modal).find('input[name=file]').val();

      var srchost = $('<a>').prop('href', src).prop('hostname');
      /* var alt=src; */
      var alt='';

      //var title=
      //var caption=
      //var description=

      $.markItUp({ replaceWith:'<img src="http://'+srchost+'/'+path+'/'+image_size+'_'+file+'" alt="'+alt+'" class="'+alignment+'" />' });
      modal.modal('hide');
      return false;
    },
    insertWizard: function(imageInsertButton) {
      var assetDiv=$(imageInsertButton).parent('.content-form-asset');
      var src=$(assetDiv).find('img').attr('src');
      var path=$(assetDiv).find('input.path').val();
      var file=$(assetDiv).find('input.file').val();
      $('#modal-image-insert > .modal-body').html(tmpl('template-insert-wizard',{"url": src,"path": path, "file": file}));
      $('#modal-image-insert').modal();
      return false;
    }
  }

}(); // ClearCMS.Image


ClearCMS.ImageQueue = function() {
  var assetList={};


  return {
    addAsset: function(asset,upload_data){
      assetList[asset._id]={asset: asset, upload_data: upload_data};
      window.setTimeout(function(){ ClearCMS.ImageQueue.checkProcessing(asset._id); },2000);
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
            if(assetList[data._id]['upload_data'].context) {
              assetList[data._id]['upload_data'].context.remove();
            }
            $('#asset-sortable').append(tmpl('template-asset-form',data));
            delete assetList[data._id];
            window.uploadsCount--;
            ClearCMS.Interface.setStatus('uploads',window.uploadsCount);
          } else {
            window.setTimeout(function(){ ClearCMS.ImageQueue.checkProcessing(data._id); },2000);
          }
        }
      });
    }

  }

}(); // ClearCMS.ImageQueue








// On Load, Initilize sites
(function($){
  ClearCMS.Form.initialize();
  ClearCMS.Interface.initialize();
  ClearCMS.ContentTypes.initialize();
  ClearCMS.Linking.initialize()

})(jQuery);

