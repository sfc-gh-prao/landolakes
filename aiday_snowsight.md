# Land O'Lakes × Snowflake — AI Day Demo Script
## Cortex Code in Snowsight + Cortex Code Desktop

**Audience:** Mixed technical and non-technical — analysts, data engineers, operations, marketing, leadership
**Duration:** ~45 minutes (adjustable — cut Optimization or Desktop sections if running long)
**Format:** Presenter-led live demo
**Prereqs:** Run `setup.sql` completely before the session. Confirm `SHOW SEMANTIC VIEWS` and `SHOW AGENTS` return results.

---

## Pre-Demo Checklist

- [ ] Run `setup.sql` — confirm all 8 tables populate (validation query at the end)
- [ ] Run `semantic_view.sql` — confirm `LOL_AIDAY_VIEW` appears in `SHOW SEMANTIC VIEWS`
- [ ] Run `agent.sql` — confirm `LOL_AIDAY_AGENT` appears in `SHOW AGENTS`
- [ ] Open `streamlit_app.py` in a Snowsight Streamlit app (LOL_AIDAY_DASHBOARD)
- [ ] Pre-open browser tabs: Snowsight workspace, Snowflake Intelligence, Streamlit app
- [ ] Have `broken_query.sql` and `slow_query.sql` open in workspace files, ready to run
- [ ] Confirm Cortex Code is accessible (`SELECT SYSTEM$CORTEX_ENABLED_FOR_CURRENT_ACCOUNT()`)

---

## Opening (3 min)

> **Say this before touching the keyboard.**

"Before we get into it — think about the last time someone on your team needed a data answer. Maybe a supply question. A sales number for a Monday meeting. A question about which customers to call for the next butter promo.

What happened? Someone probably sent a message to the data team. A ticket got opened. Two or three days later, an answer came back — maybe as a spreadsheet, maybe as a dashboard that was already a week stale. And by then, the meeting had already happened.

That latency between question and answer — that's the problem we're solving today. Not with a new platform, not with a migration project. With Cortex Code, Snowflake's AI assistant that lives directly in the browser you're already using.

In the next 45 minutes, you're going to see how we go from raw data to natural language answers, automated pipelines, a live dashboard, and an intelligent agent your whole organization can use — all from one prompt at a time."

---

## Module 1 — Setup & Context (3 min)

> Open a Cortex Code session in Snowsight (Projects > Workspaces > + Cortex Code)

### Set Context

**TYPE INTO COCO:**
```
Set my context to use the LOL_AIDAY database, SALES_DATA schema,
and LOL_AIDAY_WH warehouse for this session.
```

> While it runs:

"This just tells Cortex Code where to work — which database and compute warehouse. You do this once at the start of a session. From here on, every query runs against Land O'Lakes data."

### Explore the Data Model

**TYPE INTO COCO:**
```
What tables exist in the LOL_AIDAY.SALES_DATA schema? Give me a
one-sentence description of each table and show how many rows are in each one.
```

> While it runs:

"Cortex Code is querying the information schema, counting rows in every table, and writing a description of each one. That's 8 separate queries synthesized into a single readable summary. If a new analyst joined your team today and you asked them to do this — how long would it take? Maybe a day. This took 4 seconds."

> When results appear, walk through the tables briefly:

"Sales transactions across 480 days — dairy, WinField crop inputs, Purina animal nutrition. Weekly inventory snapshots. Daily commodity prices from CME and CBOT. This is a realistic representation of your operational data world."

---

## Module 2 — Natural Language Analytics (10 min)

> **Framing:** "Each of these prompts represents a query that would take a skilled analyst 30 to 60 minutes to write from scratch. Most of your team couldn't write them at all."

### 2.1 Revenue by Category with YoY

**TYPE INTO COCO:**
```
Show me total net revenue and gross profit by product category for each month
of 2025. Add a column showing the year-over-year percentage change compared
to the same month in 2024. Use #LOL_AIDAY.SALES_DATA.SALES
and #LOL_AIDAY.SALES_DATA.PRODUCTS
```

