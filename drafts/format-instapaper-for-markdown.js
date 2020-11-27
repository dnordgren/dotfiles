// Docs: https://scripting.getdrafts.com/

// Clean up extra newlines, ugly whitespace chars.
draft.content = draft.content
  .replace(/[\u2018\u2019]/g, "'")
  .replace(/[\u201C\u201D]/g, '"')
  .replace(/\u200B/g, '')
  .replace(/> \n/g, '')
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

const title = titleMatch && titleMatch.groups ? titleMatch.groups.title : '';
const url = urlMatch && urlMatch.groups ? urlMatch.groups.url : '';

const slugLine  = `${yearShort}${month}${day} ${title.toLowerCase()}\n\n`;
const preformattedLine = '```\n';
const orgTitleLine = `#+TITLE: ${title}\n`;
const orgDateLine  = `#+DATE: ${yearLong}-${month}-${day} ${weekday}\n`;
const orgUrlLine   = `#+URL: ${url}\n\n`;

const orgLinksDrawer = `:LINKS:\n@:${draft.uuid}\n:END:\n`;

const orgMetadataDrawer = `:METADATA:\nlat : ${draft.createdLatitude}\nlong: ${draft.createdLongitude}\n:END:\n`;

const headersLines = '## Summary\n## Reaction\n## Further reading\n## Snippets\n';

const metadataHeader = '## Metadata\n\n';

const allLines = draft.lines;

// Remove title line; we'll re-add it in order below.
allLines.shift();

draft.content = slugLine
  + `${markdownTitle}\n\n`
  + headersLines
  + `${allLines.join('\n')}\n\n`
  + metadataHeader
  + preformattedLine
  + orgTitleLine
  + orgDateLine
  + orgUrlLine
  + orgLinksDrawer
  + orgMetadataDrawer
  + preformattedLine

commit(draft);
