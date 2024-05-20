module ALU #(parameter W_operand=8,W_ALU_FUN=4,W_ALU_OUT=16 )(
input wire                    CLK,RST,Enable,
input wire  [W_operand-1:0]   A,B,
input wire  [W_ALU_FUN-1:0]   ALU_FUN,
output reg  [W_ALU_OUT-1:0]   ALU_OUT,
output reg                    OUT_VALID
);


always@(posedge CLK ,negedge RST)
  begin
   if(!RST)
     begin
       ALU_OUT  <=16'b0;
       OUT_VALID<=1'b0;
     end
   else if(Enable)
     begin
       OUT_VALID<=1'b1;
       case(ALU_FUN)
         4'b0000: ALU_OUT <=A+B;
         4'b0001: ALU_OUT <=A-B;
         4'b0010: ALU_OUT <=A*B;
         4'b0011: ALU_OUT <=A/B;
         4'b0100: ALU_OUT <=A&B;
         4'b0101: ALU_OUT <=A|B;
         4'b0110: ALU_OUT <=~(A&B);
         4'b0111: ALU_OUT <=~(A|B);
         4'b1000: ALU_OUT <=(A^B);
         4'b1001: ALU_OUT <=~(A^B);
         4'b1010: begin
                   if(A==B)
                        ALU_OUT<=16'd1;
                   else
                       ALU_OUT <=16'd0;
                  end
         4'b1011: begin
                   if(A>B)
                     ALU_OUT <=16'd2;
                   else
                     ALU_OUT <=16'd0; 
                   end
         4'b1100: ALU_OUT <=A>>1;
         4'b1101: ALU_OUT <=A<<1;
         default
           begin
                 ALU_OUT   <=16'b0;
                 OUT_VALID <=1'b0;
            end
     endcase
     end
  end
endmodule
