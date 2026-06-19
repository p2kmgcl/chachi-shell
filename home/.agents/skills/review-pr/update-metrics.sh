#!/usr/bin/env bash
# Usage: update-metrics.sh [metrics.csv] < findings
#
# Accumulates per-lens review findings into a global tally CSV.
#
# Reads one row per candidate finding from stdin (an optional "lens,..." header
# row is ignored):
#
#     LENS,PRIORITY,KEPT
#
#   PRIORITY  one of P0 P1 P2 P3 (case-insensitive)
#   KEPT      1 if the finding landed in the posted review, 0 otherwise
#
# A finding flagged by several lenses is emitted once per contributing lens, so
# each lens is credited. The script does all the grouping:
#   - found_pN  counts every candidate of priority N (pre-suppression)
#   - kept_pN   counts kept candidates of priority N; P3 is never kept, so there
#               is no kept_p3 column
# Totals accumulate across runs. A lens not yet present is appended as a fresh
# row, so adding or renaming lenses never crashes. The metrics file is created
# with a header if missing.

set -euo pipefail

METRICS="${1:-$(dirname "$0")/metrics.csv}"
HEADER="lens,found_p0,found_p1,found_p2,found_p3,kept_p0,kept_p1,kept_p2"

[[ -f "$METRICS" ]] || echo "$HEADER" > "$METRICS"

TMP="$(mktemp)"
awk -F, -v OFS=, '
  # Column index in the CSV (2..8) for a given priority + bucket.
  function foundcol(p) { return (p=="P0")?2:(p=="P1")?3:(p=="P2")?4:(p=="P3")?5:0 }
  function keptcol(p)  { return (p=="P0")?6:(p=="P1")?7:(p=="P2")?8:0 }  # no P3
  function note(lens)  { if (!(lens in seen)) { order[++n]=lens; seen[lens]=1 } }

  # First file: existing metrics (skip header, load totals, preserve order).
  NR==FNR {
    if (FNR==1 || $1=="") next
    note($1)
    for (i=2;i<=8;i++) val[$1,i]=($i==""?0:$i)
    next
  }
  # Second stream: raw findings from stdin.
  {
    lens=$1
    if (lens=="" || lens=="lens") next
    prio=toupper($2)
    kept=$3
    fc=foundcol(prio)
    if (fc==0) next            # unknown priority: ignore defensively
    note(lens)
    val[lens,fc]++
    if (kept=="1") { kc=keptcol(prio); if (kc) val[lens,kc]++ }
  }
  END {
    print "lens,found_p0,found_p1,found_p2,found_p3,kept_p0,kept_p1,kept_p2"
    for (k=1;k<=n;k++) {
      lens=order[k]; line=lens
      for (i=2;i<=8;i++) { v=val[lens,i]; if (v=="") v=0; line=line OFS v }
      print line
    }
  }
' "$METRICS" - > "$TMP"

mv "$TMP" "$METRICS"
echo "Updated $METRICS"
