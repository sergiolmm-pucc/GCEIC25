const { Builder, By, Key, until } = require('selenium-webdriver');
const fs = require('fs');
const path = require('path');

const URL_APP = 'http://localhost:8080'; // Ajuste para a URL correta do seu app
const TIMEOUT = 15000;

(async () => {
  const driver = await new Builder().forBrowser('chrome').build();
  try {
    // Splash/Login
    await driver.get(URL_APP);
    await pause(4000);
    await saveShot(driver, '01_splash.png');

    // Login
    await driver.wait(until.elementLocated(By.xpath("//input[@label='Usuário' or @aria-label='Usuário']")), TIMEOUT);
    await saveShot(driver, '02_login_vazio.png');
    await driver.findElement(By.xpath("//input[@label='Usuário' or @aria-label='Usuário']")).sendKeys('user');
    await driver.findElement(By.xpath("//input[@label='Senha' or @aria-label='Senha']")).sendKeys('1234');
    await saveShot(driver, '03_login_preenchido.png');
    await driver.findElement(By.xpath("//button[contains(.,'Log in') or contains(.,'Entrar') or contains(.,'Log In') or contains(.,'Login') or contains(.,'LOG IN') or contains(.,'LOGAR') or contains(.,'log in') or contains(.,'logar') or contains(.,'Acessar') or contains(.,'Acessar')]" )).click();
    await driver.wait(until.elementLocated(By.xpath("//*[contains(text(),'Escolha uma opção') or contains(text(),'Validar CPF')]")), TIMEOUT);
    await saveShot(driver, '04_home.png');

    // CPF
    await clickByText(driver, 'Validar CPF');
    await saveShot(driver, '05_cpf_vazio.png');
    await fillInput(driver, 'CPF', '52998224725');
    await saveShot(driver, '06_cpf_preenchido.png');
    await clickByText(driver, 'Validar');
    await pause(1000);
    await saveShot(driver, '07_cpf_resultado.png');
    await driver.navigate().back();
    await pause(1000);

    // CNH
    await clickByText(driver, 'Validar CNH');
    await saveShot(driver, '08_cnh_vazio.png');
    await fillInput(driver, 'CNH', '12345678900');
    await saveShot(driver, '09_cnh_preenchido.png');
    await clickByText(driver, 'Validar');
    await pause(1000);
    await saveShot(driver, '10_cnh_resultado.png');
    await driver.navigate().back();
    await pause(1000);

    // Cálculo de Seguro
    await clickByText(driver, 'Calcular Seguro');
    await saveShot(driver, '11_premium_vazio.png');
    await fillInput(driver, 'Ano', '2020');
    await fillInput(driver, 'Marca', 'Toyota');
    await fillInput(driver, 'Modelo', 'Corolla');
    await fillInput(driver, 'Idade', '30');
    await fillInput(driver, 'Tempo', '10');
    await saveShot(driver, '12_premium_preenchido.png');
    await clickByText(driver, 'Calcular');
    await pause(1000);
    await saveShot(driver, '13_premium_resultado.png');
    await driver.navigate().back();
    await pause(1000);

    // Sobre
    await clickByText(driver, 'Sobre');
    await saveShot(driver, '14_sobre.png');
    await driver.navigate().back();
    await pause(1000);

    console.log('✅ Fluxo COMPLETO – prints em fotos/Equipe04');
  } finally {
    await pause(2000);
    await driver.quit();
  }
})();

async function pause(ms = 1000) {
  return new Promise(res => setTimeout(res, ms));
}

async function saveShot(driver, name) {
  const dir = './fotos/Equipe04';
  if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });
  fs.writeFileSync(
    path.join(dir, name),
    await driver.takeScreenshot(),
    'base64'
  );
  await pause(500);
}

async function clickByText(driver, text) {
  const el = await driver.wait(
    until.elementLocated(By.xpath(`//*[contains(text(),'${text}')]`)), TIMEOUT
  );
  await driver.executeScript('arguments[0].scrollIntoView({block:"center"})', el);
  await el.click();
  await pause(500);
}

async function fillInput(driver, label, value) {
  // Tenta por label, placeholder ou aria-label
  const input = await driver.findElement(
    By.xpath(`//input[contains(@label,'${label}') or contains(@aria-label,'${label}') or contains(@placeholder,'${label}')]`)
  );
  await input.clear();
  await input.sendKeys(value);
  await pause(300);
} 