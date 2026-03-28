`timescale 1ns / 1ps

module sync_fifo #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 16,
    parameter ADDR_WIDTH = 4   
)(
    input wire clk,
    input wire rst,

    input wire wr_en,
    input wire rd_en,
    input wire [DATA_WIDTH-1:0] data_in,

    output reg [DATA_WIDTH-1:0] data_out,
    output wire full,
    output wire empty,
    output reg [ADDR_WIDTH:0] count
);

    // Memory array
    reg [DATA_WIDTH-1:0] fifo_mem [0:DEPTH-1];

    // Read and Write pointers
    reg [ADDR_WIDTH-1:0] wr_ptr;
    reg [ADDR_WIDTH-1:0] rd_ptr;

    // Full and Empty conditions
    assign full  = (count == DEPTH);
    assign empty = (count == 0);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_ptr   <= 0;
            rd_ptr   <= 0;
            count    <= 0;
            data_out <= 0;
        end
        else begin
            case ({wr_en, rd_en})

                // Write only
                2'b10: begin
                    if (!full) begin
                        fifo_mem[wr_ptr] <= data_in;
                        wr_ptr <= wr_ptr + 1;
                        count  <= count + 1;
                    end
                end

                // Read only
                2'b01: begin
                    if (!empty) begin
                        data_out <= fifo_mem[rd_ptr];
                        rd_ptr <= rd_ptr + 1;
                        count  <= count - 1;
                    end
                end

                // Write and Read simultaneously
                2'b11: begin
                    if (!full && !empty) begin
                        fifo_mem[wr_ptr] <= data_in;
                        data_out <= fifo_mem[rd_ptr];
                        wr_ptr <= wr_ptr + 1;
                        rd_ptr <= rd_ptr + 1;
                        count  <= count; // count unchanged
                    end
                    else if (empty && !full) begin
                        
                      
                        fifo_mem[wr_ptr] <= data_in;
                        wr_ptr <= wr_ptr + 1;
                        count  <= count + 1;
                    end
                    else if (full && !empty) begin
                       
                        data_out <= fifo_mem[rd_ptr];
                        rd_ptr <= rd_ptr + 1;
                        count  <= count - 1;
                    end
                end

              
                2'b00: begin
                   
                end

            endcase
        end
    end

endmodule
