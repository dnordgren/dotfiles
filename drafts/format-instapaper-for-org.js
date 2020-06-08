// Clean up extra newlines, ugly whitespace chars.
draft.content = draft.content
  .replace(/[\u2018\u2019]/g, "'")
  .replace(/[\u201C\u201D]/g, '"')
  .replace(/\u200B/g, '')
  .replace(/> \n/g, '')
  .replace(/\n\n\n\n/g, '\n\n\n');

const uuid = () => {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) => {
    const r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
    return v.toString(16);
  });
};

const d = draft.createdDate;

const ye = new Intl.DateTimeFormat('en', { year: 'numeric' }).format(d);
const mo = new Intl.DateTimeFormat('en', { month: '2-digit' }).format(d);
const da = new Intl.DateTimeFormat('en', { day: '2-digit' }).format(d);

const modeLine = `-*- mode: org -*-\n`;
const slugLine  = `${ye}-${mo}-${da}.snippet.slug\n`;
const titleLine = `#+TITLE: ${draft.title}\n`;
const dateLine  = `#+DATE : ${ye}-${mo}-${da}\n`;
const urlLine   = `#+URL  : ${draft.title}\n\n`;

const linksDrawer = `:LINKS:\n@:${uuid()}\n:END:\n`;

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
  + draft.content;

commit(draft);
