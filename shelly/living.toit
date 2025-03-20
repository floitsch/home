// Copyright (C) 2025 Florian Loitsch <florian@loitsch.com>
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

// Pinout: https://devices.esphome.io/devices/Shelly-Plus-2PM#gpio-pinout

import gpio
import monitor

main:
  relay1 := gpio.Pin --output 13

  state := 0
  relay1.set state

  task::
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

  task::
    switch2 := gpio.Pin --input 18
    while true:
      switch2.wait-for 1
      state = 1 - state
      relay1.set state
      // Debounce
      sleep --ms=100
      switch2.wait-for 0
      // Debounce
      sleep --ms=100
