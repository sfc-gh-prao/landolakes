-- ============================================================
-- LAND O'LAKES x SNOWFLAKE: CORTEX CODE HANDS-ON LAB
-- Setup Script v1.0  |  Run ONCE before the lab session
-- Estimated run time: 3-5 minutes on SMALL warehouse
-- ============================================================

USE ROLE ACCOUNTADMIN;

-- ============================================================
-- SECTION 1: ENVIRONMENT SETUP
-- ============================================================

CREATE DATABASE IF NOT EXISTS LOL_CORTEX_LAB
    COMMENT = 'Land O Lakes Cortex Code Hands-On Lab Database';

USE DATABASE LOL_CORTEX_LAB;

CREATE SCHEMA IF NOT EXISTS SALES_DATA
    COMMENT = 'Sales, inventory, customer, and product data';

USE SCHEMA SALES_DATA;

CREATE WAREHOUSE IF NOT EXISTS LOL_LAB_WH
    WAREHOUSE_SIZE    = 'SMALL'
    AUTO_SUSPEND      = 120
    AUTO_RESUME       = TRUE
    COMMENT           = 'Land O Lakes Cortex Code Lab Compute Warehouse';

USE WAREHOUSE LOL_LAB_WH;

CREATE STAGE IF NOT EXISTS CORTEX_ANALYST_STAGE
    COMMENT = 'Stores Cortex Analyst semantic model YAML files';

-- ============================================================
-- SECTION 2: TABLE DEFINITIONS
-- ============================================================

CREATE OR REPLACE TABLE PRODUCTS (
    PRODUCT_ID        NUMBER AUTOINCREMENT PRIMARY KEY,
    SKU               VARCHAR(20)    NOT NULL UNIQUE,
    PRODUCT_NAME      VARCHAR(100)   NOT NULL,
    CATEGORY          VARCHAR(50)    NOT NULL,
    SUB_CATEGORY      VARCHAR(50),
    BRAND             VARCHAR(50),
    UNIT_COST         DECIMAL(10,2)  NOT NULL,
    UNIT_PRICE        DECIMAL(10,2)  NOT NULL,
    UNIT_OF_MEASURE   VARCHAR(20),
    IS_ACTIVE         BOOLEAN        DEFAULT TRUE,
    LAUNCH_DATE       DATE
) COMMENT = 'Land O Lakes product catalog: dairy, crop inputs, animal nutrition';

CREATE OR REPLACE TABLE CUSTOMERS (
    CUSTOMER_ID       NUMBER AUTOINCREMENT PRIMARY KEY,
    CUSTOMER_NAME     VARCHAR(100)   NOT NULL,
    CUSTOMER_TYPE     VARCHAR(50)    NOT NULL,
    SEGMENT           VARCHAR(50),
    REGION            VARCHAR(50),
    STATE             VARCHAR(2),
    CITY              VARCHAR(100),
    ANNUAL_REVENUE    DECIMAL(18,2),
    ACCOUNT_MANAGER   VARCHAR(100),
    CREATED_DATE      DATE,
    IS_ACTIVE         BOOLEAN        DEFAULT TRUE
) COMMENT = 'Customer master: retail chains, food service, cooperatives, distributors';

CREATE OR REPLACE TABLE WAREHOUSES (
    WAREHOUSE_ID      NUMBER AUTOINCREMENT PRIMARY KEY,
    WAREHOUSE_NAME    VARCHAR(100)   NOT NULL,
    REGION            VARCHAR(50),
    STATE             VARCHAR(2),
    CITY              VARCHAR(100),
    CAPACITY_UNITS    NUMBER,
    IS_ACTIVE         BOOLEAN        DEFAULT TRUE
) COMMENT = 'Distribution centers and cold storage facilities';

CREATE OR REPLACE TABLE CAMPAIGNS (
    CAMPAIGN_ID       NUMBER AUTOINCREMENT PRIMARY KEY,
    CAMPAIGN_NAME     VARCHAR(200)   NOT NULL,
    CAMPAIGN_TYPE     VARCHAR(50),
    TARGET_SEGMENT    VARCHAR(50),
    TARGET_REGION     VARCHAR(50),
    START_DATE        DATE,
    END_DATE          DATE,
    BUDGET            DECIMAL(18,2),
    ACTUAL_SPEND      DECIMAL(18,2),
    TARGET_REVENUE    DECIMAL(18,2)
) COMMENT = 'Marketing and trade promotion campaigns';

CREATE OR REPLACE TABLE SALES (
    SALE_ID           NUMBER AUTOINCREMENT PRIMARY KEY,
    SALE_DATE         DATE           NOT NULL,
    CUSTOMER_ID       NUMBER,
    PRODUCT_ID        NUMBER,
    WAREHOUSE_ID      NUMBER,
    QUANTITY          NUMBER         NOT NULL,
    UNIT_PRICE        DECIMAL(10,2)  NOT NULL,
    DISCOUNT_PCT      DECIMAL(5,2)   DEFAULT 0,
    GROSS_REVENUE     DECIMAL(18,2),
    NET_REVENUE       DECIMAL(18,2),
    COST_OF_GOODS     DECIMAL(18,2),
    GROSS_PROFIT      DECIMAL(18,2),
    CHANNEL           VARCHAR(50),
    CAMPAIGN_ID       NUMBER,
    FOREIGN KEY (CUSTOMER_ID)  REFERENCES CUSTOMERS(CUSTOMER_ID),
    FOREIGN KEY (PRODUCT_ID)   REFERENCES PRODUCTS(PRODUCT_ID),
    FOREIGN KEY (WAREHOUSE_ID) REFERENCES WAREHOUSES(WAREHOUSE_ID)
) COMMENT = 'Sales transactions across all product lines and customer segments';

