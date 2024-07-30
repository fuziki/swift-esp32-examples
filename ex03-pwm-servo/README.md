# Example 03: PWM Servo

## Building and running the example

For full steps how to build the example code, follow the [Setup Your Environment](https://apple.github.io/swift-embedded/swift-matter-examples/tutorials/tutorial-table-of-contents#setup-your-environment) tutorials and the "Build and Run" section of the [Explore the LED Blink example](https://apple.github.io/swift-matter-examples/tutorials/swiftmatterexamples/run-example-led-blink) tutorial. In summary:

- Ensure your system has all the required software installed and your shell has access to the tools listed in the top-level README file.
- Plug in the ESP32C6 development board via a USB cable.

1. Clone the repository and navigate to the `ex03-pwm-servo` example.
  ```shell
  $ git clone https://github.com/fuziki/swift-esp32-examples.git
  $ cd swift-matter-examples/ex03-pwm-servo
  ```

2. Configure the build system for your microcontroller.
  ```shell
  $ idf.py set-target esp32c6
  ```

3. Build and deploy the application to your device. 
  ```shell
  $ idf.py build flash monitor
  ```

4. Observe that in the device logs, the log message from Embedded Swift shows up:
  ```shell
  🏎️ Hello, Embedded Swift! (Digital IO)
  ```
