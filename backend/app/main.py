import os
from dataclasses import asdict

from fastapi import Depends, FastAPI, Header, HTTPException
from pydantic import BaseModel, Field

from .wallet import WalletError, wallet_store

app = FastAPI(title="PlayArena API", version="0.2.0")

ADMIN_API_KEY = os.getenv("ADMIN_API_KEY", "")


class ChipAdjustment(BaseModel):
    user_id: str = Field(min_length=1, max_length=128)
    delta: int = Field(ge=-10_000_000, le=10_000_000)
    reason: str = Field(min_length=2, max_length=240)


def require_admin(
    x_admin_key: str | None = Header(default=None),
    x_admin_id: str | None = Header(default=None),
) -> str:
    if not ADMIN_API_KEY:
        raise HTTPException(status_code=503, detail="Admin API is not configured")
    if x_admin_key != ADMIN_API_KEY:
        raise HTTPException(status_code=403, detail="Admin access required")
    if not x_admin_id:
        raise HTTPException(status_code=400, detail="Admin identity is required")
    return x_admin_id


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


@app.get("/v1/wallet/{user_id}")
def wallet_balance(user_id: str) -> dict[str, int | str]:
    return {"user_id": user_id, "balance": wallet_store.balance(user_id)}


@app.post("/v1/admin/chips/adjust")
def admin_adjust_chips(payload: ChipAdjustment, admin_id: str = Depends(require_admin)) -> dict:
    try:
        entry = wallet_store.admin_adjust(
            user_id=payload.user_id,
            delta=payload.delta,
            reason=payload.reason,
            admin_id=admin_id,
        )
    except WalletError as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc
    return {"ok": True, "transaction": asdict(entry)}


@app.get("/v1/admin/chips/{user_id}/ledger")
def admin_chip_ledger(user_id: str, _: str = Depends(require_admin)) -> dict:
    return {"user_id": user_id, "transactions": [asdict(x) for x in wallet_store.ledger(user_id)]}
