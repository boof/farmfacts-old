var RelativeDate = Class.create({
  initialize: function(element, options){
    var now = new Date;
    var later = new Date(element.innerHTML);
    var offset = later.getTime() - now.getTime();
    element.innerHTML = this.relativeTime(offset);
  },
  relativeTime: function(offset){
    var distanceInMinutes = (offset.abs() / 60000).round();
    if (distanceInMinutes == 0) { return 'less than a minute ago'; }
    else if ($R(0,1).include(distanceInMinutes)) { return 'about a minute ago'; }
    else if ($R(2,44).include(distanceInMinutes)) { return distanceInMinutes + ' minutes ago';}
    else if ($R(45,89).include(distanceInMinutes)) { return 'about 1 hour ago';}
    else if ($R(90,1439).include(distanceInMinutes)) { return 'about ' + (distanceInMinutes / 60).round() + ' hours ago'; }
    else if ($R(1440,2879).include(distanceInMinutes)) {return '1 day ago'; }
    else if ($R(2880,43199).include(distanceInMinutes)) {return 'about ' + (distanceInMinutes / 1440).round() + ' days ago'; }
    else if ($R( 43200,86399).include(distanceInMinutes)) {return 'about a month ago' }
    else if ($R(86400,525599).include(distanceInMinutes)) {return 'about ' + (distanceInMinutes / 43200).round() + ' months ago'; }
    else if ($R(525600,1051199).include(distanceInMinutes)) {return 'about a year ago';}
    else return 'over ' + (distanceInMinutes / 525600).round() + ' years ago';
  }
});
