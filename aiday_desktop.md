# Cortex Code Desktop — Demo Talk Track
## Land O'Lakes AI Day

**Duration:** ~8 minutes (can run standalone or as follow-on to the Snowsight segment)
**Setup:** Cortex Code Desktop open with `~/coco/lol-aiday/` as the working directory and an active Snowflake connection

---

## Opening — What Desktop Unlocks (2 min)

> **Say this as you open Desktop:**

"Everything you just saw in the browser — that's Cortex Code in Snowsight. It runs anywhere, requires zero install, and it's the right tool for analytics and pipeline work in Snowflake.

But Snowflake ships a second surface: Cortex Code Desktop. Same AI, completely different capability set. The browser version lives inside Snowflake. Desktop lives on your machine — and that changes what it can do."

### The Key Differences — Desktop vs. Snowsight

| Snowsight CoCo | Desktop CoCo |
|----------------|-------------|
| Browser-only, no local file access | Reads and edits your actual files and project directories |
| One file at a time in context | Entire folder/repo as context in a single prompt |
| No terminal access | Full terminal: `snow` CLI, `git`, `npm`, `pip`, shell scripts |
| Build one Snowflake object at a time | Build complete multi-file applications end-to-end |
| Paste schema via `#TABLE` syntax | Injects any file — CSVs, configs, `.env`, schemas — automatically |
| No iteration loop with local tools | Debug loop: run code, read errors, fix, repeat — autonomously |
| Can't deploy from Snowsight itself | Can scaffold, build, deploy, and verify in one session |
| No Excel/CSV file reading | Read Excel files, extract insights, generate SQL to load into Snowflake |

"The short version: Snowsight CoCo is your data analyst. Desktop CoCo is your data engineer and full-stack developer — with your entire project as context."

---

## Live Demo Prompts (8 min, includes Excel segment)

> Run these prompts live in Desktop CoCo. Each one should complete in under 2 minutes.
> Working directory: `~/coco/lol-aiday/`

---

### PROMPT 0 — Excel file ingestion (90 sec) ★ LEAD WITH THIS ★
**What to say:** "Land O'Lakes has a lot of Excel users. Your account managers, ops leads, and sales coordinators live in spreadsheets. Let me show you what Desktop CoCo can do with an Excel file."

