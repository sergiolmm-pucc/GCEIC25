const { Builder } = require('selenium-webdriver');
const { FlutterSeleniumBridge } = require('@rentready/flutter-selenium-bridge');
const { Browser, By, Key, until } = require('selenium-webdriver');
const { Options } = require('selenium-webdriver/chrome');
const fs = require('fs');

(async () => {
  const screen = { width: 1024, height: 720 };
  const chromeOptions = new Options();
  chromeOptions.addArguments('--no-sandbox');
  chromeOptions.windowSize(screen);

  const builder = new Builder()
    .forBrowser('chrome')
    .setChromeOptions(chromeOptions);

  let driver = await builder.build();
  const bridge = new FlutterSeleniumBridge(driver);


  console.log('https://sergio.dev.br/');
  //await driver.get('https://sergio.dev.br/'); // Replace with your Flutter Web app URL
  await driver.get('http://localhost:3030/'); // Replace with your Flutter Web app URL
  //await bridge.enableAccessibility();
  // Wait for 5 secs to let the dynamic content to load
  await driver.sleep(10000);

  // Clica no botão do grupo CI_CD_10
  const botaoGrupo = await driver.findElement(By.css('flt-semantics[aria-label="Botao CI_CD_10"]'));
  await driver.executeScript("arguments[0].scrollIntoView({block: 'center'});", botaoGrupo);
  await takeShot(driver, '01_botao_CI_CD_10.png');
  await botaoGrupo.click();
  await driver.sleep(3000);
  

  // Aguarda splash
  await takeShot(driver, '02_splash.png');
  await driver.sleep(5000);
  await takeShot(driver, '03_login_vazio.png');
  // Login
  await driver.sleep(5000);
  const inputs = await driver.findElements(By.css('input'));
  await inputs[0].sendKeys('admin@gmail.com'); // campo de email
  await inputs[1].sendKeys('admin');  

  await takeShot(driver, '03_login_preenchido.png');

  const btnEntrar = await driver.findElement(By.css('flt-semantics[aria-label="Botao Entrar"]'));

  await btnEntrar.click();
  await driver.sleep(3000);
  await takeShot(driver, '04_home.png');

  // Grupo de Fotos
  const btnFotos = await driver.findElement(By.xpath("//*[contains(text(),'Grupo de Fotos')]"));
  await btnFotos.click();
  await driver.sleep(2000);
  await takeShot(driver, '05_fotos.png');
  await driver.navigate().back();
  await driver.sleep(1000);

  // Calculadora
  const btnCalc = await driver.findElement(By.xpath("//*[contains(text(),'Ir para Calculadora')]"));
  await btnCalc.click();
  await driver.sleep(1000);
  const inputValor = await driver.findElement(By.xpath("//label[text()='Valor']/following::input[1]"));
  await inputValor.sendKeys('123');
  await takeShot(driver, '06_valor_preenchido.png');

  const btnCalcular = await driver.findElement(By.xpath("//*[contains(text(),'Calcular')]"));
  await btnCalcular.click();
  await driver.sleep(2000);
  await takeShot(driver, '07_resultado.png');

  await driver.quit();
})();

async function takeShot(driver, name) {
  const dir = 'fotos/CI_CD_10';  // agora salva direto em api/fotos/CI_CD_10
  const fs = require('fs');
  const path = require('path');

  const fullPath = path.join(__dirname, '..', dir); // resolve como ../fotos/CI_CD_10

  if (!fs.existsSync(fullPath)) fs.mkdirSync(fullPath, { recursive: true });

  const image = await driver.takeScreenshot();
  fs.writeFileSync(path.join(fullPath, name), image, 'base64');
}
