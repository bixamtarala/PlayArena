import pytest

from app.wallet import WalletError, WalletStore


def test_admin_can_add_and_reduce_chips():
    store = WalletStore()
    added = store.admin_adjust(user_id="u1", delta=5000, reason="Promo", admin_id="admin-1")
    assert added.balance_before == 0
    assert added.balance_after == 5000

    reduced = store.admin_adjust(user_id="u1", delta=-1200, reason="Correction", admin_id="admin-1")
    assert reduced.balance_before == 5000
    assert reduced.balance_after == 3800
    assert store.balance("u1") == 3800
    assert len(store.ledger("u1")) == 2


def test_admin_cannot_make_balance_negative():
    store = WalletStore()
    with pytest.raises(WalletError):
        store.admin_adjust(user_id="u2", delta=-1, reason="Invalid", admin_id="admin-1")


def test_reason_and_admin_are_required():
    store = WalletStore()
    with pytest.raises(WalletError):
        store.admin_adjust(user_id="u3", delta=100, reason="", admin_id="admin-1")
    with pytest.raises(WalletError):
        store.admin_adjust(user_id="u3", delta=100, reason="Promo", admin_id="")
