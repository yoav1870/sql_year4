# Sales System (Backend + Frontend)

## Requirements

- Node.js 20+ (latest LTS recommended)
- MySQL 8.0
- Existing procedure: `p_insert_sales_from_json(IN p_json JSON)`
- Existing procedure: `sp_generate_random_data(IN p_sales_count INT)`
- Existing view: `view_total_sales_per_seller`
- Existing view: `view_seller_ranking`
- Existing view: `view_avg_sale_per_seller`

## Backend Setup

1. Install backend dependencies:

```bash
npm install
```

2. Create backend environment file:

```bash
cp .env.example .env
```

3. Update `.env` with your MySQL credentials.

## Backend Run

Development:

```bash
npm run dev
```

Production:

```bash
npm start
```

Server default URL:

`http://localhost:3000`

## Frontend Setup

1. Go to frontend directory:

```bash
cd frontend
```

2. Install frontend dependencies:

```bash
npm install
```

3. Create frontend environment file:

```bash
cp .env.example .env
```

4. Run frontend:

```bash
npm run dev
```

Frontend URL:

`http://localhost:5173`

## Backend Endpoints

- `GET /health`
- `GET /api/reports/total-sales`
- `GET /api/reports/ranking`
- `GET /api/reports/average-sales`
- `POST /api/random`
- `POST /api/sales/json`

## Example API Requests

`GET /api/reports/total-sales`

```bash
curl --location 'http://localhost:3000/api/reports/total-sales'
```

`GET /api/reports/ranking`

```bash
curl --location 'http://localhost:3000/api/reports/ranking'
```

`GET /api/reports/average-sales`

```bash
curl --location 'http://localhost:3000/api/reports/average-sales'
```

`POST /api/random`

```bash
curl --location 'http://localhost:3000/api/random' \
--header 'Content-Type: application/json' \
--data '{
  "count": 100
}'
```

`POST /api/sales/json`

```bash
curl --location 'http://localhost:3000/api/sales/json' \
--header 'Content-Type: application/json' \
--data '{
  "sales": {
    "CustomerFirstName": "John",
    "CustomerLastName": "Doe",
    "SellerID": 1,
    "purchases": [
      {
        "productId": 1,
        "quantity": 2,
        "saleDate": "2026-02-20"
      }
    ]
  }
}'
```

## Example Postman Body for `/api/sales/json`

```json
{
  "sales": {
    "CustomerFirstName": "John",
    "CustomerLastName": "Doe",
    "SellerID": 1,
    "purchases": [
      {
        "productId": 1,
        "quantity": 2,
        "saleDate": "2026-02-20"
      }
    ]
  }
}
```

## Response Format

```json
{
  "success": true,
  "data": {
    "inserted_rows": 1,
    "failed_rows": 0,
    "status": "SUCCESS",
    "failed_items": [],
    "completed_items": [
      {
        "productId": 1,
        "quantity": 2,
        "saleDate": "2026-02-20"
      }
    ]
  }
}
```