CREATE OR REPLACE TABLE INVENTORY (
    INVENTORY_ID       NUMBER AUTOINCREMENT PRIMARY KEY,
    SNAPSHOT_DATE      DATE           NOT NULL,
    PRODUCT_ID         NUMBER,
    WAREHOUSE_ID       NUMBER,
    UNITS_ON_HAND      NUMBER         NOT NULL DEFAULT 0,
    UNITS_RESERVED     NUMBER         DEFAULT 0,
    UNITS_AVAILABLE    NUMBER,
    REORDER_POINT      NUMBER,
    REORDER_QTY        NUMBER,
    DAYS_OF_SUPPLY     DECIMAL(10,1),
    LAST_RECEIVED_DATE DATE,
    FOREIGN KEY (PRODUCT_ID)   REFERENCES PRODUCTS(PRODUCT_ID),
    FOREIGN KEY (WAREHOUSE_ID) REFERENCES WAREHOUSES(WAREHOUSE_ID)
) COMMENT = 'Weekly inventory snapshots by product and warehouse location';

CREATE OR REPLACE TABLE MARKET_PRICES (
    PRICE_DATE         DATE           NOT NULL,
    COMMODITY          VARCHAR(100)   NOT NULL,
    PRICE_PER_UNIT     DECIMAL(10,4),
    UNIT               VARCHAR(20),
    EXCHANGE           VARCHAR(50),
    PRIMARY KEY (PRICE_DATE, COMMODITY)
) COMMENT = 'Daily commodity market prices from CME and CBOT exchanges';

CREATE OR REPLACE TABLE RETURNS (
    RETURN_ID          NUMBER AUTOINCREMENT PRIMARY KEY,
    RETURN_DATE        DATE           NOT NULL,
    ORIGINAL_SALE_ID   NUMBER,
    PRODUCT_ID         NUMBER,
    CUSTOMER_ID        NUMBER,
    QUANTITY_RETURNED  NUMBER         NOT NULL,
    RETURN_REASON      VARCHAR(200),
    REFUND_AMOUNT      DECIMAL(18,2),
    FOREIGN KEY (PRODUCT_ID)  REFERENCES PRODUCTS(PRODUCT_ID),
    FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMERS(CUSTOMER_ID)
) COMMENT = 'Product returns and customer refunds';

-- ============================================================
-- SECTION 3: DIMENSION DATA - PRODUCTS (28 rows)
-- ============================================================

