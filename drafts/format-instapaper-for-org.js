const uuid = () => {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) => {
    const r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
    return v.toString(16);
  });
};

// Word-wrap lines at 80 chars.
// https://github.com/jonschlinkert/word-wrap/blob/master/index.js
const wrap = (str, options) => {
  options = options || {};
  if (str == null) {
    return str;
  }

  var width = options.width || 80;
  var indent = (typeof options.indent === 'string')
    ? options.indent
    : '';

  var newline = options.newline || '\n' + indent;
  var escape = typeof options.escape === 'function'
    ? options.escape
    : identity;

  var regexString = '.{1,' + width + '}';
  if (options.cut !== true) {
    regexString += '([\\s\u200B]+|$)|[^\\s\u200B]+?([\\s\u200B]+|$)';
  }

  var re = new RegExp(regexString, 'g');
  var lines = str.match(re) || [];
  var result = indent + lines.map(function(line) {
    if (line.slice(-1) === '\n') {
      line = line.slice(0, line.length - 1);
    }
    return escape(line);
  }).join(newline);

  if (options.trim === true) {
    result = result.replace(/[ \t]*$/gm, '');
  }
  return result;
};

const identity = (str) => str;

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

const title = titleMatch && titleMatch.groups ? titleMatch.groups.title : '';
const url = urlMatch && urlMatch.groups ? urlMatch.groups.url : '';

const modeLine = `-*- mode: org -*-\n`;
const slugLine  = `${yearShort}${month}${day}-${d.getHours()}${d.getMinutes()} ${title.toLowerCase()}\n`;
const titleLine = `#+TITLE: ${title}\n`;
const dateLine  = `#+DATE: ${yearLong}-${month}-${day} ${weekday}\n`;
const urlLine   = `#+URL: ${url}\n\n`;

const linksDrawer = `:LINKS:\n@:${draft.uuid}\n:END:\n`;

const metadataDrawer = `:METADATA:\nlat : ${draft.createdLatitude}\nlong: ${draft.createdLongitude}\n:END:\n\n`;

const bullets = '* Summary\n* Reaction\n* Further reading\n* Snippets\n';

draft.content = modeLine
  + slugLine
  + titleLine
  + dateLine
  + urlLine
  + linksDrawer
  + metadataDrawer
  + bullets
  + wrap(draft.content, { width: 80 });

commit(draft);
