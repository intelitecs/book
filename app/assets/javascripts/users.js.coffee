# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/



all = (resource,success,error) ->
  $.ajax({
    url: "/#{resource}",
    type: 'GET',
    dataType: 'json',
    success: success,
    error: error
  })

loadUsers = ->
  all("users",allUsersSuccessCallback,allUsersErrorCallback)

displayUsers = ->
  if(Scope.users.length is 0)
    $('table.users_table').hide()
  else
    $('tbody.users_table_body').empty()
    $.each Scope.users, (index, user) ->
      $tr = $('<tr>').attr({'class':'user_tr'+index})
      $tdSelection = $('<td>').attr({'id':'selection'+index})
      $checkbox = $('<input type="checkbox">').attr({'id':'user_check'+index})
      #$checkbox.on 'change',{user: user, index: index}, dones
      $tdSelection.append($checkbox)
      $tdSelection.appendTo($tr)
      $tdUsername = $('<td>').attr({'id':'username'+index})
      $tdUsername.append(user.username)
      $tr.append($tdUsername)
      $tdEmail = $('<td>').attr({'id':'email'+index})
      $tdEmail.append(user.email)
      $tr.append($tdEmail)
      $('tbody.users_table_body').append($tr)



dones = (event) ->
  Scope.user = event.data.user
  index = event.data.index
  checkbox = event.target
  if checkbox.checked is true
    #console.log("user #{Scope.user.username} selected.")
    Scope.user.done = true
    Scope.usersdones.unshift(Scope.user) if Scope.usersdones.indexOf(Scope.user) is -1
    $('tr.user_tr'+index).addClass('done-true')
    #$('p#comment'+index).removeClass('comment_body_class')
  else
    #console.log("user #{Scope.user.username} deselected.")
    Scope.user.done = false
    Scope.usersdones.slice(Scope.usersdones.indexOf(Scope.user),1) if Scope.usersdones.indexOf(Scope.user) != -1
    $('tr.user_tr'+index).removeClass('done-true')

  for k, v of Scope.usersdones
    console.log(v.username)


allUsersSuccessCallback = (data) ->
  console.log("Users fetched successfully: #{data}")
  Scope.index = 0
  Scope.users = data
  $('h4.users_count').text(Scope.users.length+" utisateurs enregistrés.")
  Scope.user = Scope.users[Scope.index]
  console.log("first user : #{Scope.user.username}")
  displayUsers()


allUsersErrorCallback = (errors) ->


loadUsers()



