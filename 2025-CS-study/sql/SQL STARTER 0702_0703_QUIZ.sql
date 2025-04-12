

------------------------------------------------------------------------
-- BOOSTER QUIZ 7-2-1
------------------------------------------------------------------------


문제)
아래 SQL을 보고 다음 질문에 답하세요.
  ㅁ 아래 SQL에서 조인 조건에 해당하는 번호를 모두 적으세요.
  ㅁ 아래 SQL에서 ms_mbr 테이블의 필터 조건에 해당하는 번호를 모두 적으세요.
  ㅁ 아래 SQL에서 tr_ord 테이블의 필터 조건에 해당하는 번호를 모두 적으세요.

    SELECT  t1.mbr_id ,t1.nick_nm ,t1.mbr_gd
            ,t2.ord_no ,t2.ord_dtm ,t2.shop_id ,t2.ord_amt
    FROM    startdbmy.ms_mbr t1
            INNER JOIN startdbmy.tr_ord t2
                ON (t2.ord_dtm >= STR_TO_DATE('20221001','%Y%m%d')     -- (1)
                AND t2.ord_dtm <  STR_TO_DATE('20221002','%Y%m%d')     -- (2)
                AND t2.mbr_id = t1.mbr_id                              -- (3)
                )
    WHERE   t1.mbr_gd = 'GOLD'                                         -- (4)
    AND     t2.shop_id = 'S002'                                        -- (5)
    ORDER BY t1.mbr_id;

    
답안)
-- JOIN 조건: 3
-- ms_mbr 테이블 필터 조건: 4
-- tr_ord 테이블 필터 조건: 1, 2, 5


------------------------------------------------------------------------
-- BOOSTER QUIZ 7-2-2
------------------------------------------------------------------------

문제)
(SQL-1)과 (SQL-2)의 각각의 결과를 확인하고, (SQL-3)을 실행했다고 가정하고 질문에 답하세요
  ㅁ (SQL-3)은 (SQL-1)과 (SQL-2)를 mbr_id로 이너 조인한 SQL입니다.
  ㅁ (SQL-3)을 실행하면 nick_nm이 Air인 데이터는 몇 건인가요?
  ㅁ (SQL-3)을 실행하면 nick_nm이 Water1인 데이터는 몇 건인가요?

    -- (SQL-1)
    SELECT  t1.mbr_id ,t1.nick_nm
    FROM    startdbmy.ms_mbr t1
    WHERE   t1.Mbr_id IN ('M0001','M0099');

    -- (SQL-2)
    SELECT  t2.ord_no ,t2.ord_dtm ,t2.mbr_id
    FROM    startdbmy.tr_ord t2
    WHERE   t2.Mbr_id IN ('M0001','M0099')
    AND     t2.ord_dtm >= STR_TO_DATE('20201005','%Y%m%d')
    AND     t2.ord_dtm <  STR_TO_DATE('20201007','%Y%m%d')
    ORDER BY t2.ord_no;

    -- (SQL-1)의 결과
    mbr_id  nick_nm  
    ------  -------  
    M0001   Air      
    M0099   Water1   
    
    -- (SQL-2)의 결과
    ord_no  ord_dtm              mbr_id  
    ------  -------------------  ------  
    65231   2020-10-05 07:12:00  M0001   
    65387   2020-10-06 06:39:00  M0099   
    65453   2020-10-06 07:03:00  M0001   
    65531   2020-10-06 08:36:00  M0099   
    65537   2020-10-06 08:42:00  M0099   
    
    -- (SQL-3): (SQL-1)과 (SQL-2)를 이너 조인한 SQL
    SELECT  t1.mbr_id ,t1.nick_nm ,t2.ord_no ,t2.ord_dtm ,t2.mbr_id
    FROM    startdbmy.ms_mbr t1
            INNER JOIN startdbmy.tr_ord t2
                ON (t1.mbr_id = t2.mbr_id)
    WHERE   t1.mbr_id IN ('M0001','M0099')
    AND     t2.mbr_id IN ('M0001','M0099')
    AND     t2.ord_dtm >= STR_TO_DATE('20201005','%Y%m%d')
    AND     t2.ord_dtm <  STR_TO_DATE('20201007','%Y%m%d')
    ORDER BY t1.mbr_id ,t2.ord_no;

답안)
-- 3건.
    


------------------------------------------------------------------------
-- BOOSTER QUIZ 7-2-3
------------------------------------------------------------------------

