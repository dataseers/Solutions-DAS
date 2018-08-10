export class Comm {

  static getData(serviceURL, serviceContent, respType, obj)  {
    return fetch('/api/chart-service', {
      method: 'post',
      headers: new Headers({
        'Content-Type': 'application/json',
        'Authorization' : 'Basic' +btoa('gbandasha','Nish@123'),
      }),
      body: JSON.stringify({
        "url": serviceURL, "content": serviceContent
      })
    }).then(function (response) {
      return response.json();
    }).then(function (data) {
      obj.receiveData(respType, data);
    }).catch(error => console.error(error));
  }
  
}
