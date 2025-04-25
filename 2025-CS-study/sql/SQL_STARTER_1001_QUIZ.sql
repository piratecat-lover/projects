
------------------------------------------------------------------------
-- BOOSTER QUIZ 10-1-1
------------------------------------------------------------------------
문제)
현재 액티브 회원에 대해 회원등급별 회원수를 보여주세요. 전체합계도 추가해서 표시해 주세요.
  ㅁ 대상 테이블: ms_mbr
  ㅁ 조회 조건: mbr_st가 ACTV인 데이터
  ㅁ 조회 항목: mbr_gd, mbr_cnt
    ㅇ mbr_cnt: mbr_gd별 회원수
  ㅁ 추가 고려 사항
    ㅇ mbr_gd별 GROUP BY 처리합니다.
    ㅇ ROLLUP을 사용해 전체합계를 추가해 주세요.
    ㅇ GROUPING을 사용해 전체합계인 경우에는 mbr_gd를 Total로 표시해 주세요.

결과)
    mbr_gd  mbr_cnt  
    ------  -------  
    GOLD    3052     
    PLAT    1038     
    SILV    5709     
    Total   9799     


답안)
SELECT CASE WHEN GROUPING(t1.mbr_gd) = 1 THEN 'Total' ELSE t1.mbr_gd END mbr_gd, COUNT(*) mbr_cnt
FROM startdbmy.ms_mbr t1
WHERE t1.mbr_st = 'ACTV'
GROUP BY t1.mbr_gd WITH ROLLUP;







------------------------------------------------------------------------
-- BOOSTER QUIZ 10-1-2
------------------------------------------------------------------------
현재 액티브 회원에 대해 회원등급별 가입유형별 회원수를 보여주세요. 전체합계와 중간합계인 회원등급별 회원수도 보여주세요.
  ㅁ 대상 테이블: ms_mbr
  ㅁ 조회 조건: mbr_st가 ACTV인 데이터
  ㅁ 조회 항목: mbr_gd, join_tp, mbr_cnt
    ㅇ mbr_cnt: mbr_gd, join_tp별 회원수
  ㅁ 추가 고려 사항
    ㅇ ROLLUP을 사용해 전체합계와 회원등급(mbr_gd)별 중간합계도 출력해주세요.
    ㅇ GROUPING을 사용해 합계 처리된 항목은 Total로 표시해 주세요.

결과)
    mbr_gd  join_tp  mbr_cnt  
    ------  -------  -------  
    GOLD    DRCT     2098     
    GOLD    INV      315      
    GOLD    SNS      639      
    GOLD    Total    3052     
    PLAT    DRCT     729      
    PLAT    INV      92       
    PLAT    SNS      217      
    PLAT    Total    1038     
    SILV    DRCT     4032     
    SILV    INV      573      
    SILV    SNS      1104     
    SILV    Total    5709     
    Total   Total    9799     

답안)
SELECT CASE WHEN GROUPING(t1.mbr_gd) = 1 THEN 'Total' ELSE t1.mbr_gd END mbr_gd,
       CASE WHEN GROUPING(t1.join_tp) = 1 THEN 'Total' ELSE t1.join_tp END join_tp,
       COUNT(*) mbr_cnt
FROM startdbmy.ms_mbr t1
WHERE t1.mbr_st = 'ACTV'
GROUP BY t1.mbr_gd, t1.join_tp WITH ROLLUP;








------------------------------------------------------------------------
-- BOOSTER QUIZ 10-1-3
------------------------------------------------------------------------
현재 액티브 회원에 대해 가입유형별 회원등급별 회원수를 보여주세요. 전체합계와 중간합계인 가입유형별 회원수도 보여주세요.
  ㅁ 대상 테이블: ms_mbr
  ㅁ 조회 조건: mbr_st가 ACTV인 데이터
  ㅁ 조회 항목: join_tp, mbr_gd, mbr_cnt
    ㅇ mbr_cnt: join_tp, mbr_gd별 회원수
  ㅁ 추가 고려 사항
    ㅇ ROLLUP을 사용해 전체합계와 가입유형(join_tp)별 중간합계도 출력해주세요.
    ㅇ GROUPING을 사용해 합계 처리된 항목은 Total로 표시해 주세요.
    ㅇ [BOOSTER QUIZ 10-1-2]와는 출력되는 중간합계가 다릅니다.
    
