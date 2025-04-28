
------------------------------------------------------------------------
-- BOOSTER QUIZ 10-2-1
------------------------------------------------------------------------

문제)
아래의 (SQL-1)을 실행하면 (결과-1)과 같은 결과가 출력됩니다. (결과-1)을 (결과-2)와 같이 변경해 주세요.
(결과-2)는 회원ID별로 일자에 따른 주문금액을 각각의 컬럼으로 집계한 것입니다.
  ㅁ 대상 테이블: tr_ord
  ㅁ 조회 조건: 아래의 (SQL-1)과 동일
  ㅁ 조회 항목: mbr_id, ord_amt_0101, ord_amt_0102, ord_amt_0103
    ㅇ ord_amt_0101: mbr_id별 2023년 1월 1일의 주문금액 합계
    ㅇ ord_amt_0102: mbr_id별 2023년 1월 2일의 주문금액 합계
    ㅇ ord_amt_0103: mbr_id별 2023년 1월 3일의 주문금액 합계
  ㅁ 추가 고려 사항
    ㅇ mbr_id별 GROUP BY 처리합니다.
  ㅁ 정렬 기준: mbr_id로 오름차순 정렬해 주세요.
    
    
    
결과)
    -- (SQL-1)
    SELECT  t1.mbr_id ,t1.ord_dtm ,t1.shop_id, t1.ord_amt
    FROM    startdbmy.tr_ord t1
    WHERE   t1.ord_dtm >= STR_TO_DATE('20230101','%Y%m%d')
    AND     t1.ord_dtm <  STR_TO_DATE('20230104','%Y%m%d')
    AND     t1.shop_id = 'S028'
    ORDER BY t1.mbr_id ,t1.ord_dtm;

    -- (결과-1)
    mbr_id  ord_dtm              shop_id  ord_amt   
    ------  -------------------  -------  --------  
    M0027   2023-01-01 07:04:00  S028     5000.000  
    M0027   2023-01-02 07:08:00  S028     4500.000  
    M0027   2023-01-03 07:02:00  S028     5000.000  
    M3627   2023-01-02 07:01:00  S028     4500.000  
    M3627   2023-01-02 07:06:00  S028     4500.000  
    M3627   2023-01-02 07:06:00  S028     5000.000  
    M3927   2023-01-01 07:02:00  S028     8500.000  

    -- 결과-2)
    mbr_id  ord_amt_0101  ord_amt_0102  ord_amt_0103  
    ------  ------------  ------------  ------------  
    M0027   5000.000      4500.000      5000.000      
    M3627   NULL          14000.000     NULL          
    M3927   8500.000      NULL          NULL          


답안)
SELECT t1.mbr_id, 
       SUM(CASE WHEN DATE_FORMAT(t1.ord_dtm, '%Y%m%d') = '20230101' THEN t1.ord_amt END) AS ord_amt_0101,
       SUM(CASE WHEN DATE_FORMAT(t1.ord_dtm, '%Y%m%d') = '20230102' THEN t1.ord_amt END) AS ord_amt_0102,
       SUM(CASE WHEN DATE_FORMAT(t1.ord_dtm, '%Y%m%d') = '20230103' THEN t1.ord_amt END) AS ord_amt_0103
FROM   startdbmy.tr_ord t1
WHERE ord_dtm >= STR_TO_DATE('20230101','%Y%m%d')
AND t1.ord_dtm <  STR_TO_DATE('20230104','%Y%m%d')
AND t1.shop_id = 'S028'
GROUP BY t1.mbr_id
ORDER BY t1.mbr_id;




------------------------------------------------------------------------
-- BOOSTER QUIZ 10-2-2
------------------------------------------------------------------------


문제)
[BOOSTER-QUIZ 10-2-1]의 (결과-1)을 아래의 (결과-3)과 같이 변경해 주세요.
(결과-3)은 주문일자별로 회원별 주문건수를 구한 결과입니다. 이때, 회원별 주문건수는 회원별로 각각의 컬럼으로 표현합니다.

  ㅁ 대상 테이블: tr_ord
  ㅁ 조회 조건: [BOOSTER-QUIZ 10-2-1]의 (SQL-1)과 동일
  ㅁ 조회 항목: ord_ymd, ord_cnt_M0027, ord_cnt_M3627, ord_cnt_M3927
    ㅇ ord_ymd: ord_dtm을 YYYYMMDD 형태로 변경한 문자열
    ㅇ ord_cnt_M0027: ord_ymd별 M0027 회원의 주문건수
    ㅇ ord_cnt_M3627: ord_ymd별 M3627 회원의 주문건수
    ㅇ ord_cnt_M3927: ord_ymd별 M3927 회원의 주문건수
  ㅁ 추가 고려 사항
    ㅇ ord_ymd별 GROUP BY 처리합니다.
    ㅇ 주문건수가 없는 셀은 0으로 처리해서 보여주세요.
  ㅁ 정렬 기준: ord_ymd로 오름차순 정렬해 주세요.
  
