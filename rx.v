module bpsk_rx_sync (
    input  wire clk,
    input  wire rst,
    input  wire symbol_tick,
    input  wire signed [15:0] rx_in,
    input  wire [31:0] phase_step,
    output reg  bit_out
);

wire [31:0] phase;
wire signed [15:0] sine, cosine;
wire signed [31:0] mixed;

reg signed [47:0] acc;

// scaling
localparam signed [15:0] An = 16'sd19400;

// delayed symbol tick (CORDIC latency = 16)
wire symbol_tick_d;
delay #(.WIDTH(1), .DEPTH(16)) sym_delay (
    .clk(clk),
    .din(symbol_tick),
    .dout(symbol_tick_d)
);

phase_accumulator PA (
    .clk(clk),
    .rst(rst),
    .phase_step(phase_step),
    .phase(phase)
);

CORDIC cordic_inst (
    .clock(clk),
    .x_start(An),
    .y_start(0),
    .angle(phase),
    .cosine(cosine),
    .sine(sine)
);

assign mixed = rx_in * cosine;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        acc     <= 0;
        bit_out <= 0;
    end
    else begin
        acc <= acc + mixed;

        if (symbol_tick_d) begin
            bit_out <= (acc >= 0);
            acc <= 0;
        end
    end
end

endmodule
