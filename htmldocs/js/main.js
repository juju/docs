var redirect_hashes = ['introduction', 'installation',
                       'configuring-your-environment-using-ec2',
                       'configuring-a-local-environment'];

//$(document).ready(function() {
//  $('.stacktack').stacktack({'site': 'askubuntu.com', 'answers': 'accepted',
//                         'tags': 'true', 'secure': 'true'});
//});

$(document).ready(function() {
  if($.inArray(window.location.hash, redirect_hashes) > -1) {
    window.location.replace(window.location.pathname + '/' + window.location.hash)
  }

  $("#navlinks").load("navigation.html", function() {
    url = window.location.pathname;
    cur_page = url.substring(url.lastIndexOf('/')+1) + window.location.hash;
    console.log('loaded');
    $('#navlinks ul li').each(function() {
      if($(this).children('a').attr('href') == cur_page) {
        console.log($(this), $(this).children('a'))
        $(this).addClass('selected');
      }
    });
  });
});

$(document).ready(function() {
  $('.doc-content section.code-example').each(function() {
    var parent = this;
    $(parent).find('nav.control a').each(function() {
      if($(this).hasClass('selected')) {
        var section = $(this).data('action');
        $(parent).find('div[data-section='+section+']').show();
      }

      $(this).click(function(e) {
        e.preventDefault();
        var section = $(this).data('action');
        $(parent).find('div[data-section]').hide();
        $(this).siblings('a').removeClass('selected');
        $(this).addClass('selected');
        $(parent).find('div[data-section='+section+']').show();
        return false;
      });
    });
  });
});


