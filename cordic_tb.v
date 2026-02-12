`timescale 1ns/1ps

module bpsk_tx_tb;

reg clk;
reg rst;
reg bit_in;

wire signed [15:0] bpsk_out;

// Phase step for carrier frequency
// Example: ~1 MHz carrier with 50 MHz clock
parameter PHASE_STEP = 32'd85899346;

bpsk_tx dut (
    .clk(clk),
    .rst(rst),
    .bit_in(bit_in),
    .phase_step(PHASE_STEP),
    .bpsk_out(bpsk_out)
);

//////////////////////////////////////////////////
// Clock generation (50 MHz)
//////////////////////////////////////////////////
initial begin
    clk = 0;
    forever #10 clk = ~clk;   // 20 ns period → 50 MHz
end

//////////////////////////////////////////////////
// Stimulus
//////////////////////////////////////////////////
initial begin
    rst = 1;
    bit_in = 0;

    #100;
    rst = 0;

    // Send bit pattern: 1 1 0 0 1 0 1
    #1000 bit_in = 1;
    #1000 bit_in = 1;
    #1000 bit_in = 0;
    #1000 bit_in = 0;
    #1000 bit_in = 1;
    #1000 bit_in = 0;
    #1000 bit_in = 1;

    #3000;
    $finish;
end

//////////////////////////////////////////////////
// Monitor
//////////////////////////////////////////////////
initial begin
    $monitor("time=%0t bit=%b bpsk_out=%d",
              $time, bit_in, bpsk_out);
end

//////////////////////////////////////////////////
// VCD dump
//////////////////////////////////////////////////
initial begin
    $dumpfile("bpsk.vcd");
    $dumpvars(0, bpsk_tx_tb);
end

endmodule
