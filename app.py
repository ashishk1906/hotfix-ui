from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

import json
from pathlib import Path

app = FastAPI(title="Hotfix Dashboard API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Load mock data
DATA_FILE = Path(__file__).with_name("mock-data.json")
with DATA_FILE.open("r", encoding="utf-8") as f:
    data = json.load(f)

@app.get("/")
def root():
    return {
        "message": "Hotfix Dashboard API is running",
        "frontend": "Open index.html directly in your browser",
        "endpoints": ["/dashboard", "/hotfixes", "/logs", "/hotfix/create"]
    }

# Dashboard API
@app.get("/dashboard")
def dashboard():

    return {
        "stats": data["stats"],
        "pipeline": data["pipeline"],
        "recentActivity": data["recentActivity"]
    }

# Hotfix API
@app.get("/hotfixes")
def hotfixes():

    return {
        "hotfixes": data["hotfixes"]
    }

# Logs API
@app.get("/logs")
def logs():

    return {
        "logs": data["logs"]
    }

# Create Hotfix API
@app.post("/hotfix/create")
def create_hotfix():

    return {
        "job_id": "CHF_RUN_001",
        "status": "created",
        "branch": "hotfix/CHF-401"
    }
