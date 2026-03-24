#!/usr/bin/env python3
"""
Decode Aztec Rollup.propose() calldata: print global slot (decimal) on line 1,
then one signer address per line (lowercase 0x-prefixed).

Handles:
- propose() v1 selector 0x85b98fd8 (legacy header; slot at header[5])
- propose() v2 selector 0x48aeda19 (Ignition / blob path; slot at propose_arg0[3][2])
- Multicall3.aggregate3() 0x82ad56cb wrapping either propose variant

Requires: pip install eth_abi
"""
from __future__ import annotations

import sys

# Legacy propose (pre-blob / older rollup)
PROPOSE_SELECTOR_V1 = bytes.fromhex("85b98fd8")
# New propose (e.g. mainnet blob commits; see 4byte 0x48aeda19)
PROPOSE_SELECTOR_V2 = bytes.fromhex("48aeda19")
AGGREGATE3_SELECTOR = bytes.fromhex("82ad56cb")

PROPOSE_ABI_TYPES_V1 = [
    "(bytes32,(int256),(bytes32,bytes32,bytes32,bytes32,bytes32,uint256,uint256,address,bytes32,(uint128,uint128),uint256))",
    "(bytes,bytes)",
    "address[]",
    "(uint8,bytes32,bytes32)",
    "bytes",
]

PROPOSE_ABI_TYPES_V2 = [
    "(bytes32,((bytes32,uint32),((bytes32,uint32),(bytes32,uint32),(bytes32,uint32))),(int256),(bytes32,(bytes32,bytes32,bytes32),uint256,uint256,address,bytes32,(uint128,uint128),uint256))",
    "(bytes,bytes)",
    "address[]",
    "(uint8,bytes32,bytes32)",
    "bytes",
]


def _is_propose_selector(sel: bytes) -> bool:
    return sel in (PROPOSE_SELECTOR_V1, PROPOSE_SELECTOR_V2)


def extract_propose_calldata(data: bytes) -> bytes | None:
    """Return raw propose() calldata, unwrapping Multicall3 if needed."""
    if len(data) < 4:
        return None
    sel = data[:4]
    if _is_propose_selector(sel):
        return data
    if sel == AGGREGATE3_SELECTOR:
        try:
            from eth_abi import decode

            calls = decode(["(address,bool,bytes)[]"], data[4:])[0]
            for _target, _allow, call_data in calls:
                cd = bytes(call_data)
                if len(cd) >= 4 and _is_propose_selector(cd[:4]):
                    return cd
        except Exception:
            pass
    return None


def _slot_and_signers_from_decoded(propose_data: bytes) -> tuple[int, list] | None:
    from eth_abi import decode

    sel = propose_data[:4]
    body = propose_data[4:]
    if sel == PROPOSE_SELECTOR_V1:
        try:
            decoded = decode(PROPOSE_ABI_TYPES_V1, body)
        except Exception:
            return None
        header = decoded[0][2]
        slot = int(header[5])
        signers = decoded[2]
        return slot, list(signers)
    if sel == PROPOSE_SELECTOR_V2:
        try:
            decoded = decode(PROPOSE_ABI_TYPES_V2, body)
        except Exception:
            return None
        # propose_arg0[3] = (bytes32, (bytes32^3), uint256, uint256, address, bytes32, (uint128,uint128), uint256)
        inner_header = decoded[0][3]
        slot = int(inner_header[2])
        signers = decoded[2]
        return slot, list(signers)
    return None


def main() -> int:
    if len(sys.argv) < 2:
        return 1
    h = sys.argv[1].strip()
    if h.startswith("0x") or h.startswith("0X"):
        h = h[2:]
    try:
        data = bytes.fromhex(h)
    except ValueError:
        return 1
    propose_data = extract_propose_calldata(data)
    if propose_data is None:
        return 1
    try:
        parsed = _slot_and_signers_from_decoded(propose_data)
    except ImportError:
        return 2
    if parsed is None:
        return 1
    slot, signers = parsed
    print(slot)
    for addr in signers:
        if isinstance(addr, str):
            a = addr.lower() if addr.startswith("0x") else f"0x{addr.lower()}"
        elif hasattr(addr, "hex"):
            a = f"0x{addr.hex().lower()}"
        else:
            a = f"0x{bytes(addr).hex().lower()}"
        print(a)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
