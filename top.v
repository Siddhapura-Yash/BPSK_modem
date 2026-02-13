module bpsk_modem (
    input  wire clk,
    input  wire rst,
    input  wire bit_in,
    input  wire symbol_tick,
    input  wire [31:0] phase_step,
    output wire rx_bit,
    output wire signed [15:0] tx_signal
);

bpsk_tx tx_inst (
    .clk(clk),
    .rst(rst),
    .bit_in(bit_in),
    .phase_step(phase_step),
    .bpsk_out(tx_signal)
);

bpsk_rx_sync rx_inst (
    .clk(clk),
    .rst(rst),
    .symbol_tick(symbol_tick),
    .rx_in(tx_signal),
    .phase_step(phase_step),
    .bit_out(rx_bit)
);

endmodule