결과)
    -- (결과-3)
    ord_ymd   ord_cnt_M0027  ord_cnt_M3627  ord_cnt_M3927  
    --------  -------------  -------------  -------------  
    20230101  1              0              1              
    20230102  1              3              0              
    20230103  1              0              0              


답안)
SELECT DATE_FORMAT(t1.ord_dtm, '%Y%m%d') ord_ymd, 
        SUM(CASE WHEN t1.mbr_id = 'M0027' THEN 1 ELSE 0 END) AS ord_cnt_M0027,
        SUM(CASE WHEN t1.mbr_id = 'M3627' THEN 1 ELSE 0 END) AS ord_cnt_M3627,
        SUM(CASE WHEN t1.mbr_id = 'M3927' THEN 1 ELSE 0 END) AS ord_cnt_M3927
FROM startdbmy.tr_ord t1
WHERE t1.ord_dtm >= STR_TO_DATE('20230101','%Y%m%d')
AND t1.ord_dtm < STR_TO_DATE('20230104', '%Y%m%d')
AND t1.shop_id = 'S028'
GROUP BY DATE_FORMAT(t1.ord_dtm, '%Y%m%d')
ORDER BY ord_ymd;








------------------------------------------------------------------------
-- BOOSTER QUIZ 10-2-3
------------------------------------------------------------------------
문제)
S001, S002 매장의 2023년 1월과 2023년 2월 주문 데이터에 대해, 주문년월별, 매장별, 상품카테고리별 주문수량을 집계해 주세요.
(현재 SQL은 피벗 처리가 포함되지 않은 단순 GROUP BY SQL입니다.)
  ㅁ 대상 테이블: ms_shop, tr_ord, ms_item
  ㅁ 조회 조건
    ㅇ ms_shop: shop_id가 S001, S002인 데이터
    ㅇ tr_ord: ord_dtm이 2023년 1월, 2023년 2월인 데이터
  ㅁ 조회 항목: ord_ym, shop_id, item_cat, ord_qty_sum
    ㅇ ord_ym: ord_dtm을 YYYYMM 형태로 변환한 문자 값입니다.
    ㅇ ord_qty_sum: shop_id, item_cat별 ord_qty를 SUM 처리한 결과입니다.
  ㅁ 추가 고려 사항
    ㅇ ord_ym, shop_id, item_cat로 GROUP BY 처리합니다.
    ㅇ 피벗 처리 없는 단순 GROUP BY 집계 SQL입니다.
  ㅁ 정렬 기준: ord_ym, shop_id, item_cat로 오름차순 정렬해 주세요.
  
  
결과)
    ord_ym  shop_id  item_cat  ord_qty_sum  
    ------  -------  --------  -----------  
    202301  S001     BEV       25           
    202301  S001     BKR       47           
    202301  S001     COF       172          
    202301  S002     BEV       43           
    202301  S002     BKR       41           
    202301  S002     COF       210          
    202302  S001     BEV       33           
    202302  S001     BKR       20           
    202302  S001     COF       139          
    202302  S002     BEV       28           
    202302  S002     BKR       31           
    202302  S002     COF       176          

답안)
SELECT DATE_FORMAT(t1.ord_dtm,'%Y%m') ord_ym, t1.shop_id, t3.item_cat, SUM(t2.ord_qty) ord_qty_sum
FROM startdbmy.tr_ord t1
LEFT JOIN startdbmy.tr_ord_det t2
ON (t1.ord_no = t2.ord_no)
JOIN startdbmy.ms_item t3 ON t2.item_id = t3.item_id
WHERE t1.shop_id IN ('S001','S002')
AND t1.ord_dtm >= STR_TO_DATE('20230101','%Y%m%d')
AND t1.ord_dtm <  STR_TO_DATE('20230301','%Y%m%d')
GROUP BY DATE_FORMAT(t1.ord_dtm, '%Y%m'), t1.shop_id, t3.item_cat
ORDER BY ord_ym, t1.shop_id, t3.item_cat;






------------------------------------------------------------------------
-- BOOSTER QUIZ 10-2-4
------------------------------------------------------------------------

