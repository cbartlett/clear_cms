'use strict';

var ClearCMS = Window.ClearCMS || {};

ClearCMS.e = function() {
  return {
    FORM_FIELDS_MODIFIED: "form fields modified"
  }
}

ClearCMS.Form = function() {
  var warnBeforeUnload = false,
      markItUpSettings = {
        onShiftEnter: {keepDefault:false, replaceWith:'<br />\n'},
        onCtrlEnter:  {keepDefault:false, openWith:'\n<p>', closeWith:'</p>\n'},
        onTab:      {keepDefault:false, openWith:'   '},
        markupSet: [
          {name:'Heading 1', key:'1', openWith:'<h1(!( class="[![Class]!]")!)>', closeWith:'</h1>', placeHolder:'Your title here...' },
          {name:'Heading 2', key:'2', openWith:'<h2(!( class="[![Class]!]")!)>', closeWith:'</h2>', placeHolder:'Your title here...' },
          {name:'Heading 3', key:'3', openWith:'<h3(!( class="[![Class]!]")!)>', closeWith:'</h3>', placeHolder:'Your title here...' },
          {name:'Heading 4', key:'4', openWith:'<h4(!( class="[![Class]!]")!)>', closeWith:'</h4>', placeHolder:'Your title here...' },
          {name:'Heading 5', key:'5', openWith:'<h5(!( class="[![Class]!]")!)>', closeWith:'</h5>', placeHolder:'Your title here...' },
          {name:'Heading 6', key:'6', openWith:'<h6(!( class="[![Class]!]")!)>', closeWith:'</h6>', placeHolder:'Your title here...' },
          {name:'Paragraph', openWith:'<p(!( class="[![Class]!]")!)>', closeWith:'</p>' },
          {separator:'---------------' },
          {name:'Bold', key:'B', openWith:'(!(<strong>|!|<b>)!)', closeWith:'(!(</strong>|!|</b>)!)' },
          {name:'Italic', key:'I', openWith:'(!(<em>|!|<i>)!)', closeWith:'(!(</em>|!|</i>)!)' },
          {name:'Stroke through', key:'S', openWith:'<del>', closeWith:'</del>' },
          {separator:'---------------' },
          {name:'Ul', openWith:'<ul>\n', closeWith:'</ul>\n' },
          {name:'Ol', openWith:'<ol>\n', closeWith:'</ol>\n' },
          {name:'Li', openWith:'<li>', closeWith:'</li>' },
          {separator:'---------------' },
          {name:'Picture', key:'P', replaceWith:'<img src="[![Source:!:http://]!]" alt="[![Alternative text]!]" />' },
          {name:'Link', key:'L', openWith:'<a href="[![Link:!:http://]!]"(!( title="[![Title]!]")!)>', closeWith:'</a>', placeHolder:'Your text to link...' },
          {separator:'---------------' }
        ]
      };

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
        ClearCMS.Interface.setStatus('unsaved','true');
        warnBeforeUnload = true;
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

    }
  }
}(); // ClearCMS.UI



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

})(jQuery);

