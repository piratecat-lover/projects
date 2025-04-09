------------------------------------------------------------------------
-- BOOSTER QUIZ 6-1-1
------------------------------------------------------------------------
문제)
상품카테고리가 음료이거나 베이커리이면서, 상품크기가 레귤러인 상품을 보여주세요. Hot/Cold구분을 '차가운','뜨거운'으로 구분해서 보여주세요.
  ㅁ 대상 테이블: 상품(ms_item)
  ㅁ 조회 조건
    ㅇ item_cat(상품카테고리)가 BEV(음료)이거나 BKR(베이커리)이면서,
    ㅇ item_size_cd는 REG(레귤러)인 데이터만 보여주세요.
  ㅁ 조회 항목: hot_cold_nm, hot_cold_cd, item_id, item_nm
    ㅇ hot_cold_nm: hot_cold_cd의 값에 따라 정해진 명칭으로 치환해서 보여줍니다.
      - hot_cold_cd가 HOT이면 ‘뜨거운’, COLD이면 ‘차가운’으로 보여줍니다.
      - 주의) 실제 운영 시스템은 이런 코드성 데이터의 명칭은 기준코드 테이블로 처리합니다.
  ㅁ 정렬 기준: hot_cold_nm로 오름차순 한 후에, item_id로 오름차순 정렬하세요.



결과)
    hot_cold_nm  hot_cold_cd  item_id  item_nm              
    -----------  -----------  -------  -------------------  
    뜨거운       HOT          BGLR     Bagel(R)             
    뜨거운       HOT          HCHR     Hot Chocolate(R)     
    뜨거운       HOT          MACA     Macaron(R)           
    차가운       COLD         BMFR     Blueberry Muffin(R)  
    차가운       COLD         CITR     Yuzu Ade(R)          
    차가운       COLD         CMFR     Chocolate Muffin(R)  
    차가운       COLD         LEMR     Lemonade(R)          
    차가운       COLD         ZAMB     Grapefruit Ade(R)    

답안)
SELECT
    CASE hot_cold_cd
        WHEN 'HOT' THEN '뜨거운'
        WHEN 'COLD' THEN '차가운'
    END hot_cold_nm,
    hot_cold_cd,
    item_id,
    item_nm
FROM ms_item
WHERE item_cat IN ('BEV', 'BKR') AND item_size_cd = 'REG'
ORDER BY hot_cold_nm ASC, item_id ASC;


------------------------------------------------------------------------
-- BOOSTER QUIZ 6-1-2
------------------------------------------------------------------------
문제)
‘M0058’ 회원의 ‘2024년 12월 1일’ 주문을 조회해주세요. 주문번호로 오름차순 정렬해 주세요.
주문일시가 07시 이전이면 ‘아침주문’, 주문일시가 07시 이후면 ‘아침이후주문’으로 표시해주세요.
  ㅁ 대상 테이블: 주문(tr_ord)
  ㅁ 조회 조건: mbr_id가 M0058이면서 ord_dtm이 2024년 12월 1일
  ㅁ 조회 항목: ord_no, ord_dtm, mbr_id, 주문시점구분
    ㅇ 주문시점구분: CASE로 처리합니다.
      - ord_dtm의 시간이 07:00:00 이하(<=)면 ‘아침주문’으로 출력
      - ord_dtm의 시간이 07:00:00 초과(>)면 ‘아침이후주문’으로 출력
      - ord_dtm에서 시간을 추출하기 위해서는 DATE_FORMAT를 사용합니다.
      - 7시 10분 5초 데이터에 대해, DATE_FORMAT(t1.ord_dtm,'%H')를 사용하면 결과는 '07'이 됩니다.
      - 반면에, DATE_FORMAT(t1.ord_dtm,'%H%m%s')를 사용하면 결과는 '071005'가 됩니다.
      - WHEN 조건을 처리할 때, DATE_FORMAT으로 얻은 결과를 고려하기 바랍니다.
  ㅁ 정렬 기준: ord_no로 오름차순 정렬로 출력하세요.


결과)
    ord_no  ord_dtm              mbr_id  주문시점구분        
    ------  -------------------  ------  ------------  
    695687  2024-12-01 06:50:00  M0058   아침주문      
    696197  2024-12-01 07:16:00  M0058   아침이후주문  
    696287  2024-12-01 07:40:00  M0058   아침이후주문  
    696333  2024-12-01 08:30:00  M0058   아침이후주문  
    696384  2024-12-01 11:05:00  M0058   아침이후주문  