문제)
[BOOSTER QUIZ 10-2-3]의 답안 SQL을 인라인 뷰로 처리합니다.
인라인 뷰의 결과를 주문년월과 상품카테고리 기준으로 피벗 처리해 주세요.
매장ID별 주문수량의 합계를 각각의 컬럼으로 표시해 주세요.

  ㅁ 대상 테이블: ms_shop, tr_ord, ms_item
  ㅁ 조회 조건
    ㅇ [BOOSTER QUIZ 10-2-3]의 답안 SQL을 인라인 뷰로 처리하세요.
  ㅁ 조회 항목: ord_ym, item_cat, qty_S001, qty_S002
    ㅇ qty_S001: ord_ym+item_cat별, shop_id가 S001인 매장의 ord_qty_sum의 합계
    ㅇ qty_S002: ord_ym+item_cat별, shop_id가 S002인 매장의 ord_qty_sum의 합계
  ㅁ 추가 고려 사항
    ㅇ ord_ym과 item_cat로 GROUP BY 처리합니다.
  ㅁ 정렬 기준
    ㅇ ord_ym, item_cat로 오름차순 처리합니다.

결과)
    ord_ym  item_cat  qty_S001  qty_S002  
    ------  --------  --------  --------  
    202301  BEV       25        43        
    202301  BKR       47        41        
    202301  COF       172       210       
    202302  BEV       33        28        
    202302  BKR       20        31        
    202302  COF       139       176       

답안)
SELECT t1.ord_ym, t1.item_cat,
	SUM(CASE WHEN t1.shop_id='S001' THEN t1.ord_qty_sum END) qty_S001,
	SUM(CASE WHEN t1.shop_id='S002' THEN t1.ord_qty_sum END) qty_S002
FROM (SELECT DATE_FORMAT(o.ord_dtm,'%Y%m') ord_ym, o.shop_id, i.item_cat, SUM(d.ord_qty) ord_qty_sum
		FROM startdbmy.tr_ord o
		LEFT JOIN startdbmy.tr_ord_det d
		ON (o.ord_no = d.ord_no)
		JOIN startdbmy.ms_item i ON d.item_id  = i.item_id
		WHERE o.shop_id IN ('S001','S002')
		AND o.ord_dtm >= STR_TO_DATE('20230101','%Y%m%d')
		AND o.ord_dtm <  STR_TO_DATE('20230301','%Y%m%d')
		GROUP BY DATE_FORMAT(o.ord_dtm, '%Y%m'), o.shop_id, i.item_cat
) t1
GROUP BY t1.ord_ym, t1.item_cat
ORDER BY t1.ord_ym, t1.item_cat;








------------------------------------------------------------------------
-- BOOSTER QUIZ 10-2-5
------------------------------------------------------------------------

문제)
[BOOSTER QUIZ 10-2-4]의 결과에 주문년월별 중간합계와 전체합계를 추가해 주세요.
상품카테고리도 코드가 아닌 명칭으로 표현해 주세요. 합계된 항목은 Total로 표시해 주세요.
  ㅁ 대상 테이블: ms_shop, tr_ord, ms_item
  ㅁ 조회 조건
    ㅇ [BOOSTER QUIZ 10-2-4]의 답안 SQL을 인라인 뷰로 처리하세요.
  ㅁ 조회 항목: ord_ym, item_cat, item_cat_nm, qty_S001, qty_S002
    ㅇ item_cat_nm: item_cat에 대한 명칭입니다. ms_item_cat를 서브쿼리로 활용해 처리하세요.
    ㅇ qty_S001: ord_ym+item_cat별, shop_id가 S001인 매장의 ord_qty_sum의 합계
    ㅇ qty_S002: ord_ym+item_cat별, shop_id가 S002인 매장의 ord_qty_sum의 합계
  ㅁ 추가 고려 사항
    ㅇ ROLLUP을 활용합니다.
    ㅇ ord_ym, item_cat, item_cat_nm 컬럼이 집계된 경우에는 Total로 표시해 주세요.
      - CASE와 GROUPING 함수를 조합해 처리합니다.
  ㅁ 정렬 기준
    ㅇ ord_ym, item_cat로 오름차순 처리합니다.

결과)
    ord_ym  item_cat  item_cat_nm  qty_S001  qty_S002  
    ------  --------  -----------  --------  --------  
    Total   Total     Total        436       529       
    202301  Total     Total        244       294       
    202301  BEV       Beverage     25        43        
    202301  BKR       Bakery       47        41        
    202301  COF       Coffee       172       210       
    202302  Total     Total        192       235       
    202302  BEV       Beverage     33        28        
    202302  BKR       Bakery       20        31        
    202302  COF       Coffee       139       176       