INSERT INTO PRODUCTS (SKU, PRODUCT_NAME, CATEGORY, SUB_CATEGORY, BRAND, UNIT_COST, UNIT_PRICE, UNIT_OF_MEASURE, LAUNCH_DATE) VALUES
-- Dairy: Butter
('DAI-BUT-001', 'Salted Butter 1lb',                  'Dairy',          'Butter',       'Land O Lakes',    2.85,   4.99, 'lb',    '2018-01-01'),
('DAI-BUT-002', 'Unsalted Butter 1lb',                'Dairy',          'Butter',       'Land O Lakes',    2.80,   4.89, 'lb',    '2018-01-01'),
('DAI-BUT-003', 'European Style Butter 7oz',          'Dairy',          'Butter',       'Land O Lakes',    3.20,   6.49, 'oz',    '2020-03-15'),
('DAI-BUT-004', 'Salted Butter Half Sticks 1lb',      'Dairy',          'Butter',       'Land O Lakes',    2.75,   4.79, 'lb',    '2019-06-01'),
('DAI-BUT-005', 'Organic Butter 1lb',                 'Dairy',          'Butter',       'Land O Lakes',    3.80,   7.99, 'lb',    '2022-01-01'),
-- Dairy: Cheese
('DAI-CHE-001', 'Sharp Cheddar Block 8oz',            'Dairy',          'Cheese',       'Land O Lakes',    2.10,   4.49, 'oz',    '2018-01-01'),
('DAI-CHE-002', 'Mild Cheddar Block 8oz',             'Dairy',          'Cheese',       'Land O Lakes',    1.95,   4.19, 'oz',    '2018-01-01'),
('DAI-CHE-003', 'American Cheese Singles 12oz',       'Dairy',          'Cheese',       'Land O Lakes',    2.40,   4.99, 'oz',    '2018-01-01'),
('DAI-CHE-004', 'Provolone Deli Slices 8oz',          'Dairy',          'Cheese',       'Land O Lakes',    2.25,   4.79, 'oz',    '2021-01-15'),
-- Dairy: Cream
('DAI-CRM-001', 'Heavy Whipping Cream 1pt',           'Dairy',          'Cream',        'Land O Lakes',    1.80,   3.99, 'pt',    '2018-01-01'),
('DAI-CRM-002', 'Half & Half 1qt',                    'Dairy',          'Cream',        'Land O Lakes',    1.50,   3.29, 'qt',    '2018-01-01'),
('DAI-CRM-003', 'Sour Cream 16oz',                    'Dairy',          'Cream',        'Land O Lakes',    1.20,   2.79, 'oz',    '2018-01-01'),
('DAI-CRM-004', 'Organic Half & Half 1pt',            'Dairy',          'Cream',        'Land O Lakes',    2.50,   5.49, 'pt',    '2022-06-01'),
-- Dairy: Spreads
('DAI-SPR-001', 'Butter with Olive Oil Spread 15oz',  'Dairy',          'Spreads',      'Land O Lakes',    2.10,   4.49, 'oz',    '2019-01-01'),
('DAI-SPR-002', 'Light Butter Spread 15oz',           'Dairy',          'Spreads',      'Land O Lakes',    1.95,   3.99, 'oz',    '2018-01-01'),
-- Crop Inputs: Seeds
('CRP-SED-001', 'Corn Seed Elite 50lb Bag',           'Crop Inputs',    'Seeds',        'WinField United', 95.00, 185.00, 'bag',  '2019-01-01'),
('CRP-SED-002', 'Soybean Seed Premium 50lb Bag',      'Crop Inputs',    'Seeds',        'WinField United', 75.00, 145.00, 'bag',  '2019-01-01'),
('CRP-SED-003', 'Winter Wheat Seed 50lb Bag',         'Crop Inputs',    'Seeds',        'WinField United', 45.00,  89.00, 'bag',  '2020-09-01'),
('CRP-SED-004', 'Canola Seed Premium 50lb Bag',       'Crop Inputs',    'Seeds',        'WinField United', 55.00, 109.00, 'bag',  '2021-03-01'),
-- Crop Inputs: Herbicides & Fungicides
('CRP-HRB-001', 'Roundup PowerMax 2.5gal',            'Crop Inputs',    'Herbicides',   'WinField United', 52.00,  89.99, 'gal',  '2018-01-01'),
('CRP-HRB-002', 'Verdict Herbicide 32oz',             'Crop Inputs',    'Herbicides',   'WinField United', 48.00,  85.00, 'oz',   '2021-03-01'),
('CRP-FNG-001', 'Headline AMP Fungicide 1gal',        'Crop Inputs',    'Fungicides',   'WinField United', 65.00, 119.99, 'gal',  '2019-06-01'),
-- Animal Nutrition: Feed
('ANI-FED-001', 'Purina Horse Feed 50lb',             'Animal Nutrition','Horse Feed',  'Purina',          18.50,  32.99, 'bag',  '2018-01-01'),
('ANI-FED-002', 'Purina Cattle Feed 50lb',            'Animal Nutrition','Cattle Feed', 'Purina',          14.20,  24.99, 'bag',  '2018-01-01'),
('ANI-FED-003', 'Purina Poultry Feed 50lb',           'Animal Nutrition','Poultry Feed','Purina',          12.80,  21.99, 'bag',  '2018-01-01'),
('ANI-FED-004', 'Purina Hog Feed 50lb',               'Animal Nutrition','Hog Feed',   'Purina',          13.50,  23.49, 'bag',  '2019-01-01'),
-- Animal Nutrition: Supplements
('ANI-SUP-001', 'Tasco Cattle Supplement 25lb',       'Animal Nutrition','Supplements', 'Purina',          22.00,  39.99, 'bag',  '2020-01-01'),
('ANI-SUP-002', 'Wind & Rain Mineral Block 50lb',     'Animal Nutrition','Supplements', 'Purina',          15.00,  27.99, 'block','2021-06-01');

-- ============================================================
-- SECTION 4: DIMENSION DATA - WAREHOUSES (12 rows)
-- ============================================================

INSERT INTO WAREHOUSES (WAREHOUSE_NAME, REGION, STATE, CITY, CAPACITY_UNITS) VALUES
('Minneapolis Distribution Center',  'Midwest',   'MN', 'Minneapolis',  500000),
('Chicago Cold Storage Hub',         'Midwest',   'IL', 'Chicago',       350000),
('Kansas City Ag Center',            'Midwest',   'MO', 'Kansas City',   400000),
('Dallas Regional Center',           'South',     'TX', 'Dallas',        300000),
('Atlanta Southeast Hub',            'South',     'GA', 'Atlanta',       275000),
('Houston Distribution Center',      'South',     'TX', 'Houston',       260000),
('Los Angeles West Coast',           'West',      'CA', 'Los Angeles',   325000),
('Portland Northwest Center',        'West',      'OR', 'Portland',      200000),
('Denver Mountain West',             'West',      'CO', 'Denver',        215000),
('Philadelphia Northeast Hub',       'Northeast', 'PA', 'Philadelphia',  310000),
('Boston Cold Storage',              'Northeast', 'MA', 'Boston',        180000),
('Charlotte Mid-Atlantic Center',    'Northeast', 'NC', 'Charlotte',     240000);

-- ============================================================
-- SECTION 5: DIMENSION DATA - CUSTOMERS (28 rows)
-- ============================================================

