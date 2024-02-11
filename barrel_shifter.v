module barrel_shifter (ip,s,op,rst);

  input [15:0] ip;
  input [8:0] s;
  input rst;
  output [15:0] op;
  reg [15:0] sd;
  
  //Always.
  always @(s or rst)
    begin
      if (rst)
        sd <= 16'd0;
      else if (s==9'd256)
        sd <= (ip <<< 3);
      else if (s==9'd128)
	sd <= (ip <<< 2);
      else if (s==9'd64)
	sd <= (ip <<< 1);
      else if (s==9'd32)
	sd <= (ip << 3);
      else if (s==9'd16)
	sd <= (ip << 2);
      else if (s==9'd8)
	sd <= (ip << 1);
      else if (s==9'd4)
	sd <= (ip >> 3);
      else if (s==9'd2)
	sd <= (ip >> 2);
      else if (s==9'd1)
	sd <= (ip >> 1);
      else 
	sd <= 16'd0;
    end 

  assign op = sd;

endmodule

