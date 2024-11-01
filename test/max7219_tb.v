/* max7219_tb.v
 * Copyright (c) 2024 Samuel Ellicott
 * SPDX-License-Identifier: Apache-2.0
 *
 * Testbench for max7219 driver
 */

`default_nettype none
`timescale 1ns / 1ns

`define assert(signal, value) \
  if (signal != value) begin \
    $display("ASSERTION FAILED in %m:\n\t 0x%H (actual) != 0x%H (expected)", signal, value); \
    close(); \
  end

`define assert_cond(signal, cond, value) \
  if (!(signal cond value)) begin \
    $display("ASSERTION FAILED in %m:\n\t 0x%H (actual) != 0x%H (expected)", signal, value); \
    close(); \
  end

module max7219_tb ();

  // setup file dumping things
  localparam STARTUP_DELAY = 5;
  initial begin
    $dumpfile("max7219_tb.fst");
    $dumpvars(0, max7219_tb);
    #STARTUP_DELAY;

    $display("Test max7219 driver");
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

  reg run_timeout_counter;
  reg [15:0] timeout_counter = 0;
  always @(posedge clk) begin
    if (run_timeout_counter)
      timeout_counter <= timeout_counter + 1'd1;
    else 
      timeout_counter <= 16'h0;
  end

  reg stb;
  wire busy;
  wire ack;
  reg [3:0] addr;
  reg [7:0] data;

  wire serial_din = 0;
  wire serial_dout;
  wire serial_load;
  wire serial_clk;


  max7219 disp_driver (
    .i_reset_n (rst_n),
    .i_clk     (clk),
    .i_stb     (stb),
    .o_busy    (busy),
    .o_ack     (ack),

    .i_addr (addr),
    .i_data (data),

    .i_serial_din  (serial_din),
    .o_serial_dout (serial_dout),
    .o_serial_load (serial_load),
    .o_serial_clk  (serial_clk)
  );

  localparam TIMEOUT=64;
  task write_register (
    input [3:0] addr_t,
    input [7:0] data_t
  );
    begin
      $display("Write Data:\n\tAddress: 0x%H\n\tData: 0x%H", addr_t, data_t);
      reset_timeout_counter();
      while (busy && timeout_counter <= TIMEOUT) @(posedge clk);
      `assert_cond(timeout_counter, <, TIMEOUT);

      reset_timeout_counter();
      addr = addr_t;
      data = data_t;
      stb = 1'd1;
      @(posedge clk);
      while(!busy)
        #1 stb = 1'd1;
      stb = 1'd0;
      while (busy && timeout_counter <= TIMEOUT) @(posedge clk);
      `assert_cond(timeout_counter, <, TIMEOUT);
      run_timeout_counter = 1'h0;
    end
  endtask

  task reset_timeout_counter();
    begin
      @(posedge clk);
      run_timeout_counter = 1'd0;
      @(posedge clk);
      run_timeout_counter = 1'd1;
    end
  endtask

  task run_test();
    begin
      write_register(4'h9, 8'hFF); // all digits use bcd converters
      write_register(4'hA, 8'h07); // write intensity register ~50%
      write_register(4'hB, 8'h05); // write scan limit
      write_register(4'hC, 8'h01); // turn on display
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
