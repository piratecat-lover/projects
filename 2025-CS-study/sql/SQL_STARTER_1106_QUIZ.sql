

------------------------------------------------------------------------
-- BOOSTER QUIZ 11-6-1
------------------------------------------------------------------------
문제) 아래 SQL은 아메리카노 빅사이즈의 일별 주문수량을 구하고 있습니다.
아래 SQL을 활용해, 일별 주문수량의 누계를 추가해 주세요.
  ㅁ 조회 조건: 아래 SQL을 활용
  ㅁ 조회 항목: ord_qty_sum_run_total을 추가
    ㅇ ord_qty_sum_run_total: 일별 ord_qty의 누계입니다.
  ㅁ 추가 고려 사항
    ㅇ 아래 SQL을 인라인 뷰로 처리 후 SUM 분석함수를 적용합니다.

결과)

    SELECT  t3.item_id ,MAX(t3.item_nm) item_nm
            ,DATE_FORMAT(t1.ord_dtm,'%Y%m%d') ord_ymd
            ,SUM(t2.ord_qty) ord_qty_sum
    FROM    startdbmy.tr_ord t1
            INNER JOIN startdbmy.tr_ord_det t2
                ON (t2.ord_no = t1.ord_no)
            INNER JOIN startdbmy.ms_item t3
                ON (t3.item_id = t2.item_id)
    WHERE   t1.ord_dtm >= STR_TO_DATE('20221220','%Y%m%d')
    AND     t1.ord_dtm <  STR_TO_DATE('20221226','%Y%m%d')
    AND     t2.item_id = 'AMB'
    GROUP BY t3.item_id ,DATE_FORMAT(t1.ord_dtm,'%Y%m%d')
    ORDER BY t3.item_id ,DATE_FORMAT(t1.ord_dtm,'%Y%m%d');

    -- ord_qty_sum_run_total이 추가된 결과
    item_id  item_nm       ord_ymd   ord_qty_sum  ord_qty_sum_run_total  
    -------  ------------  --------  -----------  ---------------------  
    AMB      Americano(B)  20221220  109          109                    
    AMB      Americano(B)  20221221  124          233                    
    AMB      Americano(B)  20221222  88           321                    
    AMB      Americano(B)  20221223  123          444                    
    AMB      Americano(B)  20221224  94           538                    
    AMB      Americano(B)  20221225  85           623                    


답안)
SELECT t4.item_id, t4.item_nm, t4.ord_ymd, t4.ord_qty_sum, SUM(t4.ord_qty_sum) OVER (ORDER BY t4.ord_ymd) ord_qty_sum_run_total
FROM (SELECT  t3.item_id ,MAX(t3.item_nm) item_nm
            ,DATE_FORMAT(t1.ord_dtm,'%Y%m%d') ord_ymd
            ,SUM(t2.ord_qty) ord_qty_sum
    FROM    startdbmy.tr_ord t1
            INNER JOIN startdbmy.tr_ord_det t2
                ON (t2.ord_no = t1.ord_no)
            INNER JOIN startdbmy.ms_item t3
                ON (t3.item_id = t2.item_id)
    WHERE   t1.ord_dtm >= STR_TO_DATE('20221220','%Y%m%d')
    AND     t1.ord_dtm <  STR_TO_DATE('20221226','%Y%m%d')
    AND     t2.item_id = 'AMB'
    GROUP BY t3.item_id ,DATE_FORMAT(t1.ord_dtm,'%Y%m%d')
    ORDER BY t3.item_id ,DATE_FORMAT(t1.ord_dtm,'%Y%m%d')
) t4;



            
        

------------------------------------------------------------------------
-- BOOSTER QUIZ 11-6-2
------------------------------------------------------------------------
문제)
[BOOSTER QUIZ 11-6-1]의 답안 SQL을 변경해 아이스 아메리카노 빅사이즈(IAMB)도 추가해 주세요. 누계를 상품별로 구하는 걸로 변경해 주세요.
  ㅁ 조회 조건: [BOOSTER QUIZ 11-6-1]의 답안 SQL을 활용
  ㅁ 조회 항목: ord_qty_sum_run_total를 제거하고 ord_qty_sum_run_total_item을 추가
    ㅇ ord_qty_sum_run_total_item: 상품별로 각각 처리한 일별 ord_qty의 누계입니다.
      - SUM 분석함수에 PARTITION BY를 활용합니다.
      
결과)
    item_id  item_nm            ord_ymd   ord_qty_sum  ord_qty_sum_run_total_item  
    -------  -----------------  --------  -----------  --------------------------  
    AMB      Americano(B)       20221220  109          109                         
    AMB      Americano(B)       20221221  124          233                         
    AMB      Americano(B)       20221222  88           321                         
    AMB      Americano(B)       20221223  123          444                         
    AMB      Americano(B)       20221224  94           538                         
    AMB      Americano(B)       20221225  85           623                         
    IAMB     Iced Americano(B)  20221220  84           84                          
    IAMB     Iced Americano(B)  20221221  125          209                         
    IAMB     Iced Americano(B)  20221222  88           297                         
    IAMB     Iced Americano(B)  20221223  144          441                         
    IAMB     Iced Americano(B)  20221224  111          552                         
    IAMB     Iced Americano(B)  20221225  111          663                         

