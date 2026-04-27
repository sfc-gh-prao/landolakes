# Land O'Lakes × Snowflake
## Cortex Code: Hands-On Lab — Snowsight UI Edition

**Duration:** 90 minutes  
**Format:** Self-paced with guided checkpoints  
**Environment:** Your own Snowflake demo account — Snowsight (no local install required)

---

## Module 0 — Environment Setup (5 min)

> **Do this before anything else.** Each person has their own Snowflake demo account. You'll load the lab dataset directly into your account — it takes about 3–4 minutes to run.

### Step 0.1 — Log In

1. Open your browser and go to [https://go.dataops.live/eqr-it-tech-huddle/instructions](https://go.dataops.live/land-o-lakes/instructions)
2. Register for a demo account using your email address
3. Bookmark the URL provided at the end of the registration process. This will be the account you will be using for the lab.
4. Disregard the "Lab Instructions" link provided at the end of the registration. This README.md will be your lab guide
5. Sign into your Snowflake demo account with the credentials you were provided

### Step 0.2 — Create a new workspace

1. In the left nav, click **Projects → Workspaces**
2. Click **+ Create workspace** at the top left → **Git workspace**
3. Enter the repository URL: [https://github.com/sfc-gh-prao/eqr](https://github.com/sfc-gh-prao/landolakes)
4. Enter workspace name: EQR HOL
5. Click **+ API Integration**  
   Name: **EQR_HOL**  
   Allowed Prefixes: **https://github.com/sfc-gh-prao/eqr**  
   Leave the default selections for the remaining options and click **Create**  
7. When you return to the create workspace menu, select **Public repository** and click **Create**

At the bottom left hand corner, ensure you see "ACCOUNTADMIN" selected. This will be important for the setup script we'll be running in the next step.

> **Why ACCOUNTADMIN?** The setup script creates a database, a warehouse, and several schemas. This requires account-level privileges. You'll switch to a less-privileged role for the rest of the lab.

### Step 0.3 — Run the Setup Script

1. If you were able to successfully create a Git workspace, you will see a **setup.sql** file appear
4. Click **Run All** (▶▶ button, or `Cmd+Shift+Enter` / `Ctrl+Shift+Enter`)
5. Watch the progress — each section runs sequentially. You'll see output for each INSERT statement
6. The final step outputs a row-count summary table — **wait until you see this before moving on**


> **Expected output:**
> ```
> CAMPAIGNS        12
> CUSTOMERS        28
> INVENTORY     ~9,000
> MARKET_PRICES  3,360
> PRODUCTS          28
> RETURNS          ~170
> SALES         ~16,850
> WAREHOUSES        12
> ```
> If any table shows 0, let your instructor know before moving on.

---

## Welcome

Today you'll experience how Cortex Code — Snowflake's AI assistant built directly into the Snowsight browser UI — transforms how teams interact with data. You'll run analytics, detect data quality issues, build automated pipelines, deploy a live dashboard, and create an intelligent agent your whole team can use — all without writing a single line of SQL or Python from scratch.

The dataset mirrors Land O'Lakes' world: dairy products, crop inputs, animal nutrition, retail and cooperative customers, regional distribution centers, marketing campaigns, inventory snapshots, and commodity market prices.

---

## Lab Data Model

You'll work in the **`LOL_CORTEX_LAB`** database, `SALES_DATA` schema:

| Table | What's Inside |
|-------|--------------|
| `PRODUCTS` | 28 SKUs across Dairy (Land O Lakes), Crop Inputs (WinField United), Animal Nutrition (Purina) |
| `CUSTOMERS` | 28 accounts: retail chains, food service operators, cooperatives, distributors |
| `WAREHOUSES` | 12 distribution centers across Midwest, South, West, Northeast |
| `CAMPAIGNS` | 12 marketing and trade promotion programs |
| `SALES` | ~16,850 transactions spanning 480 days |
| `INVENTORY` | ~9,000 weekly inventory snapshots by product × warehouse |
| `MARKET_PRICES` | 3,360 daily commodity prices (CME/CBOT: butter, corn, soybeans, etc.) |
| `RETURNS` | ~170 product return records |

---

## How to Use Cortex Code in Snowsight

1. In the left nav click **Projects → Workspaces**
2. Click **+ New** → **Cortex Code**
3. The screen splits: **chat panel on the left**, **notebook/output on the right**
4. Type your prompt in the chat box at the bottom and press **Enter**

**Power-user tip:** Type `#LOL_CORTEX_LAB.SALES_DATA.SALES` in a prompt to inject the table's column names and sample rows as context. Cortex Code writes smarter, more accurate queries when it knows your schema.

---

## Module 1 — Getting Oriented (8 min)

> **Setup is complete. Open Cortex Code and let's go.**

### Step 1.1 — Set Your Context

```
Set my context to use the LOL_CORTEX_LAB database, SALES_DATA schema, and the LOL_LAB_WH warehouse for this session.
```

### Step 1.2 — Explore the Data Model

```
What tables exist in the LOL_CORTEX_LAB.SALES_DATA schema? Give me a one-sentence description of each table and show how many rows are in each one.
```

> **What to notice:** Cortex Code queries the information schema, counts rows across all tables, and describes each one — normally 8+ separate queries written by hand.

### Step 1.3 — Get Oriented to the Business

```
Using #LOL_CORTEX_LAB.SALES_DATA.PRODUCTS, show me a summary of the product catalog. How many products are there, how do they break down by category and brand, and what is the average list price per category?
```

```
Using #LOL_CORTEX_LAB.SALES_DATA.CUSTOMERS, summarize the customer base. How many customers are there by type and segment? Which regions are best represented?
```

---

## Module 2 — Natural Language Analytics (12 min)

**Goal:** Get real business answers from complex data in seconds, regardless of SQL background. Each prompt below is designed to show Cortex Code handling things that would take an analyst 30–60 minutes to write manually.

### Revenue & Profitability

```
Show me total net revenue and gross profit by product category for each month of 2025. Add a column showing the year-over-year percentage change compared to the same month in 2024.
```

```
Which 10 customers generated the most gross profit in the last 90 days? Include their customer type, region, account manager, and gross margin percentage. Sort by gross profit descending.
```

```
Calculate the average gross margin percentage grouped by customer segment and customer type. Rank each combination from highest to lowest margin.
```

> **What to highlight:** The margin calculation, YoY logic, and multi-level ranking are all SQL patterns most analysts avoid writing by hand. Cortex Code handles them instantly.

### Seasonal & Trend Analysis

```
Show the average weekly net revenue for Dairy products broken out by month of year. I want to see which months are strongest — highlight any month where Dairy revenue is more than 20% above the annual average.
```

```
Which products have declining net revenue? Compare the last 60 days to the prior 60 days and show me the top 5 biggest declines as a percentage drop.
```

### Campaign & Channel Performance

```
Show me total net revenue and number of transactions for each marketing campaign. Include the campaign budget, actual spend, and calculate ROI as revenue divided by actual spend. Flag any campaign where actual revenue came in below 80% of the target. Sort by ROI descending.
```

```
Compare revenue and average discount percentage across our four channels: Direct Retail, Food Service, Cooperative, and Distributor. Which channel has the best margin profile?
```

---

## Module 3 — Data Quality Detection & Remediation (8 min)

**Goal:** Use Cortex Code to discover data quality issues and fix them — then build a live monitoring view so problems don't go unnoticed in the future.

> **Context:** The dataset was intentionally seeded with real-world quality problems: null channel tags, invalid negative discounts, zero-quantity orders, duplicate transactions, and negative inventory values.

### Step 3.1 — Audit the Data

```
Run a comprehensive data quality audit on LOL_CORTEX_LAB.SALES_DATA. For each key table, check for:
- Null values in columns that should never be null (IDs, dates, amounts, revenue)
- Duplicate records (same date + customer + product + quantity in SALES)
- Invalid numeric values: negative discounts, zero or negative quantities, negative revenue
- Logical errors: any row where gross_profit > net_revenue (impossible), or days_of_supply < 0 in INVENTORY
- Customers in CUSTOMERS with no sales in the last 6 months

Summarize findings in a table: table name, issue type, row count affected, severity (High / Medium / Low).
```

> **What to watch for:** Cortex Code generates a battery of targeted checks and consolidates them into a single result — work that normally takes a DBA half a day.

### Step 3.2 — Fix the Issues

```
Write an UPDATE statement that fixes all NULL CHANNEL values in the SALES table. Derive the correct channel from each row's customer's CUSTOMER_TYPE in the CUSTOMERS table, using this mapping: Retail = 'Direct Retail', Food Service = 'Food Service', Cooperative = 'Cooperative', Distributor = 'Distributor'. Then run it and confirm zero NULLs remain.
```

```
Write and run two DELETE statements on the SALES table:
1. Remove all zero-quantity rows (quantity = 0)
2. Remove duplicate transactions — keep only the row with the lowest SALE_ID for each group of rows that share the same sale_date, customer_id, product_id, and quantity
Confirm how many rows were removed by each statement.
```

```
Fix the INVENTORY table: set any DAYS_OF_SUPPLY values that are negative to NULL — a negative value is impossible and NULL correctly represents "unknown". Confirm the fix.
```

### Step 3.3 — Build a Reusable DQ Monitor

```
Create a VIEW called V_DATA_QUALITY_SCORECARD in LOL_CORTEX_LAB.SALES_DATA. It should report key data quality metrics for the SALES and INVENTORY tables — percentage of null values in critical columns, count of invalid values (negative discounts, zero quantities), and a calculated overall health score from 0–100 for each table. This view should be runnable at any time to get a current picture of data quality.
```

---

## Module 4 — Data Engineering Pipelines (10 min)

**Goal:** Show data engineers how Cortex Code accelerates pipeline development — Dynamic Tables, Stored Procedures, Tasks, Streams, and Python UDFs — all from natural language prompts in Snowsight.

### Step 4.1 — Dynamic Tables

```
Create a Dynamic Table called DT_DAILY_SALES_SUMMARY in LOL_CORTEX_LAB.SALES_DATA with a target lag of 1 minute on the LOL_LAB_WH warehouse. Join SALES, PRODUCTS, and CUSTOMERS to produce a daily aggregation by product category, brand, customer type, region, and channel. Include: transaction count, unique customers, total units sold, gross revenue, net revenue, and gross margin percentage. Filter out zero-quantity rows. Write and run the DDL.
```

```
Create a second Dynamic Table called DT_INVENTORY_ALERTS with a 5-minute target lag. Join the most recent INVENTORY snapshot with PRODUCTS and WAREHOUSES. Add an alert_level column using this logic: 'OUT OF STOCK' when units_available = 0, 'REORDER NOW' when units_available <= reorder_point, 'LOW STOCK' when units_available <= reorder_point × 1.3, otherwise 'OK'. Write and run the DDL, then query it to show current alerts.
```

> **What to highlight:** Dynamic Tables replace manual refresh jobs — Snowflake manages the scheduling, incremental compute, and dependency tracking automatically.

### Step 4.2 — Stored Procedure

```
Create a table called REORDER_RECOMMENDATIONS in LOL_CORTEX_LAB.SALES_DATA to hold replenishment recommendations, then write a stored procedure called SP_GENERATE_REORDER_RECOMMENDATIONS in SQL scripting that truncates that table and re-populates it. It should pull all products from the latest INVENTORY snapshot where units_available is below reorder_point, join with product name, warehouse name, and region, and add an urgency column: 'CRITICAL' when available = 0, 'HIGH' when available is below 50% of reorder_point, 'MEDIUM' otherwise. Include estimated reorder cost as reorder_qty × unit_cost. Write, deploy, and call the procedure. Show the output grouped by urgency and category.
```

### Step 4.3 — Task Scheduling

```
Create a Snowflake Task called TASK_DAILY_REORDER_REFRESH in LOL_CORTEX_LAB.SALES_DATA that runs the stored procedure SP_GENERATE_REORDER_RECOMMENDATIONS every morning at 6 AM UTC using a CRON schedule on the LOL_LAB_WH warehouse. Write and run the CREATE TASK statement.
```

### Step 4.4 — Change Data Capture & Python UDF

```
Create a Snowflake Stream called STR_SALES_CDC on the SALES table to capture inserts, updates, and deletes. Then create a table called SALES_AUDIT_LOG and a Task that runs every minute, checks if the stream has data, and inserts changed rows into the audit log with the action type (INSERT, UPDATE, DELETE), sale_id, sale_date, customer_id, product_id, and net_revenue.
```

```
Create a Python UDF called UDF_MARGIN_HEALTH_LABEL that takes a float margin_pct as input and returns: 'EXCELLENT' for >= 40%, 'HEALTHY' for >= 25%, 'MARGINAL' for >= 10%, 'AT RISK' for below 10%, and 'UNKNOWN' for null. Then write a query that uses this UDF to label every product-category and customer-segment combination by margin health, based on the last 90 days of sales.
```

---

## Module 5 — Build a Streamlit Dashboard (8 min)

**Goal:** Deploy a production-ready, multi-tab sales and inventory dashboard directly in Snowsight — in under 10 minutes, with no front-end development.

### Step 5.1 — Open Streamlit in Snowsight

1. In the left nav, click **Projects → Streamlit**
2. Click **+ Streamlit App**
3. Name it: `LOL_SALES_DASHBOARD`
4. Set database to `LOL_CORTEX_LAB`, schema to `SALES_DATA`
5. Click **Create** — a blank editor opens

### Step 5.2 — Build the Full Dashboard

Open Cortex Code and enter:

```
Build a complete Streamlit in Snowflake app for LOL_CORTEX_LAB.SALES_DATA. Connect using get_active_session().

Structure it with 5 tabs:

Tab 1 - Sales Overview: A KPI row at the top (total net revenue, gross profit, average margin %, active customers). Below that, a monthly revenue trend area chart split by product category (Dairy, Crop Inputs, Animal Nutrition) using Land O'Lakes yellow (#F5A623) for Dairy. Below that, a horizontal bar chart of top 10 products by net revenue.

Tab 2 - Customer Analytics: Top 15 customers by net revenue as a horizontal bar chart colored by customer type. A sunburst chart showing revenue breakdown by customer type then segment.

Tab 3 - Inventory Status: A donut pie chart showing count of product-warehouse combinations by alert level (OUT OF STOCK, REORDER NOW, LOW STOCK, OK). A table of all products currently in REORDER NOW or OUT OF STOCK status from V_INVENTORY_CURRENT with color-coded rows.

Tab 4 - Campaign Performance: A scatter plot of actual spend vs revenue generated for each campaign, sized by budget. A summary table showing campaign name, type, budget, spend, revenue generated, and ROI %.

Tab 5 - Market Intelligence: A line chart of daily commodity prices for a user-selected commodity from MARKET_PRICES. Four KPI tiles showing current price, 90-day average, period high, and period low.

Add a sidebar with: date range filter (Last 30/90 days, Last 6 months, Last 12 months, All time), product category multi-select, and customer region multi-select. Apply these filters to all Sales and Customer tabs.

Write the complete app and deploy it.
```

### Step 5.3 — Run and Iterate

Click **Run** in the top right. Once it loads, try these enhancement prompts:

```
Add a "Download as CSV" button below each data table in the app.
```

```
On the Inventory Status tab, add a bar chart showing the count of alert-level items by warehouse so we can see which distribution centers have the most stockout risk.
```

```
Add a short explanatory caption below each chart explaining what a business user should look for.
```

---

## Module 6 — AI Analytics Layer: Semantic Views & Snowflake Intelligence (14 min)

**Goal:** Package everything you've built into a reusable intelligence layer — a Snowflake Semantic View that encodes your business definitions, and a Cortex Agent that any member of your organization can query in plain English through Snowflake Intelligence.

This is the shift from "I ran some queries" to "I built something my entire organization can use."

---

### Step 6.1 — Create the Semantic View (6 min)

A Semantic View is a business model stored as a first-class Snowflake object. It defines how tables join, what the metrics mean, and which verified questions it can reliably answer. Cortex Analyst reads it to generate trusted SQL from natural language — so every analyst, product owner, and exec works from the same definitions.

```
Using the context from these tables:
#LOL_CORTEX_LAB.SALES_DATA.SALES
#LOL_CORTEX_LAB.SALES_DATA.PRODUCTS
#LOL_CORTEX_LAB.SALES_DATA.CUSTOMERS
#LOL_CORTEX_LAB.SALES_DATA.WAREHOUSES
#LOL_CORTEX_LAB.SALES_DATA.CAMPAIGNS
#LOL_CORTEX_LAB.SALES_DATA.INVENTORY
#LOL_CORTEX_LAB.SALES_DATA.MARKET_PRICES

Create a semantic view called LOL_ANALYTICS_VIEW in LOL_CORTEX_LAB.SALES_DATA.

Define these relationships:
- SALES joins PRODUCTS on product_id
- SALES joins CUSTOMERS on customer_id
- SALES joins WAREHOUSES on warehouse_id
- SALES joins CAMPAIGNS on campaign_id
- INVENTORY joins PRODUCTS on product_id
- INVENTORY joins WAREHOUSES on warehouse_id

Include dimensions for: category, brand, sub_category (from products); customer_type, segment, region, account_manager (from customers); warehouse region and state (from warehouses); campaign_name and campaign_type (from campaigns); channel and sale_date (from sales); commodity (from market_prices).

Include metrics for: total net revenue (SUM of net_revenue), total gross profit (SUM of gross_profit), gross margin percentage (gross_profit / net_revenue * 100), total units sold (SUM of quantity), average discount percentage (AVG of discount_pct), transaction count (COUNT DISTINCT of sale_id), units on hand (SUM of units_on_hand from inventory), days of supply (AVG of days_of_supply from inventory), and commodity spot price (AVG of price_per_unit from market_prices).

Include verified queries for:
1. Total net revenue by product category this quarter
2. Top 10 customers by gross profit margin in the last 90 days
3. Year-over-year dairy sales comparison by month
4. Campaign ROI ranking — revenue generated per dollar of spend
5. Products below reorder point that need immediate restocking
6. Butter market price trend versus Land O'Lakes butter net revenue by week
7. Customers to target for a dairy promotion based on recent purchase frequency and margin
8. Inventory projection for butter products — days of supply based on recent consumption

Write the complete CREATE SEMANTIC VIEW statement and run it.
```

> **Checkpoint:** Confirm the view was created:
> ```sql
> SHOW SEMANTIC VIEWS IN SCHEMA LOL_CORTEX_LAB.SALES_DATA;
> ```

---

### Step 6.2 — Create the Analytics Agent (4 min)

Now create a Cortex Agent backed by that semantic view. This is what surfaces in Snowflake Intelligence for your business users.

```
Create a Cortex Agent called LOL_ANALYTICS_AGENT in LOL_CORTEX_LAB.SALES_DATA using warehouse LOL_LAB_WH.

Configure it with a Cortex Analyst tool that uses the semantic view LOL_CORTEX_LAB.SALES_DATA.LOL_ANALYTICS_VIEW.

Give it these system instructions:
"You are an analytics assistant for Land O'Lakes, a farmer-owned cooperative with product lines in dairy (Land O Lakes brand), crop inputs (WinField United), and animal nutrition (Purina). Answer questions about sales performance, product margins, customer accounts, inventory health, campaign ROI, market commodity pricing, and demand forecasting. Be concise and data-driven. When asked for projections, explain your methodology. Always cite specific products, customers, or regions when relevant."

Write and run the CREATE AGENT statement. Then grant USAGE on the agent to role SYSADMIN.
```

> **Checkpoint:** Confirm the agent exists:
> ```sql
> SHOW AGENTS IN SCHEMA LOL_CORTEX_LAB.SALES_DATA;
> ```

---

### Step 6.3 — Chat with the Agent (8 min)

Open **Snowflake Intelligence** — click the **Intelligence** icon in the left navigation bar (brain/sparkle icon). Find **LOL_ANALYTICS_AGENT** and start a new conversation.

---

**Sales Data Questions**

```
What were our total sales by product category last quarter? Compare to the same quarter last year and show the growth rate.
```

```
Which account managers are driving the highest gross margin on their accounts? Show their top 2 customers by profitability.
```

```
Show me month-over-month dairy revenue for the past 12 months. Flag any month with a greater than 10% decline.
```

---

**Marketing & Campaign Targeting**

```
Which marketing campaigns delivered the highest ROI? Which ones came in below their revenue target and by how much?
```

```
Which customers in the Midwest have the highest dairy purchase frequency and should be the first calls for our next butter promotion?
```

```
Identify customers who have not purchased Crop Inputs in the last 60 days but bought them during the same period last year. These are reactivation targets for the spring planting season.
```

```
What is the revenue difference between customers that were part of a campaign versus those that were not?
```

---

**Market Comparison**

```
How do CME butter spot prices compare to our average butter selling price over the last 6 months? Are we expanding or compressing our spread?
```

```
Show me the correlation between corn commodity prices and WinField United seed sales volumes. Does a spike in corn prices drive more or fewer seed purchases?
```

---

**Inventory Projections & Actions**

```
Which butter products are projected to run out of stock within the next 30 days based on current consumption rates? How many units do we need to order and from which warehouses?
```

```
If our dairy sales grow 15% next quarter due to the holiday season, which warehouses would hit stockout first? What reorder quantities would keep us at a 45-day buffer?
```

```
Rank all warehouses by current inventory risk — factoring in days of supply, products below reorder point, and recent sales velocity. What actions should we take this week?
```

```
What is the total estimated cost to bring all products currently below their reorder point back up to a 60-day supply across all warehouses?
```

---

---

## Wrap-Up

### What You Built in 90 Minutes

| Module | What Happened |
|--------|---------------|
| 1 | Explored an 8-table database and characterized the entire customer and product portfolio without writing SQL |
| 2 | Ran YoY revenue trends, margin analysis, campaign ROI, and declining product detection via natural language |
| 3 | Audited data quality across all tables, fixed real issues, and created a live monitoring view |
| 4 | Built Dynamic Tables, a Stored Procedure, a Task, a CDC Stream, and a Python UDF — a full automated pipeline |
| 5 | Deployed a production-ready 5-tab Streamlit dashboard with charts and sidebar filters |
| 6 | Created a Semantic View, deployed a Cortex Agent, and answered 12+ business questions through Snowflake Intelligence |

### What This Means for Your Team

| Persona | Old World | With Cortex Code |
|---------|-----------|-----------------|
| **Analysts** | Wait for data team to write queries, work with stale exports | Self-service analytics on live data, no bottleneck |
| **Data Engineers** | Write and maintain ETL scripts, schedule jobs manually | Dynamic Tables + Tasks + Cortex Code — pipeline in minutes |
| **Business Users** | Request reports, get them 2 weeks later | Ask the agent in plain English, get verified answers instantly |
| **Sales & Marketing** | Pull campaign reports quarterly | Live ROI tracking and targeting lists on demand |
| **Operations / Supply Chain** | Manual reorder spreadsheets | Automated alerts, projections, and action recommendations |

### Key Prompting Tips to Take Home

1. **Reference tables directly.** Use `#DATABASE.SCHEMA.TABLE` to give Cortex Code your schema — it writes dramatically more accurate queries when it knows your columns.
2. **Be specific about what you want.** "Show revenue by category" gets a table. "Show monthly revenue by category with YoY change, flag declines over 10%" gets something actionable.
3. **Iterate.** Your first prompt doesn't have to be perfect. Say "add a filter by region" or "make the chart a bar chart" and it keeps going.
4. **Ask why, not just what.** "Why is this product's margin declining?" and "What's causing these null values?" are just as valid as reporting questions.
5. **Trust but verify.** Cortex Code is very good — but always review generated SQL for large UPDATE, DELETE, or CREATE operations before running.

### Next Steps

- [ ] Request Cortex Code access for your team in your production Snowflake account
- [ ] Identify 3 manual reporting processes that could be self-served with Cortex Code
- [ ] Identify the 2–3 key business metrics worth encoding in a Semantic View as your source of truth
- [ ] Book a follow-up with your Snowflake SE to scope a production Streamlit or Intelligence rollout
- [ ] Run `cleanup.sql` to remove lab objects from your account

---

*Lab prepared by Snowflake Solutions Engineering | Land O'Lakes Account Team*
*Questions? Contact your SE: Pravin Rao*
