module alu(
  input [4:0] operand_a,
  input [4:0] operand_b,
  input [4:0] operation_sel,
  input cin,
  output reg [4:0] alu_result
);

  // Arithmetic and Logical Operations
  always @* begin
    case(operation_sel)
      5'b00000: alu_result = {cin, operand_a + operand_b}; // ADD
      5'b00001: alu_result = {cin, operand_a - operand_b}; // SUBTRACT
      5'b00010: alu_result = {1'b0, operand_a * operand_b}; // MULTIPLY
      5'b00011: alu_result = {1'b0, operand_a % operand_b}; // REMAINDER (%REM)
      5'b00100: alu_result = {1'b0, operand_a & operand_b}; // AND
      5'b00101: alu_result = {1'b0, ~(operand_a & operand_b)}; // NAND
      5'b00110: alu_result = {1'b0, operand_a | operand_b}; // OR
      5'b00111: alu_result = {1'b0, ~(operand_a | operand_b)}; // NOR
      5'b01000: alu_result = {1'b0, operand_a ^ operand_b}; // XOR
      5'b01001: alu_result = {1'b0, ~(operand_a ^ operand_b)}; // XNOR
      5'b01010: alu_result = {1'b0, ~operand_a}; // NOT
      5'b01011: alu_result = {1'b0, operand_a}; // BUFFER
      5'b01100: alu_result = {1'b0, ^operand_a}; // Parity Generator
      5'b01101: alu_result = {1'b0, (operand_b != 0) ? operand_a / operand_b : 5'b0}; // DIVIDE
      5'b01110: alu_result = {1'b0, operand_a * operand_a}; // SQUARE
      default: alu_result = 6'b0; // NO OPERATION
    endcase
  end

endmodule

