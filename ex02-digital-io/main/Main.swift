//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift open source project
//
// Copyright (c) 2024 Apple Inc. and the Swift project authors.
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//

let ledPin: gpio_num_t = GPIO_NUM_21
let buttonPin: gpio_num_t = GPIO_NUM_22

func sleep(sec: Double) {
    _usleep(UInt32(sec * 1_000_000))
}

@_cdecl("app_main")
func app_main() {
    print("🏎️   Hello, Embedded Swift! (Digital IO)")

    // LED
    gpio_reset_pin(ledPin);
    gpio_set_direction(ledPin, GPIO_MODE_OUTPUT)

    // Button
    gpio_reset_pin(buttonPin);
    gpio_set_direction(buttonPin, GPIO_MODE_INPUT)
    gpio_set_pull_mode(buttonPin, GPIO_PULLUP_ONLY)

    while true {
        if gpio_get_level(buttonPin) == 0 {
            for _ in 0..<5 {
                gpio_set_level(ledPin, 1)
                sleep(sec: 0.2)
                gpio_set_level(ledPin, 0)
                sleep(sec: 0.2)
            }
        }
        sleep(sec: 0.1)
    }
}
