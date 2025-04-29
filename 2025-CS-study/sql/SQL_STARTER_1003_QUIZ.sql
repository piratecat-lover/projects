
------------------------------------------------------------------------
-- BOOSTER QUIZ 10-3-1
------------------------------------------------------------------------
문제)
nick_nm이 ‘Air’와 ‘Wind3’인 회원의 2023년 1월 1일부터 2023년 1월 3일까지의 주문에 대해, 회원과 일자별 주문금액을 집계해서 보여주세요. 주문이 없는 날짜의 데이터로 0으로 보여주세요.

  ㅁ 대상 테이블: ms_mbr, cm_base_dt, tr_ord
  ㅁ 조회 조건
    ㅇ ms_mbr: nick_nm이 Air, Wind3인 회원
    ㅇ cm_base_dt: base_dt가 2023년 1월 1일부터 2023년 1월 3일까지
    ㅇ tr_ord: ord_dtm이 2023년 1월 1일부터 2023년 1월 3일까지
  ㅁ 조회 항목: ord_ymd, mbr_id, nick_nm, ord_amt_sum
    ㅇ ord_ymd
      - cm_base_dt의 base_ymd
      - tr_ord의 ord_dtm을 YYYYMMDD 형태로 변형한 값
    ㅇ ord_amt_sum: ord_ymd, mbr_id별 ord_amt의 합계
  ㅁ 추가 고려 사항
    ㅇ 두 회원의 주문이 발생하지 않은 일자의 ord_amt_sum을 0으로 채워서 보여주세요.
    ㅇ cm_base_dt와 ms_mbr을 별도의 인라인 뷰(t1)에서 크로스 조인해 마스터 데이터 집합을 만드세요.
    ㅇ tr_ord를 별도의 인라인 뷰(t2)로 처리해 ord_ymd, mbr_id별 ord_amt_sum을 집계하세요.
    ㅇ t1과 t2를 아우터 조인해 최종 결과를 보여주세요.
  ㅁ 정렬 기준: ord_ymd, mbr_id로 오름차순 정렬해 주세요.


결과)
    ord_ymd   mbr_id  nick_nm  ord_amt_sum  
    --------  ------  -------  -----------  
    20230101  M0001   Air      8000.000     
    20230102  M0001   Air      5000.000     
    20230103  M0001   Air      5000.000     
    20230101  M0200   Wind3    0.000        
    20230102  M0200   Wind3    0.000        
    20230103  M0200   Wind3    14000.000    

답안)
SELECT t1.ord_ymd, t1.mbr_id, t1.nick_nm, IFNULL(t2.ord_amt_sum, 0) ord_amt_sum
FROM (SELECT c.base_ymd ord_ymd, m.mbr_id, m.nick_nm
      FROM cm_base_dt c
      CROSS JOIN ms_mbr m
      WHERE c.base_dt >= STR_TO_DATE('20230101', '%Y%m%d')
      AND c.base_dt < STR_TO_DATE('20230104', '%Y%m%d')
      AND m.nick_nm IN ('Air', 'Wind3')
) t1
LEFT JOIN (SELECT DATE_FORMAT(o.ord_dtm, '%Y%m%d') ord_ymd, o.mbr_id, SUM(o.ord_amt) AS ord_amt_sum
            FROM tr_ord o
            WHERE o.ord_dtm >= STR_TO_DATE('20230101', '%Y%m%d')
            AND o.ord_dtm < STR_TO_DATE('20230104', '%Y%m%d')
            GROUP BY DATE_FORMAT(o.ord_dtm, '%Y%m%d'), o.mbr_id
) t2 
ON (t1.ord_ymd = t2.ord_ymd 
    AND t1.mbr_id = t2.mbr_id
)
GROUP BY t1.ord_ymd, t1.mbr_id, t1.nick_nm
ORDER BY t1.mbr_id, t1.ord_ymd;








