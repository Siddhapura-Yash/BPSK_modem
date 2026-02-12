module bpsk_mod (
    input  wire clk,
    input  wire bit_in,
    input  wire signed [15:0] carrier,
    output reg  signed [15:0] bpsk_out
);

always @(posedge clk) begin
    if (bit_in)
        bpsk_out <= carrier;
    else
        bpsk_out <= -carrier;
end

endmodule
