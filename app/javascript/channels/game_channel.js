import consumer from "channels/consumer"

export default consumer.subscriptions.create("GameChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log('Hello! game')
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
    console.log('Goodbye! game')
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log(data)
    // this.perform('handle_data', data)
    switch(data['type']) {
      case 'user_joined':
        this.show_user(data)
        break;
      case 'user_left':
        this.hide_user(data)
        break;
    }
  },

  show_user(data) {
    console.log('user_joined, show_user:' + data['seat_id'])
    let playerDiv = document.querySelector(`.player_${data['seat_id']}.list-group.h-100`);
    if (playerDiv) {
      playerDiv.style.display = 'block';

      let playerName = playerDiv.querySelector('.player-name');
      if (playerName) {
          playerName.textContent = data['nickname'];
      }

      let betElement = playerDiv.querySelector('.player-bet');
      if (betElement) {
          betElement.textContent = "Bet:" + data['bet'];
      }
    }
  },

  hide_user(data){
    console.log('user_left, hide_user:' + data['seat_id'])
    let playerDiv = document.querySelector(`.player_${data['seat_id']}.list-group.h-100`);
    if (playerDiv) {
        playerDiv.style.display = 'none';
    }
  }
});
