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
    print("🏎️   Hello, Embedded Swift! (I2C LCD)")

    let I2C_BUS_PORT: Int32 = 0

    let EXAMPLE_LCD_PIXEL_CLOCK_HZ: UInt32 =    (400 * 1000)
    let EXAMPLE_PIN_NUM_SDA = GPIO_NUM_6
    let EXAMPLE_PIN_NUM_SCL = GPIO_NUM_7
    let EXAMPLE_PIN_NUM_RST: Int32 =           -1
    let EXAMPLE_I2C_HW_ADDR: UInt32 =           0x3C

    let EXAMPLE_LCD_H_RES: UInt32 =              128
    let EXAMPLE_LCD_V_RES: UInt32 =              64

    let EXAMPLE_LCD_CMD_BITS: Int32 =           8

    var i2c_bus: i2c_master_bus_handle_t!
    var bus_config: i2c_master_bus_config_t = .init(
        i2c_port: I2C_BUS_PORT,
        sda_io_num: EXAMPLE_PIN_NUM_SDA,
        scl_io_num: EXAMPLE_PIN_NUM_SCL,
        clk_source: I2C_CLK_SRC_DEFAULT,
        glitch_ignore_cnt: 7,
        intr_priority: 0,
        trans_queue_depth: 0,
        flags: .init(enable_internal_pullup: 1)
    )
    i2c_new_master_bus(&bus_config, &i2c_bus)

    var io_handle: esp_lcd_panel_io_handle_t!
    var io_config: esp_lcd_panel_io_i2c_config_t = .init(
        dev_addr: EXAMPLE_I2C_HW_ADDR,
        on_color_trans_done: nil,
        user_ctx: nil,
        control_phase_bytes: 1,
        dc_bit_offset: 6,
        lcd_cmd_bits: EXAMPLE_LCD_CMD_BITS,
        lcd_param_bits: EXAMPLE_LCD_CMD_BITS,
        flags: .init(),
        scl_speed_hz: EXAMPLE_LCD_PIXEL_CLOCK_HZ
    )
    esp_lcd_new_panel_io_i2c_v2(i2c_bus, &io_config, &io_handle)

    var panel_handle: esp_lcd_panel_handle_t!
    var panel_config: esp_lcd_panel_dev_config_t = .init(
        reset_gpio_num: EXAMPLE_PIN_NUM_RST,
        .init(),
        data_endian: .init(0),
        bits_per_pixel: 1,
        flags: .init(),
        vendor_config: nil
    )
    esp_lcd_new_panel_ssd1306(io_handle, &panel_config, &panel_handle)

    esp_lcd_panel_reset(panel_handle)
    esp_lcd_panel_init(panel_handle)
    esp_lcd_panel_disp_on_off(panel_handle, true)

    var lvgl_cfg: lvgl_port_cfg_t = .init(
        task_priority: 4,
        task_stack: 4096,
        task_affinity: -1,
        task_max_sleep_ms: 500,
        timer_period_ms: 5
    )
    lvgl_port_init(&lvgl_cfg)

    var disp_cfg: lvgl_port_display_cfg_t = .init(
        io_handle: io_handle,
        panel_handle: panel_handle,
        buffer_size: EXAMPLE_LCD_H_RES * EXAMPLE_LCD_V_RES,
        double_buffer: true,
        hres: EXAMPLE_LCD_H_RES,
        vres: EXAMPLE_LCD_V_RES,
        monochrome: true,
        // rotate 180degree
        rotation: .init(swap_xy: false, mirror_x: true, mirror_y: true),
        flags: .init()
    )
    let disp: UnsafeMutablePointer<lv_disp_t>! = lvgl_port_add_disp(&disp_cfg)
    lv_disp_set_rotation(disp, LV_DISP_ROT_NONE)

    if (lvgl_port_lock(0)) {
        example_lvgl_demo_ui(disp);
        // Release the mutex
        lvgl_port_unlock();
    }
}

func example_lvgl_demo_ui(_ disp: UnsafeMutablePointer<lv_disp_t>) {
    let scr = lv_disp_get_scr_act(disp)
    let label = lv_label_create(scr)
    lv_label_set_long_mode(label, lv_label_long_mode_t(LV_LABEL_LONG_SCROLL_CIRCULAR))
    lv_label_set_text(label, "Hello, world!! by Embed Swift!")
    /* Size of the screen (if you use rotation 90 or 270, please set disp->driver->ver_res) */
    lv_obj_set_width(label, disp.pointee.driver.pointee.hor_res)
    lv_obj_align(label, lv_align_t(LV_ALIGN_TOP_MID), 0, 0)
}
