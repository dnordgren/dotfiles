const credential = Credential.create("Secret Token of Dynalist", "Dynalist");
credential.addPasswordField("token", "Secret Token");
credential.authorize();

const tagLine = draft.tags.map(t => "#" + t).join(" ");
const draftCreationTime = `[[${strftime(draft.createdAt, "%Y_%m_%d")}]]`;
const captureTime = `[[${strftime(new Date(), "%Y_%m_%d")}]]`;
const draftBody = draft.processTemplate("[[body]]");

let noteComponents = [];
noteComponents.push(draftBody.trim());
noteComponents.push(`Captured: ${captureTime}`)
if (captureTime !== draftCreationTime) {
    noteComponents.push(`Created: ${draftCreationTime}`);
}
noteComponents = noteComponents.filter(n => n);
const note = noteComponents.join("\n");

const http = HTTP.create();
const response = http.request({
  "url": "https://dynalist.io/api/v1/inbox/add",
  "encoding": "json",
  "method": "POST",
  "data": {
    "token": credential.getValue("token"),
    "index": "-1",
    "content": draft.processTemplate("[[title]]").trim(),
    "note": note,
    "color": "0"
  }
});

if (response.success) {
  const rText = JSON.parse(response.responseText);

  if (rText._code == "Ok") {
	app.displaySuccessMessage(`Posted to Dynalist inbox`);
  } else {
    alert(rText._code + "\n" + rText._msg);
    app.displayErrorMessage(rText._msg);
  }
} else {
  console.log(response.statusCode);
  console.log(response.error);
  alert(response.statusCode + "\n" + response.error);
  app.displayErrorMessage(response.error);
}
