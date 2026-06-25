# SAP ABAP Employee Data Report

A self-learning SAP ABAP project demonstrating core enterprise development concepts including ALV Reports, Open SQL, and CDS Views on SAP HANA.

---

## Project Overview

This project was built as part of my SAP ABAP learning journey using the SAP BTP Trial environment. It covers the fundamental building blocks of ABAP development used in real enterprise projects.

---

## Features

- **ALV Grid Report** — Displays employee data in an interactive, sortable grid with column headers
- **Open SQL Queries** — Fetches data from SAP HR table `PA0001` using HANA-optimized SELECT statements
- **Selection Screen** — Filter by Personnel Area, Position, and Date
- **CDS View** — Core Data Services view definition for employee basic data
- **ABAP OO Concepts** — Modular code using FORM routines and TYPE declarations

---

## Tech Stack

| Technology | Usage |
|---|---|
| SAP ABAP | Core programming language |
| SAP HANA | Database layer (Open SQL) |
| ALV Grid (`REUSE_ALV_GRID_DISPLAY`) | Report display |
| CDS Views | Data modeling layer |
| SAP NetWeaver / BTP Trial | Development environment |

---

## Files

```
sap-abap-learning/
│
├── ZVK_EMPLOYEE_REPORT.abap        # Main ABAP report program
├── ZVK_EMPLOYEE_CDS.ddls.asddls   # CDS View definition
└── README.md
```

---

## How It Works

### 1. Selection Screen
User enters filter criteria:
- Personnel Area (`WERKS`)
- Position (`PLANS`)
- Key Date (defaults to today)

### 2. Data Fetch (Open SQL)
```abap
SELECT pernr ename plans orgtx werks begda
  FROM pa0001
  INTO CORRESPONDING FIELDS OF TABLE lt_employee
  WHERE werks IN s_werks
    AND plans IN s_plans
    AND begda LE p_date
    AND endda GE p_date.
```
This query is optimized for SAP HANA — fetches only required columns (no `SELECT *`), uses date range filtering to get active records only.

### 3. ALV Display
Data is displayed using `REUSE_ALV_GRID_DISPLAY` with:
- Custom field catalog (column labels, positions)
- Zebra striping for readability
- Auto column width optimization
- Sort/filter/export options built-in

### 4. CDS View
A separate CDS View (`ZVK_EMPLOYEE_CDS`) is defined for the data model layer — this is the modern SAP HANA approach to data access, separating business logic from data retrieval.

---

## Key Concepts Demonstrated

| Concept | Where Used |
|---|---|
| `TYPE` declarations | Internal table and work area definition |
| `SELECT-OPTIONS` | Dynamic filter on selection screen |
| Open SQL `SELECT` | HANA-optimized data fetch from PA0001 |
| `SORT` on internal table | Sorting by WERKS and PERNR |
| Field Catalog (`slis_fieldcat_alv`) | ALV column configuration |
| `REUSE_ALV_GRID_DISPLAY` | Standard ALV function module call |
| CDS View with `@AbapCatalog` annotations | Data modeling on HANA |
| Error handling with `sy-subrc` | Post-SELECT validation |

---

## What I Learned

- How SAP ABAP programs are structured (REPORT, TYPE, DATA, SELECTION-SCREEN, START-OF-SELECTION, FORM)
- Difference between Classic ABAP and ABAP for HANA (column-based DB, push-down queries)
- How ALV reports work and why they're the standard for SAP reporting
- CDS Views as the modern replacement for database views in SAP HANA
- How HR module table `PA0001` stores infotype 0001 (Organizational Assignment) data

---

## Environment

- **Platform:** SAP BTP Trial (Business Technology Platform)
- **System:** SAP S/4HANA Cloud ABAP Environment
- **Tools:** SAP Business Application Studio (BAS) / ABAP Development Tools (ADT)

---

## Author

**Kolluru Vignesh**
- Email: kolluruvignesh10@gmail.com
- LinkedIn: [linkedin.com/in/kolluruvignesh](https://linkedin.com/in/kolluruvignesh)
- Portfolio: [kolluruvignesh.dev](https://kolluruvignesh.dev)

---

*This project is part of my journey transitioning into SAP ABAP development. Open to feedback and suggestions from experienced ABAP developers.*
