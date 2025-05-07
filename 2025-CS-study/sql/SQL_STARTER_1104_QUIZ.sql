

------------------------------------------------------------------------
-- BOOSTER QUIZ 11-4-1
------------------------------------------------------------------------
문제)
‘M0100’, ‘M0200’, ‘M0300’회원의 2023년 1월의 주문 데이터를 조회해 주세요.
주문 리스트와 함께 회원별 주문금액합계도 컬럼으로 추가해 보여주세요.
  ㅁ 대상 테이블: 주문(tr_ord)
  ㅁ 조회 조건: ord_dtm이 2023년 1월이면서 mbr_id가 M0100, M0200, M0300인 데이터
  ㅁ 조회 항목: mbr_id, ord_dtm, ord_amt, ord_amt_ov_mbr
    ㅇ ord_amt_ov_mbr: 조회된 데이터 내에서, 회원별 주문금액의 합계입니다.
      - 분석함수에 PARTITION BY를 적용해 구합니다.
  ㅁ 정렬 기준: mbr_id, ord_dtm으로 오름차순 정렬해 주세요.

결과)
    mbr_id  ord_dtm              ord_amt   ord_amt_ov_mbr  
    ------  -------------------  --------  --------------  
    M0100   2023-01-03 06:46:00  9500.000  22000.000       
    M0100   2023-01-03 09:02:00  5000.000  22000.000       
    M0100   2023-01-03 09:24:00  7500.000  22000.000       
    M0200   2023-01-03 07:10:00  5000.000  14000.000       
    M0200   2023-01-03 09:30:00  9000.000  14000.000       
    M0300   2023-01-07 07:04:00  5000.000  9500.000        
    M0300   2023-01-07 07:10:00  4500.000  9500.000                  

답안)
SELECT t1.mbr_id, t1.ord_dtm, t1.ord_amt, SUM(t1.ord_amt) OVER (PARTITION BY t1.mbr_id) ord_amt_ov_mbr
FROM startdbmy.tr_ord t1
WHERE t1.ord_dtm >= STR_TO_DATE('20230101','%Y%m%d')
AND t1.ord_dtm <  STR_TO_DATE('20230201','%Y%m%d')
AND t1.mbr_id IN ('M0100','M0200','M0300')
ORDER BY t1.mbr_id, t1.ord_dtm;


------------------------------------------------------------------------
-- BOOSTER QUIZ 11-4-2
------------------------------------------------------------------------
문제) [BOOSTER QUIZ 11-4-1]을 활용합니다. 회원별 주문금액에 따른 순위를 구해주세요. 회원별로 주문금액이 가장 큰 데이터가 1위가 됩니다.
  ㅁ 대상 테이블: 주문(tr_ord)
  ㅁ 조회 조건: [BOOSTER QUIZ 11-4-1]을 그대로 이용
  ㅁ 조회 항목: ord_amt_rank_ov를 추가
    ㅇ ord_amt_rank_ov: 회원별 주문금액에 따른 순위를 구합니다.
      - 분석함수에 PARTITION BY와 ORDER BY를 적용해 구합니다.
      - 주문금액이 가장 큰 데이터가 1위가 됩니다.
  ㅁ 정렬 기준: mbr_id, ord_dtm으로 오름차순 정렬해 주세요.


결과)
    mbr_id  ord_dtm              ord_amt   ord_amt_ov_mbr  ord_amt_rank_ov  
    ------  -------------------  --------  --------------  ---------------  
    M0100   2023-01-03 06:46:00  9500.000  22000.000       1                
    M0100   2023-01-03 09:02:00  5000.000  22000.000       3                
    M0100   2023-01-03 09:24:00  7500.000  22000.000       2                
    M0200   2023-01-03 07:10:00  5000.000  14000.000       2                
    M0200   2023-01-03 09:30:00  9000.000  14000.000       1                
    M0300   2023-01-07 07:04:00  5000.000  9500.000        1                
    M0300   2023-01-07 07:10:00  4500.000  9500.000        2                