문제)
(SQL-1)과 (SQL-2)의 각각의 결과를 확인하고, (SQL-3)을 실행했다고 가정하고 질문에 답하세요
  ㅁ (SQL-3)은 (SQL-1)과 (SQL-2)를 mbr_id로 이너 조인한 SQL입니다.
  ㅁ (SQL-3)의 실행 결과에 포함되지 않는 ms_mbr 테이블의 mbr_id는?
  ㅁ (SQL-3)의 실행 결과에 포함되지 않는 tr_ord 테이블의 ord_no는?

    -- (SQL-1)
    SELECT  t1.mbr_id ,t1.nick_nm ,t1.mbr_gd
    FROM    startdbmy.ms_mbr t1
    WHERE   t1.join_dtm = STR_TO_DATE('20220421','%Y%m%d')
    AND     t1.mbr_gd = 'PLAT'
    ORDER BY t1.mbr_id;

    -- (SQL-2)
    SELECT  t2.ord_no ,t2.ord_dtm ,t2.mbr_id ,t2.shop_id ,t2.ord_amt
    FROM    startdbmy.tr_ord t2
    WHERE   t2.ord_dtm >= STR_TO_DATE('20221021:07','%Y%m%d:%H')
    AND     t2.ord_dtm <  STR_TO_DATE('20221021:08','%Y%m%d:%H')
    AND     t2.shop_id = 'S067'
    ORDER BY t2.ord_no;

    -- (SQL-1)의 결과
    mbr_id  nick_nm   mbr_gd  
    ------  --------  ------  
    M3017   Gold60    PLAT    
    M3196   Sweet63   PLAT    
    M3366   Galaxy67  PLAT     

    -- (SQL-2)의 결과
    ord_no  ord_dtm              mbr_id  shop_id  ord_amt   
    ------  -------------------  ------  -------  --------  
    254529  2022-10-21 07:02:00  M1866   S067     7500.000  
    254667  2022-10-21 07:04:00  M3366   S067     4000.000  
    254829  2022-10-21 07:12:00  M1866   S067     7500.000  
    254830  2022-10-21 07:12:00  M1866   S067     8500.000  

    -- (SQL-3)
    SELECT  t1.mbr_id ,t1.nick_nm ,t1.mbr_gd ,t1.join_dtm
            ,t2.ord_no ,t2.ord_dtm ,t2.mbr_id, t2.shop_id ,t2.ord_amt
    FROM    startdbmy.ms_mbr t1
            INNER JOIN startdbmy.tr_ord t2
                ON (t2.mbr_id = t1.mbr_id)
    WHERE   t1.join_dtm = STR_TO_DATE('20220421','%Y%m%d')
    AND     t1.mbr_gd = 'PLAT'
    AND     t2.ord_dtm >= STR_TO_DATE('20221021:07','%Y%m%d:%H')
    AND     t2.ord_dtm <  STR_TO_DATE('20221021:08','%Y%m%d:%H')
    AND     t2.shop_id = 'S067'
    ORDER BY t1.mbr_id;

답안)
-- ms_mbr 테이블: M3017, M3196
-- tr_ord 테이블: 254529, 254829, 254830
    
  
  
  
------------------------------------------------------------------------
-- BOOSTER QUIZ 7-2-4
------------------------------------------------------------------------

문제)
아래의 명시적 조인 SQL을 비명시적 조인 SQL로 변경하세요.

    SELECT  t1.mbr_id ,t1.nick_nm ,t1.mbr_gd
            ,t2.ord_no ,t2.ord_dtm ,t2.shop_id ,t2.ord_amt
    FROM    startdbmy.ms_mbr t1
            INNER JOIN startdbmy.tr_ord t2
                ON (t2.ord_dtm >= STR_TO_DATE('20221001','%Y%m%d')     
                AND t2.ord_dtm <  STR_TO_DATE('20221002','%Y%m%d')    
                AND t2.mbr_id = t1.mbr_id                              
                )
    WHERE   t1.mbr_gd = 'GOLD'                                         
    AND     t2.shop_id = 'S002'                                        
    ORDER BY t1.mbr_id;

답안)
SELECT t1.mbr_id, t1.nick_nm, t1.mbr_gd, t2.ord_no, t2.ord_dtm, t2.shop_id, t2.ord_amt
FROM startdbmy.ms_mbr t1, startdbmy.tr_ord t2
WHERE t1.mbr_gd = 'GOLD' 
AND t2.shop_id = 'S002' 
AND t2.ord_dtm >= STR_TO_DATE('20221001','%Y%m%d') 
AND t2.ord_dtm < STR_TO_DATE('20221002','%Y%m%d') 
AND t1.mbr_id = t2.mbr_id
ORDER BY t1.mbr_id;
    
    
    
  
------------------------------------------------------------------------
-- BOOSTER QUIZ 7-3-1
------------------------------------------------------------------------
문제)
S062 매장의 2023년 3월 31일 7시부터 12시까지의 주문과 주문 상세 내역을 출력해주세요.
  ㅁ 대상 테이블: 주문(tr_ord)과 주문상세(tr_ord_det)
  ㅁ 조회 조건: shop_id가 S062이면서 ord_dtm이 2023년 3월 31일 07시부터 ord_dtm이 2023년 3월 31일 12시 이전
  ㅁ 조회 항목: ord_no, ord_dtm, shop_id, ord_det_no, item_id, ord_qty, sale_prc
  ㅁ 정렬 기준: ord_no로 오름차순 후 ord_det_no로 오름차순 정렬해서 보여주세요.
  
