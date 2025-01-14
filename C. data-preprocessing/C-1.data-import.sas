/*====================================================================================================
= 제목: 외부 데이터를 SAS로 로드하는 경우 유용한 코드
= 작성일: 2025.01.14.
= 참고: 코드 개발 진행 중
=====================================================================================================*/

/* library 할당 */
options compress = yes;
libname anpro '/workspaces/myfolder/sas-analytics-pro/B. library';


/*--------------------------------------------------------------------------------------------
-  1. csv 파일을 로드하는 경우
--------------------------------------------------------------------------------------------*/
proc import datafile = "/workspaces/myfolder/sas-analytics-pro/A. example-data/churn.csv"   /* 가져올 데이터 이름(경로) */
            dbms     = csv                                                                  /* 가져올 데이터 파일 유형(엑셀은 xlsx) */
            out      = churn                                                                /* 저장할 데이터 이름 */
            replace                                                                         /* 같은 데이터가 이미 있으면, 신규 데이터로 대체 */
            ;
    getnames     = yes;   /* 데이터의 첫 줄이 변수명인 경우 */
    guessingrows = 300;   /* 각 컬럼의 크기 및 타입을 정하기 위해 확인할 데이터 수 */
run;
data anpro.churn;

    attrib
        id                              label = '고객번호'
        callfail	format = best8.     label = '통화실패횟수'       
        complains	format = best8.     label = '불만여부'
        sublength	format = best8.     label = '가입기간(개월)'
        chargeamt	                    label = '요금수준'
        secofuse	format = comma8.    label = '통화시간' 
        freqofuse	format = best8.     label = '통화횟수'
        avgcalldur  format = comma8.2   label = '평균통화시간'
        freqsms     format = best8.     label = '문자횟수'
        distcallnum format = best8.     label = '고유통화수'
        tariffplan                      label = '요금제'
        status                          label = '상태'
        age                             label = '연령'
        custvalue	format = comma8.2   label = '고객가치'
        churn                           label = '이탈여부'
    ;

    set churn;
    id = put(_n_, z5.);

    /* 간단한 파생 변수 */
    if freqofuse > 0 then avgcalldur = secofuse / freqofuse;
    else avgcalldur = 0;

    drop agegroup; /* 연령그룹 변수 제외 */
run;



/*--------------------------------------------------------------------------------------------
-  2. xlsx 파일을 로드하는 겨우
--------------------------------------------------------------------------------------------*/
libname HRDATA xlsx "/workspaces/myfolder/sas-analytics-pro/A. example-data/HRData.xlsx";
data anpro.hrd_data;
    set HRDATA.hrdata;
    attrib
        EMP_ID                           label = '[KN] 직원고유번호'
        SEX	                             label = '[IC] 성별'
        AGE	                             label = '[IN] 나이'
        MAR_ST_CD                        label = '[IC] 결혼상태코드'
        RACE_CD	                         label = '[IC] 인종코드'
        STAT_CD	                         label = '[IC] 지역코드'
        POSIT_CD                         label = '[IC] 직위코드'
        DEPT_ID	                         label = '[IC] 부서고유번호'
        MNGR_ID	                         label = '[IC] 관리자고유번호'
        KPI_CD	                         label = '[IC] 핵심성과코드'
        SAL_AM	    format = comma8.     label = '[IN] 연봉'
        CTZ_CD	                         label = '[IC] 시민권상태코드'
        TNR_DD	    format = comma8.     label = '[IN] 최소근속일수'
        RCRT_CD	                         label = '[IC] 취업경로코드'
        ENG_SCR	    format = comma8.2    label = '[IN] 참여도설문점수'
        SAT_SCR	    format = comma8.2    label = '[IN] 직원만족도'
        PRJ_CN	    format = comma8.     label = '[IN] 특별프로젝트수행횟수'
        LT_DD	    format = comma8.     label = '[IN] 지각일수'
        ABSN	    format = comma8.     label = '[IN] 결근일수'
        TRMD_YN	                         label = '[TC] 퇴사여부'
    ;
run;



/*--------------------------------------------------------------------------------------------
-  3. infile 문을 이용한 방법 
--------------------------------------------------------------------------------------------*/
filename fp "";
data ;
infile fp;
run;