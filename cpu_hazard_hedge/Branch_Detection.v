module Branch_Detection(
    input               Branch,     // ID 단계에서 브랜치 명령 여부 (사용 안 됨)
                        equal,      // 두 레지스터 값이 같은지 여부 (Rs == Rt)
                        Hazard,     // Hazard가 발생했는지 여부 (stall 중인지)
                        Jump,       // Jump 명령 여부
    input       [5:0]   opcode,     // 명령어 opcode (브랜치 판별용)
    output  reg         isBranch,   // 현재 명령이 실제 브랜치 명령인지 여부
                        IF_Flush    // IF 단계 명령을 Flush할지 여부 (파이프라인 클리어)
);

    // 초기값 설정
    initial begin
        isBranch = 1'b0;
        IF_Flush = 1'b0;
    end

    always @(*) begin
        // Hazard 발생 시 -> 파이프라인 변경 불가 → 브랜치도 무시
        if (Hazard) begin
            isBranch = 1'b0;
            IF_Flush = 1'b0;
        end
        
        // Jump 명령일 경우 → 브랜치 아님, 하지만 IF 단계 Flush 필요
        else if (Jump == 1'b1) begin
            isBranch = 1'b0;
            IF_Flush = 1'b1;
        end
        
        // Branch 명령일 경우 처리
        else begin
            // beq (opcode = 4) → equal이 1일 때 브랜치 실행
            if (opcode == 4 && equal == 1'b1) begin //beq
                isBranch = 1'b1;
                IF_Flush = 1'b1;
            end
            // bne (opcode = 5) → equal이 0일 때 브랜치 실행
            else if (opcode == 5 && equal == 1'b0) begin //bne
                isBranch = 1'b1;
                IF_Flush = 1'b1;
            end
            // 그 외에는 브랜치 아님
            else begin
                isBranch = 1'b0;
                IF_Flush = 1'b0;
            end
        end
    end

endmodule