답안)
WITH w1 AS (SELECT t1.ord_ym, t1.item_cat,
          SUM(CASE WHEN t1.shop_id='S001' THEN t1.ord_qty_sum END) qty_S001,
          SUM(CASE WHEN t1.shop_id='S002' THEN t1.ord_qty_sum END) qty_S002
      FROM (SELECT DATE_FORMAT(o.ord_dtm,'%Y%m') ord_ym, o.shop_id, i.item_cat, SUM(d.ord_qty) ord_qty_sum
          FROM startdbmy.tr_ord o
          LEFT JOIN startdbmy.tr_ord_det d
          ON (o.ord_no = d.ord_no)
          JOIN startdbmy.ms_item i ON d.item_id  = i.item_id
          WHERE o.shop_id IN ('S001','S002')
          AND o.ord_dtm >= STR_TO_DATE('20230101','%Y%m%d')
          AND o.ord_dtm <  STR_TO_DATE('20230301','%Y%m%d')
          GROUP BY DATE_FORMAT(o.ord_dtm, '%Y%m'), o.shop_id, i.item_cat
      ) t1
      GROUP BY t1.ord_ym, t1.item_cat
)
SELECT
  CASE WHEN GROUPING(w1.ord_ym)=1 THEN 'Total' ELSE w1.ord_ym END ord_ym,
  CASE WHEN GROUPING(w1.item_cat)=1 THEN 'Total' ELSE w1.item_cat END item_cat,
  CASE WHEN GROUPING(w1.item_cat)=1 THEN 'Total' ELSE t1.item_cat_nm END item_cat_nm,
  SUM(w1.qty_S001) qty_S001,
  SUM(w1.qty_S002) qty_S002
FROM w1
LEFT JOIN startdbmy.ms_item_cat t1 
ON w1.item_cat = t1.item_cat
GROUP BY w1.ord_ym,w1.item_cat WITH ROLLUP
ORDER BY w1.ord_ym, w1.item_cat;








------------------------------------------------------------------------
-- BOOSTER QUIZ 10-2-6
------------------------------------------------------------------------

문제)
2023년의 판매 현황 분석을 보고해야 합니다. 2023년 주문에 대해 회원등급별, 매장운영유형별 주문건수를 보여주세요.
매장운영유형에 따른 주문건수 합계는 각각의 컬럼으로 표시해 주세요. 전체합계도 추가해서 보여주세요.
  ㅁ 대상 테이블: tr_ord, ms_shop, ms_mbr
  ㅁ 조회 조건
    ㅇ tr_ord: ord_dtm이 2023년인 데이터
  ㅁ 조회 항목: 회원등급, Flagship, Directly, Distributor
    ㅇ 회원등급: mbr_gd에 대한 명칭입니다. cm_base_cd를 사용합니다.
    ㅇ Flagship: mbr_gd별, shop_oper_tp가 FLAG인 매장의 주문건수입니다.
    ㅇ Directly: mbr_gd별, shop_oper_tp가 DRCT인 매장의 주문건수입니다.
    ㅇ Distributor: mbr_gd별, shop_oper_tp가 DIST인 매장의 주문건수입니다.
  ㅁ 추가 고려 사항
    ㅇ mbr_gd별 GROUP BY 처리합니다.
    ㅇ ROLLUP을 사용해 전체합계를 추가합니다.
      - 합계 처리된 항목은 Total로 표시해주세요.
  ㅁ 정렬 기준
    ㅇ 전체합계가 가장 먼저 나오도록 처리해 주세요.
    ㅇ shop_oper_tp가 PLAT인 경우 두 번째로 나오도록 해주세요.
    ㅇ shop_oper_tp가 GOLD인 경우 세 번째로 나오도록 해주세요.
    ㅇ shop_oper_tp가 SILV인 경우 네 번째로 나오도록 해주세요.

결과)
    회원등급  Flagship  Directly  Distributor  
    --------  --------  --------  -----------  
    Total     15477     35616     158277       
    Platinum  95        4134      18813        
    Gold      4211      13241     53353        
    Silver    11171     18241     86111        

답안)
SELECT CASE WHEN GROUPING(t3.base_cd_nm)=1 THEN 'Total' ELSE t3.base_cd_nm END 회원등급,
  SUM(CASE WHEN t4.shop_oper_tp='FLAG' THEN 1 ELSE 0 END) Flagship,
  SUM(CASE WHEN t4.shop_oper_tp='DRCT' THEN 1 ELSE 0 END) Directly,
  SUM(CASE WHEN t4.shop_oper_tp='DIST' THEN 1 ELSE 0 END) Distributor
FROM startdbmy.tr_ord t1
JOIN startdbmy.ms_mbr t2  
ON t1.mbr_id  = t2.mbr_id
JOIN startdbmy.cm_base_cd t3 
ON (t3.base_cd_dv = 'MBR_GD'
  AND t3.base_cd = t2.mbr_gd
)
JOIN startdbmy.ms_shop t4
ON t1.shop_id = t4.shop_id
WHERE t1.ord_dtm >= '2023-01-01'
AND t1.ord_dtm <  '2024-01-01'
GROUP BY t3.base_cd_nm WITH ROLLUP
ORDER BY GROUPING(t3.base_cd_nm),
         CASE WHEN t3.base_cd_nm='Platinum' THEN 1
         WHEN t3.base_cd_nm='Gold'     THEN 2
         WHEN t3.base_cd_nm='Silver'   THEN 3
         ELSE 0
END;




              

