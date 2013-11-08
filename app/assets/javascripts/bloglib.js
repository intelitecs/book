function formatDateFr(date){
    var months =["Janvier","Février","Mars","Avril","Mai","Juin","Juillet","Âout","Septembre","Octobre","Novembre","Décembre"];
    var dateArray = date.split('-');

    dateArray[dateArray.length -1] = dateArray[dateArray.length -1].substr(0,2);
    dateArray[1] = months[dateArray[1]-1];
    date = dateArray[2]+ " "+ dateArray[1] + " "+dateArray[0];

    return date;

}

/**
$(function(){
    function displayCreateArticleForm(event){
        var newArticleFormElement = event.data.form;
        $('body').html(newArticleFormElement).find('body');

    }


    $.ajax({
        url:'/articles/new',
        type:'GET',
        dataType: 'HTML',
        success: articleFormPageSuccess,
        error: articleFormPageError
    })

    function articleFormPageSuccess(data){
        //console.log("data: "+data);
        var form = data;
        $('i.article-create').on('click',{form: form}, displayCreateArticleForm);
    }
    function articleFormPageError(errors){
        console.log(errors);
    }

});
   */