결과)
    join_tp  mbr_gd  mbr_cnt  
    -------  ------  -------  
    DRCT     GOLD    2098     
    DRCT     PLAT    729      
    DRCT     SILV    4032     
    DRCT     Total   6859     
    INV      GOLD    315      
    INV      PLAT    92       
    INV      SILV    573      
    INV      Total   980      
    SNS      GOLD    639      
    SNS      PLAT    217      
    SNS      SILV    1104     
    SNS      Total   1960     
    Total    Total   9799     
    
답안)
SELECT CASE WHEN GROUPING(t1.join_tp) = 1 THEN 'Total' ELSE t1.join_tp END join_tp,
       CASE WHEN GROUPING(t1.mbr_gd) = 1 THEN 'Total' ELSE t1.mbr_gd END mbr_gd,
       COUNT(*) mbr_cnt
FROM start_dbmy.ms_mbr t1
WHERE t1.mbr_st = 'ACTV'
GROUP BY t1.join_tp, t1.mbr_gd WITH ROLLUP;







------------------------------------------------------------------------
-- BOOSTER QUIZ 10-1-4
------------------------------------------------------------------------
플래티넘 회원의 2023년 1월, 2023년 2월 주문에 대해, 회원가입유형별, 주문년월별, 지불유형별 주문금액 합계를 보여주세요.
회원가입유형, 주문년월별 중간합계와 회원가입유형별 중간합계 그리고 전체합계도 보여주세요. 각종 코드 값은 명칭으로 변환해서 보여주세요
  ㅁ 대상 테이블: ms_mbr, tr_ord
  ㅁ 조회 조건
    ㅇ ms_mbr: mbr_gd가 PLAT(플래티넘)인 회원 데이터
    ㅇ tr_ord: ord_dtm이 2023년 1월, 2023년 2월인 주문 데이터
  ㅁ 조회 항목: join_tp_nm, ord_ym, pay_tp_nm, ord_amt_sum
    ㅇ join_tp_nm: ms_mbr의 join_tp에 대한 명칭(cm_base_cd를 활용)
    ㅇ ord_ym: tr_ord의 ord_dtm을 DATE_FORMAT을 활용해 년월로 변환한 값
    ㅇ pay_tp_nm: tr_ord의 pay_tp에 대한 명칭(cm_base_cd를 활용)
    ㅇ ord_amt_sum: join_tp, ord_ym, pay_tp_nm에 대한 ord_amt의 SUM 결과
  ㅁ 추가 고려 사항
    ㅇ ROLLUP을 사용해 다음의 합계가 표시되도록 해주세요.
      - 회원가입유형, 주문년월별 중간합계
      - 회원가입유형별 중간합계
      - 전체합계
    ㅇ join_tp와 pay_tp는 코드 값이 아니라, 명칭으로 보여주세요.
    ㅇ 집계된 항목은 Total로 표시해 주세요.
    
결과)
    join_tp_nm                 ord_ym  pay_tp_nm  ord_amt_sum   
    -------------------------  ------  ---------  ------------  
    Direct                     202301  Card       10147000.000  
    Direct                     202301  Cash       408000.000    
    Direct                     202301  Total      10555000.000  
    Direct                     202302  Card       9106000.000   
    Direct                     202302  Cash       474500.000    
    Direct                     202302  Total      9580500.000   
    Direct                     Total   Total      20135500.000  
    Invited                    202301  Card       1169500.000   
    Invited                    202301  Cash       50000.000     
    Invited                    202301  Total      1219500.000   
    Invited                    202302  Card       786500.000    
    Invited                    202302  Cash       44000.000     
    Invited                    202302  Total      830500.000    
    Invited                    Total   Total      2050000.000   
    Social Networking Service  202301  Card       2926000.000   
    Social Networking Service  202301  Cash       128000.000    
    Social Networking Service  202301  Total      3054000.000   
    Social Networking Service  202302  Card       2537000.000   
    Social Networking Service  202302  Cash       53500.000     
    Social Networking Service  202302  Total      2590500.000   
    Social Networking Service  Total   Total      5644500.000   
    Total                      Total   Total      27830000.000  

답안)
SELECT CASE WHEN GROUPING(t3.base_cd_nm) = 1 THEN 'Total' ELSE t3.base_cd_nm END join_tp_nm,
       CASE WHEN GROUPING(DATE_FORMAT(t2.ord_dtm, '%Y%m')) = 1 THEN 'Total' ELSE DATE_FORMAT(t2.ord_dtm, '%Y%m') END ord_ym,
       CASE WHEN GROUPING(t4.base_cd_nm) = 1 THEN 'Total' ELSE t4.base_cd_nm END pay_tp_nm,
       SUM(t2.ord_amt) ord_amt_sum
