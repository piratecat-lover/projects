
------------------------------------------------------------------------
-- BOOSTER QUIZ 3-6-1
------------------------------------------------------------------------
문제)
상품ID가 ‘BMFR’ 이상이면서 ‘CLR’ 이하인 상품을 보여주세요.
  ㅁ 대상 테이블: 상품(ms_item)
  ㅁ 조회 조건: item_id가 BMFR 이상(>=) 이면서 CLR 이하(<=)인 데이터
  ㅁ 조회 항목: item_id, item_nm, item_cat  
  ㅁ 추가 고려 사항: BETWEEN 조건을 사용해 해결하세요.

결과)
    item_id  item_nm              item_cat  
    -------  -------------------  --------  
    BMFR     Blueberry Muffin(R)  BKR      
    CITR     Yuzu Ade(R)          BEV      
    CLB      Cafe Latte(B)        COF      
    CLR      Cafe Latte(R)        COF      
   
   
SELECT item_id, item_nm, item_cat FROM ms_item
WHERE item_id BETWEEN 'BMFR' AND 'CLR';

------------------------------------------------------------------------
-- BOOSTER QUIZ 3-6-2
------------------------------------------------------------------------
문제)
뜨거운 상품 중에, 명칭이 ‘(R)’로 끝나는 상품을 보여주세요.
  ㅁ 대상 테이블: 상품(ms_item)
  ㅁ 조회 조건: hot_cold_cd가 HOT이면서 item_nm이 (R)로 끝나는 데이터(LIKE 사용)
  ㅁ 조회 항목: item_id, item_nm, item_cat
       
결과)
    item_id  item_nm           item_cat  
    -------  ----------------  --------  
    AMR      Americano(R)      COF      
    BGLR     Bagel(R)          BKR      
    CLR      Cafe Latte(R)     COF      
    EINR     Einspanner(R)     COF      
    FLTR     Flat White(R)     COF      
    HCHR     Hot Chocolate(R)  BEV      
    MACA     Macaron(R)        BKR      

SELECT item_id, item_nm, item_cat FROM ms_item
WHERE hot_cold_cd = 'HOT'
AND item_nm LIKE '%(R)';

------------------------------------------------------------------------
-- BOOSTER QUIZ 3-6-3
------------------------------------------------------------------------
문제)
상품사이즈가 ‘BIG’ 인 상품 중에, 상품카테고리가 ‘COF’이거나 ‘BEV’이면서, 상품명이 ‘Iced’로 시작하지 않는 데이터를 보여주세요.
  ㅁ 대상 테이블: 상품(ms_item)
  ㅁ 조회 조건
    ㅇ item_size_cd가 BIG이고
    ㅇ item_cat가 COF 또는 BEV이면서
    ㅇ item_nm이 Iced로 시작하지 않는 데이터
  ㅁ 조회 항목: item_id, item_nm, item_cat, item_size_cd
  ㅁ 추가 고려 사항: item_cat에 대한 조건은 IN으로 item_nm에 대한 조건은 NOT LIKE로 해결하세요.

  
SELECT item_id, item_nm, item_cat, item_size_cd FROM ms_item
WHERE item_size_cd = 'BIG'
AND item_cat IN ('COF', 'BEV')
AND item_nm NOT LIKE 'Iced%';


------------------------------------------------------------------------
-- BOOSTER QUIZ 3-7-1
------------------------------------------------------------------------

문제)
상품종류가 커피이면서 뜨거운 상품 목록을 보여주세요. 상품명으로 내림차순 정렬해주세요.
  ㅁ 대상 테이블: 상품(ms_item)
  ㅁ 조회 조건: item_cat가 COF(커피)이면서, hot_cold_cd가 HOT인 데이터
  ㅁ 조회 항목: item_id, item_nm, item_cat, hot_cold_cd
  ㅁ 정렬 기준: item_nm 으로 내림차순 정렬하세요.
       
결과)
    item_id  item_nm        item_cat  hot_cold_cd  
    -------  -------------  --------  -----------  
    FLTR     Flat White(R)  COF       HOT          
    EINR     Einspanner(R)  COF       HOT          
    CLR      Cafe Latte(R)  COF       HOT          
    CLB      Cafe Latte(B)  COF       HOT          
    AMR      Americano(R)   COF       HOT          
    AMB      Americano(B)   COF       HOT          

SELECT item_id, item_nm, item_cat, hot_cold_cd FROM ms_item
WHERE (item_cat, hot_cold_cd) = ('COF', 'HOT')
ORDER BY item_nm DESC;


------------------------------------------------------------------------
-- BOOSTER QUIZ 3-7-2
------------------------------------------------------------------------

문제)
상품ID가 ‘A’ 이상이면서 ‘C’이하인 상품을 보여주세요. hot_cold_cd 값으로 먼저 오름차순한 다음에, item_cat 로 오름차순해서 보여주세요.
  ㅁ 대상 테이블: 상품(ms_item)
  ㅁ 조회 조건: item_id가 A 이상(>=), C 이하(<=)인 데이터
  ㅁ 조회 항목: item_id, item_nm, item_cat, hot_cold_cd
  ㅁ 정렬 기준: hot_cold_cd로 오름차순 한 후에, item_cat로 오름차순 정렬하세요.
       
결과)
    item_id  item_nm              item_cat  hot_cold_cd  
    -------  -------------------  --------  -----------  
    BMFR     Blueberry Muffin(R)  BKR       COLD        
    BGLR     Bagel(R)             BKR       HOT          
    AMB      Americano(B)         COF       HOT          
    AMR      Americano(R)         COF       HOT          

SELECT item_id, item_nm, item_cat, hot_cold_cd FROM ms_item
WHERE item_id BETWEEN 'A' AND 'C'
ORDER BY hot_cold_cd ASC, item_cat ASC;

------------------------------------------------------------------------
-- BOOSTER QUIZ 3-9-1
------------------------------------------------------------------------

문제)
상품카테고리가 베이커리인 상품의 정보를 보여주세요. 컬럼명을 한글로 처리해 주세요.
  ㅁ 대상 테이블: 상품(ms_item)
  ㅁ 조회 조건: item_cat가 ‘BKR’(베이커리)인 데이터
  ㅁ 조회 항목: 상품ID, 상품명, 상품종류, 냉/온구분
    ㅇ 상품ID: item_id의 별칭입니다.
    ㅇ 상품명: item_nm의 별칭입니다.
    ㅇ 상품종류: item_cat의 별칭입니다.
    ㅇ 냉/온구분: hot_cold_cd의 별칭입니다.
  ㅁ 정렬 기준: 상품명으로 내림차순 정렬하세요.
       
결과)
    상품ID  상품명               상품종류  냉/온구분      
    ------  -------------------  --------  ---------  
    MACA    Macaron(R)           BKR       HOT        
    CMFR    Chocolate Muffin(R)  BKR       COLD      
    BMFR    Blueberry Muffin(R)  BKR       COLD      
    BGLR    Bagel(R)             BKR       HOT

SELECT item_id `상품 ID`, item_nm 상품명, item_cat 상품종류, hot_cold_cd `냉/온구분` FROM ms_item
WHERE item_cat='BKR'
ORDER BY item_nm DESC;