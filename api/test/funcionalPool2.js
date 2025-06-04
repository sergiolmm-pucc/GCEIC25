const { Builder, By, until } = require('selenium-webdriver');
const { Options } = require('selenium-webdriver/chrome');
const fs = require('fs');

(async () => {
  const chromeOptions = new Options()
    .addArguments('--headless')
    .addArguments('--no-sandbox')
    .windowSize({ width: 1024, height: 720 });

  const driver = await new Builder()
    .forBrowser('chrome')
    .setChromeOptions(chromeOptions)
    .build();

  try {
    await driver.get('http://localhost:54923/'); 

    // 1. Clica no botão "Grupo 2 - Cálculo Piscina"
    const grupo2Button = await driver.wait(
      until.elementLocated(By.xpath("//flt-semantics[text()='Grupo 2 - Cálculo Piscina']")),
      10000
    );
    await grupo2Button.click();

    // 2. Aguarda splash screen
    await driver.sleep(1000);
    let image = await driver.takeScreenshot();
    fs.writeFileSync('../fotos/Pool2/splash_screen.png', image, 'base64');

    // 3. Aguarda login aparecer
    await driver.wait(until.elementLocated(By.xpath("//flt-semantics[text()='LOGIN']")), 10000);

    // Aguarda campos de input carregarem
    const inputs = await driver.findElements(By.css('input'));
    
    // === LOGIN INVÁLIDO ===
    await inputs[0].sendKeys('errado@teste.com'); // email
    await inputs[1].sendKeys('invalida'); // senha

    // Clica no botão de login
    const botaoLogin = await driver.findElement(By.xpath("//flt-semantics[text()='LOGIN']"));
    await botaoLogin.click();

    // Aguarda mensagem de erro (ajuste se o seletor for diferente)
    await driver.sleep(3000); // ou usar wait + By.css se possível

    image = await driver.takeScreenshot();
    fs.writeFileSync('../fotos/Pool2/login_invalido.png', image, 'base64');
    console.log('Screenshot de login inválido salva.');

    // === LOGIN VÁLIDO ===
    await inputs[0].clear();
    await inputs[1].clear();
    await inputs[0].sendKeys('adm@adm.com');
    await inputs[1].sendKeys('adm');

    image = await driver.takeScreenshot();
    fs.writeFileSync('../fotos/Pool2/login_preenchido.png', image, 'base64');

    await botaoLogin.click();

    // Aguarda Home
    await driver.wait(until.elementLocated(By.xpath("//flt-semantics[text()='Nova Consulta']")), 10000);
    image = await driver.takeScreenshot();
    fs.writeFileSync('../fotos/Pool2/home.png', image, 'base64');

    console.log('Teste concluído com sucesso.');

  } finally {
    await driver.quit();
  }
})();
