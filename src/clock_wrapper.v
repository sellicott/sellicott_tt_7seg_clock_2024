/*
 * clock_wrapper.v
 * author: Samuel Ellicott
 * date:  11/03/23 
 * Wrap all the important bits of the clock for tiny tapeout
 * This includes the
 * - button debouncing
 * - time register
 * - binary to BCD converter
 * - BCD to 7-segment display
 * - 7-segment serializer
 */
`timescale 1ns / 1ns
`default_nettype none

module clock_wrapper (
  i_reset_n,      // syncronous reset (active low)
  i_clk,          // fast system clock (~50MHz)
  i_refclk,       // 32.768 kHz clock
  i_en,           // enable the clock 
  i_fast_set,     // select the timeset speed (1 for fast, 0 for slow)
  i_use_refclk,   // select between the system clock and an external reference
  i_set_hours,    // stop updating time (from refclk) and set hours
  i_set_minutes,  // stop updating time (from refclk) and set minutes

  o_serial_data,
  o_serial_latch,
  o_serial_clk
);

  parameter SYS_CLK_HZ   =  5_000_000;
  parameter REF_CLK_HZ   =     32_768;
  parameter DEBOUNCE_SAMPLES = 5;
  
  input wire i_reset_n;
  input wire i_clk;
  input wire i_refclk;
  input wire i_en;
  input wire i_fast_set;
  input wire i_use_refclk;
  input wire i_set_hours;
  input wire i_set_minutes;
  
  output wire o_serial_data;
  output wire o_serial_latch;
  output wire o_serial_clk;
  
  wire [5:0] clock_seconds;
  wire [5:0] clock_minutes;
  wire [4:0] clock_hours;
  
  // BCD outputs for the display
  wire [3:0] hours_msb;
  wire [3:0] hours_lsb;
  wire [3:0] minutes_msb;
  wire [3:0] minutes_lsb;
  wire [3:0] seconds_msb;
  wire [3:0] seconds_lsb;

  // sync register
  wire refclk_sync;

  // blocks used to generate signals for the button debouncer
  // clock strobe generator
  wire clk_1hz_stb;
  wire clk_slow_set_stb;
  wire clk_fast_set_stb;
  wire clk_debounce_stb;
 
  refclk_sync refclk_sync_inst (
    .i_reset_n     (rst_n),
    .i_clk         (clk),
    .i_refclk      (refclk),
    .o_refclk_sync (refclk_sync)
  );

  clk_gen clk_gen_inst (
    .i_reset_n      (rst_n),
    .i_clk          (clk),
    .i_refclk       (refclk_sync),
    .o_1hz_stb      (clk_1hz_stb),
    .o_slow_set_stb (clk_slow_set_stb),
    .o_fast_set_stb (clk_fast_set_stb),
    .o_debounce_stb (clk_debounce_stb)
  );

  // Debounce button inputs
  wire clk_fast_set;
  wire clk_set_hours;
  wire clk_set_minutes;

  button_debounce input_debounce (
    .i_reset_n (rst_n),
    .i_clk     (clk),
    
    .i_debounce_stb (clk_debounce_stb),
    
    .i_fast_set    (i_fast_set),
    .i_set_hours   (i_set_hours),
    .i_set_minutes (i_set_minutes),
    
    .o_fast_set_db    (clk_fast_set),
    .o_set_hours_db   (clk_set_hours),
    .o_set_minutes_db (clk_set_minutes)
  );

  // Clock register
  wire [4:0] clk_hours;
  wire [5:0] clk_minutes;
  wire [5:0] clk_seconds;

  wire clk_set_stb = clk_fast_set ? clk_fast_set_stb : clk_slow_set_stb;

  clock_register clock_reg_inst (
    // global signals
    .i_reset_n (rst_n),
    .i_clk     (clk),

    // timing strobes
    .i_1hz_stb (clk_1hz_stb),
    .i_set_stb (clk_set_stb),

    // clock setting inputs
    .i_set_hours   (clk_set_hours),
    .i_set_minutes (clk_set_minutes),

    // time outputs
    .o_hours   (clk_hours),
    .o_minutes (clk_minutes),
    .o_seconds (clk_seconds)
  );

  wire [5:0] seg_dp;
  wire [3:0] seg_select;
  wire [7:0] disp_7seg;

  clock_to_7seg disp_out (
    .i_clk     (i_clk),
    .i_reset_n (i_reset_n),

    .i_hours   (clk_hours),
    .i_minutes (clk_minutes),
    .i_seconds (clk_seconds),
    .i_dp      (seg_dp),

    .i_seg_select (seg_select),

    .o_7seg (disp_7seg)
  );

  /* verilator lint_off UNUSED */
  wire serial_busy;
  /* verilator lint_on  UNUSED */

  output_wrapper #(
    .SYS_CLK_HZ(SYS_CLK_HZ),
    .SHIFT_CLK_HZ(SHIFT_CLK_HZ)
  ) shift_out_inst (
    .i_clk(i_clk),
    .i_reset_n(i_reset_n),
    .i_en(i_en),
    .i_start_stb(shift_out_stb_delay[3]),
    .o_busy(serial_busy),

    .i_hours_msb(hours_msb),
    .i_hours_lsb(hours_lsb),
    .i_minutes_msb(minutes_msb),
    .i_minutes_lsb(minutes_lsb),
    .i_seconds_msb(seconds_msb),
    .i_seconds_lsb(seconds_lsb),
    .i_dp_hours1(1'b0),
    .i_dp_hours2(1'b0),
    .i_dp_minutes1(colon_blink),
    .i_dp_minutes2(colon_blink),
    .i_dp_seconds1(1'b0),
    .i_dp_seconds2(1'b0),

    .o_serial_data(o_serial_data),
    .o_serial_latch(o_serial_latch),
    .o_serial_clk(o_serial_clk)
  );

endmodule
