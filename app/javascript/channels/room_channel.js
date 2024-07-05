import consumer from "channels/consumer"

let consumer1 = consumer.subscriptions.create("RoomChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log('Hello')
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log('received data: ', data)
    if(data['msg']!='') {
      const messageContainer = document.getElementById('messages');
      const messageElement = document.createElement('div');
      messageElement.innerHTML = data['msg'];
      messageContainer.appendChild(messageElement);
    }
  },

  speak(msg) {
    console.log('msg: ', msg)
    this.perform('speak', {msg: msg})
  }
});

// 監聽使用者輸入事件
document.addEventListener('DOMContentLoaded', function(e){
  var inputField = document.getElementById('input');

  inputField.addEventListener('keydown', function(event) {
    if (event.keyCode === 13) {
      event.preventDefault();
      const message = inputField.value;
      consumer1.speak(message)
      inputField.value = '';
    }
  });
})

// consumer.subscriptions.create("RoomChannel", {
//   connected() {
//     // Called when the subscription is ready for use on the server
//     console.log('Hello')
//   },

//   disconnected() {
//     // Called when the subscription has been terminated by the server
//   },

//   received(data) {
//     // Called when there's incoming data on the websocket for this channel
//   }
// });
