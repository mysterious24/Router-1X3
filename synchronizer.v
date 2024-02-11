module synchronizer (clock,resetn,detect_add,data_in,write_enb_reg,vld_out_0,vld_out_1,vld_out_2,read_enb_0,read_enb_1,read_enb_2,
write_enb,fifo_full,empty_0,empty_1,empty_2,soft_reset_0,soft_reset_1,soft_reset_2,full_0,full_1,full_2);

/*port connections*/
input [1:0] data_in;
input clock,resetn,detect_add,write_enb_reg,read_enb_0,read_enb_1,
read_enb_2,empty_0,empty_1,empty_2,full_0,full_1,full_2;
output reg [2:0] write_enb;
output reg fifo_full,soft_reset_0,soft_reset_1,soft_reset_2;
output wire vld_out_0,vld_out_1,vld_out_2;
reg [1:0] temp;
reg [4:0] timer_0,timer_1,timer_2;

/*int_addr_reg logic*/
always @(posedge clock)
  begin
    if(!resetn)
      temp<=2'd0;
    else if(detect_add)
      temp<=data_in;
  end

/*write enb logic*/
always @(*)
  begin
      if(write_enb_reg)
      begin
        case(temp)
	  2'b00:write_enb=3'b001;
	  2'b01:write_enb=3'b011;
	  2'b10:write_enb=3'b101;
	  default:write_enb=3'b000;
	endcase
      end
else write_enb=3'b000;
  end 

/*fifo full logic*/
always @(*)
  begin
    case(temp)
      2'b00:fifo_full=full_0;
      2'b01:fifo_full=full_1;
      2'b10:fifo_full=full_2;
      default:fifo_full=1'b0;
    endcase
  end

assign vld_out_0=(~empty_0);
assign vld_out_1=(~empty_1);
assign vld_out_2=(~empty_2);

/*timer_0 and soft_reset_0 logic*/
wire l0=(timer_0==5'd29)?1'b1:1'b0;
always @(posedge clock)
  begin
    if(~resetn)
      begin
        timer_0<=0;
        soft_reset_0<=0;
      end
    else if(vld_out_0)
      begin
	if(!read_enb_0)
          begin
	    if(l0)
	      begin
	        soft_reset_0<=1'b1;
		timer_0<=0;
	      end
	    else
	      begin
		soft_reset_0<=0;
		timer_0<=timer_0+1'b1;
	      end
	  end
      end
  end

/*timer_1 and soft_reset_1 logic*/
wire l1=(timer_1==5'd29)?1'b1:1'b0;

always @(posedge clock)
  begin
    if(~resetn)
      begin
        timer_1<=0;
        soft_reset_1<=0;
      end
    else if(vld_out_1)
      begin
	if(!read_enb_1)
          begin
	    if(l1)
	      begin
	        soft_reset_1<=1'b1;
		timer_1<=0;
	      end
	    else
	      begin
		soft_reset_1<=0;
		timer_1<=timer_1+1'b1;
	      end
	  end
      end
  end

/*timer_2 and soft_reset_2 logic*/
wire l2=(timer_2==5'd29)?1'b1:1'b0;

always @(posedge clock)
  begin
    if(~resetn)
      begin
        timer_2<=0;
        soft_reset_2<=0;
      end
    else if(vld_out_2)
      begin
	if(!read_enb_2)
          begin
	    if(l2)
	      begin
	        soft_reset_2<=1'b1;
		timer_2<=0;
	      end
	    else
	      begin
		soft_reset_2<=0;
		timer_2<=timer_2+1'b1;
	      end
	  end
      end
  end
endmodule

