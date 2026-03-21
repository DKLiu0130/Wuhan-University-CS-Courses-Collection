
  module RF(   input         clk, 
               input         rst,
               input         RFWr, 
               input save_out,
               input load_out,
               input  [4:0]  A1, A2, A3, 
               input  [31:0] WD, 
               output [31:0] RD1, RD2,r0);

  reg [31:0] rf[31:0], rf_int[31:0];

  integer i;

  always @(negedge clk, posedge rst)
    if (rst) begin    //  reset
      for (i=1; i<32; i=i+1)
        rf[i] <= 0; //  i;
    end
      
    else if(save_out)
    begin
      for (i=1; i<32; i=i+1)
      begin
        rf_int[i] <= rf[i];
        rf[i] <= 0;
      end
    end
    else if(load_out)
    begin
       for (i=1; i<32; i=i+1)
        rf[i] <= rf_int[i];
    end
    else
      if (RFWr && A3) begin
        rf[A3] <= WD;
        // $display("x%d = %h", A3, WD);    
//        $display("r[00-07]=0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X", 0, rf[1], rf[2], rf[3], rf[4], rf[5], rf[6], rf[7]);
//        $display("r[08-15]=0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X", rf[8], rf[9], rf[10], rf[11], rf[12], rf[13], rf[14], rf[15]);
//        $display("r[16-23]=0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X", rf[16], rf[17], rf[18], rf[19], rf[20], rf[21], rf[22], rf[23]);
//        $display("r[24-31]=0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X, 0x%8X", rf[24], rf[25], rf[26], rf[27], rf[28], rf[29], rf[30], rf[31]);
//        $display("r[%2d] = 0x%8X,", A3, WD);
      end
    
  assign r0=rf[30];
  assign RD1 = A1? ((RFWr && A3 == A1) ? WD : rf[A1]):0 ;
  assign RD2 = A2? ((RFWr && A3 == A2) ? WD : rf[A2]):0 ;
  //assign reg_data = (reg_sel != 0) ? rf[reg_sel] : 0; 

endmodule 
