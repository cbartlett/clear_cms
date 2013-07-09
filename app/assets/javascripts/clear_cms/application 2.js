$(document).ready(function() {
  
  $('#site_selector_id').change(function() {
    window.location.search='site_selector[id]='+$('#site_selector_id').val();
  });

});