답안)
SELECT ord_no, ord_dtm, mbr_id,
    CASE
        WHEN DATE_FORMAT(ord_dtm, '%H') < '07' THEN '아침주문' -- WHEN 구절 안에 DATE_FORMAT() 써도 되나요?
        ELSE '아침이후주문'
    END 주문시점구분
FROM tr_ord
WHERE mbr_id = 'M0058' AND ord_dtm >= STR_TO_DATE('2024-12-01', '%Y-%m-%d') AND ord_dtm < STR_TO_DATE('2024-12-02', '%Y-%m-%d')
ORDER BY ord_no ASC;

------------------------------------------------------------------------
-- BOOSTER QUIZ 6-2-1
------------------------------------------------------------------------

문제)
'S264' 매장의 '2021년 12월 1일' 주문에 대해, 주문일시와 픽업일시를 보여주고,
주문에서 픽업까지 걸린 시간에 대해 '5분초과'와 '5분이하'로 구분자를 넣어주세요.
  ㅁ 대상 테이블: 주문(tr_ord)
  ㅁ 조회 조건: shop_id가 S264이면서 ord_dtm이 2021년 12월 1일인 데이터
  ㅁ 조회 항목: ord_no, ord_dtm, shop_id, pkup_dtm, 픽업완료시간구분
    ㅇ 픽업완료시간구분: ord_dtm에서 pkup_dtm까지 걸린 시간에 따라,
      - 5분초과 또는 5분이하로 구분
      - TIMESTAMPDIFF를 사용해 처리합니다.
  ㅁ 추가 고려 사항: 현재 SQL은 GROUP BY가 불필요합니다.
  ㅁ 정렬 기준: ord_no로 오름차순 정렬하세요.


결과)
    ord_no  ord_dtm              shop_id  pkup_dtm             픽업완료시간구분          
    ------  -------------------  -------  -------------------  ----------------  
    141767  2021-12-01 07:02:00  S264     2021-12-01 07:04:00  5분이하           
    141822  2021-12-01 07:08:00  S264     2021-12-01 07:14:00  5분초과           
    141825  2021-12-01 07:09:00  S264     2021-12-01 07:12:00  5분이하           
    141833  2021-12-01 07:10:00  S264     2021-12-01 07:14:00  5분이하           
    141866  2021-12-01 07:20:00  S264     2021-12-01 07:27:00  5분초과

답안)
SELECT ord_no, ord_dtm, shop_id, pkup_dtm,
    CASE
        WHEN TIMESTAMPDIFF(MINUTE, ord_dtm, pkup_dtm) > 5 THEN '5분초과'
        ELSE '5분이하'
    END 픽업완료시간구분
FROM tr_ord
WHERE shop_id = 'S264' AND ord_dtm >= STR_TO_DATE('2021-12-01', '%Y-%m-%d') AND ord_dtm < STR_TO_DATE('2021-12-02', '%Y-%m-%d')
ORDER BY ord_no ASC;


------------------------------------------------------------------------
-- BOOSTER QUIZ 6-2-2
------------------------------------------------------------------------

문제) [BOOSTER QUIZ 6-2-1]의 풀이 SQL을 활용해 픽업완료시간구분별 주문건수를 구하세요.
  ㅁ 대상 테이블: 주문(tr_ord)
  ㅁ 조회 조건: shop_id가 S264이면서 ord_dtm이 2021년 12월 1일인 데이터
  ㅁ 조회 항목: 픽업완료시간구분, 주문건수
    ㅇ 픽업완료시간구분: ord_dtm에서 pkup_dtm까지 걸린 시간에 따라,
      - 5분초과 또는 5분이하로 구분
    ㅇ 주문건수: 픽업완료시간구분별 데이터 건수
  ㅁ 추가 고려 사항: 픽업완료시간구분별로 데이터를 GROUP BY 합니다.
  ㅁ 정렬 기준: 주문건수로 내림차순 정렬해주세요.

결과)
    픽업완료시간구분  주문건수      
    ----------------  --------  
    5분이하           3         
    5분초과           2         

답안)
SELECT
    CASE
        WHEN TIMESTAMPDIFF(MINUTE, ord_dtm, pkup_dtm) > 5 THEN '5분초과'
        ELSE '5분이하'
    END 픽업완료시간구분,
    COUNT(*) 주문건수
