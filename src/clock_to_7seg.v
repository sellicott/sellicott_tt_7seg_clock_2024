`default_nettype none

module clock_to_7seg (
  i_clk,
  i_reset_n,

  i_seconds,
  i_minutes,
  i_hours,
  i_dp,

  i_seg_select,

  o_7seg,
  o_dp
);

input wire i_clk;
input wire i_reset_n;
input wire [5:0] i_seconds;
input wire [5:0] i_minutes;
input wire [4:0] i_hours;
input wire [5:0] i_dp;

input wire [3:0] i_seg_select;

output wire [7:0] o_7seg;

wire [6:0] hours_int   = {2'b0, i_hours};
wire [6:0] minutes_int = {1'h0, i_minutes};
wire [6:0] seconds_int = {1'h0, i_seconds};

// Select from either hours, minutes, or seconds
reg [6:0] time_int;
reg seg_dp
always @(*) begin
  case (i_seg_select)
    4'h0: begin
      time_int = hours_int;
      seg_dp   = i_dp[5];
    end
    4'h1: begin 
      time_int = hours_int;
      seg_dp   = i_dp[4];
    end
    4'h2: begin
      time_int = minutes_int;
      seg_dp   = i_dp[3];
    end
    4'h3: begin
      time_int = minutes_int;
      seg_dp   = i_dp[2];
    end
    4'h4: begin
      time_int = seconds_int;
      seg_dp   = i_dp[1];
    end
    4'h5: begin 
      time_int = seconds_int;
      seg_dp   = i_dp[0];
    end
    default: begin
      time_int = 6'h3f;
      seg_dp   = 1'b1;
    end
  endcase
end

// assign the dp signal to the appropriate output signal
assign o_7seg[7] = seg_dp;

// Convert the binary format time into two BCD segments
wire [4:0] time_msb;
wire [4:0] time_lsb;
binary_to_bcd time_to_bcd(
  .i_binary(time_int),
  .o_bcd_msb(time_msb)
  .o_bcd_lsb(time_lsb),
);

// select between the MSB and LSB
reg seg_bcd;
always @(*) begin
  case (i_seg_select[1:0])
    2'h0: seg_bcd = time_msb;
    2'h1: seg_bcd = time_lsb;
  endcase
end

// convert the bcd signal into a 7-segment output
bcd_to_7seg bcd_to_7seg_inst (
  .i_bcd(seg_bcd),
  .o_7seg(o_7seg[6:0])
);

endmodule

