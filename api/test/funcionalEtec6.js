// Grupo 6 - CI/CD6
const fs = require('fs');
const { Builder } = require('selenium-webdriver');
const { FlutterSeleniumBridge } = require('@rentready/flutter-selenium-bridge');
const { By, until } = require('selenium-webdriver');
const { Options } = require('selenium-webdriver/chrome');

async function takeScreenshot(driver, path, message) {
    const image = await driver.takeScreenshot();
    return new Promise((resolve, reject) => {
        fs.writeFile(path, image, 'base64', err => {
            if (err) {
                console.error('Erro ao salvar screenshot:', err);
                reject(err);
            } else {
                console.log(message);
                resolve();
            }
        });
    });
}

async function clickAndSearchElement(driver, xpath, timeout = 30000) {
  try {
    const element = await driver.wait(until.elementLocated(By.xpath(xpath)), timeout);
    await driver.wait(until.elementIsVisible(element), timeout);
    await driver.wait(until.elementIsEnabled(element), timeout);
    await element.click();
  } catch (err) {
    console.error(`Erro ao localizar ou clicar no elemento com XPath: ${xpath}`);
    await takeScreenshot(driver, `./fotos/ERRO_${Date.now()}.png`, `Erro ao clicar no XPath: ${xpath}`);
    throw err;
  }
}


async function preencherCampo(driver, xpath, texto, timeout = 30000) {
    const campo = await driver.wait(until.elementLocated(By.xpath(xpath)), timeout);
    await campo.sendKeys(texto);
    await driver.sleep(5000);
    return campo;
}

