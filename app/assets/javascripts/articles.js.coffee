# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#= require_self


$ ->

  $('div.comment_managment').hide()

  all = (resource,success,error) ->
    $.ajax({
      url: "/#{resource}",
      type: 'GET',
      dataType: 'json',
      success: success,
      error: error
    })

  loadArticles = ->
    all("articles",allArticlesSuccessCallback,allArticlesErrorCallback)



  $('i.article-create').click ->
    $.ajax({
      url: '/articles/new',
      type: 'GET',
      dataType: 'HTML',
      success: replaceBody,
      error: (errors) -> console.log(errors)
    })


  replaceBody = (response,status,xhr) ->
    $('body').html(response).find('body')



  displayCurrentArticle = ->
    if(Scope.article != {})
      $("img.current").slideUp 'slow', ->
        $(this).fadeIn()
      $('img.current').attr({'src':Scope.article.image})
      $('h4.title').text(Scope.article.title)
      $('b.date').text(formatDateFr(Scope.article.created_at))
      $('i.number').text(" n°"+(Scope.index+1))
      $('i.total-articles').text(Scope.articles.length)
      $('h6.description').text(Scope.article.description)
      $('div.comment_column').empty()
      displayComments()



  current_user = (user,status,request) ->
    Scope.current_user = user


  current_user_erros = (errors) ->
    console.log(errors)




  displayComments = ->
    $('div.comment_column').empty()
    if(Scope.article.comments.length >5)
      $('div.comment_column').css({'overflow':'scroll','height':'400px'})
    if($.isEmptyObject(Scope.article.comments))
      $('div.comment').hide()
      return;
    else
      $.each Scope.article.comments, (index,comment) ->
        $commentDiv     = $('<div class="row comment">')

        $commentBodyDiv = $('<div class="large-14 columns pull-1 ">').css({'padding':'0'})

        if  Scope.current_user_id != -1 and Scope.current_user.admin is true
          $checkBoxDiv    = $('<div class="large-1 columns">')
          $checkBoxDiv.css({'width':'10px','height':'40px','padding':'10px','marginTop':'20px'})
          $commentCheckbox = $("<input type='checkbox' class='check'>").css({'marginTop':'-4px','marginLeft':'-6px'})
          $commentCheckbox.on 'change',{comment: comment, index: index},addToDones
          $commentCheckbox.appendTo($commentDiv)
          $checkBoxDiv.append($commentCheckbox)
          $commentDiv.append($checkBoxDiv)
        $commentP = $('<p >')
        $commentP.attr({id: "comment"+index,class:'commentBody'+index})
        $commentH5 = $('<h5 class="comment_body">').text(comment.body)
        $commentP.append($commentH5)
        $commentP.css({'padding':'10px','marginTop':'10px',marginLeft:'50px',width: '600px'})
        $commentP.addClass('comment_body_class')
        $commentBodyDiv.append($commentP)

        $commentDiv.append($commentBodyDiv)
        $('div.comment_column').append($commentDiv)


  addToDones = (event) ->
    comment = event.data.comment
    index = event.data.index
    checkbox = event.target
    if checkbox.checked is true
      comment.done = true
      Scope.commentsdones.unshift(comment) if Scope.commentsdones.indexOf(comment) is -1
      $('p#comment'+index).addClass('done-true')
      $('p#comment'+index).removeClass('comment_body_class')
    else
      comment.done = false
      Scope.commentsdones.slice(Scope.commentsdones.indexOf(comment),1) if Scope.commentsdones.indexOf(comment) != -1
      $('p#comment'+index).addClass('comment_body_class')
      $('p#comment'+index).removeClass('done-true')
      #



    Scope.commentsdones = _.filter Scope.article.comments, (comment) ->
      comment.done

    if Scope.commentsdones.length  == 0
      $('span.selection').text(" ")
      $('div.comment_managment').hide()
    else if( Scope.commentsdones.length  == 1)
      $('div.comment_managment').show()
      $('i.comment-update').show()
      $('span.selection').html("<b>1</b> commentaire sélectionné")
    else
      $('i.comment-update').hide()
      $('span.selection').html("<b>"+Scope.commentsdones.length+"</b> commentaires sélectionnés")


  deleteComment = (comment) ->
    $.ajax({
      url:'/articles/'+Scope.article.id+'/comments/'+comment.id
      type:'DELETE',
      success: (response,status,xhr) ->
        index = Scope.article.comments.indexOf(comment)
        Scope.article.comments.slice(index,1)
        Scope.commentsdones.slice(index,1)
        if index == 0
          $("div.comment_column").children('div:first').remove()
        else if index == Scope.article.comments.length-1
          $("div.comment_column").children('div:last').remove()
        else
          $("div.comment_column > div:nth-child(#{index})").remove()

        $("div.comment_managment").hide()
        $("span.selection").text("")
        $(".check").prop({'checked':false})
        $("p#comment"+index).removeClass('done-true')
        $('p#comment'+index).addClass('comment_body_class')


      error: (errors) ->
        console.log(errors)
    })


    #service-informatique-toulouse@ingesup.com


  $('i.comment-delete').click ->
    deleteComments()

  deleteComments = ->
    unless !confirm("Êtes-vous sur de supprimer? ")
      # delete operation here later
      for k,comment of Scope.commentsdones
        deleteComment(comment)
        Scope.commentsdones.slice(Scope.commentsdones.indexOf(comment),1)
      if Scope.commentsdones.length is 1
        $('span.selection').html('<h5>'+Scope.commentsdones.length+ '  commentaire supprimé avec succès!</h5>')
      else
        $('span.selection').html('<h5>'+Scope.commentsdones.length+ '  commentaires supprimés avec succès!</h5>')
    else
      for k,comment of Scope.commentsdones
        comment.done == false
        $(".check").prop({'checked':false})
      $("div.comment_managment").hide()
      $('span.selection').html('')
    Scope.commentsdones = []
    loadArticles()


  createComment = (data)->
      $.ajax({
        url: '/articles/'+Scope.article.id+'/comments',
        type:'POST',
        data: data,
        success: createCommentSuccess,
        error: createCommentError
      })

  createCommentSuccess = (response,status,xhr) ->
    console.log("comment create successfully")
    $('textarea#comment').val("")
    Scope.article.comments.unshift(Scope.article.comments[0])
    Scope.commentsdones = []
    loadArticles()


  createCommentError = (errors) ->
    console.log(errors)

  $('button#create_comment').click (e) ->
    e.preventDefault()
    $body = $('textarea#comment')
    unless  $body.val().length == 0
      data = {comment: {body: $body.val(),user_id: Scope.current_user_id}}
      createComment(data)
    else
      alert('Les commentaires vides ne sont pas acceptés.')
      false




  allArticlesSuccessCallback = (data) ->
    console.log("Articles fetched successfully: #{data}")
    Scope.articles = data
    Scope.article = Scope.articles[Scope.index]
    $("#article_search").on 'click',Scope.articles, processSearch
    displayCurrentArticle()

  allArticlesErrorCallback = (errors) ->
    console.log("Errors occured when trying to fetch data")
    Scope.errors = errors
    console.log(Scope.errors)

  loadArticles()

  $('i.article-next').click ->
    console.log("current user admin state : #{Scope.current_user.admin}")
    if Scope.index is Scope.articles.length-1
      Scope.index = 0
    else
      Scope.index++
    Scope.article = Scope.articles[Scope.index]
    $('img.current').fadeOut()
    $('span.selection').html(' ')
    displayCurrentArticle()


  $('i.article-prev').click ->
    if Scope.index is 0
      Scope.index = Scope.articles.length-1
    else
      Scope.index--
    Scope.article = Scope.articles[Scope.index]
    $('img.current').fadeOut()
    $('span.selection').html(' ')
    displayCurrentArticle()


  $('i.article-update').click ->
    $.ajax({
      url: "/articles/#{Scope.article.id}/edit",
      type:'GET',
      dataType:'HTML',
      success: (data,status,request) ->
        $('body').html(data).find('body')
        console.log("status : #{status} | #{request.statusText}")
      error: (errors) ->
        console.log("errors occured during display the updatating form : #{errors}")
    })

  deleteArticle =  ->
    $.ajax({
      url: "/articles/#{Scope.article.id}",
      type:'DELETE',
      success: (data,status,request) ->
        console.log(data)
        console.log("status : #{status} | #{request.statusText}")
      error: (errors) ->
        console.log(errors)
    })

  $('i.article-delete').click ->
    unless !confirm "Are you sure?"
      deleteArticle()
    else
      return


  processSearch = (event) ->
    articles = event.data
    titles = []
    for index,article of articles
      titles.push article.title

    $('#article_search').autocomplete({
      source:titles,
      select:(evt,ui) ->
        Scope.article = _.findWhere(articles,{title: ui.item.value})
        displayCurrentArticle()

    })













