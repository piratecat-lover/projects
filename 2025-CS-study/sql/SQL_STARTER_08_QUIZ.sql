------------------------------------------------------------------------
-- BOOSTER QUIZ 8-1-1
------------------------------------------------------------------------
문제)
가입일이 2022년 4월 19일인 회원을 조회해주세요. 가입유형과 회원등급, 회원상태에 대한 코드명도 같이 보여주세요.
  ㅁ 대상 테이블: ms_mbr(회원)
  ㅁ 조회 조건: join_dtm(가입일시)이 2022년 4월 19일
  ㅁ 조회 항목: mbr_id, nikc_nm, join_tp, join_tp_nm, mbr_gd, mbr_gd_nm, mbr_st, mbr_st_nm
    ㅇ join_tp_nm: join_tp 코드에 대한 명칭입니다.
    ㅇ mbr_gd_nm: mbr_gd 코드에 대한 명칭입니다.
    ㅇ mbr_st_nm: mbr_st 코드에 대한 명칭입니다.
    ㅇ join_tp_nm, mbr_gd_nm, mbr_st_nm은 SELECT 절 서브쿼리로 처리합니다.
      - cm_base_cd 테이블을 SELECT 절 서브쿼리에서 사용합니다.
  ㅁ 정렬 기준: mbr_id로 오름차순 정렬해주세요.

결과)
    mbr_id  nick_nm  join_tp  join_tp_nm              mbr_gd  mbr_gd_nm  mbr_st  mbr_st_nm      
    ------  -------  -------  ----------------------  ------  ---------  ------  -------------  
    M3070   Lake61   INV      Invited                 SILV    Silver     ACTV    Active Member  
    M3084   River61  SNS      Soical Network Service  SILV    Silver     ACTV    Active Member  
    M3170   Lake63   SNS      Soical Network Service  SILV    Silver     ACTV    Active Member  
    M3362   Fire67   SNS      Soical Network Service  SILV    Silver     ACTV    Active Member  
    M3367   Gold67   DRCT     Direct                  GOLD    Gold       ACTV    Active Member  

답안)
SELECT t1.mbr_id, t1.nick_nm, t1.join_tp, 
  (SELECT x.base_cd_nm 
  FROM startdbmy.cm_base_cd x 
  WHERE x.base_cd_dv = 'JOIN_TP'
  AND x.base_cd = t1.join_tp) join_tp_nm,
  t1.mbr_gd, 
  (SELECT x.base_cd_nm 
  FROM startdbmy.cm_base_cd x 
  WHERE x.base_cd_dv = 'MBR_GD'
  AND x.base_cd = t1.mbr_gd) mbr_gd_nm,
  t1.mbr_st, 
  (SELECT x.base_cd_nm 
  FROM startdbmy.cm_base_cd x 
  WHERE x.base_cd_dv = 'MBR_ST'
  AND x.base_cd = t1.mbr_st) mbr_st_nm
FROM startdbmy.ms_mbr t1
WHERE t1.join_dtm >= STR_TO_DATE('2022-04-19','%Y%-m-%d')
AND t1.join_dtm < STR_TO_DATE('2022-04-20','%Y%-m%-d')
ORDER BY t1.mbr_id;


------------------------------------------------------------------------
-- BOOSTER QUIZ 8-1-2
------------------------------------------------------------------------
문제)
주문번호 10번의 주문과 주문상세 정보를 보여주세요. 주문한 상품의 상품크기에 대한 코드명도 보여주세요.
  ㅁ 대상 테이블: 주문(tr_ord), 주문상세(tr_ord_det), 상품(ms_item)
  ㅁ 조회 조건: ord_no가 10인 데이터
  ㅁ 조회 항목: ord_no, ord_dtm, ord_det_no, item_id, item_nm, item_size_cd_nm
    ㅇ item_size_cd_nm
      - item_size_cd에 대한 명칭으로 서브쿼리를 활용해 처리합니다.
      - cm_base_cd 테이블에서 item_size_cd에 명칭을 찾을 수 있습니다.
  ㅁ 정렬 기준: ord_det_no로 오름차순 정렬해 주세요.
  