INSERT INTO CUSTOMERS (CUSTOMER_NAME, CUSTOMER_TYPE, SEGMENT, REGION, STATE, CITY, ANNUAL_REVENUE, ACCOUNT_MANAGER, CREATED_DATE) VALUES
-- Enterprise Retail
('Walmart Stores Inc.',          'Retail',        'Enterprise', 'South',     'AR', 'Bentonville',  572754000000, 'Sarah Johnson',     '2018-01-15'),
('Kroger Co.',                   'Retail',        'Enterprise', 'Midwest',   'OH', 'Cincinnati',   148258000000, 'Michael Chen',      '2018-01-15'),
('Costco Wholesale',             'Retail',        'Enterprise', 'West',      'WA', 'Issaquah',     226954000000, 'Jennifer Williams', '2018-02-01'),
('Target Corporation',           'Retail',        'Enterprise', 'Midwest',   'MN', 'Minneapolis',  109120000000, 'Robert Davis',      '2018-01-15'),
('Publix Super Markets',         'Retail',        'Enterprise', 'South',     'FL', 'Lakeland',      48399000000, 'Amanda Martinez',   '2018-03-01'),
('Albertsons Companies',         'Retail',        'Enterprise', 'West',      'ID', 'Boise',         77650000000, 'Jennifer Williams', '2018-02-15'),
('H-E-B Grocery',                'Retail',        'Enterprise', 'South',     'TX', 'San Antonio',   38000000000, 'Carlos Rodriguez',  '2019-01-01'),
-- Mid-Market Retail
('Aldi Inc.',                    'Retail',        'Mid-Market', 'Midwest',   'IL', 'Batavia',       20000000000, 'Michael Chen',      '2019-06-01'),
('Whole Foods Market',           'Retail',        'Mid-Market', 'South',     'TX', 'Austin',        16000000000, 'Amanda Martinez',   '2020-01-01'),
('Trader Joes',                  'Retail',        'Mid-Market', 'West',      'CA', 'Monrovia',      16500000000, 'Jennifer Williams', '2020-03-01'),
('Meijer Inc.',                  'Retail',        'Mid-Market', 'Midwest',   'MI', 'Grand Rapids',  18000000000, 'Michael Chen',      '2019-09-01'),
('Wegmans Food Markets',         'Retail',        'Mid-Market', 'Northeast', 'NY', 'Rochester',      9800000000, 'Sarah Johnson',     '2020-06-01'),
-- Food Service
('Sysco Corporation',            'Food Service',  'Enterprise', 'South',     'TX', 'Houston',       76300000000, 'Carlos Rodriguez',  '2018-01-15'),
('US Foods',                     'Food Service',  'Enterprise', 'Midwest',   'IL', 'Rosemont',      36000000000, 'Michael Chen',      '2018-01-15'),
('Performance Food Group',       'Food Service',  'Enterprise', 'South',     'VA', 'Richmond',      57000000000, 'Sarah Johnson',     '2019-01-01'),
('Compass Group USA',            'Food Service',  'Mid-Market', 'South',     'NC', 'Charlotte',     12000000000, 'Amanda Martinez',   '2020-06-01'),
('Darden Restaurants',           'Food Service',  'Mid-Market', 'South',     'FL', 'Orlando',       11000000000, 'Carlos Rodriguez',  '2020-01-01'),
-- Cooperatives
('Iowa Farm Cooperative',        'Cooperative',   'Mid-Market', 'Midwest',   'IA', 'Des Moines',      850000000, 'Robert Davis',      '2018-06-01'),
('Minnesota Farmers Union',      'Cooperative',   'Mid-Market', 'Midwest',   'MN', 'St. Paul',        620000000, 'Robert Davis',      '2018-01-15'),
('Wisconsin Dairy Farmers Coop', 'Cooperative',   'Mid-Market', 'Midwest',   'WI', 'Madison',         940000000, 'Sarah Johnson',     '2019-03-01'),
('Dakota Growers Coop',          'Cooperative',   'SMB',        'Midwest',   'ND', 'Fargo',           280000000, 'Robert Davis',      '2020-01-01'),
('Illinois Corn Growers Assoc',  'Cooperative',   'SMB',        'Midwest',   'IL', 'Bloomington',     310000000, 'Michael Chen',      '2020-06-01'),
-- Distributors
('Pacific Coast Ag Distributors','Distributor',   'Mid-Market', 'West',      'CA', 'Fresno',          450000000, 'Jennifer Williams', '2019-06-01'),
('Southeast Food Distributors',  'Distributor',   'Mid-Market', 'South',     'GA', 'Atlanta',         380000000, 'Amanda Martinez',   '2019-01-01'),
('Northeast Dairy Distributors', 'Distributor',   'Mid-Market', 'Northeast', 'NY', 'Albany',          420000000, 'Sarah Johnson',     '2018-09-01'),
('Great Plains Supply Co.',      'Distributor',   'SMB',        'Midwest',   'KS', 'Wichita',         195000000, 'Robert Davis',      '2020-06-01'),
('Mountain West Foods',          'Distributor',   'SMB',        'West',      'CO', 'Denver',          165000000, 'Jennifer Williams', '2021-01-01'),
('Fresh & Easy Stores',          'Retail',        'SMB',        'West',      'CA', 'El Segundo',     1200000000, 'Jennifer Williams', '2021-06-01');

