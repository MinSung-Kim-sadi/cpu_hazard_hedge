module Hazard_Detection(
    input               Branch,         // 현재 명령어가 Branch (beq 등) 명령인지 여부
                        MemRead_EX,     // EX 단계에서 메모리 읽기(load) 여부
                        RegWrite_EX,    // EX 단계 명령이 레지스터 쓰기 여부
                        RegWrite_MEM,   // MEM 단계 명령이 레지스터 쓰기 여부
                        MemRead_MEM,    // MEM 단계 명령이 메모리 읽기 여부
    input       [4:0]   Rs_ID,          // 현재(ID 단계) 명령어의 첫 번째 소스 레지스터
                        Rt_ID,          // 현재(ID 단계) 명령어의 두 번째 소스 레지스터
                        Rt_EX,          // EX 단계 명령어의 두 번째 피연산자 (load 대상)
                        Rd_EX,          // EX 단계 명령어의 목적지 레지스터
                        Dst_MEM,        // MEM 단계 명령어의 목적지 레지스터
    output reg          IFID_Write,     // IF/ID 레지스터 쓰기 제어 (1: 쓰기 허용, 0: 정지)
                        Hazard,         // 해저드 발생 여부 (1: 해저드 있음)
                        PC_Write        // PC 업데이트 제어 (1: 업데이트, 0: 정지)
);

// 초기 상태: 파이프라인 진행 가능
    initial begin
        IFID_Write = 1'b1;
        Hazard = 1'b0;
        PC_Write = 1'b1;
    end

    always @(*) begin
        // for load use hazard
        // // EX 단계의 명령이 load이고, 그 대상 레지스터가 현재 명령의 source 레지스터와 충돌할 경우 stall
        if (MemRead_EX && Rt_EX && (Rt_EX == Rs_ID || Rt_EX == Rt_ID)) begin
            IFID_Write = 1'b0;  // IF/ID 레지스터 정지
            Hazard = 1'b1;       // 해저드 발생
            PC_Write = 1'b0;   // PC 업데이트 정지
        end
        // for branch use hazard
        // 브랜치 명령이 ID 단계에서 decode된 경우, 그 비교 대상이 EX 또는 MEM 단계에서 결과가 나오는 경우 stall
         else if (Branch) begin
            // EX 단계 명령이 쓰기 예정이고, 그 목적지가 현재 명령의 Rs/Rt와 충돌하는 경우
            if (RegWrite_EX && Rd_EX && (Rd_EX == Rs_ID || Rd_EX == Rt_ID) ) begin // add beq
                IFID_Write = 1'b0;
                Hazard = 1'b1;
                PC_Write = 1'b0;
            end
            // MEM 단계 명령이 쓰기 예정이고, 그 목적지가 현재 명령의 Rs/Rt와 충돌하는 경우
            else if (RegWrite_MEM && Dst_MEM && (Dst_MEM == Rs_ID || Dst_MEM == Rt_ID) ) begin //add x beq
                IFID_Write = 1'b0;
                Hazard = 1'b1;
                PC_Write = 1'b0;
            end
            // 위 조건에 해당되지 않으면 정상적으로 진행
            else begin
                IFID_Write = 1'b1;
                Hazard = 1'b0;
                PC_Write = 1'b1;
            end
        end
        // 해저드 없음: 파이프라인 정상 진행
        else begin
            IFID_Write = 1'b1;
            Hazard = 1'b0;
            PC_Write = 1'b1;
        end

    end


endmodule