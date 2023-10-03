(function () {
  const gpio = getP8Gpio();

  gpio.subscribe(function () {
    // The first GPIO pin tell us the length of the packet.
    const packetLength = gpio[0];
    let string = "";

    // GPIO pins are filled with numbers representing string characters (UTF-16 code units).
    // Read through each pin, pull out each value, map it to a character.
    for (let i = 1; i < packetLength; i++) {
      string += String.fromCharCode(gpio[i]);
    }

    // This string is a comma-delimited list of values. Turn it into an array.
    const result = string.split(",");

    const stats = {
      character: result[0],
      level: result[1],
      score: result[2],
      time: result[3],
    };

    window.dispatchEvent(
      new CustomEvent("levelwon", {
        detail: stats,
      })
    );
  });
})();
