
------------------------------------------------------------------------
-- BOOSTER QUIZ 3-3-1
------------------------------------------------------------------------
문제)
상품 테이블에서 상품ID가 ‘AMB’인 데이터를 조회하세요.
  ㅁ 대상 테이블: 상품(ms_item)
  ㅁ 조회 조건: item_id가 AMB인 상품만 조회
  ㅁ 조회 항목: ms_item의 모든 컬럼
       
결과)
    item_id  item_nm       item_cat  item_size_cd  hot_cold_cd  lach_dt    
    -------  ------------  --------  ------------  -----------  ----------  
    AMB      Americano(B)  COF       BIG           HOT          2019-01-01
   
-- BOOSTER QUIZ 3-3-1
SELECT * FROM ms_item
WHERE item_id = "AMB";

------------------------------------------------------------------------
-- BOOSTER QUIZ 3-3-2
------------------------------------------------------------------------
문제)
상품카테고리가 음료인 상품 정보를 조회하세요.
  ㅁ 대상 테이블: 상품(ms_item)
  ㅁ 조회 조건: item_cat가 ‘BEV’(음료)인 상품
  ㅁ 조회 항목: item_id, item_nm, item_cat
       
결과)
    item_id  item_nm            item_cat  
    -------  -----------------  --------  
    CITR     Yuzu Ade(R)        BEV      
    HCHB     Hot Chocolate(B)   BEV      
    HCHR     Hot Chocolate(R)   BEV      
    LEMR     Lemonade(R)        BEV      
    ZAMB     Grapefruit Ade(R)  BEV      

-- BOOSTER QUIZ 3-3-2
SELECT item_id, item_nm, item_cat FROM ms_item
WHERE item_cat = "BEV";

------------------------------------------------------------------------
-- BOOSTER QUIZ 3-4-1
------------------------------------------------------------------------
문제)
상품카테고리가 커피이면서 빅사이이즈이고 HOT인 상품목록을 조회해주세요.
  ㅁ 대상 테이블: 상품(ms_item)
  ㅁ 조회 조건
    ㅇ item_cat(상품카테고리)가 COF(커피)이면서
    ㅇ item_size_cd(상품사이즈코드)는 BIG이고
    ㅇ hot_cold_cd(핫콜드구분코드)는 HOT인 데이터
  ㅁ 조회 항목: item_id, item_nm, item_cat, item_size_cd, hot_cold_cd
       
결과)
    item_id  item_nm        item_cat  item_size_cd  hot_cold_cd  
    -------  -------------  --------  ------------  -----------  
    AMB      Americano(B)   COF       BIG           HOT          
    CLB      Cafe Latte(B)  COF       BIG           HOT          

-- BOOSTER QUIZ 3-4-1
SELECT item_id, item_nm, item_cat, item_size_cd, hot_cold_cd FROM ms_item
WHERE item_cat = "COF" AND item_size_cd = "BIG" AND hot_cold_cd = "HOT";

------------------------------------------------------------------------
-- BOOSTER QUIZ 3-4-2
------------------------------------------------------------------------
문제)
레귤러 사이즈 상품 중에, 상품카테고리가 음료이거나 베이커리인 상품을 뽑아주세요.
  ㅁ 대상 테이블: 상품(ms_item)
  ㅁ 조회 조건
    ㅇ item_size_cd(상품사이즈코드)가 REG(Regular)이면서,
    ㅇ item_cat(상품카테고리)가 BEV(음료)이거나(OR) BKR(베이커리)인 데이터
  ㅁ 조회 항목: item_id, item_nm, item_cat, item_size_cd, hot_cold_cd

결과)
    item_id  item_nm              item_cat  item_size_cd  hot_cold_cd  
    -------  -------------------  --------  ------------  -----------  
    CITR     Yuzu Ade(R)          BEV       REG           COLD        
    HCHR     Hot Chocolate(R)     BEV       REG           HOT          
    LEMR     Lemonade(R)          BEV       REG           COLD        
    ZAMB     Grapefruit Ade(R)    BEV       REG           COLD        
    BGLR     Bagel(R)             BKR       REG           HOT          
    BMFR     Blueberry Muffin(R)  BKR       REG           COLD        
    CMFR     Chocolate Muffin(R)  BKR       REG           COLD        
    MACA     Macaron(R)           BKR       REG           HOT          

-- BOOSTER QUIZ 3-4-2
SELECT item_id, item_nm, item_cat, item_size_cd, hot_cold_cd FROM ms_item
WHERE item_size_cd = "REG" AND (item_cat = "BEV" OR item_cat = "BKR")
ORDER BY item_cat;