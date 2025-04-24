

------------------------------------------------------------------------
-- BOOSTER QUIZ 9-7-1
------------------------------------------------------------------------
문제)
2022년 전체 주문금액이 가장 높은 매장 Top-5를 보여주세요.
  ㅁ 대상 테이블: 주문(tr_ord)
  ㅁ 조회 조건
    ㅇ tr_ord: ord_dtm이 2022년인 모든 주문 데이터
  ㅁ 조회 항목: shop_id, ord_amt_sum
    ㅇ ord_amt_sum: shop_id별 ord_amt의 합계
  ㅁ 추가 고려 사항
    ㅇ shop_id로 GROUP BY 처리하세요.
    ㅇ ord_amt_sum이 가장큰 Top-5 매장만 출력하세요.
    ㅇ 아직, 인라인 뷰를 사용하지 않은 SQL입니다.
  ㅁ 정렬 기준: ord_amt_sum으로 내림차순 정렬하세요.

결과)
    shop_id  ord_amt_sum    
    -------  -------------  
    S100     115703000.000  
    S050     100343000.000  
    S020     26311000.000   
    S010     21828000.000   
    S280     19953000.000   

답안)  
SELECT shop_id, SUM(ord_amt) ord_amt_sum
FROM tr_ord
WHERE ord_dtm >= STR_TO_DATE('2022-01-01', '%Y-%m-%d')
AND ord_dtm < STR_TO_DATE('2023-01-01', '%Y-%m-%d')
GROUP BY shop_id
ORDER BY ord_amt_sum DESC
LIMIT 5;









------------------------------------------------------------------------
-- BOOSTER QUIZ 9-7-2
------------------------------------------------------------------------
[BOOSTER QUIZ 9-7-1]을 활용합니다. [BOOSTER QUIZ 9-7-1]에서 찾은 매장들에 대해, 2023년 1월부터 3월까지의 월별 주문금액 합계를 보여주세요.

  ㅁ 대상 테이블: tr_ord
  ㅁ 조회 조건
    ㅇ tr_ord: ord_dtm이 2023년 1월부터 2023년 3월까지
    ㅇ tr_ord: [BOOSTER QUIZ 9-7-1]에서 찾은 매장에 대해서만
  ㅁ 조회 항목: ord_ym, ord_amt_sum
    ㅇ ord_ym: ord_dtm을 년월로 변형한 값
    ㅇ ord_amt_sum: ord_ym별 ord_amt의 합계
  ㅁ 추가 고려 사항
    ㅇ [BOOSTER QUIZ 9-7-1]의 SQL을 인라인 뷰로 처리합니다.
    ㅇ 인라인 뷰와 2023년 1월부터 3월까지의 tr_ord를 조인해 원하는 결과를 얻습니다.
    ㅇ ord_ym별 GROUP BY 처리합니다.
  ㅁ 정렬 기준: ord_ym으로 오름차순 정렬합니다.
   

결과)
    ord_ym  ord_amt_sum   
    ------  ------------  
    202301  28576500.000  
    202302  24717500.000  
    202303  28076000.000  
    
답안)        
SELECT DATE_FORMAT(t2.ord_dtm, '%Y%m') ord_ym, SUM(t2.ord_amt) ord_amt_sum
FROM (SELECT shop_id, SUM(ord_amt) ord_amt_sum
      FROM tr_ord
      WHERE ord_dtm >= STR_TO_DATE('2022-01-01', '%Y-%m-%d')
      AND ord_dtm < STR_TO_DATE('2023-01-01', '%Y-%m-%d')
      GROUP BY shop_id
      ORDER BY ord_amt_sum DESC
      LIMIT 5) t1, tr_ord t2
WHERE t1.shop_id = t2.shop_id
AND t2.ord_dtm >= STR_TO_DATE('2023-01-01', '%Y-%m-%d')
AND t2.ord_dtm < STR_TO_DATE('2023-04-01', '%Y-%m-%d')
GROUP BY ord_ym
ORDER BY ord_ym;










------------------------------------------------------------------------
-- BOOSTER QUIZ 9-7-3
------------------------------------------------------------------------
[BOOSTER QUIZ 9-7-1]을 활용합니다. [BOOSTER QUIZ 9-7-1]에서 찾은 매장들에 대해, 2023년 매장별 주문금액 합계를 보여주세요.

  ㅁ 대상 테이블: tr_ord, ms_shop
  ㅁ 조회 조건
    ㅇ tr_ord: ord_dtm이 2023년 전체
    ㅇ tr_ord: [BOOSTER QUIZ 9-7-1]에서 찾은 매장에 대해서만
  ㅁ 조회 항목: shop_id, shop_nm, ord_amt_2022, ord_amt_2023
    ㅇ ord_amt_2022: 2022년 shop_id별 주문금액의 합계([BOOSTER QUIZ 9-7-1]에서 구한 값)
    ㅇ ord_amt_2023: 2023년 shop_id별 주문금액의 합계
  ㅁ 추가 고려 사항
    ㅇ [BOOSTER QUIZ 9-7-1]의 SQL을 인라인 뷰로 처리합니다.
    ㅇ 인라인 뷰와 2023년의 tr_ord를 조인해 원하는 결과를 얻습니다.
    ㅇ shop_id별로 GROUP BY 처리합니다.
    ㅇ 인라인 뷰와 2023년의 tr_ord가 조인할 때 1:M 조인이 되므로,
      - 1쪽 데이터의 집계함수 처리에 주의해주세요.
  ㅁ 정렬 기준: shop_id로 오름차순 정렬해주세요.
   
