task run_test();
    begin
	$display("======================================");	
  	$display("====== Register check R/W access =====");
  	$display("======================================");	
	// TCR register
	reg_name(0);
	mst_wr(TCR_ADDR,32'h0000_0000,STRB_FULL);
	mst_rd(TCR_ADDR,rdata);
	cmp_data(rdata,32'h0000_0000);

	mst_wr(TCR_ADDR,32'hffff_ffff,STRB_FULL);
	mst_rd(TCR_ADDR,rdata);
	cmp_data(rdata,32'h0000_0000);

	mst_wr(TCR_ADDR,32'h5555_5555,STRB_FULL);
	mst_rd(TCR_ADDR,rdata);
	cmp_data(rdata,32'h0000_0501);
	
	mst_wr(TCR_ADDR,32'haaaa_aaaa,STRB_FULL);
	mst_rd(TCR_ADDR,rdata);
	cmp_data(rdata,32'h0000_0501);

	// remaining register
	for (j=4;j<29;j=j+4) begin
		reset();
		reg_name(j);
		for (i=0;i<4;i=i+1) begin
    	        	case (i)
   	                	0: wdata=32'h0000_0000;
   	                	1: wdata=32'hffff_ffff;
    	                	2: wdata=32'h5555_5555;
    	                	default: wdata=32'haaaa_aaaa;
    	         	endcase
		
			mst_wr(j,wdata,STRB_FULL);
                        mst_rd(j,rdata);
                        case (j)
                                20,28:   cmp_data(rdata, wdata & 32'h001);
				24:      cmp_data(rdata, 32'h000);
                                default: cmp_data(rdata, wdata);
                        endcase
                end
        end

	$display("======================================");	
  	$display("====== Register one hot check ========");
  	$display("======================================");	
        reset();
	i=2;
	// write to TCR register
	mst_wr(TCR_ADDR,32'h1111_1110,STRB_FULL);
	// write to other register
        for (j=4;j<29;j=j+4) begin
                wdata = {8{i[3:0]}};
                mst_wr(j,wdata,STRB_FULL);
                i=i+1;
        end

        i=2;
	// read to other register
        for (j=4;j<29;j=j+4) begin
		reg_name(j);
                wdata = {8{i[3:0]}};
                mst_rd(j,rdata);
                i=i+1;
                case (j)
			0:       cmp_data(rdata, 32'h0000_0102);
                        20,28:   cmp_data(rdata, wdata & 32'h001);
			24:      cmp_data(rdata, 32'h000);
                        default: cmp_data(rdata, wdata);
                endcase
        end

	$display("======================================");	
  	$display("====== Register check reserved access=");
  	$display("======================================");
	reset();
	mst_wr(12'h20,32'hffff_ffff,STRB_FULL);
	mst_rd(12'h20,rdata);
	cmp_data(rdata,32'h0000_0000);
	
	mst_wr(12'h50,32'hffff_ffff,STRB_FULL);
	mst_rd(12'h50,rdata);
	cmp_data(rdata,32'h0000_0000);
	
	mst_wr(12'h3fc,32'hffff_ffff,STRB_FULL);
	mst_rd(12'h3fc,rdata);
	cmp_data(rdata,32'h0000_0000);


	if( fail_num != 0 )
            $display("Test_result FAILED");
        else
            $display("Test_result PASSED");
   
    end
endtask

