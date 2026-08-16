from fastapi import FastAPI

app = FastAPI(title="PlayArena API", version="0.1.0")


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok", "service": "playarena-api"}


@app.get("/v1/games")
def games() -> dict[str, list[dict[str, str]]]:
    return {
        "games": [
            {"id": "teen_patti", "name": "Teen Patti", "mode": "free_play"},
            {"id": "cricket", "name": "Cricket", "mode": "free_play"},
        ]
    }