답안)
SELECT t1.mbr_id, t1.ord_dtm, t1.ord_amt, SUM(t1.ord_amt) OVER (PARTITION BY t1.mbr_id) ord_amt_ov_mbr ,RANK() OVER (PARTITION BY t1.mbr_id ORDER BY t1.ord_amt DESC) ord_amt_rank_ov
FROM startdbmy.tr_ord t1
WHERE t1.ord_dtm >= STR_TO_DATE('20230101','%Y%m%d')
AND t1.ord_dtm <  STR_TO_DATE('20230201','%Y%m%d')
AND t1.mbr_id IN ('M0100','M0200','M0300')
ORDER BY t1.mbr_id, t1.ord_dtm;



------------------------------------------------------------------------
-- BOOSTER QUIZ 11-4-3
------------------------------------------------------------------------
문제) 아래 SQL을 수정해 주문년월별 주문금액합계를 레코드별로 추가해서 보여주세요.
  ㅁ 조회 조건: 아래 SQL을 활용
  ㅁ 조회 항목: ord_amt_sum_ov_ym(주문년월별 주문금액합계)를 추가
    ㅇ ord_amt_sum_ov_ym: 조회된 결과에 대한, 주문년월별 주문금액합계입니다.
      - 주문년월은 ord_dtm을 년월형태(%Y%m)로 변환한 값입니다.
      - 분석함수에 PARTITION BY를 적용해 구합니다.

결과)
    SELECT  t1.ord_no ,t1.shop_id ,t1.ord_dtm ,t1.ord_amt
    FROM    startdbmy.tr_ord t1
    WHERE   t1.ord_dtm >= STR_TO_DATE('20230101','%Y%m%d')
    AND     t1.ord_dtm <  STR_TO_DATE('20230401','%Y%m%d')
    AND     t1.ord_amt >= 10000
    AND     t1.shop_id = 'S282'
    ORDER BY t1.shop_id, t1.ord_dtm;

    -- ord_amt_sum_ov_ym이 추가된 결과
    ord_no  shop_id  ord_dtm              ord_amt    ord_amt_sum_ov_ym  
    ------  -------  -------------------  ---------  -----------------  
    299431  S282     2023-01-03 07:12:00  17000.000  32000.000          
    311312  S282     2023-01-25 07:02:00  15000.000  32000.000          
    327226  S282     2023-02-22 07:01:00  10000.000  10000.000          
    334620  S282     2023-03-06 07:06:00  19000.000  44000.000          
    338596  S282     2023-03-13 07:02:00  10000.000  44000.000          
    339242  S282     2023-03-14 07:01:00  15000.000  44000.000          

답안)
SELECT t1.ord_no, t1.shop_id, t1.ord_dtm, t1.ord_amt, SUM(t1.ord_amt) OVER (PARTITION BY DATE_FORMAT(t1.ord_dtm,'%Y%m')) ord_amt_sum_ov_ym
FROM startdbmy.tr_ord t1
WHERE t1.ord_dtm >= STR_TO_DATE('20230101','%Y%m%d')
AND t1.ord_dtm <  STR_TO_DATE('20230401','%Y%m%d')
AND t1.ord_amt >= 10000
AND t1.shop_id = 'S282'
ORDER BY t1.shop_id, t1.ord_dtm;



------------------------------------------------------------------------
-- BOOSTER QUIZ 11-4-4
------------------------------------------------------------------------
문제) 아래 SQL을 수정해 주문시간별 상품카테고리별 주문수량합계를 레코드별로 추가해서 보여주세요.
  ㅁ 조회 조건: 아래 SQL을 활용
  ㅁ 조회 항목: ord_qty_sum_ov_hour_cat(주문시간별 상품카테고리별 주문수량합계)를 추가
    ㅇ ord_qty_sum_ov_hour_cat: 조회된 결과에 대한, 주문시간대별, 상품카테고리별 주문수량합계입니다.
      - 주문시간대: ord_dtm을 시간(%H)으로 변환한 값입니다.
      - 분석함수에 PARTITION BY를 적용해 구합니다.
      - PARTITION BY에 주문시간대와 상품카테고리(item_cat) 두 개를 사용합니다.

