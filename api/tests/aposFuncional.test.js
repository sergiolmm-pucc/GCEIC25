const { Builder } = require('selenium-webdriver');
const { FlutterSeleniumBridge } = require('@rentready/flutter-selenium-bridge');
const { Browser, By, Key, until } = require('selenium-webdriver');
const { Options } = require('selenium-webdriver/chrome');

(async () => {
  // Configuração do ambiente do WebDriver e opções do navegador
  const screen = {
    width: 1024,
    height: 720
  };

  console.log('Config chrome');
  const chromeOptions = new Options();
  // comentar as linhas abaixo quando for subir para teste local
  //  chromeOptions.addArguments('--headless');
  //  chromeOptions.addArguments('--no-sandbox');
  //  chromeOptions.windowSize(screen);

  console.log('ini builder');
  const builder = new Builder()
    .forBrowser('chrome')
    .setChromeOptions(chromeOptions);

  // Criação da instância do WebDriver
  console.log('driver creation');
  let driver = await builder.build();

  const bridge = new FlutterSeleniumBridge(driver);

  //console.log('https://sergio.dev.br/');
  //await driver.get('https://sergio.dev.br/'); // Replace with your Flutter Web app URL
  await driver.get('http://localhost:49794/'); // Replace with your Flutter Web app URL
  //await bridge.enableAccessibility();

  await driver.sleep(10000);
  await driver.takeScreenshot().then((image, err) => {
    require('fs').writeFile('../fotos/APOS/tela_inicio.png', image, 'base64', function (err) {
      if (err == null) {
        console.log('Gravou Foto 1');
      } else {
        console.log('Erro ->' + err);
      }
    });
  });

  await driver.wait(until.elementLocated(By.xpath("//flt-semantics[text()='Calculadora de Aposentadoria']")), 15000);
  const calcButton = await driver.findElement(By.xpath("//flt-semantics[text()='Calculadora de Aposentadoria']"));
  await calcButton.click();
  await driver.sleep(5000);
  await driver.takeScreenshot().then((image, err) => {
    require('fs').writeFile('../fotos/APOS/splash_screen.png', image, 'base64', function (err) {
      if (err == null) {
        console.log('Gravou Foto da Splash da Aposentadoria');
      } else {
        console.log('Erro ->' + err);
      }
    });
  });

  await driver.sleep(10000);
  await driver.takeScreenshot().then((image, err) => {
    require('fs').writeFile('../fotos/APOS/login_screen.png', image, 'base64', function (err) {
      if (err == null) {
        console.log('Gravou Foto da Tela de Login');
      } else {
        console.log('Erro ->' + err);
      }
    });
  });

  await driver.wait(until.elementLocated(By.xpath("//*[@aria-label='Usuário']")), 15000);
  await driver.findElement(By.xpath("//*[@aria-label='Usuário']")).sendKeys('admin');
  await driver.wait(until.elementLocated(By.xpath("//*[@aria-label='Senha']")), 15000);
  await driver.findElement(By.xpath("//*[@aria-label='Senha']")).sendKeys('1234');
  await driver.wait(until.elementLocated(By.xpath("//flt-semantics[text()='Entrar']")), 15000);
  const loginButton = await driver.findElement(By.xpath("//flt-semantics[text()='Entrar']"));
  await loginButton.click();
  await driver.sleep(5000);
  await driver.takeScreenshot().then((image, err) => {
    require('fs').writeFile('../fotos/APOS/home_screen.png', image, 'base64', function (err) {
      if (err == null) {
        console.log('Gravou Foto da Tela Inicial');
      } else {
        console.log('Erro ->' + err);
      }
    });
  });

  const aboutButton = await driver.wait(
    until.elementLocated(By.xpath("//flt-semantics[@role='button' and contains(text(), 'Sobre')]")),
    15000
  );
  await aboutButton.click();
  await driver.sleep(5000);
  await driver.takeScreenshot().then((image, err) => {
    require('fs').writeFile('../fotos/APOS/about_screen.png', image, 'base64', function (err) {
      if (err == null) {
        console.log('Gravou Foto da Tela Sobre');
      } else {
        console.log('Erro ->' + err);
      }
    });
  });

  const backButton = await driver.wait(
    until.elementLocated(By.xpath("//flt-semantics[@role='button' and contains(text(), 'Back')]")),
    15000
  );
  await backButton.click();

  const helpButton = await driver.wait(
    until.elementLocated(By.xpath("//flt-semantics[@role='button' and contains(text(), 'Ajuda')]")),
    15000
  );
  await helpButton.click();
  await driver.sleep(5000);
  await driver.takeScreenshot().then((image, err) => {
    require('fs').writeFile('../fotos/APOS/help_screen.png', image, 'base64', function (err) {
      if (err == null) {
        console.log('Gravou Foto da Tela de Ajuda');
      } else {
        console.log('Erro ->' + err);
      }
    });
  });

  const backButton2 = await driver.wait(
    until.elementLocated(By.xpath("//flt-semantics[@role='button' and contains(text(), 'Back')]")),
    15000
  );
  await backButton2.click();

  const calcAposButton = await driver.wait(
    until.elementLocated(By.xpath("//flt-semantics[@role='button' and contains(text(), 'Calcular aposentadoria')]")),
    10000
  );
  await calcAposButton.click();

  await driver.takeScreenshot().then((image, err) => {
      require('fs').writeFile('../fotos/APOS/calculo_aposentadoria.png', image, 'base64', function (err) {
        if (err == null) {
          console.log('Gravou Foto da Tela de Calculo de Aposentadoria');
        } else {
          console.log('Erro ->' + err);
        }
      });
    });

  const btnSexo = await driver.wait( until.elementLocated(By.xpath("//flt-semantics[@role='button' and contains(text(), 'Sexo')]")), 10000);
  await btnSexo.click();

  const optFeminino = await driver.wait(until.elementLocated(By.xpath("//flt-semantics[@role='button' and contains(text(), 'Feminino')]")),10000);
  await optFeminino.click();

  const inputIdade = await driver.wait(until.elementLocated(By.css("input[aria-label='Idade atual']")),10000);
  await inputIdade.sendKeys("62");

  const inputContribuicao = await driver.wait(until.elementLocated(By.css("input[aria-label='Anos de contribuição']")),10000);
  await inputContribuicao.sendKeys("35");

  const btnCalcular = await driver.wait(until.elementLocated(By.xpath("//flt-semantics[@role='button' and contains(text(), 'Calcular')]")),10000);
  await btnCalcular.click();

  await driver.sleep(5000);
  await driver.takeScreenshot().then((image, err) => {
      require('fs').writeFile('../fotos/APOS/calculo_aposentadoria_result.png', image, 'base64', function (err) {
        if (err == null) {
          console.log('Gravou Foto da Tela de Calculo de Aposentadoria Resultado');
        } else {
          console.log('Erro ->' + err);
        }
      });
  });

  await driver.sleep(15000);
  driver.quit();
})();
