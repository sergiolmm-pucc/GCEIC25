const { Builder, By } = require('selenium-webdriver');
const { FlutterSeleniumBridge } = require('@rentready/flutter-selenium-bridge');
const { Options } = require('selenium-webdriver/chrome');
const fs = require('fs');

(async () => {
  const screen = { width: 1280, height: 800 };

  const chromeOptions = new Options();
  chromeOptions.addArguments('--headless');
  chromeOptions.addArguments('--no-sandbox');
  chromeOptions.windowSize(screen);

  const driver = await new Builder()
    .forBrowser('chrome')
    .setChromeOptions(chromeOptions)
    .build();

  const bridge = new FlutterSeleniumBridge(driver);

  // Helper para tirar e salvar print
  async function takeScreenshot(nomeArquivo) {
    const image = await driver.takeScreenshot();
    fs.writeFileSync(`../fotos/markup11/${nomeArquivo}`, image, 'base64');
    console.log(`✅ Screenshot salva: ${nomeArquivo}`);
  }

  try {
    // Acesso inicial
    console.log('🌐 Acessando /');
    await driver.get('https://sergio.dev.br/');
     await driver.sleep(10000);
    await takeScreenshot('01-home.png');

    // Splash screen
    console.log('🌐 Acessando /markupSplashScreen');
    await driver.get('https://sergio.dev.br/#/markupSplashScreen');
    await driver.sleep(5000);
    await takeScreenshot('02-splashscreen.png');

    // Tela principal de markup
    console.log('Acessando /markup');
    await driver.get('https://sergio.dev.br/#/markup');
    await driver.sleep(10000); // aguardar renderização completa
    await takeScreenshot('03-markup.png');

    // Abrindo página "Sobre o App"
    console.log('Clicando em "Sobre o App"');
    const sobreButtonXPath = "//flt-semantics[text()='Sobre o App']";
    const sobreButton = await driver.findElement(By.xpath(sobreButtonXPath));
    await sobreButton.click();

    await driver.sleep(8000); // tempo para carregar a nova rota
    await takeScreenshot('04-sobre-o-app.png');

  } catch (error) {
    console.error('Erro durante execução:', error);
  } finally {
    await driver.quit();
  }
})();
