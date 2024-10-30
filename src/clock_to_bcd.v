
/* clock_to_bcd.v
 * Copyright (c) 2024 Samuel Ellicott
 * SPDX-License-Identifier: Apache-2.0
 *
 * Convert the time inputs into bcd outputs for the 7-segment displays
 */

`default_nettype none

module clock_register (
  // global signals
  i_reset_n,
  i_clk,

  // Time inputs 
  i_hours,
  i_minutes,
  i_seconds,

  i_hours_h_dp,
  i_minutes_h_dp,
  i_seconds_h_dp,
  i_seconds_l_dp,

  // bcd outputs
  o_hours_h_bcd,
  o_hours_l_bcd,
  o_minutes_h_bcd,
  o_minutes_l_bcd,
  o_seconds_h_bcd,
  o_seconds_l_bcd,

  o_dp_segs
);

// global signals
input wire i_reset_n;
input wire i_clk;

// input wires
input wire [4:0] i_hours;
input wire [5:0] i_minutes;
input wire [5:0] i_seconds;

// output display segments
output wire [3:0] o_hours_h_bcd;
output wire [3:0] o_hours_l_bcd;
output wire [3:0] o_minutes_h_bcd;
output wire [3:0] o_minutes_l_bcd;
output wire [3:0] o_seconds_h_bcd;
output wire [3:0] o_seconds_l_bcd;
output wire [5:0] o_dp_segs;

binary_to_bcd hours_conv_inst (
  .i_binary ({2'h0, i_hours}),
  .o_bcd_h  (o_hours_h_bcd),
  .o_bcd_l  (o_hours_l_bcd)
);

binary_to_bcd minutes_conv_inst (
  .i_binary ({1'h0, i_minutes}),
  .o_bcd_h  (o_minutes_h_bcd),
  .o_bcd_l  (o_minutes_l_bcd)
);

binary_to_bcd seconds_conv_inst (
  .i_binary ({1'h0, i_seconds}),
  .o_bcd_h  (o_seconds_h_bcd),
  .o_bcd_l  (o_seconds_l_bcd)
);

endmodule
