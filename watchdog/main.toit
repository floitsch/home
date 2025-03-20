// Copyright (C) 2025 Florian Loitsch <florian@loitsch.com>
// Use of this source code is governed by an MIT-style license that can be
// found in the LICENSE file.

import certificate-roots
import http
import gpio
import net

reset-count := 0

relay-pin := gpio.Pin 2 --output
button-pin := gpio.Pin 0 --input --pull-up

main:
  set-plug true
  certificate-roots.install-common-trusted-roots
  task::
    while true:
      sleep (Duration --m=10)
      catch --trace: check-health

  while true:
    catch --trace: run-server
    sleep --ms=5_000

check-health:
  network := net.open
  client/http.Client? := null
  try:
    client = http.Client network
    response := client.get --uri="https://sign.toit.io"
    if response.status-code != 200:
      print "Failed to connect to Toit server"
      reset-hp
    else:
      print "Health check succeeded"
  finally:
    if client: client.close
    network.close

set-plug value/bool:
  relay-pin.set (value ? 1 : 0)

reset-hp:
  reset-count++
  set-plug false
  sleep --ms=1_000
  set-plug true

run-server:
  network := net.open
  try:
    // Listen on a free port.
    tcp-socket := network.tcp-listen 80
    print "Server on http://$network.address:$tcp-socket.local-address.port/"
    server := http.Server --max-tasks=5
    server.listen tcp-socket:: | request/http.RequestIncoming writer/http.ResponseWriter |
      resource := request.query.resource
      if resource == "/" or resource == "/index.html":
        writer.headers.set "Content-Type" "text/html"
        writer.out.write """
          <html>
            <body>
              <p>Running.</p>
              <p>Reset count: $reset-count</p>
            </body>
          </html>
          """
      else:
        writer.headers.set "Content-Type" "text/plain"
        writer.write-headers 404
        writer.out.write "Not found\n"
      writer.close
  finally:
    network.close
