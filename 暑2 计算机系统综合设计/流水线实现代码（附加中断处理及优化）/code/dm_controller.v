`include "ctrl_encode_def.v"
module dm_controller(
  input mem_w,
  input [31:0] Addr_in,
  input [31:0] Data_write,
  input [2:0] dm_ctrl,
  input [31:0] Data_read_from_dm,
  output reg [31:0] Data_read,
  output reg [31:0] Data_write_to_dm,
  output reg [3:0] wea_mem
  );
  
  /*
`define dm_word 3'b000
`define dm_halfword 3'b001
`define dm_halfword_unsigned 3'b010
`define dm_byte 3'b011
`define dm_byte_unsigned 3'b100
  */
  always @* 
  begin
        Data_read <= 32'b0;
        Data_write_to_dm <= 32'b0;
        wea_mem <= 4'b0;
        /*
        case (mem_w)
        1'b0:
        */
        if(mem_w == 1'b0)
        begin
           // Data_write_to_dm <= Data_write;
           wea_mem <= 4'b0000;
           case(dm_ctrl)
          3'b000: Data_read <= Data_read_from_dm;
          3'b001:
          begin
            case (Addr_in[1])
              1'b0: Data_read <= {{{32 - 16}{Data_read_from_dm[15]}}, Data_read_from_dm[15:0]};
              1'b1: Data_read <= {{{32 - 16}{Data_read_from_dm[31]}}, Data_read_from_dm[31:16]};
            endcase
          end
    
          3'b011:
          begin
            case (Addr_in[1:0])
              2'b00: Data_read <= {{{32 - 8}{Data_read_from_dm[7]}}, Data_read_from_dm[7:0]};
              2'b01: Data_read <= {{{32 - 8}{Data_read_from_dm[15]}}, Data_read_from_dm[15:8]};
              2'b10: Data_read <= {{{32 - 8}{Data_read_from_dm[23]}}, Data_read_from_dm[23:16]};
              2'b11: Data_read <= {{{32 - 8}{Data_read_from_dm[31]}}, Data_read_from_dm[31:24]};
            endcase
          end
          
          3'b010:
          begin
            case (Addr_in[1])
              1'b0: Data_read <= {{{32 - 16}{1'b0}}, Data_read_from_dm[15:0]};
              1'b1: Data_read <= {{{32 - 16}{1'b0}}, Data_read_from_dm[31:16]};
            endcase
          end
          
          3'b100:
          begin
            case (Addr_in[1:0])
              2'b00: Data_read <= {{{32 - 8}{1'b0}}, Data_read_from_dm[7:0]};
              2'b01: Data_read <= {{{32 - 8}{1'b0}}, Data_read_from_dm[15:8]};
              2'b10: Data_read <= {{{32 - 8}{1'b0}}, Data_read_from_dm[23:16]};
              2'b11: Data_read <= {{{32 - 8}{1'b0}}, Data_read_from_dm[31:24]};
            endcase
          end
         endcase
        end
        // 1'b1:
        else
        begin
            Data_read <= Data_read_from_dm;
            case(dm_ctrl)
                `dm_word:
                begin
                    Data_write_to_dm <= Data_write;          
                    wea_mem <= 4'b1111;
                end
                `dm_halfword, `dm_halfword_unsigned:
                begin
                    Data_write_to_dm <= {2{Data_write[15:0]}};
                    case(Addr_in[1])
                        1'b0: wea_mem <= 4'b0011;
                        1'b1: wea_mem <= 4'b1100;
                    endcase
                end
                `dm_byte, `dm_byte_unsigned:
                begin
                    Data_write_to_dm <= {4{Data_write[7:0]}};
                     case(Addr_in[1:0])
                        2'b00: wea_mem <= 4'b0001;
                        2'b01: wea_mem <= 4'b0010;
                        2'b10: wea_mem <= 4'b0100;
                        2'b11: wea_mem <= 4'b1000;
                     endcase             
                end
                default: wea_mem <= 4'b0000;
            endcase
       end
       // endcase
  end
  /*wire [3:0] temp;
  assign temp = (mem_w == 0) ? 4'b0000 : (dm_ctrl == 3'b000) ? 4'b1111:
  (dm_ctrl == 3'b001 || dm_ctrl == 3'b010) ? ((Addr_in[1] == 1'b0) ? 4'b0011: 4'b1100):
  (dm_ctrl == 3'b011 || dm_ctrl == 3'b100) ? 
  ((Addr_in[1:0] == 2'b00) ? 4'b0001: (Addr_in[1:0] == 2'b01) ? 4'b0010:
  (Addr_in[1:0] == 2'b10) ? 4'b0100: (Addr_in[1:0] == 2'b11) ? 4'b1000 : 4'b0000) : 4'b0000;
  
  assign wea_mem = temp;*/
  
endmodule