-- ============================================================
-- SECTION 6: DIMENSION DATA - CAMPAIGNS (12 rows)
-- ============================================================

INSERT INTO CAMPAIGNS (CAMPAIGN_NAME, CAMPAIGN_TYPE, TARGET_SEGMENT, TARGET_REGION, START_DATE, END_DATE, BUDGET, ACTUAL_SPEND, TARGET_REVENUE) VALUES
('Holiday Butter Season 2024',      'Seasonal',       'Enterprise',  'National',  '2024-10-01','2025-01-31', 2500000, 2350000, 18000000),
('Spring Planting Push 2024',       'Seasonal',       'Cooperative', 'Midwest',   '2024-02-01','2024-05-31', 1800000, 1950000, 12000000),
('Back to School Dairy 2024',       'Seasonal',       'Retail',      'National',  '2024-07-15','2024-09-15', 1200000, 1100000,  8500000),
('Q1 2025 Butter Promo',            'Promotional',    'Enterprise',  'National',  '2025-01-01','2025-03-31',  800000,  720000,  5000000),
('WinField Spring Seed Launch 25',  'Promotional',    'Cooperative', 'Midwest',   '2025-02-01','2025-04-30', 1500000, 1480000,  9500000),
('Land O Lakes Brand Refresh 25',   'Brand Awareness','All',         'National',  '2025-01-01','2025-12-31', 5000000, 4200000, 35000000),
('Food Service Expansion Drive',    'Trade',          'Food Service','South',     '2024-09-01','2024-12-31',  950000,  890000,  6200000),
('Organic Line Launch Q2 2025',     'Promotional',    'Retail',      'West',      '2025-04-01','2025-06-30',  600000,  580000,  3500000),
('Holiday Butter Season 2025',      'Seasonal',       'Enterprise',  'National',  '2025-10-01','2026-01-31', 2700000, 2600000, 19500000),
('Q1 2026 Dairy Push',              'Promotional',    'Enterprise',  'National',  '2026-01-01','2026-03-31',  900000,  750000,  5500000),
('WinField Spring Seed Launch 26',  'Seasonal',       'Cooperative', 'Midwest',   '2026-02-01','2026-05-31', 1600000,  980000, 10500000),
('Purina Animal Nutrition Drive',   'Trade',          'Cooperative', 'Midwest',   '2025-06-01','2025-09-30',  750000,  710000,  5800000);

-- ============================================================
-- SECTION 7: SALES DATA GENERATION (~16,800 rows, 2 years)
-- Approach: deterministic HASH-based assignment over a date x
-- transaction number grid; seasonal multipliers applied per
-- product category; discount and quantity vary by customer type
-- ============================================================

