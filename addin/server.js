const https = require("https");
const express = require("express");
const path = require("path");
const devCerts = require("office-addin-dev-certs");

const PORT = 3000;

async function main() {
  const httpsOptions = await devCerts.getHttpsServerOptions();

  const app = express();
  app.use(express.static(__dirname));

  https.createServer(httpsOptions, app).listen(PORT, () => {
    console.log(`Add-in dev server running at https://localhost:${PORT}`);
  });
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
