var redirect_hashes = ['introduction', 'installation',
                       'configuring-your-environment-using-ec2',
                       'configuring-a-local-environment'];

$(document).ready(function() {
  $('.stacktack').stacktack({'site': 'askubuntu.com', 'answers': 'accepted',
                         'tags': 'true', 'secure': 'true'});
});

$(document).ready(function() {
  if($.inArray(window.location.hash, redirect_hashes) > -1) {
    window.location.replace(window.location.pathname + '/' + window.location.hash)
  }
});