답안)
SELECT t4.item_id, t4.item_nm, t4.ord_ymd, t4.ord_qty_sum, SUM(t4.ord_qty_sum) OVER (PARTITION BY t4.item_id ORDER BY t4.ord_ymd) ord_qty_sum_run_total
FROM (SELECT  t3.item_id ,MAX(t3.item_nm) item_nm
            ,DATE_FORMAT(t1.ord_dtm,'%Y%m%d') ord_ymd
            ,SUM(t2.ord_qty) ord_qty_sum
    FROM    startdbmy.tr_ord t1
            INNER JOIN startdbmy.tr_ord_det t2
                ON (t2.ord_no = t1.ord_no)
            INNER JOIN startdbmy.ms_item t3
                ON (t3.item_id = t2.item_id)
    WHERE   t1.ord_dtm >= STR_TO_DATE('20221220','%Y%m%d')
    AND     t1.ord_dtm <  STR_TO_DATE('20221226','%Y%m%d')
    AND     t2.item_id IN ('AMB', 'IAMB')
    GROUP BY t3.item_id ,DATE_FORMAT(t1.ord_dtm,'%Y%m%d')
    ORDER BY t3.item_id ,DATE_FORMAT(t1.ord_dtm,'%Y%m%d')
) t4;



        
------------------------------------------------------------------------
-- BOOSTER QUIZ 11-6-3
------------------------------------------------------------------------
문제)
2022년 7월의 회원가입수를 일별로 보여주세요. 회원가입이 없는 날도 0으로 출력되도록 해주세요. 레코드별로 최근 10일 중 회원가입이 가장 많았던 수치도 보여주세요.
  ㅁ 대상 테이블: ms_mbr, cm_base_dt
  ㅁ 조회 조건
    ㅇ cm_base_dt: base_ymd가 2022년 7월
    ㅇ ms_mbr: join_dtm이 2022년 7월
  ㅁ 조회 항목: base_ymd, join_cnt, join_cnt_max_ov_10d
    ㅇ base_ymd
      - cm_base_dt의 base_ymd
      - ms_mbr의 join_dtm을 YYYYMMDD 형태로 변환한 값
    ㅇ join_cnt: 해당 일자에 가입한 회원 수
    ㅇ join_cnt_max_ov_10d: 오늘을 포함한 최근 10일 중, join_cnt의 최댓값
      - MAX 분석함수를 활용합니다.
  ㅁ 추가 고려 사항:
    ㅇ 가입한 회원이 없어도 join_cnt가 0으로 출력될 수 있도록 해야 합니다.
      - cm_base_dt를 기준집합으로 하는 아우터 조인을 활용합니다.
        
결과)
    base_ymd  join_cnt  join_cnt_max_ov_10d  
    --------  --------  -------------------  
    20220701  97        97                   
    20220702  90        97                   
    20220703  87        97                   
    20220704  77        97                   
    20220705  74        97                   
    20220706  73        97                   
    20220707  64        97                   
    20220708  63        97                   
    20220709  49        97                   
    20220710  44        97                   
    20220711  36        90                   
    20220712  33        87                   
    20220713  37        77                   
    20220714  30        74                   
    20220715  29        73                   
    20220716  14        64                   
    20220717  11        63                   
    20220718  7         49                   
    20220719  4         44                   
    20220720  1         37                   
    20220721  1         37                   
    20220722  0         37                   
    20220723  0         30                   
    20220724  0         29                   
    20220725  0         14                   
    20220726  0         11                   
    20220727  0         7                    
    20220728  0         4                    
    20220729  0         1                    
    20220730  0         1                    
    20220731  0         0                    

답안)
SELECT t3.base_ymd, IFNULL(t3.join_cnt, 0) join_cnt, MAX(t3.join_cnt) OVER (ORDER BY t3.base_ymd ROWS BETWEEN 9 PRECEDING AND CURRENT ROW) join_cnt_max_ov_10d
FROM (SELECT t1.base_ymd, COUNT(t2.mbr_id) join_cnt
      FROM startdbmy.cm_base_dt t1
      LEFT JOIN startdbmy.ms_mbr t2
      ON t1.base_ymd = DATE_FORMAT(t2.join_dtm, '%Y%m%d')
      WHERE t1.base_ymd >= STR_TO_DATE('20220701','%Y%m%d')
      AND t1.base_ymd <  STR_TO_DATE('20220801','%Y%m%d')
      GROUP BY t1.base_ymd
      ) t3
ORDER BY t3.base_ymd;


