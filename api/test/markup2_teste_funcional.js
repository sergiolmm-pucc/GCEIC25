// tests/markup2_teste_funcional.js
const { Builder, By, Key, until } = require('selenium-webdriver');
const { Options }                 = require('selenium-webdriver/chrome');
const fs   = require('fs');
const path = require('path');

const URL_APP    = 'http://localhost:8080';
const TIMEOUT    = 15_000;
const STEP_DELAY = 1_500;

(async () => {
  const driver = await new Builder()
    .forBrowser('chrome')
    .setChromeOptions(
      new Options().windowSize({ width: 1280, height: 800 })
    )
    .build();

  try {
    /* ---------- abre app ---------- */
    await driver.get(URL_APP);
    await pause(7_000);

    /* ---------- navega até login ---------- */
    await clickBy(driver, [
      By.css('flt-semantics[role="button"][aria-label="Grupo CI_CD_8"]'),
      By.xpath('//*[@aria-label="Grupo CI_CD_8"]')
    ]);
    await waitUrlContains(driver, '/#/CI_CD_8');

    /* ---------- Slash screen --------- */

    // 1. aguarda o texto da splash (“Carregando...”) aparecer
    const splashText = await findBy(driver, [
    By.xpath("//*[normalize-space(text())='Carregando...']"),
    By.css('flt-semantics[aria-label="Carregando..."]')
    ]);

    // 2. print da splash
    await saveShot(driver, '00_splash.png');

    // 3. mantém a tela visível por ~2 s
    await pause(2_000);

    // 4. espera sair da splash → campo Email aparecer
    await driver.wait(
    until.elementLocated(By.css('[aria-label="Email"]')),
    TIMEOUT,
    'Login não apareceu após a splash'
    );

    /* ---------- login ---------- */
    const email = await findBy(driver, [By.css('[aria-label="Email"]')]);
    const senha = await findBy(driver, [By.css('[aria-label="Senha"]')]);
    await email.sendKeys('admin@email.com');
    await senha.sendKeys('123456');
    await saveShot(driver, '01_login_preenchido.png');

    await clickBy(driver, [
      By.css('flt-semantics[role="button"][aria-label="Entrar"]')
    ]);
    await driver.wait(until.stalenessOf(email), TIMEOUT);

    /* ---------- Calculadora de Markup (multiplicador) ---------- */
    await clickBy(driver, [
      By.css('flt-semantics[role="button"][aria-label="Calculadora de Markup"]')
    ]);
    await fillField(driver, 'Despesas Variáveis', '100');
    await fillField(driver, 'Despesas Fixas',     '20');
    await fillField(driver, 'Margem de Lucro',    '30');
    await saveShot(driver, '02_multip_campos.png');

    await clickBy(driver, [
      By.css('flt-semantics[role="button"][aria-label="Calculate"]')
    ]);
    await driver.wait(
      until.elementLocated(
        By.xpath("//*[contains(text(),'Multiplicador do Markup')]")
      ),
      TIMEOUT
    );
    await saveShot(driver, '03_multip_resultado.png');

    /* ---------- volta p/ Home ---------- */
    await clickBy(driver, [By.css('flt-semantics[role="button"][aria-label="Back"]')]);
    await driver.wait(
      until.elementLocated(
        By.css('flt-semantics[role="button"][aria-label="Calculadora de Divisão de Markup"]')
      ),
      TIMEOUT
    );
    await saveShot(driver, '04_home_de_novo.png');

    /* ---------- Calculadora de Divisão de Markup ---------- */
    await clickBy(driver, [
      By.css('flt-semantics[role="button"][aria-label="Calculadora de Divisão de Markup"]')
    ]);

    await fillField(driver, 'Preço de Venda',            '250');
    await fillField(driver, 'Custo Total de Vendas',     '180');
    await saveShot(driver, '05_divisor_campos.png');

    await clickBy(driver, [
      By.css('flt-semantics[role="button"][aria-label="Calculate"]')
    ]);
    await driver.wait(
      until.elementLocated(
        By.xpath("//*[contains(text(),'Divisor do Markup')]")
      ),
      TIMEOUT
    );
    await saveShot(driver, '06_divisor_resultado.png');

    /* ---------- volta p/ Home outra vez ---------- */
    await clickBy(driver, [By.css('flt-semantics[role="button"][aria-label="Back"]')]);
    await driver.wait(
      until.elementLocated(
        By.css('flt-semantics[role="button"][aria-label="Calculadora de Markup"]')
      ),
      TIMEOUT
    );
    await saveShot(driver, '07_home_final.png');

    /* ---------- SOBRE ---------- */
    await clickBy(driver, [
      By.css('flt-semantics[role="button"][aria-label="Sobre"]'),
      By.xpath("//*[normalize-space(text())='Sobre']")
    ]);

    // localiza o botão “Carregar Informações”
    const btnCarregar = await findBy(driver, [
      By.css('flt-semantics[role="button"][aria-label="Carregar Informações"]'),
      By.xpath("//button[normalize-space(.)='Carregar Informações']"),
      By.xpath("//*[normalize-space(text())='Carregar Informações']")
    ]);

    // clica e faz print imediato (estado “Buscando dados…”)
    await btnCarregar.click();
    await pause(1_000);                           // deixa o loader aparecer
    await saveShot(driver, '08_sobre_loading.png');

    // aguarda no máximo 10 s para os dados chegarem (sem checar texto)
    await pause(10_000);
    await saveShot(driver, '09_sobre_dados.png');

    console.log('✅ Fluxo COMPLETO – prints em fotos/markup2');
  } finally {
    await pause(2_000);
    await driver.quit();
  }
})();

/* ===== utils ===== */

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
    By.css(`input[aria-label="${label} (%)"]:not([disabled])`)
  ]);
  await driver.executeScript(
    'arguments[0].scrollIntoView({block:"center"})', input
  );
  await input.sendKeys(Key.chord(Key.CONTROL, 'a', Key.DELETE));
  await input.sendKeys(value);
  await pause();
}

async function waitUrlContains(driver, frag) {
  await driver.wait(
    async () => (await driver.getCurrentUrl()).includes(frag),
    TIMEOUT
  );
  await pause();
}

async function saveShot(driver, name) {
  const dir = './fotos/markup2';
  if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });
  fs.writeFileSync(
    path.join(dir, name),
    await driver.takeScreenshot(),
    'base64'
  );
  await pause();
}