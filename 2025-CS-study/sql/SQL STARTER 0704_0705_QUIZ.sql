
------------------------------------------------------------------------
-- BOOSTER QUIZ 7-5-1
------------------------------------------------------------------------
문제)
'2022년 1월'의 주문 데이터를 매장운영유형별로 집계해 주문금액을 보여주세요.
  ㅁ 대상 테이블: 매장(ms_shop)과 주문(tr_ord)
  ㅁ 조회 조건: ord_dtm이 2022년 1월인 데이터
  ㅁ 조회 항목: shop_oper_tp, ord_amt_sum
    ㅇ ord_amt_sum: shop_oper_tp별로 ord_amt를 SUM 처리한 내용입니다.
  ㅁ 추가 고려 사항: shop_oper_tp별 GROUP BY 처리합니다.
  ㅁ 정렬 기준: shop_oper_tp로 오름차순 정렬합니다.
  

결과)
    shop_oper_tp  ord_amt_sum   
    ------------  ------------  
    DIST          33242500.000  
    DRCT          5616500.000   
    FLAG          1559000.000   

답안)
SELECT t1.shop_oper_tp, SUM(t2.ord_amt) ord_amt_sum
FROM ms_shop t1, tr_ord t2
WHERE t1.shop_id = t2.shop_id
AND t2.ord_dtm >= STR_TO_DATE('2022-01-01', '%Y-%m-%d')
AND t2.ord_dtm < STR_TO_DATE('2022-02-01', '%Y-%m-%d')
GROUP BY t1.shop_oper_tp
ORDER BY t1.shop_oper_tp ASC;


------------------------------------------------------------------------
-- BOOSTER QUIZ 7-5-2
------------------------------------------------------------------------
문제)
폐점한 매장의 매장운영유형별 주문년도별 주문건수를 구해주세요.
  ㅁ 대상 테이블: 매장(ms_shop)과 주문(tr_ord)
  ㅁ 조회 조건: shop_st가 CLSD(폐점)인 매장의 모든 주문 데이터
  ㅁ 조회 항목: shop_oper_tp, ord_year, ord_cnt
    ㅇ ord_year: ord_dtm을 년도로 변환한 값입니다.
    ㅇ ord_cnt: shop_oper_tp, ord_year 별 주문 건수입니다.
  ㅁ 추가 고려 사항: shop_oper_tp, ord_year로 GROUP BY 처리합니다.
  ㅁ 정렬 기준: shop_oper_tp로 오름차순, ord_year로 오름차순합니다.
  
  
결과)
    shop_oper_tp  ord_year  ord_cnt  
    ------------  --------  -------  
    DIST          2020      107      
    DIST          2021      210      
    DIST          2022      809      
    DRCT          2021      22       
    DRCT          2022      148      
    FLAG          2019      9        

답안)
SELECT t1.shop_oper_tp, DATE_FORMAT(t2.ord_dtm, '%Y') ord_year, COUNT(*) ord_cnt
FROM ms_shop t1, tr_ord t2
WHERE t1.shop_id = t2.shop_id
AND t1.shop_st = 'CLSD'
GROUP BY t1.shop_oper_tp, DATE_FORMAT(t2.ord_dtm, '%Y')
ORDER BY t1.shop_oper_tp ASC, ord_year ASC;


------------------------------------------------------------------------
-- BOOSTER QUIZ 7-5-3
------------------------------------------------------------------------
문제)
shop_start_ymd가 '20180405'인 매장에 대해, 매장ID별로 '2019년 12월 23일'의 주문금액합계를 구하세요.
매장명과 매장면적, 매장면적당 주문금액합계도 출력하세요.
  ㅁ 대상 테이블: 매장(ms_shop)과 주문(tr_ord)
  ㅁ 조회 조건
    ㅇ ms_shop의 shop_start_ymd가 20180405인 데이터
    ㅇ tr_ord의 ord_dtm이 2019년 12월 23일인 데이터
  ㅁ 조회 항목: shop_id, shop_nm, shop_size, ord_amt_sum, ord_amt_per_size
   ㅇ ord_amt_sum: ord_amt를 shop_id별로 SUM 처리한 결과입니다.
   ㅇ ord_amt_per_size: ord_amt_sum을 shop_size로 나눈 값입니다.
  ㅁ 추가 고려 사항
    ㅇ shop_id로 GROUP BY 처리하세요.
    ㅇ shop_nm과 shop_size는 집계함수 처리해야 합니다.
  ㅁ 정렬 기준: shop_size로 내림차순 정렬해주세요.


결과)
    shop_id  shop_nm            shop_size  ord_amt_sum  ord_amt_per_size  
    -------  -----------------  ---------  -----------  ----------------  
    S044     Houston-3rd        113        4000.000     35.3982301        
    S016     San Francisco-1st  57         21000.000    368.4210526       
    S002     Los Angeles-1st    29         4000.000     137.9310345       

답안)
SELECT t1.shop_id, MAX(t1.shop_nm) shop_nm, MAX(t1.shop_size) shop_size, SUM(t2.ord_amt) ord_amt_sum, SUM(t2.ord_amt)/t1.shop_size ord_amt_per_size
FROM ms_shop t1, tr_ord t2
WHERE t1.shop_id = t2.shop_id
AND t1.shop_start_ymd = '20180405'
AND t2.ord_dtm >= STR_TO_DATE('20191223','%Y%m%d')
AND t2.ord_dtm < STR_TO_DATE('20191224','%Y%m%d')
GROUP BY t1.shop_id
ORDER BY t1.shop_size DESC;