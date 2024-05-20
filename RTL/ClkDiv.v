module ClkDiv(
input wire       i_ref_clk,
input wire       i_ret_n,
input wire       i_clk_en,
input wire  [7:0]i_div_ratio,
output reg       o_div_clk 
);


wire          CLK_DIV_EN;
reg           o_clk;
reg  [3:0]    counter;
wire [2:0]    half;
wire          odd;
reg           flag;

assign CLK_DIV_EN =(i_clk_en && (i_div_ratio!=4'd0)&&(i_div_ratio!=4'd1));
assign odd = i_div_ratio[0];
assign half= (i_div_ratio>>1);

always@(posedge i_ref_clk ,negedge i_ret_n)
begin
  if(!i_ret_n)
    begin
      o_clk     <='b0;
      counter   <='b1;
      flag      <=1'b0;
    end
  else if(CLK_DIV_EN)
    begin
      if((counter==half) && !odd)        //even case
        begin
          o_clk <= ~o_clk;
          counter<=1;
        end
     else if((counter==(half+flag)) && odd)   //odd case
        begin 
          o_clk  <= ~o_clk;
          counter<=1;
          flag   <= ~flag;
        end
    else
      counter<=counter+1;
      
    end
end


always@(*)
  begin
    if(CLK_DIV_EN)
       o_div_clk=o_clk;
    else
       o_div_clk=i_ref_clk;
  end
  
endmodule
