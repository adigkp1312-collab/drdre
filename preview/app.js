const card = document.querySelector(".phone-card");
const voiceMap = document.querySelector("#voice-map");
const talkButtons = [document.querySelector("#talk-button"), document.querySelector("#rail-control")];
const mapStatus = document.querySelector("#map-status");
const talkLabel = document.querySelector("#talk-label");
const responseCopy = document.querySelector("#response-copy");
const selectionNotice = document.querySelector("#selection-notice");
const imageInput = document.querySelector("#image-input");
const fileInput = document.querySelector("#file-input");

let isListening = false;
let noticeTimer = null;

function setListening(nextValue) {
  isListening = nextValue;
  card.classList.toggle("listening", isListening);
  talkButtons.forEach((button) => {
    button.setAttribute("aria-pressed", String(isListening));
    button.setAttribute("aria-label", isListening ? "Stop listening" : "Tap to talk");
  });
  voiceMap.setAttribute("aria-label", isListening ? "Telivu is listening" : "Telivu is ready to listen");
  mapStatus.innerHTML = isListening ? "<i></i>Listening" : "<i></i>Ready";
  talkLabel.textContent = isListening ? "Tap to stop" : "Your voice";
  responseCopy.textContent = isListening ? "Take your time. I’m listening." : "Take your time. I’m ready.";
}

function showSelection(file) {
  window.clearTimeout(noticeTimer);
  const safeName = file.name.length > 24 ? `${file.name.slice(0, 21)}…` : file.name;
  selectionNotice.textContent = `Selected locally · ${safeName}`;
  selectionNotice.classList.add("visible");
  noticeTimer = window.setTimeout(() => selectionNotice.classList.remove("visible"), 3200);
}

talkButtons.forEach((button) => button.addEventListener("click", () => setListening(!isListening)));
document.querySelector("#add-image").addEventListener("click", () => imageInput.click());
document.querySelector("#add-file").addEventListener("click", () => fileInput.click());
imageInput.addEventListener("change", () => imageInput.files?.[0] && showSelection(imageInput.files[0]));
fileInput.addEventListener("change", () => fileInput.files?.[0] && showSelection(fileInput.files[0]));
