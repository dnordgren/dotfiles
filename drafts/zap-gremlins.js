draft.content = draft.content
  .replace(/\\/g, '')
  .replace(/“/g, '"')
  .replace(/”/g, '"')
  .replace(/‘/g, "'")
  .replace(/’/g, "'")
  .replace(/\255/g, '') // short hyphen from WSJ

draft.update()
