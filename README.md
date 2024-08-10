# Swift ESP32 Examples

This repository provides a collection of examples for running Swift on the ESP32-C6 using Embedded Swift.  
The examples range from basic GPIO operations to controlling an LCD via I2C.  
This repository is based on and inspired by the examples from [Swift Matter Examples](https://github.com/apple/swift-matter-examples).  

https://github.com/apple/swift-matter-examples

## Example Overview

- **ex00-empty-template**: A minimal template to start new projects using Embedded Swift.
- **ex01-led-brink**: Blinks the onboard LED of the ESP32-C6-DevKitC-1-N8. 
- **ex02-digital-io**: Demonstrates digital input and output by controlling an LED with a button.
- **ex03-pwm-servo**: Controls a servo motor using PWM signals.
- **ex04-i2c-lcd**: Operates an SSD1306-based I2C LCD, displaying information on the screen.

## Environment Setup

To set up your environment and follow along with the examples, please refer to the official tutorial from Apple [here](https://apple.github.io/swift-matter-examples/tutorials/tutorial-table-of-contents).  

https://apple.github.io/swift-matter-examples/tutorials/tutorial-table-of-contents

## Installation

### Prerequisites

- Plug in the ESP32-C6 development board via a USB cable.
- Ensure that you have the necessary tools and environment set up as described in the tutorial linked above.

### Steps

1. **Clone the Repository**  
   Start by cloning this repository and navigating to the example you want to try, such as the `ex01-led-brink` example.
   ```bash
   $ git clone https://github.com/fuziki/swift-esp32-examples.git
   $ cd swift-esp32-examples/ex01-led-brink
   ```

2. **Configure the Build System**  
   Configure the build system for the ESP32-C6 microcontroller.  
   (Running . scripts/export.sh once after starting the terminal is sufficient.)
   ```bash
   $ . scripts/export.sh
   $ idf.py set-target esp32c6
   ```

4. **Build and Deploy**  
   Build the application and deploy it to your ESP32-C6 device.
   ```bash
   $ idf.py build flash monitor
   ```

5. **Observe the Output**  
   Once the deployment is complete, you should see the following log message on the device:
   ```text
   🏎️   Hello, Embedded Swift! (LED Blink)
   ```