결과)
    ord_no  ord_dtm              ord_det_no  item_id  item_nm              item_size_cd_nm  
    ------  -------------------  ----------  -------  -------------------  ---------------  
    10      2019-03-19 06:32:00  1           AMR      Americano(R)         Regular Size     
    10      2019-03-19 06:32:00  2           CMFR     Chocolate Muffin(R)  Regular Size     


답안)
SELECT t1.ord_no, t1.ord_dtm, t2.ord_det_no, t2.item_id, t3.item_nm, 
  (SELECT x.base_cd_nm 
  FROM startdbmy.cm_base_cd x 
  WHERE x.base_cd_dv = 'ITEM_SIZE_CD'
  AND x.base_cd = t3.item_size_cd) item_size_cd_nm
FROM startdbmy.tr_ord t1, startdbmy.tr_ord_det t2, startdbmy.ms_item t3
WHERE t1.ord_no = 10
AND t1.ord_no = t2.ord_no
AND t2.item_id = t3.item_id
ORDER BY t2.ord_det_no;

-- Without JOIN
SELECT t1.ord_no,
  (SELECT x.ord_dtm
  FROM startdbmy.tr_ord x
  WHERE x.ord_no = t1.ord_no) ord_dtm,
  t1.ord_det_no,
  t1.item_id,
  (SELECT x.item_nm
  FROM startdbmy.ms_item x
  WHERE x.item_id = t1.item_id) item_nm,
  (SELECT x.base_cd_nm
  FROM startdbmy.cm_base_cd x
  WHERE x.base_cd_dv = 'ITEM_SIZE_CD'
  AND x.base_cd = 
    (SELECT y.item_size_cd
    FROM startdbmy.ms_item y
    WHERE y.item_id = t1.item_id)
  ) item_size_cd_nm
FROM startdbmy.tr_ord_det t1
WHERE t1.ord_no = 10
ORDER BY t1.ord_det_no;

------------------------------------------------------------------------
-- BOOSTER QUIZ 8-1-3
------------------------------------------------------------------------
문제)
아래 SQL에서 ms_shop과 ms_mbr에 대한 서브쿼리를 조인으로 변경하세요.

결과)
    SELECT  t1.ord_no ,t1.ord_dtm ,t1.shop_id
            ,(SELECT x.shop_nm FROM startdbmy.ms_shop x WHERE x.shop_id = t1.shop_id) shop_nm
            ,(SELECT x.shop_size FROM startdbmy.ms_shop x WHERE x.shop_id = t1.shop_id) shop_size
            ,t1.mbr_id
            ,(SELECT x.nick_nm FROM startdbmy.ms_mbr x WHERE x.mbr_id = t1.mbr_id) nick_nm
    FROM    startdbmy.tr_ord t1
    WHERE   t1.ord_no = 100
    ORDER BY t1.ord_no;

    ord_no  ord_dtm              shop_id  shop_nm         shop_size  mbr_id  nick_nm  
    ------  -------------------  -------  --------------  ---------  ------  -------  
    100     2019-03-27 07:01:00  S033     Fort Worth-2nd  91         M0032   Pink     

답안)
SELECT t1.ord_no, t1.ord_dtm, t1.shop_id, t2.shop_nm, t2.shop_size, t1.mbr_id, t3.nick_nm
FROM startdbmy.tr_ord t1, startdbmy.ms_shop t2, startdbmy.ms_mbr t3
WHERE t1.ord_no = 100
AND t1.shop_id = t2.shop_id
AND t1.mbr_id = t3.mbr_id
ORDER BY t1.ord_no;



------------------------------------------------------------------------
-- BOOSTER QUIZ 8-1-4
------------------------------------------------------------------------
문제)
아래 SQL에서 서브쿼리를 제거하고 조인으로 처리하세요.

