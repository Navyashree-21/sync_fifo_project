`timescale 1ns/1ps

module sync_fifo_tb;

   
    parameter DATA_WIDTH = 8;
    parameter DEPTH = 16;
    parameter ADDR_WIDTH = 4;

    
    reg clk;
    reg rst;
    reg wr_en;
    reg rd_en;
    reg [DATA_WIDTH-1:0] data_in;

    wire [DATA_WIDTH-1:0] data_out;
    wire full;
    wire empty;
    wire [ADDR_WIDTH:0] count;

    sync_fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty),
        .count(count)
    );

    
    always #5 clk = ~clk;

    
    task write_fifo(input [7:0] data);
        begin
            @(posedge clk);
            if (!full) begin
                wr_en = 1;
                rd_en = 0;
                data_in = data;
                $display("WRITE: Data = %0d, Count = %0d", data, count);
            end
            @(posedge clk);
            wr_en = 0;
        end
    endtask

   
    task read_fifo;
        begin
            @(posedge clk);
            if (!empty) begin
                wr_en = 0;
                rd_en = 1;
            end
            @(posedge clk);
            rd_en = 0;
            $display("READ: Data = %0d, Count = %0d", data_out, count);
        end
    endtask

    integer i;

    initial begin
        
        clk = 0;
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        data_in = 0;

       
        #20;
        rst = 0;
        $display("Reset Done");

       
        // TEST 1: Write 5 values
     
        for (i = 1; i <= 5; i = i + 1) begin
            write_fifo(i * 10);
        end

      
        // TEST 2: Read 3 values
      
        for (i = 0; i < 3; i = i + 1) begin
            read_fifo();
        end

       
        // TEST 3: Fill FIFO completely
       
        for (i = 0; i < DEPTH; i = i + 1) begin
            write_fifo(i + 100);
        end

        if (full)
            $display("FIFO is FULL");

        
        // TEST 4: Empty FIFO completely
     
        for (i = 0; i < DEPTH; i = i + 1) begin
            read_fifo();
        end

        if (empty)
            $display("FIFO is EMPTY");

      
        // TEST 5: Simultaneous Read/Write
   
        @(posedge clk);
        wr_en = 1;
        rd_en = 1;
        data_in = 8'hAA;

        @(posedge clk);
        wr_en = 0;
        rd_en = 0;

        $display("SIMULTANEOUS RW Done");

     
        #50;
        $finish;
    end

endmodule
