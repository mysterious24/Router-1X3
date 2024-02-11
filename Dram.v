
module Dram(
    input  clk,        // Clock input
    input  rst,        // Reset input
    input  [4:0] col_addr,  // 5-bit column address
    input  [31:0] data_in,  // 32-bit data input
    output reg [31:0] data_out, // 32-bit data output
    input  [4:0] row_addr,   // 5-bit row address
    input  [2:0] cs,         // Chip select
    input  [2:0] rw,         // Read/Write
    input  [1:0] oe,         // Output Enable
    input  [2:0] refresh     // External refresh
);

// Internal memory array
reg [31:0] memory [0:31];

// Process for read and write operations
always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Reset values on reset signal
        data_out <= 32'b0; // Initialize data_out in the reset condition
    end else begin
        // Read operation
        if (cs == 3'b001 && rw == 3'b001 && oe == 2'b01) begin
            data_out <= memory[col_addr];
        end
        // Write operation
        else if (cs == 3'b001 && rw == 3'b010 && oe == 2'b10) begin
            memory[col_addr] <= data_in;
        end
        // Additional conditions for other operations...
    end
end

endmodule

