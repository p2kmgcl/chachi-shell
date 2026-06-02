// ==UserScript==
// @name         GitHub PR Review Tags
// @namespace    chachi-shell/review-pr
// @version      1.0.0
// @description  Visual enhancements for review-pr skill: renders priority/lens chips and filter toolbar
// @author       Pablo Molina
// @match        https://github.com/*/*/pull/*
// @grant        none
// @run-at       document-idle
// ==/UserScript==

(function () {
  'use strict';

  // ── Styles ──────────────────────────────────────────────────────────────────

  const styleEl = document.createElement('style');
  styleEl.textContent = `
    .prt-badges {
      display: flex; flex-wrap: wrap; gap: 4px; margin-bottom: 6px;
    }
    .prt-chip {
      display: inline-flex; align-items: center;
      padding: 1px 8px; border-radius: 12px;
      font-size: 11px; font-weight: 700; line-height: 18px;
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
    }
    .prt-p0   { background: #cf222e; color: #fff; }
    .prt-p1   { background: #bc4c00; color: #fff; }
    .prt-p2   { background: #0969da; color: #fff; }
    .prt-lens { background: #ddf4ff; color: #0550ae; border: 1px solid rgba(84,174,255,.4); }

    .prt-toolbar {
      position: sticky; top: 60px; z-index: 200;
      background: var(--color-canvas-default, #fff);
      border: 1px solid var(--color-border-default, #d0d7de);
      border-radius: 6px; padding: 8px 12px; margin: 8px 0 12px;
      display: flex; align-items: center; flex-wrap: wrap; gap: 6px;
      box-shadow: 0 1px 3px rgba(31,35,40,.12);
    }
    .prt-toolbar-label {
      font-size: 12px; font-weight: 600;
      color: var(--color-fg-muted, #656d76); margin-right: 2px;
    }
    .prt-sep { width: 1px; height: 20px; background: var(--color-border-default, #d0d7de); margin: 0 4px; }

    .prt-filter-chip {
      display: inline-flex; align-items: center;
      padding: 2px 10px; border-radius: 12px; border: 2px solid transparent;
      font-size: 12px; font-weight: 600; cursor: pointer; user-select: none;
      transition: opacity 0.15s, transform 0.1s;
    }
    .prt-filter-chip:hover { transform: scale(1.06); }
    .prt-filter-chip.prt-off { opacity: 0.28; }
    .prt-filter-p0   { background: #cf222e; color: #fff; }
    .prt-filter-p1   { background: #bc4c00; color: #fff; }
    .prt-filter-p2   { background: #0969da; color: #fff; }
    .prt-filter-lens { background: #ddf4ff; color: #0550ae; border-color: rgba(84,174,255,.4) !important; }

    .prt-border-p0 { border-left: 4px solid #cf222e !important; padding-left: 8px !important; }
    .prt-border-p1 { border-left: 4px solid #bc4c00 !important; padding-left: 8px !important; }
    .prt-border-p2 { border-left: 4px solid #0969da !important; padding-left: 8px !important; }

    [data-prt-hidden] { display: none !important; }
  `;
  document.head.appendChild(styleEl);

  // ── Tag parsing ──────────────────────────────────────────────────────────────

  // Matches: [P0][SECURITY][BUGS] or [P1] etc. at the start of text
  const TAG_RE = /^(\[P[0-2]\])((?:\[[A-Z][A-Z0-9-]*\])*)\s*/;

  function parseTags(text) {
    const m = text.match(TAG_RE);
    if (!m) return null;
    return {
      priority: m[1].slice(1, -1),  // 'P0' | 'P1' | 'P2'
      lenses: [...m[2].matchAll(/\[([A-Z][A-Z0-9-]*)\]/g)].map(x => x[1]),
      len: m[0].length,
    };
  }

  // ── DOM helpers ──────────────────────────────────────────────────────────────

  // Strip the first `charCount` characters from the text nodes inside `node`
  function stripPrefixText(node, charCount) {
    let remaining = charCount;
    const walk = (n) => {
      if (remaining <= 0) return;
      if (n.nodeType === Node.TEXT_NODE) {
        const cut = Math.min(remaining, n.textContent.length);
        n.textContent = n.textContent.slice(cut);
        remaining -= cut;
      } else {
        for (const child of [...n.childNodes]) walk(child);
      }
    };
    walk(node);
  }

  // Walk up from el to find the inline thread container used for filtering/hiding
  function findThreadContainer(el) {
    let node = el.parentElement;
    while (node && node !== document.body) {
      if (
        node.classList.contains('review-thread') ||
        node.classList.contains('js-comments-holder') ||
        node.classList.contains('js-comment-container') ||
        node.classList.contains('timeline-comment-wrapper') ||
        (node.tagName === 'TR' && node.closest('table'))
      ) return node;
      node = node.parentElement;
    }
    return el.parentElement;
  }

  // Walk up to find the visual comment card for the colored border
  function findCommentCard(el) {
    let node = el.parentElement;
    while (node && node !== document.body) {
      if (
        node.classList.contains('review-comment') ||
        node.classList.contains('timeline-comment') ||
        node.classList.contains('js-comment') ||
        node.classList.contains('comment')
      ) return node;
      node = node.parentElement;
    }
    return el;
  }

  // ── Comment processing ───────────────────────────────────────────────────────

  function processComment(body) {
    if (body.dataset.prtDone) return;
    body.dataset.prtDone = '1';

    const firstP = body.querySelector('p');
    if (!firstP) return;

    const parsed = parseTags(firstP.textContent);
    if (!parsed) return;

    stripPrefixText(firstP, parsed.len);

    // Inject badge row before comment content
    const row = document.createElement('div');
    row.className = 'prt-badges';

    const pc = document.createElement('span');
    pc.className = `prt-chip prt-${parsed.priority.toLowerCase()}`;
    pc.textContent = parsed.priority;
    row.appendChild(pc);

    for (const lens of parsed.lenses) {
      const lc = document.createElement('span');
      lc.className = 'prt-chip prt-lens';
      lc.textContent = lens;
      row.appendChild(lc);
    }
    body.insertBefore(row, body.firstChild);

    // Colored left border on the comment card
    const card = findCommentCard(body);
    card.classList.add(`prt-border-${parsed.priority.toLowerCase()}`);

    // Tag thread container for filter matching
    const thread = findThreadContainer(body);
    if (!thread) return;
    const existing = (thread.dataset.prtTags || '').split(',').filter(Boolean);
    const tags = new Set([...existing, parsed.priority, ...parsed.lenses]);
    thread.dataset.prtTags = [...tags].join(',');
  }

  function processAllComments() {
    document.querySelectorAll(
      '.comment-body:not([data-prt-done]), .js-comment-body:not([data-prt-done])'
    ).forEach(processComment);
  }

  // ── Filter toolbar ───────────────────────────────────────────────────────────

  // Empty set = no restriction on that group (show all)
  const filters = { priorities: new Set(), lenses: new Set() };

  function collectTags() {
    const priorities = new Set(), lenses = new Set();
    document.querySelectorAll('[data-prt-tags]').forEach(el => {
      el.dataset.prtTags.split(',').filter(Boolean).forEach(t =>
        (t.startsWith('P') ? priorities : lenses).add(t)
      );
    });
    return { priorities: [...priorities].sort(), lenses: [...lenses].sort() };
  }

  function applyFilters() {
    document.querySelectorAll('[data-prt-tags]').forEach(thread => {
      const tags = thread.dataset.prtTags.split(',').filter(Boolean);
      const pMatch = filters.priorities.size === 0 || tags.some(t => filters.priorities.has(t));
      const lMatch = filters.lenses.size === 0 || tags.some(t => filters.lenses.has(t));
      // AND between groups, OR within each group
      thread.toggleAttribute('data-prt-hidden', !(pMatch && lMatch));
    });
  }

  function updateChipStates() {
    document.querySelectorAll('.prt-filter-chip').forEach(chip => {
      const set = chip.dataset.ftype === 'p' ? filters.priorities : filters.lenses;
      // Dim chips that are not in the active filter set (when a filter is active)
      chip.classList.toggle('prt-off', set.size > 0 && !set.has(chip.dataset.fval));
    });
  }

  function toggleFilter(type, value) {
    const set = type === 'p' ? filters.priorities : filters.lenses;
    set.has(value) ? set.delete(value) : set.add(value);
    updateChipStates();
    applyFilters();
  }

  function buildToolbar() {
    const existing = document.getElementById('prt-toolbar');
    if (existing) existing.remove();

    const filesEl = document.getElementById('files');
    if (!filesEl) return;

    const { priorities, lenses } = collectTags();
    if (!priorities.length && !lenses.length) return;

    const bar = document.createElement('div');
    bar.id = 'prt-toolbar';
    bar.className = 'prt-toolbar';

    const addLabel = (text) => {
      const s = document.createElement('span');
      s.className = 'prt-toolbar-label';
      s.textContent = text;
      bar.appendChild(s);
    };

    const addChip = (label, cssClass, type, value) => {
      const c = document.createElement('span');
      c.className = `prt-filter-chip ${cssClass}`;
      c.dataset.ftype = type;
      c.dataset.fval = value;
      c.textContent = label;
      c.addEventListener('click', () => toggleFilter(type, value));
      bar.appendChild(c);
    };

    if (priorities.length) {
      addLabel('Priority:');
      priorities.forEach(p => addChip(p, `prt-filter-${p.toLowerCase()}`, 'p', p));
    }
    if (priorities.length && lenses.length) {
      const sep = document.createElement('div');
      sep.className = 'prt-sep';
      bar.appendChild(sep);
    }
    if (lenses.length) {
      addLabel('Lens:');
      lenses.forEach(l => addChip(l, 'prt-filter-lens', 'l', l));
    }

    filesEl.insertBefore(bar, filesEl.firstChild);
  }

  // ── Init & lifecycle ─────────────────────────────────────────────────────────

  function run() {
    processAllComments();
    buildToolbar();
  }

  // Debounced toolbar rebuild to avoid thrashing on rapid DOM mutations
  let toolbarTimer = null;
  const contentObserver = new MutationObserver(() => {
    processAllComments();
    clearTimeout(toolbarTimer);
    toolbarTimer = setTimeout(buildToolbar, 300);
  });
  contentObserver.observe(document.body, { childList: true, subtree: true });

  // SPA navigation: GitHub uses pushState — watch the <title> for URL changes
  let lastUrl = location.href;
  const navObserver = new MutationObserver(() => {
    if (location.href === lastUrl) return;
    lastUrl = location.href;
    filters.priorities.clear();
    filters.lenses.clear();
    // Wait for GitHub to render the new page content
    setTimeout(run, 800);
  });
  navObserver.observe(document.head.querySelector('title') || document.head, {
    childList: true, subtree: true,
  });

  run();
})();