> While it runs:

"The # syntax injects the table's actual schema — column names and sample data — into the prompt. Cortex Code now knows the exact column names. That's why it writes accurate queries instead of guessing."

> When results appear:

"Look at the pattern. Dairy spikes in November through January — holiday baking season. Crop inputs peak in March through May — spring planting. That seasonality is baked into this data. Your leadership team can see it in 10 seconds, not 10 days."

---

### 2.2 Top Customers by Gross Profit

**TYPE INTO COCO:**
```
Which 10 customers generated the most gross profit in the last 90 days?
Include their customer type, region, account manager, and gross margin percentage.
Sort by gross profit descending. #LOL_AIDAY.SALES_DATA.SALES
#LOL_AIDAY.SALES_DATA.CUSTOMERS
```

> When results appear:

"Two things to call out. First — Cortex Code correctly joined SALES to CUSTOMERS to get customer type and region. It understood those columns live in a different table and handled it automatically. Second — the gross margin calculation uses NULLIF to protect against division by zero. That's a production-quality query, not a quick hack."

---

### 2.3 Campaign ROI Analysis

**TYPE INTO COCO:**
```
Show me total net revenue and number of transactions for each marketing campaign.
Include the campaign budget, actual spend, and calculate ROI as revenue divided by
actual spend. Flag any campaign where actual revenue came in below 80% of the
target. Sort by ROI descending. #LOL_AIDAY.SALES_DATA.SALES
#LOL_AIDAY.SALES_DATA.CAMPAIGNS
```

> When results appear:

"Notice the flag column — 'below 80% of target' became a CASE WHEN column. You gave it a business rule in plain English and it encoded it into SQL. Your marketing team can now answer the question 'which campaigns underperformed' in a single prompt, without any SQL knowledge."

---

### 2.4 Seasonal Dairy Analysis

**TYPE INTO COCO:**
```
Show the average weekly net revenue for Dairy products broken out by month of year.
I want to see which months are strongest — highlight any month where Dairy revenue
is more than 20% above the annual average.
#LOL_AIDAY.SALES_DATA.SALES #LOL_AIDAY.SALES_DATA.PRODUCTS
```

> When results appear:

"Watch what Cortex Code does with 'highlight' — it adds a calculated flag column. You didn't say 'add a CASE WHEN column.' You said 'highlight.' It translated your intent into the right SQL construct. That's the thing to watch throughout this demo."

---

## Module 3 — Query Troubleshooting (5 min)

> **Framing:** "Here's a scenario that happens all the time. Someone hands you a query — maybe it was written by someone who left the team, maybe it came from a colleague. You run it. It fails. Here's how Cortex Code handles that."

> Open `broken_query.sql` in a workspace file. Run it.

> It will fail with errors about column `revenue` not found.

"I just ran this campaign ROI query and got errors. Rather than digging through the SQL myself, I'm going to let Cortex Code diagnose it."

**TYPE INTO COCO:**
```
I got SQL errors on this query. Can you identify and fix all the bugs?
Here is the schema context: #LOL_AIDAY.SALES_DATA.SALES
#LOL_AIDAY.SALES_DATA.CAMPAIGNS
[paste or reference the broken query]
```

> While CoCo runs:

"It's reading the query, reading the actual schema, and comparing what the query references against what actually exists in the table."

> When CoCo responds, call out the bugs it found:

"Three bugs in this query. First — it referenced a column called `revenue` that doesn't exist. The actual column is `net_revenue`. Second — it tried to use a SELECT alias `roi_pct` inside the same SELECT list — SQL doesn't allow that. Third — it was dividing by `actual_spend` without protecting against NULL or zero. CoCo found all three and fixed them. Copy the fixed query, run it, and it works."

> **What to highlight:** "This is 5 minutes instead of 45. More importantly — someone who has never written SQL before could hand this query to Cortex Code and get a working version back."

