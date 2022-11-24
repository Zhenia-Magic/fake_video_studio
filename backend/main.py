from fastapi import FastAPI
from typing import Dict

app = FastAPI()


@app.get("/")
async def root() -> Dict[str, str]:
    return {"message": "Welcome to Fake Video Studio"}


@app.get("/create-video")
async def create_video(character: str, script: str) -> str:
    return "s3_link"
