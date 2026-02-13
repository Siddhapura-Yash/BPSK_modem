module bpsk_tx (
    input  wire clk,
    input  wire rst,
    input  wire bit_in,
    input  wire [31:0] phase_step,
    output wire signed [15:0] bpsk_out
);

wire [31:0] phase;
wire signed [15:0] sine, cosine;

// CORDIC input scaling
localparam signed [15:0] An = 16'sd19400;

// Phase accumulator
phase_accumulator PA (
    .clk(clk),
    .rst(rst),
    .phase_step(phase_step),
    .phase(phase)
);

// CORDIC NCO
CORDIC cordic_inst (
    .clock(clk),
    .x_start(An),
    .y_start(0),
    .angle(phase),
    .cosine(cosine),
    .sine(sine)
);

// BPSK modulation
bpsk_mod mod_inst (
    .carrier(cosine),
    .bit_in(bit_in),
    .bpsk_out(bpsk_out)
);


endmodule
