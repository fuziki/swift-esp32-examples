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

@_cdecl("app_main")
func app_main() {
    let servoPin = GPIO_NUM_23

    let SERVO_MIN_PULSEWIDTH_US: Int32 = 500
    let SERVO_MAX_PULSEWIDTH_US: Int32 = 2500
    let SERVO_MIN_DEGREE: Int32 =        -90
    let SERVO_MAX_DEGREE: Int32 =        90
    let SERVO_TIMEBASE_RESOLUTION_HZ: UInt32 = 1000000
    let SERVO_TIMEBASE_PERIOD: UInt32 = 20000
    
    func example_angle_to_compare(_ angle: Int32) -> UInt32 {
        UInt32((angle - SERVO_MIN_DEGREE) * (SERVO_MAX_PULSEWIDTH_US - SERVO_MIN_PULSEWIDTH_US) / (SERVO_MAX_DEGREE - SERVO_MIN_DEGREE) + SERVO_MIN_PULSEWIDTH_US)
    }
    
    var timer: mcpwm_timer_handle_t!
    var timer_config: mcpwm_timer_config_t! = .init(
        group_id: 0,
        clk_src: MCPWM_TIMER_CLK_SRC_DEFAULT,
        resolution_hz: SERVO_TIMEBASE_RESOLUTION_HZ,
        count_mode: MCPWM_TIMER_COUNT_MODE_UP,
        period_ticks: SERVO_TIMEBASE_PERIOD,
        intr_priority: 0,
        flags: .init(update_period_on_empty: 0, update_period_on_sync: 0))
    mcpwm_new_timer(&timer_config, &timer)
    
    var oper: mcpwm_oper_handle_t!
    var operator_config: mcpwm_operator_config_t = .init(group_id: 0, intr_priority: 0, flags: .init())
    mcpwm_new_operator(&operator_config, &oper)
    
    mcpwm_operator_connect_timer(oper, timer)
    
    var comparator: mcpwm_cmpr_handle_t!
    var comparator_config: mcpwm_comparator_config_t = .init(
        intr_priority: 0,
        flags: .init(
            update_cmp_on_tez: 1,
            update_cmp_on_tep: 0,
            update_cmp_on_sync: 0
        )
    )
    mcpwm_new_comparator(oper, &comparator_config, &comparator)
    
    var generator: mcpwm_gen_handle_t!
    var generator_config: mcpwm_generator_config_t = .init(
        gen_gpio_num: servoPin.rawValue,
        flags: .init()
    )
    mcpwm_new_generator(oper, &generator_config, &generator)
    mcpwm_comparator_set_compare_value(comparator, example_angle_to_compare(0))
    
    mcpwm_generator_set_action_on_timer_event(
        generator,
        mcpwm_gen_timer_event_action_t(
            direction: MCPWM_TIMER_DIRECTION_UP,
            event: MCPWM_TIMER_EVENT_EMPTY,
            action: MCPWM_GEN_ACTION_HIGH
        )
    )
    mcpwm_generator_set_action_on_compare_event(
        generator,
        mcpwm_gen_compare_event_action_t(
            direction: MCPWM_TIMER_DIRECTION_UP,
            comparator: comparator,
            action: MCPWM_GEN_ACTION_LOW)
    )
    mcpwm_timer_enable(timer)
    mcpwm_timer_start_stop(timer, MCPWM_TIMER_START_NO_STOP)

    print("🏎️   Hello, Embedded Swift! (PWM Servo)")

    while true {
        mcpwm_comparator_set_compare_value(comparator, example_angle_to_compare(-60))
        sleep(1)
        mcpwm_comparator_set_compare_value(comparator, example_angle_to_compare(60))
        sleep(1)
        mcpwm_comparator_set_compare_value(comparator, example_angle_to_compare(0))
        sleep(1)
    }
}
