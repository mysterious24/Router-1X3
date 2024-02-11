module register_1 (clk,resetn,pkt_valid,data_in,fifo_full,rst_int_reg,detect_add,
ld_state,laf_state,full_state,lfd_state,parity_done,low_pkt_valid,err,dout);

//port declarations
input clk,resetn,pkt_valid,fifo_full,rst_int_reg,detect_add,
ld_state,laf_state,full_state,lfd_state;
input [7:0] data_in;
output reg parity_done,low_pkt_valid,err;
output reg[7:0] dout;
reg [7:0] Header_byte,fifo_full_state_byte,Packet_parity,Internal_parity;

//dout logic
always @ (posedge clk)
begin 
if(~resetn)
 dout<=0;
else if(lfd_state)
 dout<=Header_byte;
else if(ld_state && ~fifo_full)
 dout<=data_in;
else if(laf_state)
 dout<=fifo_full_state_byte;
else
 dout<=dout;
end

//Header_byte and fifo_full_state_byte lofic
always @ (posedge clk)
begin
if(~resetn)
 {Header_byte,fifo_full_state_byte}<=0;
else
 begin
 if(pkt_valid && detect_add)
  Header_byte<=data_in;
 else if(ld_state && fifo_full)
  fifo_full_state_byte<=data_in;
 end
end

//parity_done logic
always @ (posedge clk)
begin
if(~resetn)
 parity_done<=0;
else
 begin
 if(ld_state && ~pkt_valid && ~fifo_full)
  parity_done<=1'b1;
 else if(laf_state && ~parity_done && low_pkt_valid)
  parity_done<=1'b1;
 else
  begin
   if(detect_add)
   parity_done<=1'b0;
  end
 end
end

//low_pkt_valid logic
always @ (posedge clk)
begin
if(~resetn)
low_pkt_valid<=0;
else
 fork
 if(rst_int_reg)
  low_pkt_valid<=0;
 if(~pkt_valid && ld_state)
  low_pkt_valid<=1'b1;
join
end

//Packet_parity logic
always @(posedge clk)
  begin
    if(~resetn)
      Packet_parity<=0;
    else if((ld_state && ~pkt_valid && ~fifo_full) || (laf_state && low_pkt_valid && ~parity_done))
      Packet_parity<=data_in;
    else if(~pkt_valid && rst_int_reg)
      Packet_parity<=0;
    else
      begin
        if(detect_add)
	  Packet_parity<=0;
      end
  end

//Internal parity logic
always @(posedge clk)
  begin
    if(~resetn)
      Internal_parity<=8'b0;
    else if(detect_add)
      Internal_parity<=8'b0;
    else if(lfd_state)
      Internal_parity<=Internal_parity ^ Header_byte;
    else if(ld_state && pkt_valid && ~full_state)
      Internal_parity<=Internal_parity ^ data_in;
    else if(~pkt_valid && rst_int_reg)
      Internal_parity<=0;
  end

//error logic
always@(posedge clk)
  begin
    if(~resetn)
      err<=0;
    else
      begin
        if(parity_done==1'b1 && (Internal_parity != Packet_parity))
          err<=1'b1;
        else
          err<=0;
      end
  end

endmodule

