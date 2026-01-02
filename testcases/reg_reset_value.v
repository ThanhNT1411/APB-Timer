task run_test();
    integer i;
    begin
	$display("======================================");
	$display("====== Register check reset value ====");
  	$display("======================================");	
	for (i=0;i<29;i=i+4) begin
		mst_rd(i,rdata);
		if (i==0) begin
			cmp_data(rdata, 32'h0000_0100);
		end else if (i==12 || i==16) begin
			cmp_data(rdata, 32'hFFFF_FFFF);
		end else begin
	  		cmp_data(rdata, 32'h0);
	       	end
	end

	// write to register
	for (i=0;i<29;i=i+4) begin
		mst_wr(i,32'hffff_ffff,STRB_FULL);
	end

	// check reset after write
	reset();
	for (i=0;i<29;i=i+4) begin
		mst_rd(i,rdata);
		if (i==0) begin
			cmp_data(rdata, 32'h0000_0100);
		end else if (i==12 || i==16) begin
			cmp_data(rdata, 32'hFFFF_FFFF);
		end else begin
	  		cmp_data(rdata, 32'h0);
	       	end
	end

        if( fail_num != 0 )
            $display("Test_result FAILED");
        else
            $display("Test_result PASSED");
        end


endtask


