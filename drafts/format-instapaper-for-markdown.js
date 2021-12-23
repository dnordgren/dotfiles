// Docs: https://scripting.getdrafts.com/

// Clean up extra newlines, ugly whitespace chars.
draft.content = draft.content
  .replace(/[\u2018\u2019]/g, "'")
  .replace(/\255/g, '') // short hyphen from WSJ
  .replace(/[\u201C\u201D]/g, '"')
  .replace(/\u200B/g, '')
  .replace(/> \n/g, '')
  .replace(/“/g, '"')
  .replace(/”/g, '"')
  .replace(/‘/g, "'")
  .replace(/’/g, "'")
  .replace(/\n\n\n\n/g, '\n\n\n');

const d = draft.createdAt;

const yearLong  = new Intl.DateTimeFormat('en', { year: 'numeric' }).format(d);
const yearShort = new Intl.DateTimeFormat('en', { year: '2-digit' }).format(d);
const month     = new Intl.DateTimeFormat('en', { month: '2-digit' }).format(d);
const day       = new Intl.DateTimeFormat('en', { day: '2-digit' }).format(d);
const weekday   = new Intl.DateTimeFormat('en', { weekday: 'short' }).format(d);

const markdownTitle = draft.title;
const titleRegex = /\[(?<title>.*)\]/;
const urlRegex   = /\((?<url>.*)\)/;

const titleMatch = markdownTitle.match(titleRegex);
const urlMatch = markdownTitle.match(urlRegex);

let title = titleMatch && titleMatch.groups ? titleMatch.groups.title : '';
title = title
  .replace(/[^a-z0-9]/gi, '_').toLowerCase();
const url = urlMatch && urlMatch.groups ? urlMatch.groups.url : '';

const slugLine  = `${yearShort}${month}${day} ${title}-lit\n`;
const preformattedLine = '```txt\n';
const orgTitleLine = `#+TITLE: ${title}\n`;
const orgDateLine  = `#+DATE: ${yearLong}-${month}-${day} ${weekday}\n`;
const orgUrlLine   = `#+URL: ${url}\n\n`;

const orgLinksDrawer = `:LINKS:\n@:${draft.uuid}\n:END:\n`;

const orgMetadataDrawer = `:METADATA:\nlat : ${draft.createdLatitude}\nlong: ${draft.createdLongitude}\n:END:\n`;

const headersLines = '## Summary\n\n\n## Snippets\n';

const metadataHeader = '## Metadata\n\n';

const allLines = draft.lines;

// Remove title line; we'll re-add it in order below.
allLines.shift();

draft.content = slugLine
  + `${url}\n`
  + `---\n`
  + `css: x-devonthink-item://03BDDA7E-447B-465F-B1C3-D29011FDF320\n`
  + `---\n`
  + `${markdownTitle}\n\n`
  + headersLines
  + `${allLines.join('\n')}`
  + metadataHeader
  + preformattedLine
  + orgTitleLine
  + orgDateLine
  + orgUrlLine
  + orgLinksDrawer
  + orgMetadataDrawer
  + '\`\`\`';

draft.update();
