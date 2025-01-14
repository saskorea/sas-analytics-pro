/*====================================================================================================
= 제목: 모델링 대상 데이터 분할
= 작성일: 2025.01.14.
= 참고: 코드 개발 진행 중
=====================================================================================================*/

%let source_table =;
%let target_table =;
%let target_varnm =;
proc partition data = &source_table.     /* 입력 데이터 */
               samppct    = 30           /* 두 번째 Sample의 크기(비율) 30% */
               samppct2   = 30           /* 세 번째 Sample의 크기(비율) 30% */
               seed       = 123123
               partind  
               
               ;
    by &target_varnm.;             /* 타겟 변수 */
    output 
        out        = &target_table. /* 데이터 분할 결과 테이블 */
        copyvars   = (_all_)        /* 결과 테이블에 포함할 변수 지정 */
        partindname= _PartInd_      /* Partition 변수 이름 */
    ;
run;