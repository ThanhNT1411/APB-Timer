task run_test();
    begin
	
	$display("======================================");	
  	$display("====== Check prohibit div_val ========");
  	$display("======================================");	
	for(i=0;i<16;i=i+1) begin
		mst_wr(TCR_ADDR,{20'b0,i[3:0],8'b0},STRB_FULL);
		mst_rd(TCR_ADDR,rdata);
		if (i<9) begin
			cmp_data(i[3:0],rdata[11:8]);
			pslverr_check(0);
		end else begin 
			cmp_data(8,rdata[11:8]);
			pslverr_check(1);
		end
	end
	
	$display("======================================");	
  	$display("====== Check error div_en ============");
  	$display("======================================");	
	reset();
	mst_wr(TCR_ADDR,32'h003,STRB_FULL);
	mst_wr(TCR_ADDR,32'h001,STRB_FULL);
	mst_rd(TCR_ADDR,rdata);
	cmp_data(32'h0003,rdata);
	pslverr_check(1);

	reset();
	mst_wr(TCR_ADDR,32'h003,STRB_FULL);
	mst_wr(TCR_ADDR,32'h000,STRB_FULL);
	mst_rd(TCR_ADDR,rdata);
	cmp_data(32'h0003,rdata);
	pslverr_check(1);

	reset();
	mst_wr(TCR_ADDR,32'h003,STRB_FULL);
	mst_wr(TCR_ADDR,32'h003,STRB_FULL);
	mst_rd(TCR_ADDR,rdata);
	cmp_data(32'h0003,rdata);
	pslverr_check(0);

	reset();
	mst_wr(TCR_ADDR,32'h002,STRB_FULL);
	mst_wr(TCR_ADDR,32'h001,STRB_FULL);
	mst_rd(TCR_ADDR,rdata);
	cmp_data(32'h0001,rdata);
	pslverr_check(0);


	$display("======================================");	
  	$display("====== Check error div_val ===========");
  	$display("======================================");	
	reset();
	mst_wr(TCR_ADDR,32'h101,STRB_FULL);
	mst_wr(TCR_ADDR,32'h301,4'b0010);
	mst_rd(TCR_ADDR,rdata);
	cmp_data(32'h101,rdata);
	pslverr_check(1);

	reset();
	mst_wr(TCR_ADDR,32'h101,STRB_FULL);
	mst_wr(TCR_ADDR,32'h300,STRB_FULL);
	mst_rd(TCR_ADDR,rdata);
	cmp_data(32'h101,rdata);
	pslverr_check(1);

	reset();
	mst_wr(TCR_ADDR,32'h101,STRB_FULL);
	mst_wr(TCR_ADDR,32'h101,STRB_FULL);
	mst_rd(TCR_ADDR,rdata);
	cmp_data(32'h101,rdata);
	pslverr_check(0);

	reset();
	mst_wr(TCR_ADDR,32'h100,STRB_FULL);
	mst_wr(TCR_ADDR,32'h301,STRB_FULL);
	mst_rd(TCR_ADDR,rdata);
	cmp_data(32'h301,rdata);
	pslverr_check(0);




	if( fail_num != 0 )
            $display("Test_result FAILED");
        else
            $display("Test_result PASSED");
        end
endtask

