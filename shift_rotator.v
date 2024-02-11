module shift_rotator (rst,data_ip,select,data_op);

  //Ports.
  input [15:0] data_ip;
  input [5:0] select;
  input rst;
  output [15:0] data_op;
  reg [15:0] case_op;

  //Logic.
  always @(*) 
    begin
      case (select)
        6'd32: case_op = {data_ip[2], data_ip[14:3]};
        6'd16: case_op = {data_ip[1], data_ip[14:2]};
        6'd8: case_op = {data_ip[0], data_ip[14:1]};
        6'd4: case_op = {data_ip[12:0], data_ip[15:13]} ;
        6'd2: case_op = {data_ip[13:0], data_ip[15:14]}; 
        6'd1: case_op = {data_ip[14:0], data_ip[15]};
        default: case_op = data_ip; // No rotation
      endcase
    end

  assign data_op = case_op;

endmodule
