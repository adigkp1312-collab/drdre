const talkButton = document.querySelector("#talk-button");
const avatarStage = document.querySelector("#avatar-stage");
const stageState = document.querySelector("#stage-state");
const avatarCaption = document.querySelector("#avatar-caption");
const supportCopy = document.querySelector("#support-copy");
const talkInstruction = document.querySelector("#talk-instruction");
const selectionNotice = document.querySelector("#selection-notice");
const imageInput = document.querySelector("#image-input");
const fileInput = document.querySelector("#file-input");

let isListening = false;
let noticeTimer = null;

function setListening(nextValue) {
  isListening = nextValue;
  avatarStage.classList.toggle("listening", isListening);
  talkButton.classList.toggle("listening", isListening);
  talkButton.setAttribute("aria-pressed", String(isListening));
  talkButton.setAttribute("aria-label", isListening ? "Stop listening" : "Tap to talk");
  avatarStage.setAttribute("aria-label", isListening ? "Telivu is listening" : "Telivu is ready to listen");
  stageState.textContent = isListening ? "LISTENING" : "READY";
  avatarCaption.textContent = isListening ? "I’M LISTENING · TAKE YOUR TIME" : "READY WHEN YOU ARE";
  supportCopy.textContent = isListening ? "Speak in your own words. You can pause whenever you need." : "Speak naturally. Add a photo or report if it helps.";
  talkInstruction.innerHTML = isListening ? "<strong>TAP TO STOP</strong><span>Listening now</span>" : "<strong>TAP TO TALK</strong><span>English · captions on</span>";
}

function showSelection(file) {
  window.clearTimeout(noticeTimer);
  const safeName = file.name.length > 24 ? `${file.name.slice(0, 21)}…` : file.name;
  selectionNotice.textContent = `SELECTED LOCALLY · ${safeName}`;
  selectionNotice.classList.add("visible");
  noticeTimer = window.setTimeout(() => selectionNotice.classList.remove("visible"), 3200);
}

talkButton.addEventListener("click", () => setListening(!isListening));
document.querySelector("#add-image").addEventListener("click", () => imageInput.click());
document.querySelector("#add-file").addEventListener("click", () => fileInput.click());
imageInput.addEventListener("change", () => imageInput.files?.[0] && showSelection(imageInput.files[0]));
fileInput.addEventListener("change", () => fileInput.files?.[0] && showSelection(fileInput.files[0]));
