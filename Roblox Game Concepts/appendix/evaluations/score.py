"""Aggregate panel scores: weighted average + threshold gates.
Usage: python3 score.py <eval_dir> [concept ids comma-separated]
"""
import json, sys, os

W = {1: ("Access", .12), 2: ("Mobile", .12), 3: ("Monet", .12), 4: ("Replay", .14),
     5: ("Viral", .12), 6: ("DevSimp", .10), 7: ("Diff", .10), 8: ("Fun", .18)}
HARD8 = {1, 2, 3, 4, 8}  # must be >= 8
d = sys.argv[1]
agents = {}
for n in range(1, 11):
    p = os.path.join(d, f"a{n}.json")
    if os.path.exists(p):
        agents[n] = json.load(open(p))["scores"]
ids = sys.argv[2].split(",") if len(sys.argv) > 2 else sorted(agents[1].keys())
rows = []
for c in ids:
    s = {n: agents[n][c]["score"] for n in agents if c in agents[n]}
    wavg = sum(s[n] * W[n][1] for n in W if n in s)
    fails = []
    if wavg < 8.0: fails.append("avg<8")
    for n in W:
        if n not in s: continue
        lim = 8 if n in HARD8 else 7
        if s[n] < lim: fails.append(f"{W[n][0]}={s[n]}")
    veto = agents.get(8, {}).get(c, {}).get("veto", False)
    if veto: fails.append("VETO")
    rows.append((wavg, c, s, fails))
rows.sort(reverse=True)
hdr = "ID   " + " ".join(f"{W[n][0]:>7}" for n in W) + "  Steam9  Comm10  WAvg   Status"
print(hdr)
for wavg, c, s, fails in rows:
    print(f"{c:<5}" + " ".join(f"{s.get(n,'-'):>7}" for n in W)
          + f"  {s.get(9,'-'):>6}  {s.get(10,'-'):>6}  {wavg:5.2f}  "
          + ("PASS" if not fails else "FAIL: " + ", ".join(fails)))
