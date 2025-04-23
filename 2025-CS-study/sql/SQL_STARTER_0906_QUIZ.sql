


------------------------------------------------------------------------
-- BOOSTER QUIZ 9-6-1
------------------------------------------------------------------------

2022년 5월과, 2022년 6월의 가입한 회원수와 오픈한 매장수를 보여주세요.
  ㅁ 대상 테이블: ms_mbr, ms_shop
  ㅁ 조회 조건
    ㅇ ms_mbr: join_dtm이 2022년 5월, 2022년 6월인 데이터
    ㅇ ms_shop: shop_start_ymd(매장시작일자)가 2022년 5월, 2022년 6월인 데이터
  ㅁ 조회 항목: ym, mbr_cnt, shop_cnt
    ㅇ ym: 년월 값으로, 회원의 가입년월과 매장의 시작년월을 동시에 뜻합니다.
    ㅇ mbr_cnt: 가입년월별 회원수
    ㅇ shop_cnt: 매장시작년월별 매장수
  ㅁ 추가 고려 사항:
    ㅇ mbr_cnt를 별도 인라인 뷰 t1으로 처리하세요.
    ㅇ shop_cnt를 별도 인라인 뷰 t2로 처리하세요.
      - shop_start_ymd는 DATE가 아닌 VARCHAR 자료형임에 주의합니다.
      - 년월 값을 만들기 위해서는 DATE_FORMAT이 아닌 SUBSTR(shop_start_ymd,1,6)을 사용해야 합니다.
    ㅇ 인라인 뷰 t1과 t2를 조인해 최종 결과를 보여주세요.
  ㅁ 정렬 기준: ym으로 오름차순 정렬해주세요.

결과)

    ym      mbr_cnt  shop_cnt  
    ------  -------  --------  
    202205  2810     12        
    202206  2857     8         

답안)
SELECT t1.ym, t1.mbr_cnt, t2.shop_cnt
FROM (SELECT DATE_FORMAT(join_dtm, '%Y%m') AS ym, COUNT(*) AS mbr_cnt
      FROM ms_mbr
      WHERE join_dtm >= STR_TO_DATE('2022-05-01', '%Y-%m-%d')
        AND join_dtm < STR_TO_DATE('2022-07-01', '%Y-%m-%d')
      GROUP BY ym
      ) t1
LEFT JOIN (SELECT DATE_FORMAT(shop_start_ymd, '%Y%m') AS ym, COUNT(*) AS shop_cnt
           FROM ms_shop
           WHERE shop_start_ymd >= STR_TO_DATE('2022-05-01', '%Y-%m-%d')
             AND shop_start_ymd < STR_TO_DATE('2022-07-01', '%Y-%m-%d')
           GROUP BY ym
           ) t2
ON t1.ym = t2.ym
ORDER BY t1.ym;


------------------------------------------------------------------------
-- BOOSTER QUIZ 9-6-2
------------------------------------------------------------------------
[BOOSTER QUIZ 9-6-1]의 결과에 2022년 5월, 2022년 6월의 주문 건수를 추가해주세요.
  ㅁ 추가 대상 테이블: tr_ord
  ㅁ 추가 조회 조건
    ㅇ tr_ord: ord_dtm이 2022년 5월, 2022년 6월인 데이터
  ㅁ 추가 조회 항목: ord_cnt
    ㅇ ord_cnt: 주문년월별 주문건수
  ㅁ 추가 고려 사항:
    ㅇ [BOOSTER QUIZ 9-6-1]의 SQL을 수정해 ord_cnt만 추가합니다.
    ㅇ ord_cnt를 인라인 뷰 t3로 처리하세요.
  ㅁ 정렬 기준: ym으로 오름차순 정렬해주세요.

결과)

ym      mbr_cnt  shop_cnt  ord_cnt  
------  -------  --------  -------  
202205  2810     12        6909     
202206  2857     8         11066    

답안)
SELECT t1.ym, t1.mbr_cnt, t2.shop_cnt, t3.ord_cnt
FROM (SELECT DATE_FORMAT(join_dtm, '%Y%m') AS ym, COUNT(*) AS mbr_cnt
      FROM ms_mbr
      WHERE join_dtm >= STR_TO_DATE('2022-05-01', '%Y-%m-%d')
        AND join_dtm < STR_TO_DATE('2022-07-01', '%Y-%m-%d')
      GROUP BY ym
      ) t1
LEFT JOIN (SELECT DATE_FORMAT(shop_start_ymd, '%Y%m') AS ym, COUNT(*) AS shop_cnt
           FROM ms_shop
           WHERE shop_start_ymd >= STR_TO_DATE('2022-05-01', '%Y-%m-%d')
             AND shop_start_ymd < STR_TO_DATE('2022-07-01', '%Y-%m-%d')
           GROUP BY ym
           ) t2
ON t1.ym = t2.ym
LEFT JOIN (SELECT DATE_FORMAT(ord_dtm, '%Y%m') AS ym, COUNT(*) AS ord_cnt
           FROM tr_ord
           WHERE ord_dtm >= STR_TO_DATE('2022-05-01', '%Y-%m-%d')
             AND ord_dtm < STR_TO_DATE('2022-07-01', '%Y-%m-%d')
           GROUP BY ym
           ) t3
ON t1.ym = t3.ym
ORDER BY t1.ym;