---

## Module 4 — Query Optimization (5 min)

> **Framing (for technical audience):** "Now something for the data engineers and analysts. This query works — it returns correct results — but it's written in a way that causes Snowflake to do far more work than necessary."

> Open `slow_query.sql`. Run it (it will take noticeably longer than the previous queries).

"This query resolves customer name, product name, and monthly totals by running a separate sub-query for every single row in the SALES table. On 17,000 rows, that's 34,000 extra full table scans. It works. It's just brutally inefficient."

**TYPE INTO COCO:**
```
This query runs very slowly on our SALES table (~17,000 rows).
Rewrite it to maximize performance — eliminate all correlated subqueries,
replace them with proper JOINs and window functions, and make sure
Snowflake can apply any available partition pruning.
Show me the before-and-after and explain the key changes.
#LOL_AIDAY.SALES_DATA.SALES
#LOL_AIDAY.SALES_DATA.CUSTOMERS
#LOL_AIDAY.SALES_DATA.PRODUCTS
```


> When results appear:

"The rewrite does three things: it replaces all the correlated subqueries with proper JOINs — so each lookup table is joined once instead of queried once per row. It pre-computes the monthly totals and customer averages in CTEs so they're calculated once, not 17,000 times. And it removes the YEAR() and MONTH() wrapping that was preventing Snowflake from pruning partitions.

For technical folks in the room — that's the difference between O(n²) and O(n log n) at a basic level. Cortex Code explains the changes, not just produces them. That's useful for teaching as much as for fixing."

---

## Module 5 — Semantic View (5 min)

> **Framing:** "Everything we've done so far has been ad-hoc — query by query. What the Semantic View does is encode your business definitions — how tables relate, what 'gross margin' means, which questions have verified SQL answers — into a Snowflake object that anyone can query through. This is the difference between 'I ran some queries' and 'I built something my entire organization can use.'"

**TYPE INTO COCO:**
```
Using the context from these tables:
#LOL_AIDAY.SALES_DATA.SALES
#LOL_AIDAY.SALES_DATA.PRODUCTS
#LOL_AIDAY.SALES_DATA.CUSTOMERS
#LOL_AIDAY.SALES_DATA.WAREHOUSES
#LOL_AIDAY.SALES_DATA.CAMPAIGNS
#LOL_AIDAY.SALES_DATA.INVENTORY
#LOL_AIDAY.SALES_DATA.MARKET_PRICES

Create a semantic view called LOL_AIDAY_VIEW in LOL_AIDAY.SALES_DATA.
Define relationships for SALES joining to PRODUCTS, CUSTOMERS, WAREHOUSES,
and CAMPAIGNS, and INVENTORY joining to PRODUCTS and WAREHOUSES.
Include dimensions for product category, brand, sub-category; customer type,
segment, region, account manager; warehouse region and state; campaign name
and type; channel; and commodity.
Include metrics for total net revenue, total gross profit, gross margin
percentage, total units sold, average discount, transaction count, units on
hand, days of supply, and commodity spot price.
Include 18 verified queries covering: revenue by category, top customers by
margin, YoY dairy comparison, campaign ROI, reorder alerts, butter vs CME
spot price, dairy promo targeting, inventory projections, MoM trends, account
manager performance, warehouse stockout risk, seasonal patterns, declining
products, channel comparison, crop inputs vs commodity prices, reactivation
targets, campaign attribution, and butter price trend.
Write and run the CREATE SEMANTIC VIEW statement.
```

> While it runs (30-60 seconds):

"Cortex Code is building the entire data model — relationships, dimension definitions, metric formulas with synonyms, and 18 pre-tested SQL queries — in a single CREATE statement. What normally takes days of semantic layer configuration work is done in under a minute."

> When complete:

"Run `SHOW SEMANTIC VIEWS IN SCHEMA LOL_AIDAY.SALES_DATA;` — you'll see LOL_AIDAY_VIEW as a first-class Snowflake object. This is your business model, stored in Snowflake, queryable, shareable, and governed with RBAC just like any table."

