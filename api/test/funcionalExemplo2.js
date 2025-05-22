const { Builder } = require('selenium-webdriver');
const { FlutterSeleniumBridge } = require('@rentready/flutter-selenium-bridge');
const { Browser, By,Key,  until } = require('selenium-webdriver');
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
  chromeOptions.addArguments('--headless');
  chromeOptions.addArguments('--no-sandbox');
  chromeOptions.windowSize(screen);


  console.log('ini builder');
  const builder = new Builder()
    .forBrowser('chrome')
    .setChromeOptions(chromeOptions);

    // Criação da instância do WebDriver
  
  console.log('driver creation');  
  let driver = await builder.build();

  const bridge = new FlutterSeleniumBridge(driver);  


  console.log('https://sergio.dev.br/');
  await driver.get('https://sergio.dev.br/'); // Replace with your Flutter Web app URL
  //await driver.get('http://localhost:3030/'); // Replace with your Flutter Web app URL
  //await bridge.enableAccessibility();
  // Wait for 5 secs to let the dynamic content to load
  await driver.sleep(10000);

  await driver.takeScreenshot().then((image, err) => {
        require('fs').writeFile('./fotos/exemplo/tela-inicio_102.png', image, 'base64', function (err) {
          if (err == null){
              console.log('Gravou Foto 1 ');
          }else{
              console.log('Erro ->' + err);
          }
  
        });
      });

    const buttonXPath = "//flt-semantics[text()='Entrar']";
  const clickMeButton = await driver.findElement(By.xpath(buttonXPath));
  await clickMeButton.click();  

  await driver.sleep(5000);
    // diretorio deve existir...
  await driver.takeScreenshot().then((image, err) => {
        require('fs').writeFile('./fotos/exemplo/inicio-splash101.png', image, 'base64', function (err) {
          if (err == null){
              console.log('Gravou Foto 2 ');
          }else{
              console.log('Erro ->' + err);
          }
  
        });
      });

  await driver.sleep(8000);
  await driver.takeScreenshot().then((image, err) => {
        require('fs').writeFile('./fotos/exemplo/segunda_tela_102-b3.png', image, 'base64', function (err) {
          if (err == null){
              console.log('Gravou Foto 3');
          }else{
              console.log('Erro ->' + err);
          }
  
        });
      });

    // Seleciona todos os inputs, textareas e elementos contenteditable
    const inputs = await driver.findElements(By.css('textarea, input, [contenteditable="true"]'));
    // Itera e coleta os dados
    const results = [];
    for (let el of inputs) {
      const tag = await el.getTagName();
      let value = await el.getAttribute('value');
      if (!value) {
        value = await el.getText(); // fallback para contenteditable

      }
      // textContent via getProperty (equivalente ao .textContent do navegador)
      const textProp = await el.getProperty('textContent');
      results.push({
        tag,
        value: value || '(vazio)',
        textProp: textProp || '(vazio)',
      });
    }
     await inputs[1].sendKeys('SLMM');   
    // Imprime em formato de tabela
    console.table(results);

 const buttonXPath2 = "//flt-semantics[text()='Consultar API']";
  const clickMeButton2 = await driver.findElement(By.xpath(buttonXPath2));
  await clickMeButton2.click();
  await driver.sleep(5000);  
 // diretorio deve existir...
    await driver.takeScreenshot().then((image, err) => {
        require('fs').writeFile('./fotos/exemplo/resultado_consultaAPIß.png', image, 'base64', function (err) {
          if (err == null){
              console.log('Gravou Foto 4');
          }else{
              console.log('Erro ->' + err);
          }
  
        });
      });
  await driver.sleep(1000);  
  console.log('Input text');
 const buttonXPath3 = "//flt-semantics[text()='Concatenar']";
  const clickMeButton3 = await driver.findElement(By.xpath(buttonXPath3));
  await clickMeButton3.click();
  await driver.sleep(5000);  
 // diretorio deve existir...
    await driver.takeScreenshot().then((image, err) => {
        require('fs').writeFile('./fotos/exemplo/resultado-concatenar.png', image, 'base64', function (err) {
          if (err == null){
              console.log('Gravou Foto 5');
          }else{
              console.log('Erro ->' + err);
          }
  
        });
      });

   await driver.sleep(5000);
  driver.quit();    
})();
  