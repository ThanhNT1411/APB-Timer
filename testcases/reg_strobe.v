task run_test();
    reg [31:0] mask;
    begin
	$display("======================================");	
  	$display("====== Regiter check strobe ==========");
  	$display("======================================");	
	// TCR register
	reg_name(TCR_ADDR);
	wdata=32'hffff_88ff;
	mst_wr(TCR_ADDR,wdata,4'b1010);
	mst_rd(TCR_ADDR,rdata);
	cmp_data(rdata, 32'h0000_0800);
	
	reset();
	mst_wr(TCR_ADDR,wdata,4'b0101);
	mst_rd(TCR_ADDR,rdata);
	cmp_data(rdata, 32'h0000_0103);

	// remaining register
	reset();
	for (j=4;j<29;j=j+4) begin
		reg_name(j);
		if (j==12||j==16) 
			wdata=32'h0000_0000;
		else
			wdata=32'hffff_ffff;

		for (i=0;i<2;i=i+1) begin
			reset();
			if (i==0) begin
				mst_wr(j,wdata,4'b1010);
				mask = 32'hff00_ff00;
			end else begin
				mst_wr(j,wdata,4'b0101);
				mask = 32'h00ff_00ff;
			end
                        mst_rd(j,rdata);
                        case (j)
                                20,28:   cmp_data(rdata & mask, wdata & mask & 32'h001);
				24:      cmp_data(rdata & mask, 32'h000);
                                default: cmp_data(rdata & mask, wdata & mask);
                        endcase
                end
        end


	if( fail_num != 0 )
            $display("Test_result FAILED");
        else
            $display("Test_result PASSED");

    end
endtask