결과)
    ord_no  ord_dtm              shop_id  ord_det_no  item_id  ord_qty  sale_prc  
    ------  -------------------  -------  ----------  -------  -------  --------  
    348150  2023-03-31 07:02:00  S062     1           CLR      2        5000.000  
    348150  2023-03-31 07:02:00  S062     2           CMFR     2        3500.000  
    348290  2023-03-31 07:04:00  S062     1           CLR      1        5000.000  
    348372  2023-03-31 07:06:00  S062     1           CLB      1        5000.000  
    348526  2023-03-31 07:16:00  S062     1           CLR      2        5000.000  
    348550  2023-03-31 07:20:00  S062     1           AMR      1        4500.000  
    348550  2023-03-31 07:20:00  S062     2           BGLR     1        3000.000  

답안)
SELECT t1.ord_no, t1.ord_dtm, t1.shop_id, t2.ord_det_no, t2.item_id, t2.ord_qty, t2.sale_prc
FROM startdbmy.tr_ord t1, startdbmy.tr_ord_det t2
WHERE t1.shop_id = 'S062'
AND t1.ord_dtm >= STR_TO_DATE('20230331:07','%Y%m%d:%H')
AND t1.ord_dtm < STR_TO_DATE('20230331:12','%Y%m%d:%H')
AND t1.ord_no = t2.ord_no
ORDER BY t1.ord_no, t2.ord_det_no;



  
------------------------------------------------------------------------
-- BOOSTER QUIZ 7-3-2
------------------------------------------------------------------------
문제)
'S230' 매장의 '2023년 1월 1일' 주문 중에, '아메리카노빅사이즈' 관련 주문 정보를 출력해주세요.
  ㅁ 대상 테이블: 주문(tr_ord)과 주문상세(tr_ord_det)
  ㅁ 조회 조건
    ㅇ shop_id가 S230이면서 ord_dtm이 2023년 1월 1일인 주문 데이터
    ㅇ item_id가 AMB(아메리카노빅사이즈)인 주문상세 데이터
  ㅁ 조회 항목: ord_no, ord_dtm, shop_id, ord_det_no, item_id, ord_qty, sale_prc
  ㅁ 정렬 기준: ord_no로 오름차순 정렬해주세요.
  
결과)
    ord_no  ord_dtm              shop_id  ord_det_no  item_id  ord_qty  sale_prc  
    ------  -------------------  -------  ----------  -------  -------  --------  
    298094  2023-01-01 07:06:00  S230     1           AMB      1        4500.000  
    298244  2023-01-01 07:25:00  S230     1           AMB      1        4500.000  

답안)
SELECT t1.ord_no, t1.ord_dtm, t1.shop_id, t2.ord_det_no, t2.item_id, t2.ord_qty, t2.sale_prc
FROM startdbmy.tr_ord t1, startdbmy.tr_ord_det t2
WHERE t1.shop_id = 'S230'
AND t1.ord_dtm >= STR_TO_DATE('20230101','%Y%m%d')
AND t1.ord_dtm < STR_TO_DATE('20230102','%Y%m%d')
AND t2.item_id = 'AMB'
AND t1.ord_no = t2.ord_no
ORDER BY t1.ord_no;



------------------------------------------------------------------------
-- BOOSTER QUIZ 7-3-3
------------------------------------------------------------------------
문제)
주문번호 91810에 포함된 주문 상세 내역을 보여주세요. 주문된 상품의 상품명도 같이 보여주세요.
  ㅁ 대상 테이블: 주문상세(tr_ord_det)와 상품(ms_item)
  ㅁ 조회 조건: ord_no가 91810인 주문 데이터
  ㅁ 조회 항목: ord_no, ord_det_no, ord_qty, sale_prc, item_id, item_nm
  ㅁ 정렬 기준: ord_det_no로 오름차순 정렬해주세요.

결과)
    ord_no  ord_det_no  ord_qty  sale_prc  item_id  item_nm              
    ------  ----------  -------  --------  -------  -------------------  
    91810   1           1        4500.000  ICLB     Iced Cafe Latte(B)   
    91810   2           1        3000.000  BMFR     Blueberry Muffin(R)  

답안)
SELECT t1.ord_no, t1.ord_det_no, t1.ord_qty, t1.sale_prc, t2.item_id, t2.item_nm
FROM startdbmy.tr_ord_det t1, startdbmy.ms_item t2
WHERE t1.ord_no = 91810
AND t1.item_id = t2.item_id
ORDER BY t1.ord_det_no;