------------------------------------------------------------------------
-- BOOSTER QUIZ 10-3-2
------------------------------------------------------------------------
문제)
아래 결과와 같은 대시보드를 만들려고 합니다. 년월별로 새로 매장이 오픈한 수, 회원이 가입한 수, 주문건수를 보여주세요.
발생한 수치가 없을 때는 0으로 채워서 보여주세요.

  ㅁ 대상 테이블: cm_base_dt, ms_shop, ms_mbr, tr_ord
  ㅁ 조회 조건
    ㅇ cm_base_dt: base_dt가 2021년 4월부터 2021년 6월까지
    ㅇ ms_shop: shop_start_ymd가 2021년 4월부터 2021년 6월까지
      - shop_start_ymd는 DATE 자료형이 아닌 VARCHAR 자료형임에 주의가 필요합니다.
    ㅇ ms_mbr: join_dtm이 2021년 4월부터 2021년 6월까지
    ㅇ tr_ord: ord_dtm이 2021년 4월부터 2021년 6월까지
  ㅁ 조회 항목: ym, shop_open_cnt, mbr_join_cnt, ord_cnt
    ㅇ ym
      - cm_base_dt의 base_ymd를 6자리까지 자른 년월값, 또는 base_dt를 DATE_FORMAT으로 변형합니다.
      - ms_shop의 shop_start_ymd를 6자리까지 자른 년월값
      - ms_mbr의 join_dtm을 DATE_FORMAT으로 변형한 년월값
      - tr_ord의 ord_dtm을 DATE_FORMAT으로 변형한 년월값
    ㅇ shop_open_cnt: ym(shop_start_ymd)별 ms_shop의 건수
    ㅇ mbr_join_cnt: ym(join_dtm)별 ms_mbr의 건수
    ㅇ ord_cnt: ym(ord_dtm)별 tr_ord의 건수
  ㅁ 추가 고려 사항
    ㅇ 발생하지 않은 값도 0으로 나오도록 처리해 주세요.
    ㅇ 총 4개의 인라인 뷰를 활용해 처리합니다.
      - cm_base_dt를 별도의 인라인 뷰(t1)에서 처리해 3개월간의 년월 데이터를 만듭니다.
      - ms_shop, ms_mbr, tr_ord에 대한 처리를 각각의 인라인 뷰로 처리합니다.
  ㅁ 정렬 기준: ym으로 오름차순 정렬해 주세요.
  
결과)
    ym      shop_open_cnt  mbr_join_cnt  ord_cnt  
    ------  -------------  ------------  -------  
    202104  51             0             5018     
    202105  39             0             5134     
    202106  0              435           5344     

답안)
SELECT t1.ym, IFNULL(t2.shop_open_cnt, 0) shop_open_cnt, IFNULL(t3.mbr_join_cnt, 0) mbr_join_cnt, IFNULL(t4.ord_cnt, 0) ord_cnt
FROM (SELECT DATE_FORMAT(c.base_ymd, '%Y%m') AS ym
      FROM cm_base_dt c
      WHERE c.base_dt >= STR_TO_DATE('20210401', '%Y%m%d')
      AND c.base_dt < STR_TO_DATE('20210701', '%Y%m%d')
      GROUP BY DATE_FORMAT(c.base_ymd, '%Y%m')
) t1
LEFT JOIN (SELECT DATE_FORMAT(s.shop_start_ymd, '%Y%m') AS ym, COUNT(*) AS shop_open_cnt
            FROM ms_shop s
            WHERE s.shop_start_ymd >= STR_TO_DATE('20210401', '%Y%m%d')
            AND s.shop_start_ymd < STR_TO_DATE('20210701', '%Y%m%d')
            GROUP BY DATE_FORMAT(s.shop_start_ymd, '%Y%m')
) t2
ON t1.ym = t2.ym
LEFT JOIN (SELECT DATE_FORMAT(m.join_dtm, '%Y%m') AS ym, COUNT(*) AS mbr_join_cnt
            FROM ms_mbr m
            WHERE m.join_dtm >= STR_TO_DATE('20210401', '%Y%m%d')
            AND m.join_dtm < STR_TO_DATE('20210701', '%Y%m%d')
            GROUP BY DATE_FORMAT(m.join_dtm, '%Y%m')
) t3
ON t1.ym = t3.ym
LEFT JOIN (SELECT DATE_FORMAT(o.ord_dtm, '%Y%m') AS ym, COUNT(*) AS ord_cnt
            FROM tr_ord o
            WHERE o.ord_dtm >= STR_TO_DATE('20210401', '%Y%m%d')
            AND o.ord_dtm < STR_TO_DATE('20210701', '%Y%m%d')
            GROUP BY DATE_FORMAT(o.ord_dtm, '%Y%m')
) t4
ON t1.ym = t4.ym
ORDER BY t1.ym;






