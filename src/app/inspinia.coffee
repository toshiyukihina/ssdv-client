$(document).ready ->
  # Full height
  fixHeight = ->
    heightWithoutNavbar = $("body > #wrapper").height() - 61
    $(".sidebard-panel").css("min-height", heightWithoutNavbar + "px")

    navbarHeigh = $('nav.navbar-default').height()
    wrapperHeigh = $('#page-wrapper').height()

    $('#page-wrapper').css("min-height", navbarHeigh + "px") if navbarHeigh > wrapperHeigh
    $('#page-wrapper').css("min-height", $(window).height()  + "px") if navbarHeigh < wrapperHeigh

  $(window).bind "load resize scroll", ->
    fixHeight() unless $("body").hasClass('body-small')

  setTimeout ->
    fixHeight()

# Minimalize menu when screen is less than 768px
$ ->
  $(window).bind "load resize", ->
    if $(this).width() < 769
      $('body').addClass('body-small')
    else
      $('body').removeClass('body-small')