결과)
    shop_id  shop_nm          ord_amt_2022   ord_amt_2023   
    -------  ---------------  -------------  -------------  
    S100     Washington-5th   115703000.000  182535500.000  
    S050     San Jose-3rd     100343000.000  155924500.000  
    S020     Washington-1st   26311000.000   46713000.000   
    S010     San Jose-1st     21828000.000   39562500.000   
    S280     Washington-14th  19953000.000   43889500.000   


답안)
SELECT t1.shop_id, MAX(t3.shop_nm) shop_nm, MAX(t1.ord_amt_sum) ord_amt_2022, SUM(t2.ord_amt) ord_amt_2023
FROM (SELECT shop_id, SUM(ord_amt) ord_amt_sum
      FROM tr_ord
      WHERE ord_dtm >= STR_TO_DATE('2022-01-01', '%Y-%m-%d')
      AND ord_dtm < STR_TO_DATE('2023-01-01', '%Y-%m-%d')
      GROUP BY shop_id
      ORDER BY ord_amt_sum DESC
      LIMIT 5) t1
LEFT JOIN tr_ord t2
ON (t1.shop_id = t2.shop_id
AND t2.ord_dtm >= STR_TO_DATE('2023-01-01', '%Y-%m-%d')
AND t2.ord_dtm < STR_TO_DATE('2024-01-01', '%Y-%m-%d')
)
JOIN ms_shop t3
ON t1.shop_id = t3.shop_id
GROUP BY t1.shop_id
ORDER BY t1.shop_id;







------------------------------------------------------------------------
-- BOOSTER QUIZ 9-7-4
------------------------------------------------------------------------
2022년 1월의 주문금액이 높은 Top-3 회원에 속하면서, 2022년 2월의 주문금액도 Top-3 회원에 속하는 리스트를 조회해주세요.

  ㅁ 대상 테이블: tr_ord, ms_mbr
  ㅁ 조회 조건
    ㅇ tr_ord(t1): ord_dtm이 2022년 1월
      - mbr_id별 ord_amt 합계가 가장 큰 Top-3를 조회합니다.
      - 이 결과를 인라인 뷰 t1으로 처리합니다.
    ㅇ tr_ord(t2): ord_dtm이 2022년 2월
      - mbr_id별 ord_amt 합계가 가장 큰 Top-3를 조회합니다.
      - 이 결과를 인라인 뷰 t2로 처리합니다.
  ㅁ 조회 항목: mbr_id, nick_nm, ord_amt_202201, ord_amt_202202
    ㅇ ord_amt_202201: 2022년 1월의 mbr_id별 주문금액 합계(인라인 뷰 t1의 수치)
    ㅇ ord_amt_202202: 2022년 2월의 mbr_id별 주문금액 합계(인라인 뷰 t2의 수치)
  ㅁ 추가 고려 사항
    ㅇ t1과 t2를 조인하면 2022년 1월에 Top-3이면서 2022년 2월에도 Top-3인 회원을 찾을 수 있습니다.
    ㅇ t1과 t2를 조인해 찾은 mbr_id에 대해 ms_mbr과 조인해 nick_nm을 추출합니다.


결과)
mbr_id  nick_nm  ord_amt_202201  ord_amt_202202  
------  -------  --------------  --------------  
M0016   Galaxy   254500.000      217500.000      

답안)
SELECT t1.mbr_id, t3.nick_nm, t1.ord_amt ord_amt_202201, t2.ord_amt ord_amt_202202
FROM (SELECT mbr_id, SUM(ord_amt) ord_amt
      FROM tr_ord
      WHERE ord_dtm >= STR_TO_DATE('2022-01-01', '%Y-%m-%d')
      AND ord_dtm < STR_TO_DATE('2022-02-01', '%Y-%m-%d')
      GROUP BY mbr_id
      ORDER BY ord_amt DESC
      LIMIT 3
      ) t1
JOIN (SELECT mbr_id, SUM(ord_amt) ord_amt
      FROM tr_ord
      WHERE ord_dtm >= STR_TO_DATE('2022-02-01', '%Y-%m-%d')
      AND ord_dtm < STR_TO_DATE('2022-03-01', '%Y-%m-%d')
      GROUP BY mbr_id
      ORDER BY ord_amt DESC
      LIMIT 3
      ) t2
ON t1.mbr_id = t2.mbr_id
JOIN ms_mbr t3
ON t3.mbr_id = t1.mbr_id
ORDER BY t1.mbr_id;








