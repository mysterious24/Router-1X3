
module fifo(clock,resetn,write_enb,soft_reset,read_enb,data_in,lfd_state,empty,data_out,full);

//port connections
input [7:0] data_in;
input clock,resetn,write_enb,soft_reset,read_enb,lfd_state;
output reg [7:0] data_out;
output empty,full;
reg [4:0] wr_pt,rd_pt,fifo_counter;
reg lfd_state_s;
integer i;
reg [8:0] mem [15:0];

//fifo down counter logic
always @(posedge clock)
begin
    if(!resetn)
      begin
        fifo_counter<=0;
      end
    else if(soft_reset)
      begin
	fifo_counter<=0;
      end
    else if(read_enb & ~empty)
      begin
	if(mem[rd_pt[3:0]][8]==1'b1)
	  fifo_counter<=mem[rd_pt[3:0]][7:2]+1'b1;
	else if(fifo_counter!=0)
	  fifo_counter<=fifo_counter-1'b1;
      end
end

//delay lfd_state_ by one cycle
always @(posedge clock)
begin
if(!resetn)
lfd_state_s<=0;
else
lfd_state_s<=lfd_state;
end

//read operation
wire w1=(fifo_counter==0 && data_out != 0)?1'b1:1'b0;
always @(posedge clock)
begin
    if(!resetn)
      data_out<=8'b00000000;
    else if(soft_reset)
      data_out<=8'bzzzzzzzz;
    else
      begin
	if(w1)
	  data_out<=8'dz;
	else if(read_enb && ~empty)
	  data_out<=mem[rd_pt[3:0]];
      end
end

//write operation
always @(posedge clock)
begin
    if(!resetn)
      begin
        for(i=0;i<16;i=i+1)
          begin
	    mem[i]<=0;
	  end
      end
    else if(soft_reset)
      begin
        for(i=0;i<16;i=i+1)
	  begin
	    mem[i]<=0;
	  end
      end
    else
      begin
	if(write_enb && !full)
	  {mem[wr_pt[3:0]][8], mem[wr_pt[3:0]][7:0]}<={!lfd_state_s,data_in};
	  //mem[wr_pt[3:0]]<={lfd_state_s,data_in};
end
end

//logic for incrementing pointer
always @(posedge clock)
begin
    if(!resetn)
      begin
        rd_pt<=5'b00000;
        wr_pt<=5'b00000;
      end
    else if(soft_reset)
      begin
        rd_pt<=5'b00000;
        wr_pt<=5'b00000;
      end
    else
      begin
        if(!full && write_enb)
	  wr_pt<=wr_pt+1;
	else
	  wr_pt<=wr_pt;
	if(!empty && read_enb)
	  rd_pt<=rd_pt+1;
	else
	  rd_pt<=rd_pt;
      end
end

assign full = (wr_pt=={~rd_pt[4],rd_pt[3:0]})?1'b1:1'b0;
assign empty = (wr_pt==rd_pt)?1'b1:1'b0;

endmodule
