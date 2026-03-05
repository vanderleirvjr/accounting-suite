# 💵 PayTracker — Pay Advice, Budget & Tax Server

A self-hosted Docker server for tracking pay stubs, taxes, deductions, and budgets.

---

## 🚀 Quick Start

### Requirements
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (Mac/Windows/Linux)

### Launch
```bash
cd payserver
docker compose up --build
```

Then open your browser to: **http://localhost:8000**

> On first run Docker will build the image (~2 min). Subsequent starts are instant.

---

## 🌐 Features

| Feature | Description |
|---|---|
| **Pay Advice Entry** | Full form with all your pay stub fields |
| **Live Calculation** | Net pay preview as you type |
| **Charts & Trends** | Gross vs net line chart, tax breakdown bar chart, pay breakdown donut |
| **Tax Year Summary** | Aggregate all stubs by year for W-2 cross-checking |
| **Budget Goals** | Set monthly spending targets and see them vs your net pay |
| **Export CSV / Excel** | Download all stubs or filter by year |
| **REST API** | Full JSON API for all data — see `/docs` |

---

## 📋 Fields Tracked

**Income:** Gross Pay

**Pre-Tax Deductions:** Dental, Medical, Retirement Plan, Parking Permit

**Taxes:** Federal Taxes, Medicare, Social Security, State Tax, FAMLI/PFML

**Post-Tax Deductions:** LTD, Vol AD&D, Basic Life Imputed Income, Imputed FAMLI EE, STD

**Miscellaneous:** Tuition Reimbursement

---

## 🔗 API Endpoints

| Method | URL | Description |
|---|---|---|
| GET | `/api/pay-advices/` | List all pay stubs (filter: `?year=2025`) |
| POST | `/api/pay-advices/` | Create new pay stub |
| GET | `/api/pay-advices/{id}` | Get single stub |
| PUT | `/api/pay-advices/{id}` | Update stub |
| DELETE | `/api/pay-advices/{id}` | Delete stub |
| GET | `/api/pay-advices/summary/{year}` | Year summary |
| GET | `/api/pay-advices/export/csv` | Export CSV |
| GET | `/api/pay-advices/export/excel` | Export Excel |
| GET | `/api/budget/` | List budget goals |
| POST | `/api/budget/` | Create goal |
| PUT | `/api/budget/{id}` | Update goal |
| DELETE | `/api/budget/{id}` | Delete goal |

Interactive API docs: **http://localhost:8000/docs**

---

## 💾 Data Persistence

Your data lives in a named Docker volume (`paytracker-pgdata`). It persists across restarts and rebuilds.

To back up your database:
```bash
docker exec paytracker-db pg_dump -U payuser paydb > backup.sql
```

To restore:
```bash
cat backup.sql | docker exec -i paytracker-db psql -U payuser paydb
```

---

## 🛑 Stop the Server
```bash
docker compose down
```

To also remove all data (⚠️ irreversible):
```bash
docker compose down -v
```
