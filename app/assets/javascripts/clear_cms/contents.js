var _checkFormState=function(){
  if(window.warnBeforeUnload){
    return "There are unsaved changes.";
  }
}


$(document).ready(function() {
  window.onbeforeunload=_checkFormState;

  $('form.clear_cms_content').submit(function(){
    window.warnBeforeUnload=false;
  });

  $('form.clear_cms_content').change(function(){
    window.warnBeforeUnload=true;
  });


  $(document).on('nested:fieldAdded', function(event){
    // this field was just inserted into your form
    //var field = event.field;
    // it's a jQuery object already! Now you can find date input
    //var dateField = field.find('.date');
    // and activate datepicker on it
    //dateField.datepicker();
    $('textarea.markitup').markItUp(mySettings);
  })


  //tooltips for index page category listing
  $('.category_listings').tooltip({trigger: 'hover'});

/* Sortable image assets */
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

  $( "ul, li" ).disableSelection();
/**/

  //$('#fileupload').bind('fileuploadadd', function (e, data) { data.submit()});
  //$('form.clear_cms_content').append('<input name="clear_cms_content[content_blocks_attributes][0][content_assets_attributes][99][remote_file_url]" value="https://www.google.com/images/srpr/logo3w.png" />');


/*
  $('#fileupload').fileupload({
      headers: {
          'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
      },
      destroy: function (e, data) {
          data.headers = $(this).data('fileupload')
              .options.headers;
          $.blueimpUI.fileupload.prototype.options.destroy
              .call(this, e, data);
      }
  });



  $('#fileupload').bind('fileuploaddone', function(e,data) {
    console.log(data.result);
    //$('form.clear_cms_content').append('<input name="clear_cms_content[content_blocks_attributes][0][content_assets_attributes]['+Math.random(5)+'][remote_file_url]" type="hidden" value="'+data.result.files[0].url+'" />');
    $('#modal-gallery > .modal-body').append('<img src="'+data.result.files[0].thumbnail_url+'" class="img-polaroid" />');
    $('#asset-sortable').append(tmpl('template-asset-form',data.result.files[0]));
  });
*/


  $(".form-action.next-state").bind('click',
    function(event) {
      //alert($(this).attr('data-next-state'));
      $('#clear_cms_content_state').val($(this).attr('data-next-state'));
      $('form.clear_cms_content').submit();

    }
  );


});


var ClearCMS = Window.ClearCMS || {};


ClearCMS.Image = function() {

  function internal_sample() {


  }


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

}();


ClearCMS.ImageQueue = function() {
  var assetList={};


  return {
    addAsset: function(asset,upload_data){
      assetList[asset._id]={asset: asset, upload_data: upload_data};
      window.setTimeout(function(){ ClearCMS.ImageQueue.checkProcessing(asset._id); },2000);
      window.warnBeforeUnload=true;
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
          } else {
            window.setTimeout(function(){ ClearCMS.ImageQueue.checkProcessing(data._id); },2000);
          }
        }
      });
    }

  }



}();

//      helper: $(this).find('img'),