---

## Module 6 — Cortex Agent Creation (2 min)

**TYPE INTO COCO:**
```
Create a Cortex Agent called LOL_AIDAY_AGENT in LOL_AIDAY.SALES_DATA
using warehouse LOL_AIDAY_WH.
Configure it with a Cortex Analyst tool that uses the semantic view
LOL_AIDAY.SALES_DATA.LOL_AIDAY_VIEW.
Give it a system prompt that establishes it as a Land O'Lakes analytics
assistant covering dairy, WinField crop inputs, and Purina animal nutrition —
concise, data-driven, cites specific products and regions.
Write and run the CREATE AGENT statement, then grant USAGE to PUBLIC.
```

"The agent has one tool: Cortex Analyst backed by your semantic view. When someone asks it a question, it routes through the semantic view to generate verified SQL, executes it, and returns a natural language answer backed by your data. No hallucination. No guessing on the 18 verified queries."

---

## Module 7 — Snowflake Intelligence (CoWork) Demo (8 min)

> **Transition:** Open Snowflake Intelligence — click the brain/sparkle icon in the left nav. Find `LOL_AIDAY_AGENT`. Start a new conversation.

"Now for the payoff. Your VP of Sales, your cooperative account managers, your supply chain team — none of them need to know what a JOIN is. They open Snowflake Intelligence, find this agent, and ask in plain English."

### Opener — strong first impression:
**PROMPT:**
```
What were our total sales by product category last quarter?
Compare to the same quarter last year and show the growth rate.
```

> "The agent doesn't just return a table. It tells you what the data says in plain English, then shows you the SQL it ran. That's transparency — anyone can verify the methodology."

---

### Campaign ROI — for marketing audience:
**PROMPT:**
```
Which marketing campaigns delivered the highest ROI?
Which ones came in below their revenue target and by how much?
```

---

### Reactivation targeting — high demo impact:
**PROMPT:**
```
Identify customers who have not purchased Crop Inputs in the last 60 days
but bought them during the same period last year.
These are reactivation targets for the spring planting season.
```

> "A query your best analyst would take two hours to write. The agent does it in 10 seconds. Your account managers can now identify their own reactivation targets, on their own schedule, without waiting for a list from the data team."

---

### Commodity market intelligence:
**PROMPT:**
```
How do CME butter spot prices compare to our average butter selling price
over the last 6 months? Are we expanding or compressing our spread?
```

> "This is a procurement and pricing strategy question that usually requires multiple data sources and manual assembly. Here it's one sentence."

---

### Inventory projection — most impressive:
**PROMPT:**
```
Which butter products are projected to run out of stock within the next 30 days
based on current consumption rates? How many units do we need to order
and from which warehouses?
```

> "This is where it shifts from reporting to decision support. The agent isn't just showing data — it's recommending actions. 'Order X units at warehouse Y.' That's a supply chain planning answer your operations team would normally need a full analysis for."

---

## Module 8 — Streamlit Dashboard with Embedded Agent (5 min)

> **Transition to pre-built app:** Navigate to Projects > Streamlit > LOL_AIDAY_DASHBOARD.

"Everything we've built feeds into this dashboard. Sales overview, inventory alerts, campaign performance — connected to live data. And Tab 4 is the embedded agent. Your business users open this app and get both the charts and a conversational interface in one place."

> Click through each tab briefly. On Tab 4 — Ask the Agent, type:

```
Which customers should be our first calls for the next butter promotion?
```

> "This is Cortex Code Snowsight's answer to business intelligence: a single app that combines a traditional dashboard with a natural language interface to your data. Built and deployed without leaving Snowflake."

---

> **OPTIONAL — build the app live (if time allows):**

> Open a blank Streamlit app in Snowsight. Open Cortex Code. Type:

