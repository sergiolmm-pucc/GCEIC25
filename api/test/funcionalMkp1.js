const { Builder, By, until } = require('selenium-webdriver');
// const { FlutterSeleniumBridge } = require('@rentready/flutter-selenium-bridge');
const { Options } = require('selenium-webdriver/chrome');
const fs = require('fs');

(async () => {
  const screen = { width: 1280, height: 800 };
  const chromeOptions = new Options();
  chromeOptions.addArguments('--headless');
  chromeOptions.addArguments('--no-sandbox');
  chromeOptions.windowSize(screen);

  const builder = new Builder()
    .forBrowser('chrome')
    .setChromeOptions(chromeOptions);

  let driver = await builder.build();
  //const bridge = new FlutterSeleniumBridge(driver);

  // Altere para a URL do seu app Flutter Web
  await driver.get('http://localhost:8000/'); // ou a URL de produção
  await driver.sleep(5000);

  // Clicar no botão Calculadora de Markup na tela inicial
  await driver.wait(until.elementLocated(By.xpath("//flt-semantics[@aria-label='Botão Calculadora de Markup']")), 10000);
  const markupBtn = await driver.findElement(By.xpath("//flt-semantics[@aria-label='Botão Calculadora de Markup']"));
  await markupBtn.click();
  await driver.sleep(10000); // Espera a splash carregar

  // Acessar Sobre
  await driver.wait(until.elementLocated(By.xpath("//flt-semantics[@aria-label='Botão Sobre']")), 10000);
  const sobreBtn = await driver.findElement(By.xpath("//flt-semantics[@aria-label='Botão Sobre']"));
  await sobreBtn.click();
  await driver.sleep(2000);
  await driver.takeScreenshot().then(image => {
    fs.writeFileSync('./fotos/mkp1/sobre.png', image, 'base64');
  });
  // Voltar para login
  await driver.navigate().back();
  await driver.sleep(4000);

  // Acessar Ajuda
  await driver.wait(until.elementLocated(By.xpath("//flt-semantics[@aria-label='Botão Ajuda']")), 10000);
  const ajudaBtn = await driver.findElement(By.xpath("//flt-semantics[@aria-label='Botão Ajuda']"));
  await ajudaBtn.click();
  await driver.sleep(2000);
  await driver.takeScreenshot().then(image => {
    fs.writeFileSync('./fotos/mkp1/ajuda.png', image, 'base64');
  });
  // Voltar para login
  await driver.navigate().back();
  await driver.sleep(4000);

  // Screenshot da tela de login
  await driver.takeScreenshot().then(image => {
    fs.writeFileSync('./fotos/mkp1/login.png', image, 'base64');
  });
  await driver.sleep(1000);

  // Preencher usuário
  await driver.wait(until.elementLocated(By.xpath("//flt-semantics[@aria-label='Campo Usuário']//input")), 8000);
  const usuarioInput = await driver.findElement(By.xpath("//flt-semantics[@aria-label='Campo Usuário']//input"));
  await usuarioInput.sendKeys('admin');
  await driver.sleep(500);

  // Preencher senha
  await driver.wait(until.elementLocated(By.xpath("//flt-semantics[@aria-label='Campo Senha']//input")), 10000);
  const senhaInput = await driver.findElement(By.xpath("//flt-semantics[@aria-label='Campo Senha']//input"));
  await senhaInput.sendKeys('admin');
  await driver.sleep(500);

  // Screenshot após preencher login
  await driver.takeScreenshot().then(image => {
    fs.writeFileSync('./fotos/mkp1/login_preenchido.png', image, 'base64');
  });
  await driver.sleep(1000);

  // Clicar no botão Entrar
  await driver.wait(until.elementLocated(By.xpath("//flt-semantics[@aria-label='Botão Entrar']")), 10000);
  const entrarBtn = await driver.findElement(By.xpath("//flt-semantics[@aria-label='Botão Entrar']"));
  await entrarBtn.click();
  await driver.sleep(6000); // aguarda splash/login

  // Screenshot da tela principal de cálculo
  await driver.takeScreenshot().then(image => {
    fs.writeFileSync('./fotos/mkp1/home.png', image, 'base64');
  });
  await driver.sleep(1000);

  // Preencher campos do cálculo simples
  await driver.wait(until.elementLocated(By.xpath("//flt-semantics[@aria-label='Campo Custo do Produto']//input")), 10000);
  const custoInput = await driver.findElement(By.xpath("//flt-semantics[@aria-label='Campo Custo do Produto']//input"));
  await custoInput.sendKeys('100');
  await driver.sleep(500);
  await driver.wait(until.elementLocated(By.xpath("//flt-semantics[@aria-label='Campo Lucro Desejado']//input")), 10000);
  const lucroInput = await driver.findElement(By.xpath("//flt-semantics[@aria-label='Campo Lucro Desejado']//input"));
  await lucroInput.sendKeys('50');
  await driver.sleep(500);

  // Screenshot antes de calcular
  await driver.takeScreenshot().then(image => {
    fs.writeFileSync('./fotos/mkp1/pre_calculo.png', image, 'base64');
  });
  await driver.sleep(1000);

  // Clicar no botão Calcular
  await driver.wait(until.elementLocated(By.xpath("//flt-semantics[@aria-label='Botão Calcular']")), 10000);
  const calcularBtn = await driver.findElement(By.xpath("//flt-semantics[@aria-label='Botão Calcular']"));
  await calcularBtn.click();
  await driver.sleep(3000);

  // Screenshot do resultado
  await driver.takeScreenshot().then(image => {
    fs.writeFileSync('./fotos/mkp1/resultado.png', image, 'base64');
  });

  await driver.quit();
})();