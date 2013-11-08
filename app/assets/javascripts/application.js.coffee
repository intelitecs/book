# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require jquery
#= require jquery_ujs
#= require underscore
#= require jquery.ui.all
#= require foundation
# require turbolinks

#= require_tree .

$ ->
  $(document).foundation()



  #configuration of jquery to always include the csrf_token in the request
  $(document).ajaxSend (e,request,options) ->
    token = $("meta[name='csrf-token']").attr('content')
    request.setRequestHeader('X-CSRF-Token',token)


  window.Scope = {
    current_comments_index: 0,
    index:0,
    articles: {},
    article:{},
    comments:{},
    errors:{},
    commentsdones: [],
    current_user_id: null,
    current_comments: [],
    users:{},
    user:{},
    current_user:{}
    usersdones:[]
  }




  $(".user_form label").css({'textAlign':'right'})

  $icon_plus = $("div.articles_browser").children("i.icon-plus-sign")
  $article_management = $("div.articles_management")
  $icon_plus.hover ->
    $(this).css({'visibility':'hidden'})
    $article_management.css({'visibility':'visible','marginLeft':'-52px'}).addClass("position_management_on_hover")

  $article_management.mouseleave ->
    $(this).css({'visibility':'hidden'})
    $icon_plus.css({'visibility':'visible'})

  $("img.article_image").hover ->
    $("div.articles_browser").css({'visibility':'visible'})


  $("div.articles_row").hover ->
    $("div.articles_browser").css({'visibility':'visible'})


  user_id = $('form.comment_form').data('current_user_id')

  if user_id  is ""
    Scope.current_user_id = -1
  else
    Scope.current_user_id = parseInt(user_id)


  current_user = (user,status,request) ->
    Scope.current_user = user


  current_user_erros = (errors) ->
    console.log(errors)

  $.ajax({
    url: "/users/#{Scope.current_user_id}",
    type: 'GET',
    dataType: 'json',
    success: current_user,
    error: current_user_erros
  })


  console.log('current user id = '+Scope.current_user_id+ " type = "+ typeof Scope.current_user_id )

