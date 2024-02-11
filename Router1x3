module topmodule (clock,resetn,read_enb_0,read_enb_1,read_enb_2,pkt_valid,data_in,valid_out_0,valid_out_1,
valid_out_2,data_out_0,data_out_1,data_out_2,error,busy);

//port connections
input [7:0] data_in;
input clock,resetn,read_enb_0,read_enb_1,read_enb_2,pkt_valid;
output [7:0] data_out_0,data_out_1,data_out_2;
output valid_out_0,valid_out_1,valid_out_2,error,busy;

wire empty_0,empty_1,empty2;
wire full_0,full_1,full_2,write_enb_reg,rst_int_reg,lfd_state;
wire [2:0] soft_reset,write_enb;
wire [7:0] dout;

//instantiate other subblocks
//fifo
fifo ff0 (clock,resetn,write_enb[0],soft_reset[0],read_enb_0,dout,lfd_state,empty_0,data_out_0,full_0);
fifo ff1 (clock,resetn,write_enb[1],soft_reset[1],read_enb_1,dout,lfd_state,empty_1,data_out_1,full_1);
fifo ff2 (clock,resetn,write_enb[2],soft_reset[2],read_enb_2,dout,lfd_state,empty_2,data_out_2,full_2);

//fsm
FSM fs1 (clock,resetn,pkt_valid,busy,parity_done,data_in [1:0],soft_reset_0,soft_reset_1,soft_reset_2,
fifo_full,low_pkt_valid,empty_0,empty_1,empty_2,detect_add,ld_state,laf_state,full_state,
write_enb_reg,rst_int_reg,lfd_state);

//synchronizer
synchronizer s1 (clock,resetn,detect_add,data_in [1:0],write_enb_reg,valid_out_0,valid_out_1,valid_out_2,read_enb_0,
read_enb_1,read_enb_2,write_enb [2:0],fifo_full,empty_0,empty_1,empty_2,soft_reset_0,
soft_reset_1,soft_reset_2,full_0,full_1,full_2);

//register
register_1 r1 (clock,resetn,pkt_valid,data_in,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,
full_state,lfd_state,parity_done,low_pkt_valid,error,dout);

endmodule