```
Build a complete Streamlit in Snowflake app for LOL_AIDAY.SALES_DATA
using get_active_session(). Include 4 tabs: Sales Overview (KPIs +
monthly trend by category + top 10 products), Inventory Alerts (donut
chart by stock status + alert table), Campaign Performance (scatter
of spend vs revenue + summary table), and Ask the Agent (chat interface
calling LOL_AIDAY.SALES_DATA.LOL_AIDAY_AGENT).
Add sidebar filters for date range, category, and region.
Write the complete app.
```

> "One prompt. A complete multi-tab production dashboard. Deploy it, and everyone in your organization with access to this Snowflake account can use it immediately — no Docker, no Kubernetes, no deployment pipeline."

---

## Transition to Desktop (2 min)

"What we've done so far — all of this — runs entirely in the browser. No local install. That's Cortex Code in Snowsight, and it's a massive step forward for your analysts and business users.

But I know Land O'Lakes has a lot of Excel users. Account managers, ops leads, sales coordinators — they live in spreadsheets. Before I show you Cortex Code Desktop, I want to start with something that will land for that audience specifically.

The Desktop section opens with a real Excel file — four sheets, 28 accounts, 12 campaigns, 18 reorder alerts, a manually compiled exec summary that's always 3-5 days stale. We're going to drop it into Desktop CoCo and watch it read the whole thing, surface the risks, generate the SQL to load it into Snowflake, and tell us exactly which parts of the spreadsheet should never be manually maintained again.

That's the conversation: not 'should we replace Excel' — it's 'what in this spreadsheet is already live in Snowflake and your team just doesn't know it yet.'"

> Transition to `desktop_demo.md` for the Desktop segment. Start with PROMPT 0 (Excel file ingestion).

---

## Wrap-Up (3 min)

"Let's recap what just happened in under 45 minutes.

You saw natural language analytics — complex YoY comparisons, margin analysis, campaign targeting lists — in seconds. You saw live query debugging and optimization. You saw a complete semantic layer built from one prompt. An intelligent agent deployed. And a production-ready dashboard.

The question I want to leave you with is: what's on your team's backlog right now that this could address? Not someday. Right now. What reports are sitting in a ticket queue? What supply questions are going unanswered? What decisions are being made without data because it's too hard to get to?

Your data is already in Snowflake. The intelligence layer is already built. The barrier was always the translation between question and answer. Today you saw what it looks like when that barrier is gone."

---

## Persona Notes

| Audience | Highest-impact moment | Key message |
|----------|----------------------|-------------|
| Business Analysts | Module 2 analytics prompts + Module 7 agent | "Answer your own questions, on your own schedule" |
| Data Engineers | Module 4 optimization + Module 5 semantic view | "Eliminates the toil — you focus on architecture" |
| Sales & Marketing | Module 7 reactivation targeting prompt | "Account managers self-serve their own prospect lists" |
| Operations / Supply Chain | Module 7 inventory projection prompt | "Decision support, not just reporting" |
| Leadership | Module 8 dashboard + agent | "One app, every question, no data team bottleneck" |

---

## Quick Troubleshooting

| Issue | Fix |
|-------|-----|
| Cortex Code not responding | `ALTER WAREHOUSE LOL_AIDAY_WH RESUME;` then reload tab |
| Setup.sql failed partway | Run `DROP DATABASE IF EXISTS LOL_AIDAY CASCADE;` then re-run setup.sql from top |
| Semantic view CREATE errors | Paste the error back into CoCo: "I got this error, fix the column reference" |
| Streamlit app Python error | Paste error into CoCo: "I got this error. Fix it." |
| Agent not found in Intelligence | Confirm `SHOW AGENTS IN SCHEMA LOL_AIDAY.SALES_DATA;` returns the agent; check USAGE grant |
| Dynamic Table shows no data | `ALTER DYNAMIC TABLE ... REFRESH;` or wait for the lag to trigger |

---

*Prepared by Pravin Rao | Snowflake Solutions Engineering | Land O'Lakes Account Team*
