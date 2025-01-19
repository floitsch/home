// Copyright (C) 2025 Florian Loitsch <florian@loitsch.com>
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

// Pinout: https://devices.esphome.io/devices/Shelly-Plus-2PM#gpio-pinout

import gpio
import monitor

main:
  relay1 := gpio.Pin --output 13
  relay1.set 1
  latch := monitor.Latch
  // Keep running forever.
  latch.get
