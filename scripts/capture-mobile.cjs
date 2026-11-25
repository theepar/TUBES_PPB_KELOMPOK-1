const fs = require('node:fs');

async function capture() {
  const response = await fetch('http://127.0.0.1:9222/json/new?about:blank', { method: 'PUT' });
  const page = await response.json();
  const socket = new WebSocket(page.webSocketDebuggerUrl);
  await new Promise(resolve => socket.addEventListener('open', resolve, { once: true }));
  let nextId = 0;
  const pending = new Map();
  const errors = [];
  socket.addEventListener('message', event => {
    const message = JSON.parse(event.data);
    if (message.id) {
      const request = pending.get(message.id);
      if (!request) return;
      pending.delete(message.id);
      if (message.error) request.reject(new Error(message.error.message));
      else request.resolve(message.result);
    } else if (message.method === 'Runtime.exceptionThrown') {
      errors.push(message.params.exceptionDetails);
    }
  });
  function send(method, params = {}) {
    return new Promise((resolve, reject) => {
      const id = ++nextId;
      pending.set(id, { resolve, reject });
      socket.send(JSON.stringify({ id, method, params }));
    });
  }
  try {
    await send('Runtime.enable');
    await send('Page.enable');
    await send('Emulation.setDeviceMetricsOverride', {
      width: 390, height: 844, deviceScaleFactor: 1, mobile: true,
    });
    await send('Page.addScriptToEvaluateOnNewDocument', {
      source: "window.screenshotReady = false; window.addEventListener('flutter-first-frame', () => { window.screenshotReady = true; });",
    });
    await send('Page.navigate', { url: 'http://127.0.0.1:5178' });
    let ready = false;
    for (let attempt = 0; attempt < 100; attempt++) {
      await new Promise(resolve => setTimeout(resolve, 200));
      const result = await send('Runtime.evaluate', { expression: 'window.screenshotReady === true', returnByValue: true });
      if (result.result.value) { ready = true; break; }
      if (errors.length) throw new Error(JSON.stringify(errors));
    }
    if (!ready) throw new Error('Flutter did not render its first frame within 20 seconds.');
    await new Promise(resolve => setTimeout(resolve, 500));
    const screenshot = await send('Page.captureScreenshot', { format: 'png', captureBeyondViewport: false });
    fs.mkdirSync('artifacts/screenshots', { recursive: true });
    fs.writeFileSync('artifacts/screenshots/login.png', Buffer.from(screenshot.data, 'base64'));
    console.log('Saved artifacts/screenshots/login.png at 390 x 844 after Flutter rendered.');
  } finally {
    socket.close();
  }
}

capture().catch(error => { console.error(error.message); process.exitCode = 1; });
