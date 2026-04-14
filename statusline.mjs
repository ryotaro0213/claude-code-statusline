const BLOCKS = ' ▏▎▍▌▋▊▉█';
const R = '\x1b[0m';
const DIM = '\x1b[2m';

function gradient(pct) {
  if (pct < 50) {
    const r = Math.round(pct * 5.1);
    return `\x1b[38;2;${r};200;80m`;
  }
  const g = Math.round(200 - (pct - 50) * 4);
  return `\x1b[38;2;255;${Math.max(g, 0)};60m`;
}

function bar(pct, width = 10) {
  pct = Math.min(Math.max(pct, 0), 100);
  const filled = (pct * width) / 100;
  const full = Math.floor(filled);
  const frac = Math.floor((filled - full) * 8);
  let b = '█'.repeat(full);
  if (full < width) {
    b += BLOCKS[frac];
    b += '░'.repeat(width - full - 1);
  }
  return b;
}

function fmt(label, pct) {
  const p = Math.round(pct);
  return `${label} ${gradient(pct)}${bar(pct)} ${p}%${R}`;
}

let raw = '';
process.stdin.setEncoding('utf8');
process.stdin.on('data', (chunk) => { raw += chunk; });
process.stdin.on('end', () => {
  let data = {};
  try { data = JSON.parse(raw); } catch {}

  const model = data?.model?.display_name ?? 'Claude';
  const parts = [model];

  const ctx = data?.context_window?.used_percentage;
  if (ctx != null) parts.push(fmt('ctx', ctx));

  const five = data?.rate_limits?.five_hour?.used_percentage;
  if (five != null) parts.push(fmt('5h', five));

  const week = data?.rate_limits?.seven_day?.used_percentage;
  if (week != null) parts.push(fmt('7d', week));

  process.stdout.write(parts.map((p) => ` ${p} `).join(`${DIM}│${R}`));
});
