module rowaddress_buffer (
    input wire clk,
    input wire ras,       // Row Access Strobe
    input wire [4:0] row_address_input,
    output reg [4:0] row_address_output
);

    reg [4:0] stored_row_address;

    always @(posedge clk) begin
        if (ras) begin
            // If RAS is asserted, latch the new row address
            stored_row_address <= row_address_input;
        end
    end

    // Output the stored row address
    assign row_address_output = stored_row_address;

endmodulei
