module refreshcontrol(
input wire clk,
    input wire rst,
    output reg refresh
);

    // Internal counter to track refresh cycles
    reg [11:0] refresh_counter;

    // Refresh interval (adjust based on specifications)
    parameter REFRESH_INTERVAL = 4096;

    // Process for refresh control
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset values on reset signal
            refresh_counter <= 12'h0;
            refresh <= 1'b0;
        end else begin
            // Increment the refresh counter
            refresh_counter <= refresh_counter + 1;

            // Check for refresh condition
            if (refresh_counter == REFRESH_INTERVAL) begin
                refresh <= 1'b1;
                refresh_counter <= 12'h0;  // Reset the counter after refresh
            end else begin
                refresh <= 1'b0;
            end
        end
    end

endmodule