FROM tr_ord
WHERE shop_id = 'S264' AND ord_dtm >= STR_TO_DATE('2021-12-01', '%Y-%m-%d') AND ord_dtm < STR_TO_DATE('2021-12-02', '%Y-%m-%d')
GROUP BY CASE 
        WHEN TIMESTAMPDIFF(MINUTE, ord_dtm, pkup_dtm) > 5 THEN '5분초과'
        ELSE '5분이하'
    END
ORDER BY 주문건수 DESC;


------------------------------------------------------------------------
-- BOOSTER QUIZ 6-2-3
------------------------------------------------------------------------


문제) ‘S001’과 ‘S002’ 매장의 ‘2022년’ 주문에 대해 매장별로 ‘상반기’와 ‘하반기’로 구분해 주문건수를 구해주세요.
  ㅁ 대상 테이블: 주문(tr_ord)
  ㅁ 조회 조건: shop_id가 S001, S002인 매장의 ord_dtm이 2022년인 모든 데이터
  ㅁ 조회 항목: shop_id, 반기구분, ord_cnt
    ㅇ 반기구분: ord_dtm을 CASE 처리해서 구합니다.
      : 22년1월부터 22년 6월말까지는 ‘상반기’, 22년 7월부터는 ‘하반기’로 구분합니다.
    ㅇ ord_cnt: shop_id, 반기구분별 주문 건수입니다.
  ㅁ 추가 고려 사항: shop_id, 반기구분별 GROUP BY 처리합니다.
    ㅇ ord_cnt는 shop_id, 반기구분별 주문건수입니다.
  ㅁ 정렬 기준: shop_id로 오름차순 후에, 반기구분으로 오름차순하세요.


결과)
    shop_id  반기구분  ord_cnt      
    -------  --------  --------  
    S001     상반기    255       
    S001     하반기    834       
    S002     상반기    429       
    S002     하반기    1012       

답안)
SELECT shop_id,
    CASE
        WHEN DATE_FORMAT(ord_dtm, '%Y%m') BETWEEN '202201' AND '202206' THEN '상반기'
        ELSE '하반기'
    END 반기구분,
    COUNT(*) ord_cnt
FROM tr_ord
WHERE shop_id IN ('S001', 'S002') AND DATE_FORMAT(ord_dtm, '%Y') = '2022'
GROUP BY shop_id,
      CASE
          WHEN DATE_FORMAT(ord_dtm, '%Y%m') BETWEEN '202201' AND '202206' THEN '상반기'
          ELSE '하반기'
      END
ORDER BY shop_id ASC, 반기구분 ASC;


------------------------------------------------------------------------
-- BOOSTER QUIZ 6-2-4
------------------------------------------------------------------------

문제) '2021년 12월 24일'의 주문을 보여주세요. 그런데, 'S010' 매장의 주문은 무조건 먼저 조회되도록 해주시고, 나머지는 주문번호순으로 보여주세요.
  ㅁ 대상 테이블: 주문(tr_ord)
  ㅁ 조회 조건: ord_dtm이 2021년 12월 24일인 데이터
  ㅁ 조회 항목: ord_no, ord_dtm, shop_id, ord_amt
  ㅁ 정렬 기준
    ㅇ S010 매장의 주문이 무조건 먼저 나오도록 처리하고,
    ㅇ 나머지는 ord_no 순으로 오름차순 정렬하세요.

결과)
    ord_no  ord_dtm              shop_id  ord_amt    
    ------  -------------------  -------  ---------  
    147009  2021-12-24 07:01:00  S010     8500.000   
    147043  2021-12-24 07:02:00  S010     4000.000   
    147056  2021-12-24 07:03:00  S010     4000.000   
    147070  2021-12-24 07:04:00  S010     8500.000   
    147078  2021-12-24 07:05:00  S010     4000.000   
    147083  2021-12-24 07:06:00  S010     4500.000   
    147130  2021-12-24 07:21:00  S010     8000.000   
    146965  2021-12-24 06:31:00  S008     4000.000   
    146966  2021-12-24 06:31:00  S009     4500.000   
    ...생략...

답안)
SELECT ord_no, ord_dtm, shop_id, ord_amt
FROM tr_ord
WHERE ord_dtm >= STR_TO_DATE('2021-12-24', '%Y-%m-%d') AND ord_dtm < STR_TO_DATE('2021-12-25', '%Y-%m-%d')
ORDER BY
    CASE
        WHEN shop_id = 'S010' THEN 0
        ELSE 1
    END ASC, ord_no ASC;