INSERT INTO SALES (
    SALE_DATE, CUSTOMER_ID, PRODUCT_ID, WAREHOUSE_ID,
    QUANTITY, UNIT_PRICE, DISCOUNT_PCT,
    GROSS_REVENUE, NET_REVENUE, COST_OF_GOODS, GROSS_PROFIT,
    CHANNEL, CAMPAIGN_ID
)
WITH date_grid AS (
    SELECT
        DATEADD(day, seq4()::INT, '2024-01-01')::DATE AS sale_date,
        seq4()::INT                                     AS day_num
    FROM TABLE(GENERATOR(ROWCOUNT => 480))
),
tx_grid AS (
    SELECT
        d.sale_date,
        d.day_num,
        t.tx_num,
        ABS(MOD(HASH(d.day_num * 7919 + t.tx_num * 104729), 2147483647)) AS rh
    FROM date_grid d
    CROSS JOIN (SELECT seq4()::INT AS tx_num FROM TABLE(GENERATOR(ROWCOUNT => 35))) t
),
assigned AS (
    SELECT
        sale_date,
        rh,
        (MOD(rh,           28) + 1)::INT AS product_id,
        (MOD(ABS(HASH(rh+1)), 28) + 1)::INT AS customer_id,
        (MOD(ABS(HASH(rh+2)), 12) + 1)::INT AS warehouse_id
    FROM tx_grid
),
enriched AS (
    SELECT
        a.sale_date,
        a.customer_id,
        a.product_id,
        a.warehouse_id,
        a.rh,
        p.unit_price  AS list_price,
        p.unit_cost,
        p.category,
        c.customer_type,
        c.region
    FROM assigned a
    JOIN PRODUCTS  p ON p.product_id  = a.product_id
    JOIN CUSTOMERS c ON c.customer_id = a.customer_id
),
with_qty AS (
    SELECT
        sale_date,
        customer_id,
        product_id,
        warehouse_id,
        list_price   AS unit_price,
        unit_cost,
        category,
        customer_type,
        region,
        -- Seasonal base quantity per category
        GREATEST(10, ROUND((
            CASE category
                WHEN 'Dairy' THEN
                    CASE WHEN MONTH(sale_date) IN (11,12,1) THEN 1300
                         WHEN MONTH(sale_date) IN (6,7,8)   THEN  750
                         ELSE 950 END
                WHEN 'Crop Inputs' THEN
                    CASE WHEN MONTH(sale_date) IN (3,4,5)    THEN 1600
                         WHEN MONTH(sale_date) IN (10,11,12) THEN  280
                         ELSE 600 END
                WHEN 'Animal Nutrition' THEN
                    CASE WHEN MONTH(sale_date) IN (11,12,1,2) THEN 1050
                         ELSE 750 END
                ELSE 500
            END
            * CASE customer_type
                WHEN 'Retail'        THEN 4.2
                WHEN 'Food Service'  THEN 2.1
                WHEN 'Cooperative'   THEN 1.6
                WHEN 'Distributor'   THEN 2.8
                ELSE 1.0
              END
            * (0.65 + MOD(rh, 70)::FLOAT / 100.0)
        )::INT)) AS quantity,
        -- Discount by customer type
        ROUND(
            CASE customer_type
                WHEN 'Retail'       THEN 2.0 + MOD(rh, 8)
                WHEN 'Food Service' THEN 5.0 + MOD(rh, 10)
                WHEN 'Cooperative'  THEN 8.0 + MOD(rh, 10)
                WHEN 'Distributor'  THEN 4.0 + MOD(rh, 12)
                ELSE 1.0 + MOD(rh, 5)
            END, 2
        ) AS discount_pct,
        -- Channel
        CASE customer_type
            WHEN 'Retail'       THEN 'Direct Retail'
            WHEN 'Food Service' THEN 'Food Service'
            WHEN 'Cooperative'  THEN 'Cooperative'
            WHEN 'Distributor'  THEN 'Distributor'
            ELSE 'Other'
        END AS channel,
        -- Campaign tagging
        CASE
            WHEN sale_date BETWEEN '2024-10-01' AND '2025-01-31' AND category = 'Dairy'            THEN 1
            WHEN sale_date BETWEEN '2024-02-01' AND '2024-05-31' AND category = 'Crop Inputs'      THEN 2
            WHEN sale_date BETWEEN '2024-07-15' AND '2024-09-15' AND category = 'Dairy'            THEN 3
            WHEN sale_date BETWEEN '2025-01-01' AND '2025-03-31' AND category = 'Dairy'            THEN 4
            WHEN sale_date BETWEEN '2025-02-01' AND '2025-04-30' AND category = 'Crop Inputs'      THEN 5
            WHEN sale_date BETWEEN '2025-10-01' AND '2026-01-31' AND category = 'Dairy'            THEN 9
            WHEN sale_date BETWEEN '2026-01-01' AND '2026-03-31' AND category = 'Dairy'            THEN 10
            WHEN sale_date BETWEEN '2026-02-01' AND '2026-05-31' AND category = 'Crop Inputs'      THEN 11
            WHEN sale_date BETWEEN '2025-06-01' AND '2025-09-30' AND category = 'Animal Nutrition' THEN 12
            ELSE NULL
        END AS campaign_id
    FROM enriched
)
SELECT
    sale_date,
    customer_id,
    product_id,
    warehouse_id,
    quantity,
    unit_price,
    discount_pct,
    ROUND(quantity * unit_price, 2)                                            AS gross_revenue,
    ROUND(quantity * unit_price * (1 - discount_pct / 100.0), 2)              AS net_revenue,
    ROUND(quantity * unit_cost, 2)                                             AS cost_of_goods,
    ROUND(quantity * unit_price * (1 - discount_pct / 100.0)
          - quantity * unit_cost, 2)                                           AS gross_profit,
    channel,
    campaign_id
FROM with_qty;

-- ============================================================
-- SECTION 8: INVENTORY DATA GENERATION
-- Weekly snapshots for the last 52 weeks (~9,000 rows)
-- ============================================================

INSERT INTO INVENTORY (
    SNAPSHOT_DATE, PRODUCT_ID, WAREHOUSE_ID,
    UNITS_ON_HAND, UNITS_RESERVED, UNITS_AVAILABLE,
    REORDER_POINT, REORDER_QTY, DAYS_OF_SUPPLY, LAST_RECEIVED_DATE
)
WITH weeks AS (
    SELECT DATEADD(week, -(seq4()::INT), CURRENT_DATE())::DATE AS snap_date
    FROM TABLE(GENERATOR(ROWCOUNT => 52))
),
combos AS (
    SELECT
        w.snap_date,
        p.product_id,
        p.category,
        wh.warehouse_id,
        wh.capacity_units,
        ABS(MOD(HASH(DATEDIFF('week','2024-01-01', w.snap_date)::INT * 9973
                     + p.product_id * 1031
                     + wh.warehouse_id * 137), 2147483647)) AS rh
    FROM weeks w
    CROSS JOIN PRODUCTS p
    CROSS JOIN WAREHOUSES wh
    WHERE MOD(ABS(HASH(w.snap_date, p.product_id, wh.warehouse_id)), 4) < 3
),
with_levels AS (
    SELECT
        snap_date,
        product_id,
        warehouse_id,
        -- Scale base inventory by warehouse size and category velocity
        GREATEST(0, ROUND(
            CASE category
                WHEN 'Dairy'            THEN 8000
                WHEN 'Crop Inputs'      THEN 4000
                WHEN 'Animal Nutrition' THEN 5500
                ELSE 3000
            END
            * (capacity_units / 350000.0)
            * (0.4 + MOD(rh, 120)::FLOAT / 100.0)
        )) AS units_on_hand,
        CASE category
            WHEN 'Dairy'            THEN 3000
            WHEN 'Crop Inputs'      THEN 1500
            WHEN 'Animal Nutrition' THEN 2000
            ELSE 1500
        END AS reorder_point,
        CASE category
            WHEN 'Dairy'            THEN 15000
            WHEN 'Crop Inputs'      THEN  6000
            WHEN 'Animal Nutrition' THEN  9000
            ELSE  6000
        END AS reorder_qty,
        rh
    FROM combos
)
SELECT
    snap_date,
    product_id,
    warehouse_id,
    units_on_hand,
    ROUND(units_on_hand * 0.07)                                  AS units_reserved,
    units_on_hand - ROUND(units_on_hand * 0.07)                  AS units_available,
    reorder_point,
    reorder_qty,
    ROUND(3.0 + MOD(rh, 87)::FLOAT, 1)                          AS days_of_supply,
    DATEADD(day, -(MOD(rh, 14)::INT + 1), snap_date)             AS last_received_date
