# Hotfix Dashboard

A simple FastAPI + HTML dashboard for viewing mock hotfix data.

## Tech Used

- FastAPI
- Uvicorn
- HTML
- Inline CSS
- Inline JavaScript with `fetch()`

## Project Structure

```txt
project/
├── app.py
├── index.html
├── mock-data.json
├── requirements.txt
└── README.md
```

## Setup

Install dependencies:

```bash
pip install -r requirements.txt
```

## Run Backend

```bash
uvicorn app:app --reload
```

Backend runs at:

```txt
http://127.0.0.1:8000
```

## Open Frontend

Open `index.html` directly in your browser.

The frontend calls the backend APIs using:

```txt
http://127.0.0.1:8000
```

## API Endpoints

```txt
GET  /
GET  /dashboard
GET  /hotfixes
GET  /logs
POST /hotfix/create
```

## Notes

- Data comes from `mock-data.json`.
- No database is used.
- No authentication is used.
- No frontend build tools are required.
