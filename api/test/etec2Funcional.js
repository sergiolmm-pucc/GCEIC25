const { Builder, By, Key, until } = require('selenium-webdriver');
const { Options } = require('selenium-webdriver/chrome');
const fs = require('fs');
const path = require('path');

const URL_APP = 'http://localhost:8080';
const TIMEOUT = 15000;
const STEP_DELAY = 1500;

(async () => {
  const driver = await new Builder()
    .forBrowser('chrome')
    .setChromeOptions(new Options().windowSize({ width: 1280, height: 800 }))
    .build();

  try {
    // Abre app
    await driver.get(URL_APP);
    await pause(7000);

    // Splash screen - texto "Carregando..."
    await findBy(driver, [
      By.xpath("//*[normalize-space(text())='Carregando...']")
    ]);
    await saveShot(driver, '00_splash.png');
    await pause(2000);

    // Login
    const email = await findBy(driver, [By.xpath("//*[contains(@aria-label, 'Email')]"), By.xpath("//*[contains(text(),'Email')]")]);
    const senha = await findBy(driver, [By.xpath("//*[contains(@aria-label, 'Senha')]"), By.xpath("//*[contains(text(),'Senha')]")]);
    await email.sendKeys('admin@email.com');
    await senha.sendKeys('admin');
    await saveShot(driver, '01_login_preenchido.png');

    await clickBy(driver, [
      By.xpath("//*[contains(@aria-label, 'Entrar') or text()='Entrar']")
    ]);
    await pause(2000);

    // Home > Grupo de Fotos
    await clickBy(driver, [By.xpath("//*[contains(text(),'Grupo de Fotos')]")]);
    await pause(2000);
    await saveShot(driver, '02_fotos.png');

    // Voltar
    await driver.navigate().back();
    await pause(1000);

    // Home > Calculadora
    await clickBy(driver, [By.xpath("//*[contains(text(),'Ir para Calculadora')]")]);
    await fillField(driver, 'Valor', '123');
    await saveShot(driver, '03_calcular_preenchido.png');

    await clickBy(driver, [By.xpath("//*[contains(text(),'Calcular')]")]);
    await pause(2000);
    await saveShot(driver, '04_calculado.png');

    console.log('✅ Teste funcional completo!');
  } finally {
    await pause(2000);
    await driver.quit();
  }
})();

// === utils ===

async function pause(ms = STEP_DELAY) {
  return new Promise(res => setTimeout(res, ms));
}

async function findBy(driver, selectors) {
  for (const sel of selectors) {
    try {
      const el = await driver.wait(until.elementLocated(sel), TIMEOUT);
      await driver.wait(until.elementIsVisible(el), TIMEOUT);
      return el;
    } catch (_) {}
  }
  throw new Error(`Elemento não encontrado: ${selectors[0]}`);
}

async function clickBy(driver, selectors) {
  const el = await findBy(driver, selectors);
  await driver.executeScript(
    'arguments[0].scrollIntoView({block:"center"})', el
  );
  await el.click();
  await pause();
}

async function fillField(driver, label, value) {
  const input = await findBy(driver, [
    By.css(`input[aria-label="${label}"]:not([disabled])`),
    By.xpath(`//input[@aria-label="${label}"]`),
    By.xpath(`//*[contains(text(),"${label}")]/following::input[1]`)
  ]);
  await driver.executeScript(
    'arguments[0].scrollIntoView({block:"center"})', input
  );
  await input.sendKeys(Key.chord(Key.CONTROL, 'a', Key.DELETE));
  await input.sendKeys(value);
  await pause();
}

async function saveShot(driver, name) {
  const dir = './fotos/CI_CD_10';
  if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });
  fs.writeFileSync(
    path.join(dir, name),
    await driver.takeScreenshot(),
    'base64'
  );
  await pause();
}