FROM with_levels;

-- ============================================================
-- SECTION 9: MARKET PRICES GENERATION
-- Daily commodity prices: 480 days × 7 commodities = 3,360 rows
-- Prices use a seasonal sine wave + small random noise
-- ============================================================

INSERT INTO MARKET_PRICES (PRICE_DATE, COMMODITY, PRICE_PER_UNIT, UNIT, EXCHANGE)
WITH date_spine AS (
    SELECT
        DATEADD(day, seq4()::INT, '2024-01-01')::DATE AS price_date,
        seq4()::INT                                    AS day_num
    FROM TABLE(GENERATOR(ROWCOUNT => 480))
),
commodities AS (
    SELECT 'Butter'       AS commodity, 2.45 AS base_price, 0.30 AS amplitude, 'lb'     AS unit, 'CME'  AS exchange UNION ALL
    SELECT 'Cheddar',                   1.75,                0.20,              'lb',             'CME'  UNION ALL
    SELECT 'Dry Whey',                  0.52,                0.08,              'lb',             'CME'  UNION ALL
    SELECT 'Corn',                      4.85,                0.60,              'bushel',         'CBOT' UNION ALL
    SELECT 'Soybeans',                 12.20,                1.20,              'bushel',         'CBOT' UNION ALL
    SELECT 'Wheat',                     5.90,                0.70,              'bushel',         'CBOT' UNION ALL
    SELECT 'Class III Milk',           16.80,                1.80,              'cwt',            'CME'
)
SELECT
    d.price_date,
    c.commodity,
    ROUND(
        c.base_price
        + c.amplitude * SIN(d.day_num * 0.018)
        + c.amplitude * 0.4 * COS(d.day_num * 0.007)
        + (c.amplitude * 0.1 * MOD(ABS(HASH(d.day_num, c.commodity)), 200)::FLOAT / 100.0 - c.amplitude * 0.1),
        4
    ) AS price_per_unit,
    c.unit,
    c.exchange
FROM date_spine d
CROSS JOIN commodities c;

-- ============================================================
-- SECTION 10: RETURNS DATA (derived from ~1% of sales)
-- ============================================================

INSERT INTO RETURNS (
    RETURN_DATE, ORIGINAL_SALE_ID, PRODUCT_ID, CUSTOMER_ID,
    QUANTITY_RETURNED, RETURN_REASON, REFUND_AMOUNT
)
WITH reasons AS (
    SELECT 0 AS r, 'Product quality issue'          AS reason UNION ALL
    SELECT 1,       'Damaged in transit'                        UNION ALL
    SELECT 2,       'Incorrect product shipped'                  UNION ALL
    SELECT 3,       'Near expiration date'                       UNION ALL
    SELECT 4,       'Order entry error'                          UNION ALL
    SELECT 5,       'Customer over-ordered'
)
SELECT
    DATEADD(day, MOD(ABS(HASH(s.sale_id)), 14) + 1, s.sale_date) AS return_date,
    s.sale_id                                                       AS original_sale_id,
    s.product_id,
    s.customer_id,
    GREATEST(1, ROUND(s.quantity * 0.15))                          AS quantity_returned,
    r.reason                                                        AS return_reason,
    ROUND(GREATEST(1, ROUND(s.quantity * 0.15)) * s.unit_price
          * (1 - s.discount_pct / 100.0), 2)                       AS refund_amount
FROM SALES s
JOIN reasons r ON r.r = MOD(ABS(HASH(s.sale_id + 99)), 6)
WHERE MOD(s.sale_id, 100) = 0;

-- ============================================================
-- SECTION 11: INTENTIONAL DATA QUALITY ISSUES
-- (Used in Module 3 - Data Quality exercises)
-- ============================================================

-- Issue 1: ~1% of sales have NULL channel (missing channel tagging)
UPDATE SALES
SET CHANNEL = NULL
WHERE MOD(SALE_ID, 87) = 0;

-- Issue 2: ~0.8% of sales have invalid negative discount
UPDATE SALES
SET DISCOUNT_PCT = -5.0
WHERE MOD(SALE_ID, 123) = 0;

-- Issue 3: ~2% of inventory records have negative days of supply
UPDATE INVENTORY
SET DAYS_OF_SUPPLY = -1.0
WHERE MOD(INVENTORY_ID, 45) = 0;

