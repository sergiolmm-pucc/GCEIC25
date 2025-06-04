const { Builder, By, Key, until } = require('selenium-webdriver');
const { Options } = require('selenium-webdriver/chrome');
const fs = require('fs');
const path = require('path');

function ensureDirectoryExistence(filePath) {
  const dirname = path.dirname(filePath);
  if (fs.existsSync(dirname)) return true;
  fs.mkdirSync(dirname, { recursive: true });
}

const screenshotsDir = path.join(__dirname, '..', 'fotos', 'mob3');

(async () => {
  const screen = { width: 1024, height: 720 };
  const chromeOptions = new Options();
  chromeOptions.addArguments('--headless');
  chromeOptions.addArguments('--no-sandbox');
  chromeOptions.windowSize(screen);

  const driver = await new Builder()
    .forBrowser('chrome')
    .setChromeOptions(chromeOptions)
    .build();

  try {
    console.log('1) Abrindo site...');
    await driver.get('https://sergio.dev.br');
    await driver.sleep(5000);

    console.log('2) Esperando botão MOB3 aparecer...');
    const mob3Button = await driver.wait(
      until.elementLocated(By.xpath("//flt-semantics[text()='MOB3']")),
      15000
    );
    await driver.wait(until.elementIsVisible(mob3Button), 5000);

    console.log('3) Clicando em MOB3');
    await mob3Button.click();

    console.log('4) Aguardando splash screen...');
    await driver.sleep(5000);
    await takeScreenshot(driver, 'splash_screen.png');

    console.log('5) Aguardando tela de login...');
    await driver.sleep(5000);
    await takeScreenshot(driver, 'login_tela.png');

    console.log('6) Preenchendo campos de login...');
    const emailInput = await driver.findElement(By.css('input[aria-label="Email"]'));
    const senhaInput = await driver.findElement(By.css('input[aria-label="Senha"]'));

    await emailInput.clear();
    await emailInput.sendKeys('usuario1@email.com');

    await driver.sleep(1000);

    await senhaInput.clear();
    let attempts = 0;
    while (attempts < 3) {
      await senhaInput.sendKeys('123456');
      await driver.sleep(500);

      const value = await senhaInput.getAttribute('value');
      if (value === '123456') break;

      console.warn(`Tentativa ${attempts + 1}: senha não preenchida corretamente. Retentando...`);
      await senhaInput.clear();
      attempts++;
    }

    if (attempts === 3) {
      throw new Error('Campo de senha não foi preenchido corretamente após 3 tentativas.');
    }

    await driver.sleep(5000);

    console.log('7) Clicando no botão Entrar...');
    const entrarButton = await driver.findElement(By.xpath("//flt-semantics[contains(text(), 'Entrar')]"));
    await entrarButton.click();

    console.log('8) Aguardando menu principal...');
    await driver.sleep(10000);
    await takeScreenshot(driver, 'menu_principal.png');

    console.log('9) Navegando para tela Ajuda...');
    const ajudaBtn = await driver.findElement(By.xpath("//flt-semantics[text()='Ajuda']"));
    await ajudaBtn.click();
    await driver.sleep(3000);
    await takeScreenshot(driver, 'tela_ajuda.png');

    console.log('10) Voltando ao menu...');
    await clickBackArrow(driver);
    await ensureOnMenu(driver);

    console.log('11) Navegando para tela Sobre...');

    const sobreBtn = await driver.wait(
      until.elementLocated(By.xpath("//flt-semantics[text()='Sobre']")),
      10000
    );
    await driver.wait(until.elementIsVisible(sobreBtn), 5000);
    await driver.sleep(1000);  

    await driver.executeScript("arguments[0].click();", sobreBtn);

    await driver.sleep(5000);  
    await takeScreenshot(driver, 'tela_sobre.png');

    console.log('12) Voltando ao menu...');
    await clickBackArrow(driver);
    await ensureOnMenu(driver);

    console.log('13) Navegando para tela Consulta de manutenção...');

    const consultarBtn = await driver.wait(
      until.elementLocated(By.xpath("//flt-semantics[contains(text(),'Consulta de Manutenção')]")),
      10000
    );
    await driver.wait(until.elementIsVisible(consultarBtn), 5000);
    await driver.sleep(1000); 

    await driver.executeScript("arguments[0].click();", consultarBtn);

    await driver.sleep(3000);  
    await takeScreenshot(driver, 'tela_consultar.png');

    console.log('14) Voltando ao menu...');
    await clickBackArrow(driver);
    await ensureOnMenu(driver);

    console.log('15) Navegando para tela Consulta Elétrica...');
    const consultaEletricaBtn = await driver.wait(
      until.elementLocated(By.xpath("//flt-semantics[contains(text(),'Consulta Elétrica')]")),
      10000
    );
    await driver.wait(until.elementIsVisible(consultaEletricaBtn), 5000);
    await driver.sleep(1000);
    await driver.executeScript("arguments[0].click();", consultaEletricaBtn);
    await driver.sleep(3000);
    await takeScreenshot(driver, 'tela_consulta_eletrica.png');

    console.log('16) Voltando ao menu...');
    await clickBackArrow(driver);
    await ensureOnMenu(driver);

    console.log('17) Navegando para tela Consulta Hidráulica...');
    const consultaHidraulicaBtn = await driver.wait(
      until.elementLocated(By.xpath("//flt-semantics[contains(text(),'Consulta Hidráulica')]")),
      10000
    );
    await driver.wait(until.elementIsVisible(consultaHidraulicaBtn), 5000);
    await driver.sleep(1000);
    await driver.executeScript("arguments[0].click();", consultaHidraulicaBtn);
    await driver.sleep(3000);
    await takeScreenshot(driver, 'tela_consulta_hidraulica.png');

    console.log('18) Voltando ao menu...');
    await clickBackArrow(driver);
    await ensureOnMenu(driver);

    console.log('19) Navegando para tela Consulta Total...');
    const consultaTotalBtn = await driver.wait(
      until.elementLocated(By.xpath("//flt-semantics[contains(text(),'Consulta do Preço Total')]")),
      10000
    );
    await driver.wait(until.elementIsVisible(consultaTotalBtn), 5000);
    await driver.sleep(1000);
    await driver.executeScript("arguments[0].click();", consultaTotalBtn);
    await driver.sleep(3000);
    await takeScreenshot(driver, 'tela_consulta_total.png');

    console.log('20) Voltando ao menu...');
    await clickBackArrow(driver);
    await ensureOnMenu(driver);

    console.log('Testes finalizados com sucesso.');

  } catch (err) {
    console.error('Erro durante os testes:', err);
  } finally {
    await driver.quit();
  }

  async function takeScreenshot(driver, fileName) {
    const image = await driver.takeScreenshot();
    const filePath = path.join(screenshotsDir, fileName);
    ensureDirectoryExistence(filePath);
    fs.writeFileSync(filePath, image, 'base64');
    console.log(`Screenshot salva em: ${filePath}`);
  }

  async function ensureOnMenu(driver) {
    console.log('Garantindo que estamos na tela Menu Principal...');
    try {
      await driver.wait(
        until.elementLocated(By.xpath("//flt-semantics[text()='Sobre']")),
        7000
      );
      console.log('Já estamos no Menu Principal.');
    } catch (err) {
      console.log('Ainda não voltou ao Menu, tentando voltar novamente...');
      await clickBackArrow(driver);
      await driver.sleep(3000);
      try {
        await driver.wait(
          until.elementLocated(By.xpath("//flt-semantics[text()='Sobre']")),
          10000
        );
        console.log('Voltamos ao Menu Principal.');
      } catch (finalErr) {
        console.error('Ainda não conseguimos voltar para o Menu. Erro:', finalErr);
        await takeScreenshot(driver, 'erro_ao_voltar_menu.png');
        throw finalErr;
      }
    }
    await driver.sleep(1000);
  }

  async function clickBackArrow(driver) {
    console.log('Procurando seta de voltar...');
    try {
      const backButton = await driver.wait(
        until.elementLocated(By.xpath("(//flt-semantics[@role='button'])[1]")),
        5000
      );
      await driver.wait(until.elementIsVisible(backButton), 2000);
      await driver.executeScript("arguments[0].click();", backButton);
      console.log('Seta de voltar clicada.');
    } catch (err) {
      console.error('Erro ao tentar clicar na seta de voltar:', err);
      throw err;
    }
  }
})();
