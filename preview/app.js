const surface = document.querySelector(".app-surface");
const panel = document.querySelector("#companion-panel");
const panelState = document.querySelector("#panel-state");
const panelCaption = document.querySelector("#panel-caption");
const talkButton = document.querySelector("#talk-button");
const voiceActionLabel = document.querySelector("#voice-action-label");
const statusRegion = document.querySelector("#status-region");
const responseRegion = document.querySelector("#response-region");
const imageInput = document.querySelector("#image-input");
const fileInput = document.querySelector("#file-input");
const attachmentSummary = document.querySelector("#attachment-summary");
const attachmentLabel = document.querySelector("#attachment-label");

const states = {
  ready: { action: "TAP TO TALK", status: "TAP TO TALK · ENGLISH · CAPTIONS ON", panel: "READY", caption: "READY WHEN YOU ARE", next: "listening", label: "Tap to talk" },
  listening: { action: "STOP", status: "LISTENING · TAP STOP WHEN YOU ARE DONE", panel: "LISTENING", caption: "I’M LISTENING · TAKE YOUR TIME", next: "processing", label: "Stop listening" },
  processing: { action: "SHOW RESPONSE", status: "VOICE NOTE SAVED · PREPARING A PLAIN-ENGLISH RESPONSE", panel: "PROCESSING", caption: "YOUR WORDS STAY VISIBLE", next: "response-ready", label: "Show response" },
  "response-ready": { action: "SPEAK AGAIN", status: "RESPONSE READY · YOU CAN ADD MORE CONTEXT", panel: "READY", caption: "READY FOR WHAT COMES NEXT", next: "listening", label: "Speak again" }
};

let state = "ready";
let selectedInput = null;

function setState(nextState) {
  state = nextState;
  const config = states[state];
  surface.dataset.state = state;
  talkButton.dataset.state = state;
  talkButton.setAttribute("aria-pressed", String(state === "listening"));
  talkButton.setAttribute("aria-label", config.label);
  voiceActionLabel.textContent = config.action;
  statusRegion.textContent = config.status;
  panel.setAttribute("aria-label", `Telivu is ${config.panel.toLowerCase()}`);
  panelState.innerHTML = `<b aria-hidden="true"></b>${config.panel}`;
  panelCaption.textContent = config.caption;
  responseRegion.hidden = state !== "response-ready";
}

function displayName(name) { return name.length > 25 ? `${name.slice(0, 22)}…` : name; }

function showAttachment(file, kind) {
  selectedInput = kind;
  attachmentLabel.textContent = `${kind === "image" ? "IMAGE" : "FILE"} SELECTED · ${displayName(file.name)}`;
  attachmentSummary.hidden = false;
  statusRegion.textContent = "ATTACHMENT ADDED LOCALLY · TAP TO TALK WHEN READY";
}

talkButton.addEventListener("click", () => setState(states[state].next));
document.querySelector("#add-image").addEventListener("click", () => imageInput.click());
document.querySelector("#add-file").addEventListener("click", () => fileInput.click());
document.querySelector("#language-button").addEventListener("click", () => { statusRegion.textContent = "ENGLISH IS THE DEMO LANGUAGE"; });
document.querySelector("#remove-attachment").addEventListener("click", () => {
  attachmentSummary.hidden = true;
  imageInput.value = "";
  fileInput.value = "";
  selectedInput = null;
  statusRegion.textContent = "ATTACHMENT REMOVED · TAP TO TALK WHEN READY";
});
document.querySelector("#replace-attachment").addEventListener("click", () => (selectedInput === "image" ? imageInput : fileInput).click());
imageInput.addEventListener("change", () => imageInput.files?.[0] && showAttachment(imageInput.files[0], "image"));
fileInput.addEventListener("change", () => fileInput.files?.[0] && showAttachment(fileInput.files[0], "file"));
setState("ready");
