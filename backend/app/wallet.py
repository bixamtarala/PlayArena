from dataclasses import dataclass
from datetime import datetime, timezone
from threading import Lock
from uuid import uuid4


@dataclass(frozen=True)
class LedgerEntry:
    id: str
    user_id: str
    delta: int
    balance_before: int
    balance_after: int
    reason: str
    admin_id: str
    created_at: str


class WalletError(ValueError):
    pass


class WalletStore:
    """Development-only in-memory wallet.

    Production will use the existing Supabase wallet + immutable ledger tables.
    Manual balance changes are intentionally exposed only through admin methods.
    """

    def __init__(self) -> None:
        self._balances: dict[str, int] = {"preview-player": 10_000}
        self._ledger: list[LedgerEntry] = []
        self._lock = Lock()

    def balance(self, user_id: str) -> int:
        return self._balances.get(user_id, 0)

    def ledger(self, user_id: str) -> list[LedgerEntry]:
        return [entry for entry in reversed(self._ledger) if entry.user_id == user_id]

    def admin_adjust(self, *, user_id: str, delta: int, reason: str, admin_id: str) -> LedgerEntry:
        if delta == 0:
            raise WalletError("Adjustment cannot be zero")
        if not reason.strip():
            raise WalletError("Reason is required")
        if not admin_id.strip():
            raise WalletError("Admin identity is required")

        with self._lock:
            before = self.balance(user_id)
            after = before + delta
            if after < 0:
                raise WalletError("Balance cannot become negative")
            entry = LedgerEntry(
                id=str(uuid4()),
                user_id=user_id,
                delta=delta,
                balance_before=before,
                balance_after=after,
                reason=reason.strip(),
                admin_id=admin_id.strip(),
                created_at=datetime.now(timezone.utc).isoformat(),
            )
            self._balances[user_id] = after
            self._ledger.append(entry)
            return entry


wallet_store = WalletStore()
