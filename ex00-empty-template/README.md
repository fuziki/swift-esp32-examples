# ex00-empty-template

## Overview

This is a copy of the [Empty Template](https://github.com/apple/swift-matter-examples/tree/main/empty-template) from the swift-matter-examples repository.

## Circuit Diagram

No connections are required.

## Execution Steps

1. Set the target to ESP32-C6:
   ```bash
   $ idf.py set-target esp32c6
   ```
   
2. Connect your ESP32 to the PC, build, and flash the application:
   ```bash
   $ idf.py build flash monitor
   ```

3. A message will appear in the terminal:
   ```text
   🏎️ Hello, Embedded Swift!
   ```