결과)
    SELECT  t1.ord_no ,t4.item_cat ,t4.item_cat_nm ,t3.item_nm 
            ,DATE_FORMAT(t1.ord_dtm,'%H') ord_hour, t2.ord_qty
    FROM    startdbmy.tr_ord t1
            INNER JOIN startdbmy.tr_ord_det t2
                ON (t2.ord_no = t1.ord_no)
            INNER JOIN startdbmy.ms_item t3
                ON (t3.item_id = t2.item_id)
            INNER JOIN startdbmy.ms_item_cat t4
                ON (t4.item_cat = t3.item_cat)
    WHERE   t1.ord_dtm >= STR_TO_DATE('20230101','%Y%m%d')
    AND     t1.ord_dtm <  STR_TO_DATE('20230102','%Y%m%d')
    AND     t1.ord_amt >= 10000
    AND     t1.shop_id IN ('S100')
    AND     t4.item_cat IN ('BKR','COF')
    ORDER BY t1.shop_id ,ord_hour;

    -- ord_qty_sum_ov_hour_cat 추가된 결과입니다.
    ord_no  item_cat  item_cat_nm  item_nm              ord_hour  ord_qty  ord_qty_sum_ov_hour_cat  
    ------  --------  -----------  -------------------  --------  -------  -----------------------  
    298201  BKR       Bakery       Chocolate Muffin(R)  07        2        6                        
    298260  BKR       Bakery       Chocolate Muffin(R)  07        2        6                        
    298290  BKR       Bakery       Bagel(R)             07        2        6                        
    297797  COF       Coffee       Iced Cafe Latte(B)   07        2        10                       
    298127  COF       Coffee       Cafe Latte(B)        07        2        10                       
    298201  COF       Coffee       Americano(B)         07        2        10                       
    298260  COF       Coffee       Cafe Latte(R)        07        2        10                       
    298290  COF       Coffee       Americano(B)         07        2        10                       
    298306  COF       Coffee       Cafe Latte(B)        08        2        6                        
    298307  COF       Coffee       Iced Cafe Latte(B)   08        2        6                        
    298320  COF       Coffee       Iced Cafe Latte(B)   08        2        6                        
    298322  BKR       Bakery       Chocolate Muffin(R)  09        2        2                        
    298322  COF       Coffee       Cafe Latte(B)        09        2        2                        
    298336  COF       Coffee       Cafe Latte(R)        10        2        2                        



답안)
SELECT t1.ord_no, t4.item_cat, t4.item_cat_nm, t3.item_nm, DATE_FORMAT(t1.ord_dtm,'%H') ord_hour, t2.ord_qty, SUM(t2.ord_qty) OVER (PARTITION BY DATE_FORMAT(t1.ord_dtm,'%H'), t4.item_cat) ord_qty_sum_ov_hour_cat
FROM startdbmy.tr_ord t1
JOIN startdbmy.tr_ord_det t2 
ON t2.ord_no = t1.ord_no
JOIN startdbmy.ms_item t3
ON t3.item_id = t2.item_id
JOIN startdbmy.ms_item_cat t4
ON t4.item_cat = t3.item_cat
WHERE t1.ord_dtm >= STR_TO_DATE('20230101','%Y%m%d')
AND t1.ord_dtm <  STR_TO_DATE('20230102','%Y%m%d')
AND t1.ord_amt >= 10000
AND t1.shop_id IN ('S100')
AND t4.item_cat IN ('BKR','COF')
ORDER BY ord_hour, ord_qty_sum_ov_hour_cat; -- 정답은 이 순서가 맞는 것 같습니다





