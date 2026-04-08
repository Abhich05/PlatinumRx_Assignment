# PlatinumRx Data Analyst Assignment

## Folder Structure

```
Data_Analyst_Assignment/
├── SQL/
│   ├── 01_Hotel_Schema_Setup.sql   — CREATE TABLE + INSERT sample data (Hotel)
│   ├── 02_Hotel_Queries.sql        — Solutions for Part A, Questions 1–5
│   ├── 03_Clinic_Schema_Setup.sql  — CREATE TABLE + INSERT sample data (Clinic)
│   └── 04_Clinic_Queries.sql       — Solutions for Part B, Questions 1–5
├── Spreadsheets/
│   └── Ticket_Analysis.xlsx        — Four-sheet workbook (ticket, feedbacks, Analysis, Notes)
├── Python/
│   ├── 01_Time_Converter.py        — Minutes → "X hrs Y minutes" converter
│   └── 02_Remove_Duplicates.py     — Remove duplicate chars from a string using a loop
└── README.md
```

---

## Phase 1 — SQL

### Database: MySQL (compatible with PostgreSQL with minor date-function changes)

### Hotel System (Part A)

| Q  | Approach |
|----|----------|
| Q1 | `ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY booking_date DESC)` → pick rn=1 per user |
| Q2 | JOIN bookings → booking_commercials → items, filter `YEAR=2021 AND MONTH=11`, `SUM(qty*rate)` |
| Q3 | Same join, filter `MONTH=10`, `GROUP BY bill_id`, `HAVING SUM > 1000` |
| Q4 | Aggregate qty per (month, item), then `RANK()` ASC and DESC within month |
| Q5 | Aggregate bill per (user, month), `DENSE_RANK() DESC` per month, filter rank=2 |

### Clinic System (Part B)

| Q  | Approach |
|----|----------|
| Q1 | `GROUP BY sales_channel, SUM(amount)` filtered by year |
| Q2 | `GROUP BY uid, SUM(amount) DESC LIMIT 10` |
| Q3 | CTE for monthly revenue + monthly expense, LEFT JOIN, `profit = revenue − expense`, CASE for status |
| Q4 | Per-clinic revenue − expense per month, `RANK() DESC` within city, pick rank=1 |
| Q5 | Same, `DENSE_RANK() ASC` within state, pick rank=2 |

> To run against a different year/month, update the SET variables at the top of `04_Clinic_Queries.sql`.

---

## Phase 2 — Spreadsheet

**File:** `Ticket_Analysis.xlsx`

### Sheets

| Sheet | Purpose |
|-------|---------|
| `ticket` | Source ticket data (ticket_id, created_at, closed_at, outlet_id, cms_id) |
| `feedbacks` | Feedback data; col D (`ticket_created_at`) auto-populated via formula |
| `Analysis` | Helper columns (Same Day?, Same Hour?) + outlet-wise summary table |
| `Notes` | Full explanation of every formula used |

### Q1 — Populate `ticket_created_at`
```
=IFERROR(INDEX(ticket!$B:$B, MATCH(A2, ticket!$E:$E, 0)), "Not Found")
```
Uses INDEX/MATCH (preferred over VLOOKUP because `cms_id` is *not* the leftmost column in the ticket sheet).

### Q2 — Same-day and same-hour closure counts

**Same Day helper column:**
```
=IF(INT(created_at) = INT(closed_at), "Yes", "No")
```

**Same Hour helper column:**
```
=IF(AND(INT(created_at)=INT(closed_at), HOUR(created_at)=HOUR(closed_at)), "Yes", "No")
```

**Outlet summary (SUMPRODUCT):**
```
=SUMPRODUCT(($B$4:$B$11 = outlet_id) * ($G$4:$G$11))   -- same day count
=SUMPRODUCT(($B$4:$B$11 = outlet_id) * ($H$4:$H$11))   -- same hour count
```

---

## Phase 3 — Python

### 01_Time_Converter.py
```
hours            = total_minutes // 60
remaining_mins   = total_minutes %  60
output           = f"{hours} hrs {remaining_mins} minutes"
```
- Handles edge cases: 0 minutes, exact hours, negative input (raises ValueError).

### 02_Remove_Duplicates.py
```python
result = ""
for char in input_string:
    if char not in result:
        result += char
```
- Preserves first-occurrence order.
- Works for any character (letters, digits, symbols, spaces).

---

## Assumptions

- SQL scripts are written for **MySQL 8+**. For PostgreSQL, replace `YEAR(col)` / `MONTH(col)` with `EXTRACT(YEAR FROM col)` / `EXTRACT(MONTH FROM col)`.
- Sample data is illustrative — enough rows to test every query condition (bills > 1000, 2nd-highest bills, same-day closures, etc.).
- The `@year` and `@month` session variables in `04_Clinic_Queries.sql` act as query parameters; adjust as needed before running.
