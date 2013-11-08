
/**
Function.prototype.extends = function(parent){
    if(parent.constructor == Function){
        //normal Inheritance
        this.prototype = new parent;
        this.prototype.constructor = this;
        this.prototype.parent = parent.prototype;
    }else{
        // Pure Virtual Inheritance
        this.prototype = parent;
        this.prototype.constructor = this;
        this.prototype.parent = parent.prototype;
    }
    return this;
}

var Mammal = function (name){
    this.name = name;
    this.offspring = [];
    this.toString = function(){
        return "[ Mammal "+this.name+" ]";
    };
}

Mammal.prototype.haveABaby=function(){
    var newBaby=new Mammal('Baby '+this.name);
    this.offspring.push(newBaby);
    return newBaby;
}


var Cat = function(name){
    this.name = name;
    //this.toString = function(){
    //    return "[ Cat "+this.name+" ]";
    //};
}

Cat.extends(Mammal);
Cat.prototype.haveABaby=function(){
    this.parent.haveABaby.call(this);
}



var AbstractHttp =   function(params){
    this.goodMorningTest = function(name){
        console.log("Good morning "+ name);
    };
    this.user = (typeof(params.user) !== 'undefined') ? params.user: null;
    this.password = ( typeof(params.password) !== 'undefined') ? params.password: null;
    this.type = (params.type) ? params.type :  null;
    this.url  = (params.url) ? params.url : null;
    this.dataType = (params.dataType) ? params.dataType : 'json';
    this.data = (params.data) ? params.data :  null;
    this.success = (params.success && typeof(prams.success) === 'function') ? params.success :  null;
    this.error = (params.error && typeof(prams.error) === 'function') ? params.error :  null;
    this.request = new XMLHttpRequest();
    this.response = null;
    this.processRequest = function(){
        this.request.open(this.type,this.url,true,this.user,this.password);
        this.request.onreadystatechange = this.processResponse;
        this.send(this.data);

    };


    this.processResponse = function(){
      if(this.readyState ==  4){
          if(this.status ==  200){
              switch(this.dataType){
                  case 'text':
                      this.response = this.responseText;
                      break;
                  case 'xml':
                      this.response = this.responseXML;
                      break;
                  default:
                      this.response = this.responseJSON;
                      break;
              }
              this.success(this.response, this.status, this);
          }else{ // something went wrong
               this.response = this.response;
               this.error(this.response,this.status,this);
          }
      }
    };

};

var Article = function(params){
   this.params = params;

}

Article.extends(new AbstractHttp({

}));


 */
