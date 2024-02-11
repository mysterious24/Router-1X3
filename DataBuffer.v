module DataBuffer (
    input  clk,
    input  rst,
    input  [31:0] data_input,
    input  ie, // Input Enable
    input  oe, // Output Enable
    output wire [31:0] data_output
);

    reg [31:0] input_buffer;
    reg [31:0] output_buffer;
    reg prev_ie; // Previous input enable
    reg prev_oe; // Previous output enable

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset values on reset signal
            input_buffer <= 32'b0;
            output_buffer <= 32'b0;
            prev_ie <= 1'b0;
            prev_oe <= 1'b0;
        end else begin
            // Store input data only when input enable transitions from low to high
            if (ie && ~prev_ie) begin
                input_buffer <= data_input;
            end

            // Store output data only when output enable transitions from low to high
            if (oe && ~prev_oe) begin
                output_buffer <= input_buffer;
            end

            // Update previous input and output enable values
            prev_ie <= ie;
            prev_oe <= oe;
        end
    end

    // Output the stored data
    assign data_output = output_buffer;

endmodule