> Have `LOL_Account_Review.xlsx` in the `~/coco/lol-aiday/` folder (it's already there).
> Drop the file into the Desktop CoCo chat, or reference it by path.

**TYPE INTO DESKTOP COCO:**
```
I just uploaded LOL_Account_Review.xlsx. This spreadsheet is maintained
manually by our Sales Operations team. It has 4 sheets:
- Territory Review: 28 accounts with YTD revenue, targets, and attainment
- Campaign Tracker: 12 campaigns with budget, spend, and ROI
- Reorder Log: products flagged for reorder at various distribution centers
- Exec Summary: manually compiled KPIs (updated weekly, always 3-5 days stale)

Please:
1. Read all 4 sheets and give me a summary of what you found — key insights,
   anything concerning, and any accounts or products that need attention
2. Identify which accounts are flagged as below plan or missing orders
3. Write a SQL script to create a new table called ACCOUNT_MANAGER_TARGETS
   in LOL_AIDAY.SALES_DATA and INSERT all 28 accounts from the Territory
   Review sheet with their YTD revenue, targets, and attainment percentages
4. Tell me what we could automate — which parts of this spreadsheet should
   never need to be updated manually again if we connected it to Snowflake
```

**What to highlight while CoCo reads and responds:**

"CoCo is reading all 4 sheets at once — 28 accounts, 12 campaigns, 18 reorder alerts, and a manually compiled executive summary. It's not just parsing cells — it's understanding what the data means.

Notice the note we put in Sheet 2: 'This file is not connected to Snowflake.' And the exec summary says it's always 3-5 business days stale because someone manually updates it every Monday morning from 4 different files.

That's the conversation Land O'Lakes should be having. Not 'can we replace Excel' — that's the wrong framing. It's: 'which parts of this never need to be manually updated again?'"

**After CoCo responds, call out:**
- Which accounts it flagged as at-risk (Wisconsin Dairy Coop, Dakota Growers, Meijer, Trader Joe's)
- The generated `CREATE TABLE` + `INSERT` statements it wrote from the spreadsheet data
- Its answer on what can be automated (territory review → live query from Snowflake, reorder log → already exists as `V_INVENTORY_CURRENT`, campaign tracker → live from `CAMPAIGNS` + `SALES`)

**Punchline:**
"The exec summary took someone half a day to build manually. What CoCo just showed us is that 3 of the 4 sheets are already in Snowflake — or could be — as live, always-current data. The fourth one, account targets, we just loaded in 30 seconds. The spreadsheet can retire."

---

### PROMPT 1 — Project orientation (30 sec)
**What to say:** "First thing I always do with Desktop — orient CoCo to the project."

**TYPE INTO DESKTOP COCO:**
```
What files are in my current project directory? Give me a one-sentence
summary of what each file does and how they relate to each other.
```

**What to highlight:** "CoCo reads the file tree, reads each file, and builds a mental model of the entire project. In Snowsight, you'd have to reference tables one at a time. Here it ingests the whole thing in one prompt."

---

### PROMPT 2 — Multi-file editing (45 sec)
**What to say:** "Now here's something Snowsight can't do at all — edit an existing deployed file."

**TYPE INTO DESKTOP COCO:**
```
Read my streamlit_app.py. Add a 'Download as CSV' button below every
data table in the app. Keep all existing functionality intact.
```

**What to highlight:** "CoCo reads the existing 500-line app, finds every `st.dataframe()` call, and adds the download button beside each one. No copy-paste, no hunting through the file. In Snowsight CoCo, you can only generate new code — you can't edit existing files you're working on locally."

---

### PROMPT 3 — Terminal access + Snowflake CLI (30 sec)
**What to say:** "Desktop has direct terminal access — including the `snow` CLI."

**TYPE INTO DESKTOP COCO:**
```
Run: snow sql -q "SHOW AGENTS IN SCHEMA LOL_AIDAY.SALES_DATA;" 
and tell me what agents exist and what tools they have configured.
```

**What to highlight:** "That command hits your Snowflake account directly through the CLI, returns live results, and CoCo interprets them — all without leaving the IDE. You can `snow sql`, `snow cortex`, `snow streamlit deploy`, `git push` — anything the shell can do, CoCo can orchestrate."

---

### PROMPT 4 — Cross-file analysis (45 sec)
**What to say:** "Here's the multi-file context that makes Desktop genuinely different."

**TYPE INTO DESKTOP COCO:**
```
Read broken_query.sql and slow_query.sql. For each one:
1. Identify every bug or performance issue
2. Write the fixed/optimized version
3. Save the results as fixed_query.sql and optimized_query.sql
```

**What to highlight:** "Two files, both analyzed, both fixed, two new files written — in one prompt. In Snowsight you'd have to open each file, copy-paste into CoCo, then copy the fix back. Here CoCo reads, reasons, writes, and saves without any manual handling."

---

### PROMPT 5 — Project documentation (45 sec)
**What to say:** "Desktop CoCo can read your entire project and generate documentation that's actually accurate."

**TYPE INTO DESKTOP COCO:**
```
Read every file in this directory. Write a README.md that explains:
- What this demo is and who it's for
- What each file does and in what order to use it
- How to set up and run the demo from scratch
- What prompts to use for each Snowsight and Desktop demo moment
Keep it concise — this is for the presenter, not the audience.
```

**What to highlight:** "A README that actually reflects the real files, in the right order, with accurate descriptions — because CoCo read all of them. This takes 5 minutes in Desktop. It takes an hour to write manually and it's usually wrong within a week."

---

### PROMPT 6 — App builder (the big one — 90 sec)
**What to say:** "The most powerful Desktop demo for a non-technical audience. I'm going to ask Desktop CoCo to build the entire Streamlit app from scratch — as if I'd never built it before."

> Open a new blank file in the editor. Then type:

**TYPE INTO DESKTOP COCO:**
```
Build a complete Streamlit in Snowflake app for LOL_AIDAY.SALES_DATA.
Connect using get_active_session(). Structure it with 4 tabs:

Tab 1 - Sales Overview: 4 KPI tiles (total net revenue, gross profit,
avg margin %, active customers). Monthly revenue line chart by product
category (Dairy in #F5A623 yellow). Top 10 products horizontal bar chart.

Tab 2 - Inventory Alerts: Donut chart of stock status distribution.
Color-coded table of all REORDER NOW + OUT OF STOCK items with
estimated reorder cost.

Tab 3 - Campaign Performance: Scatter chart of actual spend vs revenue
sized by budget. Summary table with ROI % and target performance flag.

Tab 4 - Ask the Agent: Chat interface using st.chat_input and
st.chat_message. Call LOL_AIDAY.SALES_DATA.LOL_AIDAY_AGENT via
SNOWFLAKE.CORTEX.AGENT_RUN. Maintain conversation history in
st.session_state.

Add sidebar with date range filter, category multi-select, and
region multi-select applied to all data tabs.

Save it as lol_dashboard_from_prompt.py.
```

**What to highlight:** "A complete 500-line production-quality Streamlit app — 4 tabs, sidebar filters, live Snowflake queries, embedded agent chat — from one prompt. In Snowsight CoCo you can build Streamlit apps too, but you do it in the Streamlit editor. Here Desktop CoCo builds the file directly to your local filesystem, so you can version-control it, collaborate on it, and deploy it with `snow streamlit deploy` — all from one place."

---

### PROMPT 7 — Deploy to Snowflake (30 sec, optional if time allows)
**What to say:** "And once the app is built, deploying it is one command."

**TYPE INTO DESKTOP COCO:**
```
Deploy lol_dashboard_from_prompt.py as a Streamlit app to Snowflake
using the snow CLI. Database: LOL_AIDAY, schema: SALES_DATA,
warehouse: LOL_AIDAY_WH. App name: LOL_AIDAY_DASHBOARD_2.
```

**What to highlight:** "CoCo runs `snow streamlit deploy` with the right flags. The app is live in Snowsight immediately. No manual steps, no Dockerfile, no CI/CD pipeline."

---

## Desktop-Only Capabilities — Summary Talking Points

Use any of these to answer "what else can Desktop do?":

**0. Read Excel and CSV files as context.**
Drop an Excel file — even a multi-sheet workbook — into Desktop CoCo and it reads every sheet, extracts the data, surfaces insights, and generates SQL to load it into Snowflake. This is the "we have a lot of Excel users" moment. The workflow: share the file → CoCo reads it → generates INSERT statements → data is in Snowflake → never touch the spreadsheet again.

**1. Edit existing codebases, not just generate new code.**
You can point Desktop CoCo at a 10,000-line Python repo and ask it to refactor a function, fix a bug, or add a feature. It reads the whole project first.

**2. Multi-step autonomous workflows.**
Ask CoCo to "set up the entire LOL demo from scratch" and it will: run setup.sql, validate row counts, run semantic_view.sql, run agent.sql, deploy the Streamlit app, and verify everything — without you touching anything.

**3. Iterative debug loop.**
When code fails, paste the error back into CoCo and it fixes it. It can also run the code itself and catch the error before you even see it.

**4. Local data as context.**
Point Desktop CoCo at a local CSV, an Excel file, a JSON config, or a `.env` file and it reads it as context. "Here's our product list — write me INSERT statements for it." That's not possible in Snowsight.

**5. Git integration.**
"Commit these changes with a message describing what changed" — Desktop CoCo can run `git add`, `git commit`, `git push` through the terminal.

**6. Complex app scaffolding.**
Not just Streamlit — Desktop CoCo can scaffold a full Next.js app, a FastAPI backend, a dbt project, or a Snowpark Python pipeline from a description.

---

## Closing Line

"Snowsight CoCo removes the bottleneck for data analysts and business users — the question-to-answer latency we talked about at the top. Desktop CoCo removes the bottleneck for developers and data engineers — the gap between an idea and a deployed, working application.

Together they cover every person in your data organization. That's the shift."

---

*Desktop demo prompts tested with Cortex Code Desktop — connection to Snowflake required. All prompts assume `~/coco/lol-aiday/` as the working directory.*