FROM startdbmy.ms_mbr t1
JOIN startdbmy.tr_ord t2 
ON (t1.mbr_id = t2.mbr_id
AND t2.ord_dtm >= STR_TO_DATE('2023-01-01', '%Y-%m-%d')
AND t2.ord_dtm < STR_TO_DATE('2023-03-01', '%Y-%m-%d')
)
JOIN startdbmy.cm_base_cd t3
ON (t3.base_cd_dv = 'JOIN_TP'
AND t1.join_tp = t3.base_cd
)
JOIN startdbmy.cm_base_cd t4
ON (t4.base_cd_dv = 'PAY_TP'
AND t2.pay_tp = t4.base_cd
)
WHERE t1.mbr_gd = 'PLAT'
GROUP BY t3.base_cd_nm, DATE_FORMAT(t2.ord_dtm, '%Y%m'), t4.base_cd_nm WITH ROLLUP;
    
    
    
    
    
    


------------------------------------------------------------------------
-- BOOSTER QUIZ 10-1-5
------------------------------------------------------------------------
[BOOSTER QUIZ 10-1-4]를 활용합니다. 플래티넘 회원의 2023년 1월, 2023년 2월 주문에 대해, 회원가입유형별, 주문년월별, 지불유형별 주문금액 합계를 보여주세요.
가입유형별 중간합계만 보여주세요. 전체합계와 다른 중간합계는 필요 없습니다.

결과)
    join_tp_nm              ord_ym  pay_tp_nm  ord_amt_sum   
    ----------------------  ------  ---------  ------------  
    Direct                  202301  Card       10147000.000  
    Direct                  202301  Cash       408000.000    
    Direct                  202302  Card       9106000.000   
    Direct                  202302  Cash       474500.000    
    Direct                  Total   Total      20135500.000  
    Invited                 202301  Card       1169500.000   
    Invited                 202301  Cash       50000.000     
    Invited                 202302  Card       786500.000    
    Invited                 202302  Cash       44000.000     
    Invited                 Total   Total      2050000.000   
    Social Network Service  202301  Card       2926000.000   
    Social Network Service  202301  Cash       128000.000    
    Social Network Service  202302  Card       2537000.000   
    Social Network Service  202302  Cash       53500.000     
    Social Network Service  Total   Total      5644500.000   

답안)
(SELECT t3.base_cd_nm join_tp_nm, DATE_FORMAT(t2.ord_dtm,'%Y%m') ord_ym, t4.base_cd_nm pay_tp_nm, SUM(t2.ord_amt) ord_amt_sum
FROM startdbmy.ms_mbr t1
JOIN startdbmy.tr_ord t2 
ON (t1.mbr_id = t2.mbr_id
	AND t2.ord_dtm >= STR_TO_DATE('2023-01-01','%Y-%m-%d')
	AND t2.ord_dtm <  STR_TO_DATE('2023-03-01','%Y-%m-%d')
)
JOIN startdbmy.cm_base_cd t3 
ON (t3.base_cd_dv = 'JOIN_TP'
	AND t3.base_cd    = t1.join_tp
)
JOIN startdbmy.cm_base_cd t4 
ON (t4.base_cd_dv = 'PAY_TP'
	AND t4.base_cd = t2.pay_tp
)
WHERE t1.mbr_gd = 'PLAT'
GROUP BY t3.base_cd_nm, DATE_FORMAT(t2.ord_dtm,'%Y%m'), t4.base_cd_nm
)
UNION ALL
(SELECT t3.base_cd_nm join_tp_nm, 'Total' ord_ym, 'Total' pay_tp_nm, SUM(t2.ord_amt) ord_amt_sum
FROM startdbmy.ms_mbr t1
JOIN startdbmy.tr_ord t2 
ON (t1.mbr_id = t2.mbr_id
	AND t2.ord_dtm >= STR_TO_DATE('2023-01-01','%Y-%m-%d')
	AND t2.ord_dtm <  STR_TO_DATE('2023-03-01','%Y-%m-%d')
)
JOIN startdbmy.cm_base_cd t3 
ON (t3.base_cd_dv = 'JOIN_TP'
	AND t3.base_cd = t1.join_tp
)
WHERE t1.mbr_gd = 'PLAT'
GROUP BY t3.base_cd_nm
)
ORDER BY join_tp_nm, ord_ym, pay_tp_nm;









