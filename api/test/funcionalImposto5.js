const { Builder, By, Key, until } = require('selenium-webdriver');
const { Options } = require('selenium-webdriver/chrome');
const fs = require('fs');
const path = require('path');

function ensureDirectoryExistence(filePath) {
  const dirname = path.dirname(filePath);
  if (fs.existsSync(dirname)) return true;
  fs.mkdirSync(dirname, { recursive: true });
}

const screenshotsDir = path.join(__dirname, '..', 'fotos', 'impostos5');

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

    console.log('2) Esperando botão aparecer...');
    const appButton = await driver.wait(
      until.elementLocated(By.xpath("//flt-semantics[text()='Calculadora de Impostos 5']")),
      15000
    );
    await driver.wait(until.elementIsVisible(appButton), 5000);

    console.log('3) Clicando no botão...');
    await appButton.click();

    console.log('4) Aguardando transition screen...');
    await driver.sleep(5000);
    await takeScreenshot(driver, 'transition_screen5.png');

    console.log('5) Aguardando tela de login...');
    await driver.wait(until.elementLocated(By.xpath("//*[contains(@aria-label, 'Campo de email')]")), 10000);
    await takeScreenshot(driver, 'login_tela5.png');

    console.log('6) Preenchendo campos de login...');
    const emailInput = await driver.findElement(By.css('input[aria-label="Email"]'));
    const senhaInput = await driver.findElement(By.css('input[aria-label="Senha"]'));


    await emailInput.sendKeys('adm@email.com');
    await senhaInput.sendKeys('qwerty');

    console.log('7) Clicando no botão Entrar...');
    const entrarButton = await driver.findElement(By.xpath("//flt-semantics[contains(text(), 'Entrar')]"));
    await entrarButton.click();

    await driver.wait(until.stalenessOf(entrarButton), 10000);

    console.log('8) Aguardando menu principal...');
    await driver.sleep(10000);
    await takeScreenshot(driver, 'splash_screen5.png');

    console.log('9) Navegando para tela Sobre...');
    const ajudaBtn = await driver.findElement(By.xpath("//flt-semantics[text()='Sobre nós']"));
    await ajudaBtn.click();
    await driver.sleep(3000);
    await takeScreenshot(driver, 'tela_sobre5.png');

    console.log('10) Voltando ao menu...');
    await clickBackButton(driver);
    await ensureOnSplashScreen(driver);

    console.log('11) Navegando para tela Calculo de IPI...');

    const consultarIPI = await driver.wait(
      until.elementLocated(By.xpath("//flt-semantics[contains(text(),'Cálculo de IPI')]")),
      10000
    );
    await driver.wait(until.elementIsVisible(consultarIPI), 5000);
    await driver.sleep(1000); 

    await driver.executeScript("arguments[0].click();", consultarIPI);

    await driver.sleep(3000);  
    await takeScreenshot(driver, 'tela_IPI5.png');

    console.log('12) Voltando ao menu...');
    await clickBackButton(driver);
    await ensureOnSplashScreen(driver);

    console.log('13) Navegando para tela Calculo de ICMS...');

    const consultarICMS = await driver.wait(
      until.elementLocated(By.xpath("//flt-semantics[contains(text(),'Cálculo de ICMS')]")),
      10000
    );
    await driver.wait(until.elementIsVisible(consultarICMS), 5000);
    await driver.sleep(1000); 

    await driver.executeScript("arguments[0].click();", consultarICMS);

    await driver.sleep(3000);  
    await takeScreenshot(driver, 'tela_ICMS5.png');

    console.log('14) Voltando ao menu...');
    await clickBackButton(driver);
    await ensureOnSplashScreen(driver);

    console.log('15) Navegando para tela Calculo de IRPJ...');

    const consultarIRPJ = await driver.wait(
      until.elementLocated(By.xpath("//flt-semantics[contains(text(),'Cálculo de IRPJ')]")),
      10000
    );
    await driver.wait(until.elementIsVisible(consultarIRPJ), 5000);
    await driver.sleep(1000); 

    await driver.executeScript("arguments[0].click();", consultarIRPJ);

    await driver.sleep(3000);  
    await takeScreenshot(driver, 'tela_IRPJ5.png');

    console.log('16) Voltando ao menu...');
    await clickBackButton(driver);
    await ensureOnSplashScreen(driver);

    console.log('17) Navegando para tela Calculo de ISS...');

    const consultarISS = await driver.wait(
      until.elementLocated(By.xpath("//flt-semantics[contains(text(),'Cálculo de ISS')]")),
      10000
    );
    await driver.wait(until.elementIsVisible(consultarISS), 5000);
    await driver.sleep(1000); 

    await driver.executeScript("arguments[0].click();", consultarISS);

    await driver.sleep(3000);  
    await takeScreenshot(driver, 'tela_ISS5.png');

    console.log('18) Voltando ao menu...');
    await clickBackButton(driver);
    await ensureOnSplashScreen(driver);

    console.log('19) Navegando para tela Help...');
    const HelpBtn = await driver.findElement(By.xpath("//flt-semantics[text()='Help']"));
    await HelpBtn.click();
    await driver.sleep(3000);
    await takeScreenshot(driver, 'tela_help5.png');

    console.log('20) Voltando ao menu...');
    await clickBackButton(driver);
    await ensureOnSplashScreen(driver);

    console.log('Testes finalizados.');

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

  async function ensureOnSplashScreen(driver) {
    console.log('Verificando se estamos na SplashScreen...');
    try {
        // Verifica pelo título principal da splash screen
        await driver.wait(
            until.elementLocated(By.xpath("//*[contains(text(), 'Calculadora de impostos')]")),
            7000
        );
        
        // Verifica também por pelo menos um dos botões principais
        await driver.wait(
            until.elementLocated(By.xpath("//*[contains(text(), 'Cálculo de IPI') or contains(text(), 'Cálculo de ICMS') or contains(text(), 'Cálculo de IRPJ')]")),
            3000
        );
        
        console.log('Confirmação: Estamos na SplashScreen.');
    } catch (err) {
        console.log('Não estamos na SplashScreen. Tentando voltar...');
        await clickBackButton(driver);
        await driver.sleep(3000);
        
        try {
            // Verificação novamente após tentar voltar
            await driver.wait(
                until.elementLocated(By.xpath("//*[contains(text(), 'Calculadora de impostos')]")),
                10000
            );
            console.log('Agora estamos na SplashScreen.');
        } catch (finalErr) {
            console.error('Não conseguimos retornar à SplashScreen. Erro:', finalErr);
            await takeScreenshot(driver, 'erro_ao_voltar_splash.png');
            throw finalErr;
        }
    }
    await driver.sleep(1000);
  }

  async function clickBackButton(driver) {
    console.log('Procurando botão de voltar no AppBar...');
    try {
        // Localiza o botão de voltar no AppBar (normalmente o primeiro botão na barra de navegação)
        const backButton = await driver.wait(
            until.elementLocated(By.xpath("(//flt-semantics[@role='button'])[1]")),
            5000
        );
        
        await driver.wait(until.elementIsVisible(backButton), 2000);
        await driver.executeScript("arguments[0].click();", backButton);
        console.log('Botão de voltar clicado com sucesso.');
    } catch (err) {
        console.error('Erro ao tentar clicar no botão de voltar:', err);
        throw err;
    }
  }
})();