------------------------------------------------------------------------
-- BOOSTER QUIZ 11-4-5
------------------------------------------------------------------------
문제) 
아래 SQL은 매장별, 일별 주문금액합계를 처리하고 있습니다.
아래 SQL을 인라인 뷰로 처리하고, 인라인 뷰 바깥에서 주문일자별 주문금액합계에 따른 순위를 구해주세요.
  ㅁ 조회 조건: 아래 SQL을 활용
  ㅁ 조회 항목: ord_amt_rank_ov_ymd(주문일자별 주문금액합계 순위)를 추가
    ㅇ ord_amt_rank_ov_ymd: 조회 결과에 대한, 주문일자별 주문금액합계(ord_amt_sum)에 따른 순위입니다.
      - 주문금액합계가 크면 1위가 됩니다.
      - 아래 SQL을 인라인 뷰로 처리하고, 인라인 뷰 바깥에서 RANK 분석함수로 처리하세요.



결과)
    SELECT  t2.shop_id ,MAX(t2.shop_nm) shop_nm ,DATE_FORMAT(t1.ord_dtm,'%Y%m%d') ord_ymd
            ,SUM(t1.ord_amt) ord_amt_sum
    FROM    startdbmy.tr_ord t1
            INNER JOIN startdbmy.ms_shop t2
                ON (t2.shop_id = t1.shop_id)
    WHERE   t1.ord_dtm >= STR_TO_DATE('20240101','%Y%m%d')
    AND     t1.ord_dtm <  STR_TO_DATE('20240104','%Y%m%d')
    AND     t2.shop_oper_tp = 'FLAG'
    AND     t2.shop_size >= 160
    GROUP BY t2.shop_id ,DATE_FORMAT(t1.ord_dtm,'%Y%m%d')
    ORDER BY t2.shop_id ,DATE_FORMAT(t1.ord_dtm,'%Y%m%d');


    -- ord_amt_rank_ov_ymd가 추가된 결과입니다.
    shop_id  shop_nm        ord_ymd   ord_amt_sum  ord_amt_rank_ov_ymd  
    -------  -------------  --------  -----------  -------------------  
    S183     Chicago-10th   20240101  48500.000    1                    
    S074     Columbus-4th   20240101  38100.000    2                    
    S191     Austin-10th    20240101  24700.000    3                    
    S290     San Jose-15th  20240102  30600.000    1                    
    S183     Chicago-10th   20240102  15800.000    2                    
    S191     Austin-10th    20240102  4500.000     3                    
    S191     Austin-10th    20240103  17000.000    1                    
    S074     Columbus-4th   20240103  11300.000    2                    
    S183     Chicago-10th   20240103  4500.000     3                    
        
답안)
SELECT t3.*, RANK() OVER (PARTITION BY t3.ord_ymd ORDER BY t3.ord_amt_sum DESC) ord_amt_rank_ov_ymd
FROM (SELECT t2.shop_id ,MAX(t2.shop_nm) shop_nm ,DATE_FORMAT(t1.ord_dtm,'%Y%m%d') ord_ymd,SUM(t1.ord_amt) ord_amt_sum
      FROM startdbmy.tr_ord t1
      INNER JOIN startdbmy.ms_shop t2
      ON (t2.shop_id = t1.shop_id)
      WHERE   t1.ord_dtm >= STR_TO_DATE('20240101','%Y%m%d')
      AND     t1.ord_dtm <  STR_TO_DATE('20240104','%Y%m%d')
      AND     t2.shop_oper_tp = 'FLAG'
      AND     t2.shop_size >= 160
      GROUP BY t2.shop_id ,DATE_FORMAT(t1.ord_dtm,'%Y%m%d')
      ORDER BY t2.shop_id ,DATE_FORMAT(t1.ord_dtm,'%Y%m%d')
     ) t3;






        
------------------------------------------------------------------------
-- BOOSTER QUIZ 11-4-6
------------------------------------------------------------------------

문제) 
[BOOSTER QUIZ 11-4-5]를 활용해 주문일자별 1위인 데이터만 출력해 주세요.
  ㅁ 조회 조건: [BOOSTER QUIZ 11-4-5]를 활용
  

결과)                    
    shop_id  shop_nm        ord_ymd   ord_amt_sum  ord_amt_rank_ov  
    -------  -------------  --------  -----------  ---------------  
    S183     Chicago-10th   20240101  48500.000    1                
    S290     San Jose-15th  20240102  30600.000    1                
    S191     Austin-10th    20240103  17000.000    1                


