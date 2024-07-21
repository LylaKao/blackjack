import { Controller } from "@hotwired/stimulus"

// export default class extends Controller {
//   connect() {
//     this.element.textContent = "Hello World!"
//   }
// }

import gameChannel from "channels/game_channel"

export default class extends Controller {
  static targets = ["message"]

  send(event) {
    event.preventDefault()
    gameChannel.send({ message: this.messageTarget.value })
    this.messageTarget.value = "";
  }
}