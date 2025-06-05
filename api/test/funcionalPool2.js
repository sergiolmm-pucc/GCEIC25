const { Builder, By, until, Key } = require('selenium-webdriver');
const { Options } = require('selenium-webdriver/chrome');
const fs = require('fs');
const path = require('path');

(async () => {
  const chromeOptions = new Options()
    .addArguments('--headless=new')
    .addArguments('--no-sandbox')
    .addArguments('--disable-gpu')
    .addArguments('--window-size=1920,1080');

  const driver = await new Builder()
    .forBrowser('chrome')
    .setChromeOptions(chromeOptions)
    .build();

  const dir = path.resolve(__dirname, '../fotos/Pool2');
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }

  // Função para clicar em um elemento flt-semantics pelo texto (label)
  async function clicarPorTextoSemantics(driver, textoAlvo) {
    const elementos = await driver.findElements(By.css('flt-semantics'));
    for (let elem of elementos) {
      try {
        const texto = await elem.getText();
        if (texto.includes(textoAlvo)) {
          await elem.click();
          return true;
        }
      } catch (e) {
        // ignora erros em elementos sem texto
      }
    }
    throw new Error(`Elemento com texto "${textoAlvo}" não encontrado.`);
  }

  // Função para preencher um input relacionado a um label de Semantics
  async function preencherPorTextoSemantics(driver, label, valor) {
    // Encontrar o flt-semantics com o label do input (textField)
    const semanticos = await driver.findElements(By.css('flt-semantics'));
    for (let sem of semanticos) {
      try {
        const semLabel = await sem.getAttribute('label');
        if (semLabel && semLabel.includes(label)) {
          // Dentro desse semantico, procurar input
          const input = await sem.findElement(By.css('input'));
          await input.clear();
          await input.sendKeys(valor);
          return true;
        }
      } catch {
        // ignora erros, continua procurando
      }
    }
    throw new Error(`Input com label "${label}" não encontrado.`);
  }

  // Função para tirar screenshot com nome específico
  async function tirarPrint(nomeArquivo) {
    const image = await driver.takeScreenshot();
    fs.writeFileSync(path.join(dir, nomeArquivo), image, 'base64');
    console.log(`Print salvo: ${nomeArquivo}`);
  }

  try {
    // Abre a URL principal
    await driver.get('http://localhost:54923/');

    // Clique no botão "Grupo 2 - Cálculo Piscina"
    await clicarPorTextoSemantics(driver, 'Grupo 2 - Cálculo Piscina');
    await driver.sleep(3000);
    await tirarPrint('splash_screen.png');

    // Espera tela de login
    await driver.wait(until.elementLocated(By.xpath("//flt-semantics[text()='LOGIN']")), 10000);
    await tirarPrint('login_vazio.png');

    // Preenche login incorreto
    const inputs = await driver.findElements(By.css('input'));
    await inputs[0].sendKeys('errado@teste.com');
    await inputs[1].sendKeys('invalida');

    await clicarPorTextoSemantics(driver, 'LOGIN');
    await driver.sleep(3000);
    await tirarPrint('login_invalido.png');

    // Limpar campos e preencher login correto
    for (let input of inputs) {
      await input.sendKeys(Key.chord(Key.CONTROL, 'a'), Key.BACK_SPACE);
    }
    await inputs[0].sendKeys('adm@adm.com');
    await inputs[1].sendKeys('adm');

    await clicarPorTextoSemantics(driver, 'LOGIN');
    await driver.sleep(5000);
    await tirarPrint('home.png');

    // Navega para Cálculo do Volume (exemplo)
    await clicarPorTextoSemantics(driver, 'Cálculo do Volume');
    await driver.sleep(3000);
    await tirarPrint('volume.png');

    // Voltar e ir para Manutenção
    const backButton = await driver.wait(
      until.elementLocated(By.xpath("//flt-semantics[contains(@label, 'Back') or @role='button']")),
      10000
    );
    await backButton.click();

    await driver.sleep(3000);
    await clicarPorTextoSemantics(driver, 'Manutenção');
    await driver.sleep(3000);
    await tirarPrint('manutencao.png');

    console.log('Teste concluído com sucesso.');
  } finally {
    await driver.quit();
  }
})();
