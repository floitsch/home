// Copyright (C) 2025 Florian Loitsch <florian@loitsch.com>
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

// Pinout: https://devices.esphome.io/devices/Shelly-Plus-2PM#gpio-pinout

import gpio
import monitor

main:
  // Plug is always on (for now).
  relay2 := gpio.Pin --output 13
  relay2.set 1

  state := 0
  relay1 := gpio.Pin --output 12
  relay1.set state

  switch1 := gpio.Pin --input 5
  current := switch1.get
  while true:
    next := 1 - current
    switch1.wait-for next
    state = 1 - state
    relay1.set state
    // Debounce
    sleep --ms=100
    current = next