-- Issue 4: Introduce ~50 duplicate sale records
INSERT INTO SALES (
    SALE_DATE, CUSTOMER_ID, PRODUCT_ID, WAREHOUSE_ID,
    QUANTITY, UNIT_PRICE, DISCOUNT_PCT,
    GROSS_REVENUE, NET_REVENUE, COST_OF_GOODS, GROSS_PROFIT,
    CHANNEL, CAMPAIGN_ID
)
SELECT
    SALE_DATE, CUSTOMER_ID, PRODUCT_ID, WAREHOUSE_ID,
    QUANTITY, UNIT_PRICE, DISCOUNT_PCT,
    GROSS_REVENUE, NET_REVENUE, COST_OF_GOODS, GROSS_PROFIT,
    CHANNEL, CAMPAIGN_ID
FROM SALES
WHERE MOD(SALE_ID, 337) = 0
LIMIT 50;

-- Issue 5: A handful of sales with quantity = 0 (invalid)
UPDATE SALES
SET QUANTITY = 0, GROSS_REVENUE = 0, NET_REVENUE = 0, GROSS_PROFIT = 0
WHERE MOD(SALE_ID, 500) = 7;

-- ============================================================
-- SECTION 12: CONVENIENCE VIEWS
-- ============================================================

CREATE OR REPLACE VIEW V_SALES_ENRICHED AS
SELECT
    s.sale_id,
    s.sale_date,
    DATE_TRUNC('month', s.sale_date)  AS sale_month,
    DATE_TRUNC('week',  s.sale_date)  AS sale_week,
    YEAR(s.sale_date)                 AS sale_year,
    QUARTER(s.sale_date)              AS sale_quarter,
    MONTH(s.sale_date)                AS sale_month_num,
    p.sku,
    p.product_name,
    p.category,
    p.sub_category,
    p.brand,
    c.customer_name,
    c.customer_type,
    c.segment,
    c.region,
    c.state,
    c.account_manager,
    w.warehouse_name,
    w.region                          AS warehouse_region,
    w.state                           AS warehouse_state,
    s.quantity,
    s.unit_price,
    s.discount_pct,
    s.gross_revenue,
    s.net_revenue,
    s.cost_of_goods,
    s.gross_profit,
    ROUND(100.0 * s.gross_profit / NULLIF(s.net_revenue, 0), 2) AS margin_pct,
    s.channel,
    cam.campaign_name,
    cam.campaign_type
FROM SALES s
JOIN PRODUCTS   p   ON p.product_id   = s.product_id
JOIN CUSTOMERS  c   ON c.customer_id  = s.customer_id
JOIN WAREHOUSES w   ON w.warehouse_id = s.warehouse_id
LEFT JOIN CAMPAIGNS cam ON cam.campaign_id = s.campaign_id;

CREATE OR REPLACE VIEW V_INVENTORY_CURRENT AS
SELECT
    i.snapshot_date,
    p.sku,
    p.product_name,
    p.category,
    p.sub_category,
    p.brand,
    w.warehouse_name,
    w.region,
    w.state,
    i.units_on_hand,
    i.units_reserved,
    i.units_available,
    i.reorder_point,
    i.reorder_qty,
    i.days_of_supply,
    i.last_received_date,
    CASE
        WHEN i.units_available <= i.reorder_point THEN 'REORDER NOW'
        WHEN i.units_available <= i.reorder_point * 1.25 THEN 'LOW STOCK'
        ELSE 'OK'
    END AS stock_status
FROM INVENTORY i
JOIN PRODUCTS   p ON p.product_id   = i.product_id
JOIN WAREHOUSES w ON w.warehouse_id = i.warehouse_id
WHERE i.snapshot_date = (SELECT MAX(snapshot_date) FROM INVENTORY);

-- ============================================================
-- SECTION 13: SUMMARY STATS (verify data was loaded correctly)
-- ============================================================

SELECT 'PRODUCTS'     AS tbl, COUNT(*) AS row_count FROM PRODUCTS     UNION ALL
SELECT 'CUSTOMERS',           COUNT(*)              FROM CUSTOMERS     UNION ALL
SELECT 'WAREHOUSES',          COUNT(*)              FROM WAREHOUSES    UNION ALL
SELECT 'CAMPAIGNS',           COUNT(*)              FROM CAMPAIGNS     UNION ALL
SELECT 'SALES',               COUNT(*)              FROM SALES         UNION ALL
SELECT 'INVENTORY',           COUNT(*)              FROM INVENTORY     UNION ALL
SELECT 'MARKET_PRICES',       COUNT(*)              FROM MARKET_PRICES UNION ALL
SELECT 'RETURNS',             COUNT(*)              FROM RETURNS
ORDER BY tbl;

-- ============================================================
-- SETUP COMPLETE
-- Expected row counts (approximate):
--   PRODUCTS:       28
--   CUSTOMERS:      28
--   WAREHOUSES:     12
--   CAMPAIGNS:      12
--   SALES:      ~16,850  (includes ~50 duplicate DQ records)
--   INVENTORY:   ~9,000
--   MARKET_PRICES: 3,360
--   RETURNS:       ~169
-- ============================================================