결과)
    SELECT  t1.mbr_id ,t1.nick_nm ,t1.join_dtm
            ,(
                SELECT  SUM(x.ord_amt)
                FROM    startdbmy.tr_ord X
                WHERE   x.mbr_id = t1.mbr_id
                AND     x.ord_dtm >= STR_TO_DATE('20210801','%Y%m%d')
                AND     x.ord_dtm <  STR_TO_DATE('20210901','%Y%m%d')
            ) ord_amt
            ,(
                SELECT  COUNT(*)
                FROM    startdbmy.tr_ord X
                WHERE   x.mbr_id = t1.mbr_id
                AND     x.ord_dtm >= STR_TO_DATE('20210801','%Y%m%d')
                AND     x.ord_dtm <  STR_TO_DATE('20210901','%Y%m%d')
            ) ord_cnt
    FROM    startdbmy.ms_mbr t1
    WHERE   t1.join_dtm >= STR_TO_DATE('20210702','%Y%m%d')
    AND     t1.join_dtm <  STR_TO_DATE('20210703','%Y%m%d')
    AND     t1.mbr_gd = 'PLAT'
    AND     t1.mbr_st = 'ACTV'
    ORDER BY t1.mbr_id ASC;

    mbr_id  nick_nm   join_dtm             ord_amt    ord_cnt  
    ------  --------  -------------------  ---------  -------  
    M2604   Coffee52  2021-07-02 00:00:00  13000.000  1        
    M2674   Metal53   2021-07-02 00:00:00  23500.000  4        
    M2884   River57   2021-07-02 00:00:00  12500.000  2        


답안)
SELECT t1.mbr_id, t1.nick_nm, t1.join_dtm, 
  SUM(t2.ord_amt) ord_amt, COUNT(t2.ord_no) ord_cnt
FROM startdbmy.ms_mbr t1
LEFT JOIN startdbmy.tr_ord t2
ON (t1.mbr_id = t2.mbr_id
  AND t2.ord_dtm >= STR_TO_DATE('20210801','%Y%m%d')
  AND t2.ord_dtm < STR_TO_DATE('20210901','%Y%m%d')
  )
WHERE t1.join_dtm >= STR_TO_DATE('20210702','%Y%m%d')
AND t1.join_dtm < STR_TO_DATE('20210703','%Y%m%d')
AND t1.mbr_gd = 'PLAT'
AND t1.mbr_st = 'ACTV'
GROUP BY t1.mbr_id, t1.nick_nm, t1.join_dtm
ORDER BY t1.mbr_id;
    
------------------------------------------------------------------------
-- BOOSTER QUIZ 8-2-1
------------------------------------------------------------------------
문제) '2022년 12월 24일'에 한 번이라도 주문이 있었던 회원 수를 알려주세요.
  ㅁ 대상 테이블: ms_mbr, tr_ord
  ㅁ 조회 조건: 2022년 12월 24일(ord_dtm)에 주문이 한 건이라도 있는 회원
  ㅁ 조회 항목: mbr_cnt
    ㅇ mbr_cnt: 2022년 12월 24일에 주문이 한 건이라도 있었던 회원의 수
  ㅁ 추가 고려 사항
    ㅇ tr_ord 테이블을 WHERE 절의 EXISTS 서브쿼리로 처리하세요.
    

결과)
    mbr_cnt  
    -------  
    359      


답안)
SELECT COUNT(DISTINCT t1.mbr_id) mbr_cnt
FROM startdbmy.ms_mbr t1
WHERE EXISTS 
  (SELECT 1
  FROM startdbmy.tr_ord x 
  WHERE x.mbr_id = t1.mbr_id
  AND x.ord_dtm >= STR_TO_DATE('20221224','%Y%m%d')
  AND x.ord_dtm < STR_TO_DATE('20221225','%Y%m%d')
  );


            
            
