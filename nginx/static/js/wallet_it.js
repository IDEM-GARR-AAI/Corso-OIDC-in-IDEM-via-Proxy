
// ## wallet ##
// This class monitor button with class '.ita .ita-button[data-wallet]'
class Wallet {
  // get the qrcode data url as option for costructor 
  // if is present almost an ita-button[data-wallet] run add-observer
  constructor(url) {
    this.url = url
    this.elements = document.querySelectorAll('.ita .ita-button[data-wallet]')
    if (this.elements.length > 0 ) { this.add_observer() }
  }

  // add an observer for each vutton[data-wallet]
  // on click execute wallet_get
  add_observer () {
    for (var u = 0; u < this.elements.length; u++) {
      this.elements[u].addEventListener('click', ()=> {
        this.wallet_get()
      });
    }
  }

  // Try to get qrcode data from url and populate the wallet
  async wallet_get() {
    try {
      const response = await fetch(this.url);
      if (response.ok) { 
        this.wallet_populate(await response.json()) 
      }
    } catch (error) {
      console.log(error)
    }
  }

  // add qrcode from data
  wallet_populate(data) {
    let qrcode = document.getElementById("qrcode")
    qrcode.innerHTML = ''
    new QRCode(qrcode, data["code"]);
    console.log(data)
  }
}
