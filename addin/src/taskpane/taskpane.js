const HELPER_URL = "http://127.0.0.1:7643";

Office.onReady((info) => {
  if (info.host === Office.HostType.Word) {
    document.getElementById("scan-button").disabled = false;
    document.getElementById("scan-button").onclick = scan;
  }
});

async function scan() {
  const button = document.getElementById("scan-button");
  const status = document.getElementById("status");

  button.disabled = true;
  status.textContent = "Scanning…";

  try {
    const response = await fetch(`${HELPER_URL}/scan`, { method: "POST" });

    if (response.status === 409) {
      status.textContent = "Scan cancelled.";
      return;
    }

    if (!response.ok) {
      const problem = await response.json().catch(() => null);
      status.textContent = `Scan failed: ${problem?.detail ?? response.statusText}`;
      return;
    }

    const { imageBase64 } = await response.json();
    await insertImageAtLastSelection(imageBase64);
    status.textContent = "Image inserted.";
  } catch (err) {
    status.textContent =
      "Could not reach the scan helper. Is it running on 127.0.0.1:7643?";
    console.error(err);
  } finally {
    button.disabled = false;
  }
}

async function insertImageAtLastSelection(imageBase64) {
  await Word.run(async (context) => {
    const selection = context.document.getSelection();
    selection.insertInlinePictureFromBase64(imageBase64, Word.InsertLocation.replace);
    await context.sync();
  });
}