(async () => {
    const screen = { width: 1024, height: 920 };

    try {
        console.log('Config chrome');
        const chromeOptions = new Options();
        chromeOptions.addArguments('--headless');
        chromeOptions.addArguments('--no-sandbox');
        chromeOptions.windowSize(screen);

        const builder = new Builder().forBrowser('chrome').setChromeOptions(chromeOptions);
        console.log('driver creation');
        const driver = await builder.build();

        const bridge = new FlutterSeleniumBridge(driver);
        await driver.manage().window().setRect(screen);
        //await driver.get("http://localhost:58067/");
        await driver.get('https://sergio.dev.br/');

        console.log('Esperando 5s para o app carregar...');
        await driver.sleep(5000);

        // Tela Inicial
        await takeScreenshot(driver, './fotos/ETEC_CI-CD6/tela_inicio.png', 'Gravou foto da tela inicial');
        
        // Clicando no botão que redireciona para nosos app
        //await driver.wait(until.elementLocated(By.xpath("//flt-semantics[text()='Cálculo do ETEC[CI/CD 6]']")), 15000);
        const redirectButton = await driver.findElement(By.xpath("//flt-semantics[text()='Cálculo do ETEC[CI/CD 6]']"));
        await redirectButton.click();
        
        // Splash Screen
        await driver.sleep(1000);
        await takeScreenshot(driver, './fotos/ETEC_CI-CD6/splash_screen.png', 'Gravou Foto da Splash do Cálculo ETEC');
        
        // Login Screen
        await driver.sleep(10000);
        await takeScreenshot(driver, './fotos/ETEC_CI-CD6/login_screen.png', 'Gravou Foto da Tela de Login');
        
        // Entrando no app
        await preencherCampo(driver, "//*[@aria-label='Email']", 'admin@email.com');
        await preencherCampo(driver, "//*[@aria-label='Senha']", '123456');
        await takeScreenshot(driver, './fotos/ETEC_CI-CD6/login_screen_preenchido.png', 'Gravou Foto da Tela de Login Preenchida');
        await clickAndSearchElement(driver, "//*[contains(text(), 'Entrar')]");
        
        // Home Screen
        await driver.sleep(6000);
        await takeScreenshot(driver, './fotos/ETEC_CI-CD6/home_screen.png', 'Gravou Foto da Tela Inicial do ETEC');
        
        // About Screen
        await clickAndSearchElement(driver, "//flt-semantics[@role='button' and contains(text(), 'Sobre')]");
        await driver.executeScript("window.scrollTo(0, document.body.scrollHeight)");
        await driver.sleep(5000);
        await takeScreenshot(driver, './fotos/ETEC_CI-CD6/about_screen.png', 'Gravou Foto da Tela Sobre');
        await clickAndSearchElement(driver, "//flt-semantics[@role='button' and contains(text(), 'Back')]");
        
        // Help Screen
        await clickAndSearchElement(driver, "//flt-semantics[@role='button' and contains(text(), 'Ajuda')]");
        await driver.sleep(5000);
        await takeScreenshot(driver, './fotos/ETEC_CI-CD6/help_screen.png', 'Gravou Foto da Tela de Ajuda');
        //await clickAndSearchElement(driver, "//flt-semantics[@role='button' and contains(text(), 'Back')]");
        await clickAndSearchElement(driver, "(//flt-semantics[@role='button'])[1]"); //back
        
        
        // Calcular CustoMensal Screen
        await clickAndSearchElement(driver, "//*[contains(text(), 'Custo Mensal')]");
        
        // Preenchendo campos
        await preencherCampo(driver, "//*[@aria-label='Digite o salário líquido']", "1518");
        await clickAndSearchElement(driver, "//*[contains(text(), 'Calcular Custo Mensal')]");
        await driver.sleep(15000);
        await takeScreenshot(driver, './fotos/ETEC_CI-CD6/calculo_custoMensal.png', 'Gravou Foto da Tela de Calculo de Custo Mensal');
        await clickAndSearchElement(driver, "(//flt-semantics[@role='button'])[1]"); //back

        // Calcular Ferias Screen
        await clickAndSearchElement(driver, "//*[contains(text(), 'Férias')]");
        
        // Preenchendo campos
        await preencherCampo(driver, "//*[@aria-label='Digite o salário líquido']", "1518");
        await clickAndSearchElement(driver, "//*[contains(text(), 'Buscar Férias')]");
        await driver.sleep(15000);
        await takeScreenshot(driver, './fotos/ETEC_CI-CD6/calculo_ferias.png', 'Gravou Foto da Tela de Calculo de Férias');
        await clickAndSearchElement(driver, "(//flt-semantics[@role='button'])[1]"); //back
        

        // Calcular Rescisão Screen
        await clickAndSearchElement(driver, "//*[contains(text(), 'Rescisão')]");
        
        // Preenchendo campos
        await preencherCampo(driver, "//*[@aria-label='Digite o salário base']", "2000");
        await preencherCampo(driver, "//*[@aria-label='Digite os meses trabalhados']", "13");
        await preencherCampo(driver, "//*[@aria-label='Digite o saldo de dias']", "18");
        await clickAndSearchElement(driver, "//flt-semantics[@role='checkbox']");
        await clickAndSearchElement(driver, "//*[contains(text(), 'Calcular Rescisão')]");
        await driver.sleep(15000);
        await takeScreenshot(driver, './fotos/ETEC_CI-CD6/calculo_rescisão.png', 'Gravou Foto da Tela de Calculo de Rescisão');
        await clickAndSearchElement(driver, "(//flt-semantics[@role='button'])[1]"); //back
        
        
        // Calcular 13ºSalário Screen
        await clickAndSearchElement(driver, "//*[contains(text(), '13º Salário')]");
        
        // Preenchendo campos
        await preencherCampo(driver, "//*[@aria-label='Digite o salário']", "1518");
        await preencherCampo(driver, "//*[@aria-label='Ex: 11']", "10");
        await clickAndSearchElement(driver, "//*[contains(text(), 'Calcular 13º')]");
        await driver.sleep(15000);
        await takeScreenshot(driver, './fotos/ETEC_CI-CD6/calculo_decimoTerceiro.png', 'Gravou Foto da Tela de Calculo de 13º');
        await clickAndSearchElement(driver, "(//flt-semantics[@role='button'])[1]"); //back
        
        // Calcular eSocial Screen
        await clickAndSearchElement(driver, "//*[contains(text(), 'eSocial')]");
        
        // Preenchendo campos
        await preencherCampo(driver, "//*[@aria-label='Digite o salário bruto']", "1200");
        await preencherCampo(driver, "//*[@aria-label='Digite o número de dependentes']", "2");
        await clickAndSearchElement(driver, "//*[contains(text(), 'Calcular eSocial')]");
        await driver.sleep(15000);
        await takeScreenshot(driver, './fotos/ETEC_CI-CD6/calculo_eSocial.png', 'Gravou Foto da Tela de Calculo eSocial');
        await clickAndSearchElement(driver, "(//flt-semantics[@role='button'])[1]"); //back

        // Saindo
        await driver.sleep(8000);
        await driver.quit();
    } catch (err) {
        console.error('[ERRO CRÍTICO]', err);
    }
        
})();
