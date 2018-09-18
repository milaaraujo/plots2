/**
    This functionality operates on the header search form that is part of the primary layout.  It operates the submission of the search form to the general search page.  Any site-wide scripting that should affect the header searches should go here.
  **/
$(function() {
  //Set up the _header search form submission
  $('#search_form').submit(function(e){
    e.preventDefault();
    query = $('#search_form_input').val();
    window.location = "/search/" + query + "/notes";
  });
});
