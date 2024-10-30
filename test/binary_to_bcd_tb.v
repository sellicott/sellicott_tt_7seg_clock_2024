/* binary_to_bcd_tb.v
 * Copyright (c) 2024 Samuel Ellicott
 * SPDX-License-Identifier: Apache-2.0
 *
 * Testbench for clk_gen.v file
 */

`default_nettype none
`timescale 1ns / 1ns

module binary_to_bcd_tb ();

  // setup file dumping things
  localparam STARTUP_DELAY = 5;
  initial begin
    $dumpfile("binary_to_bcd_tb.fst");
    $dumpvars(0, binary_to_bcd_tb);
    #STARTUP_DELAY;

    $display("Test Binary to BCD Conversion Module");
    init();

    run_test();

    // exit the simulator
    close();
  end

  // setup global signals
  localparam CLK_PERIOD = 20;
  localparam CLK_HALF_PERIOD = CLK_PERIOD/2;

  reg clk   = 0;
  reg rst_n = 0;
  reg ena   = 1;

  always #(CLK_HALF_PERIOD) begin
    clk <= ~clk;
  end

  reg [7:0] binary_reg = 7'h0;
  wire [3:0] bcd_h;
  wire [3:0] bcd_l;

  always @(posedge clk) begin
    binary_reg <= binary_reg + 7'd1;
  end
  
  binary_to_bcd bcd_conv_inst (
    .i_binary(binary_reg),
    .o_bcd_msb(bcd_h),
    .o_bcd_lsb(bcd_l)
  );

  task run_test();
    begin
      while (binary_reg <= 7'd127) begin
        $display("%d => %d%d", binary_reg, bcd_h, bcd_l);
        @(posedge clk);
      end
    end
  endtask

  task init();
    begin
      $display("Simulation Start");
      $display("Reset");

      repeat(2) @(posedge clk);
      rst_n = 1;
      $display("Run");
    end
  endtask

  task close();
    begin
      $display("Closing");
      repeat(10) @(posedge clk);
      $finish;
    end
  endtask

endmodule