답안)
SELECT t3.*
FROM (SELECT t2.shop_id ,MAX(t2.shop_nm) shop_nm ,DATE_FORMAT(t1.ord_dtm,'%Y%m%d') ord_ymd, SUM(t1.ord_amt) ord_amt_sum, RANK() OVER (PARTITION BY DATE_FORMAT(t1.ord_dtm,'%Y%m%d') ORDER BY SUM(t1.ord_amt) DESC) ord_amt_rank_ov
      FROM startdbmy.tr_ord t1
      INNER JOIN startdbmy.ms_shop t2
      ON (t2.shop_id = t1.shop_id)
      WHERE   t1.ord_dtm >= STR_TO_DATE('20240101','%Y%m%d')
      AND     t1.ord_dtm <  STR_TO_DATE('20240104','%Y%m%d')
      AND     t2.shop_oper_tp = 'FLAG'
      AND     t2.shop_size >= 160
      GROUP BY t2.shop_id ,DATE_FORMAT(t1.ord_dtm,'%Y%m%d')
      ORDER BY ord_ymd
     ) t3
WHERE t3.ord_amt_rank_ov = 1;





------------------------------------------------------------------------
-- BOOSTER QUIZ 11-4-7
------------------------------------------------------------------------
문제) 2020년부터 2024년까지의 커피 상품카테고리 주문 중에, 년도별로 가장 많이 팔린 상품 하나씩만 보여주세요.
  ㅁ 대상 테이블: tr_ord, tr_ord_det, ms_item
  ㅁ 조회 조건
    ㅇ tr_ord: ord_dtm이 2020년부터 2024년 마지막 날까지
    ㅇ ms_item: item_cat가 COF(커피)만
  ㅁ 조회 항목: ord_yy, item_id, item_nm, ord_qty_sum, ord_qty_sum_rank_ov 
    ㅇ ord_yy: ord_dtm을 DATE_FORMAT을 사용해 년도만 추출한 값입니다.
    ㅇ ord_qty_sum: ord_yy별, item_id별 ord_qty의 합계입니다.
    ㅇ ord_qty_sum_rank_ov: ord_yy별 ord_qty_sum에 따른 순위입니다.
      - ord_qty_sum이 가장 크면 1위입니다.
  ㅁ 추가 고려 사항:
    ㅇ ord_yy별 ord_qty_sum_rank_ov가 1위인 데이터만 최종 출력해 주세요.
    
        
결과)

    ord_yy  item_id  item_nm            ord_qty_sum  ord_qty_sum_rank_ov  
    ------  -------  -----------------  -----------  -------------------  
    2020    IAMR     Iced Americano(R)  8496         1                    
    2021    IAMB     Iced Americano(B)  10480        1                    
    2022    AMR      Americano(R)       22617        1                    
    2023    IAMB     Iced Americano(B)  31856        1                    
    2024    IAMR     Iced Americano(R)  31515        1                    


답안)
SELECT t4.*
FROM (SELECT DATE_FORMAT(t1.ord_dtm, '%Y') ord_yy, t2.item_id, t3.item_nm, SUM(t2.ord_qty) ord_qty_sum, RANK() OVER (PARTITION BY DATE_FORMAT(t1.ord_dtm, '%Y') ORDER BY SUM(t2.ord_qty) DESC) ord_qty_sum_rank_ov
      FROM startdbmy.tr_ord t1
      JOIN startdbmy.tr_ord_det t2 
      ON t2.ord_no = t1.ord_no
      JOIN startdbmy.ms_item t3 
      ON (t3.item_id = t2.item_id
      AND t3.item_cat = 'COF')
      WHERE t1.ord_dtm >= STR_TO_DATE('20200101', '%Y%m%d')
      AND t1.ord_dtm <  STR_TO_DATE('20250101', '%Y%m%d')
      GROUP BY ord_yy, item_id
     ) t4
WHERE ord_qty_sum_rank_ov = 1;