------------------------------------------------------------------------
-- BOOSTER QUIZ 8-2-2
------------------------------------------------------------------------
문제) '2020'년 이전에 가입한 현재 ACTIVE 회원 중에, '2021년 1월 1일'부터 '2021년 1월 10일'까지 주문이 한 건도 없는 회원 수를 알려주세요.

  ㅁ 대상 테이블: ms_mbr, tr_ord
  ㅁ 조회 조건: join_dtm이 '20200101' 미만이면서 mbr_st가 ACTV인 회원
  ㅁ 조회 항목: mbr_cnt
    ㅇ mbr_cnt: 2021년 1월 1일부터 2021년 1월 10일까지 주문이 한 건도 없는 회원 수
      - ord_dtm 조건 처리시, 2021년 1월 11일 미만으로 조건을 처리해야 함에 주의
  ㅁ 추가 고려 사항
    ㅇ tr_ord 테이블을 WHERE 절의 NOT EXISTS 서브쿼리로 처리하세요.


결과)
    mbr_cnt  
    -------  
    940      


답안)
SELECT COUNT(DISTINCT t1.mbr_id) mbr_cnt
FROM startdbmy.ms_mbr t1
WHERE t1.join_dtm < STR_TO_DATE('20200101','%Y%m%d')
AND t1.mbr_st = 'ACTV'
AND NOT EXISTS 
  (SELECT 1
  FROM startdbmy.tr_ord x 
  WHERE x.mbr_id = t1.mbr_id
  AND x.ord_dtm >= STR_TO_DATE('20210101','%Y%m%d')
  AND x.ord_dtm < STR_TO_DATE('20210111','%Y%m%d')
  );

            
------------------------------------------------------------------------
-- BOOSTER QUIZ 8-2-3
------------------------------------------------------------------------
'2022년 12월 24일'에 초코머핀 주문이 한 번이라도 있었던 회원을 회원등급별로 카운트(회원수)해주세요.
  ㅁ 대상 테이블: ms_mbr, tr_ord, tr_ord_det
  ㅁ 조회 조건
    ㅇ 2022년 12월 24일(ord_dtm)에 item_id가 CMFR(초코머핀)인 주문이 한건이라도 있는 회원
  ㅁ 조회 항목: mbr_gd, mbr_gd_nm, mbr_cnt
    ㅇ mbr_gd_nm: mbr_gd(회원등급)에 대한 코드명입니다.
      - cm_base_cd를 활용한 SELECT 절 서브쿼리로 처리해주세요.
    ㅇ mbr_cnt: mbr_gd별 회원 건수
  ㅁ 추가 고려 사항
     ㅇ tr_ord와 tr_ord_det를 WHERE 절의 EXISTS 서브쿼리로 처리합니다.
     ㅇ EXISTS까지 처리된 결과를 mbr_gd로 GROUP BY 처리하세요.
  ㅁ 정렬 기준: mbr_cnt로 내림차순 정렬해주세요.
    
결과)
    mbr_gd  mbr_gd_nm  mbr_cnt  
    ------  ---------  -------  
    SILV    Silver     23       
    GOLD    Gold       16       
    PLAT    Platinum   7        

답안)
SELECT t1.mbr_gd, 
  (SELECT x.base_cd_nm 
  FROM startdbmy.cm_base_cd x 
  WHERE x.base_cd_dv = 'MBR_GD'
  AND x.base_cd = t1.mbr_gd) mbr_gd_nm,
  COUNT(DISTINCT t1.mbr_id) mbr_cnt
FROM startdbmy.ms_mbr t1
WHERE EXISTS 
  (SELECT 1
  FROM startdbmy.tr_ord x 
  WHERE x.mbr_id = t1.mbr_id
  AND x.ord_dtm >= STR_TO_DATE('20221224','%Y%m%d')
  AND x.ord_dtm < STR_TO_DATE('20221225','%Y%m%d')
  AND EXISTS 
    (SELECT 1
    FROM startdbmy.tr_ord_det y 
    WHERE y.ord_no = x.ord_no
    AND y.item_id = 'CMFR'
    )
  )
GROUP BY t1.mbr_gd, mbr_gd_nm
ORDER BY mbr_cnt DESC;