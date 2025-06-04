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
    await takeScreenshot(driver, `../fotos/ERRO_${Date.now()}.png`, `Erro ao clicar no XPath: ${xpath}`);
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
        //await driver.get('http://localhost:64787/');
        await driver.get('https://sergio.dev.br/');

        console.log('Esperando 20s para o app carregar...');
        await driver.sleep(20000);

        // Tela Inicial
        await takeScreenshot(driver, '../fotos/APOS/tela_inicio.png', 'Gravou foto da tela inicial');

        // Clicando no botão que redireciona para nosos app
        await driver.wait(until.elementLocated(By.xpath("//flt-semantics[text()='Calculadora de Aposentadoria']")), 15000);
        const calcButton = await driver.findElement(By.xpath("//flt-semantics[text()='Calculadora de Aposentadoria']"));
        await calcButton.click();

        // Splash Screen
        await driver.sleep(5000);
        await takeScreenshot(driver, '../fotos/APOS/splash_screen.png', 'Gravou Foto da Splash da Aposentadoria');

        // Login Screen
        await driver.sleep(10000);
        await takeScreenshot(driver, '../fotos/APOS/login_screen.png', 'Gravou Foto da Tela de Login');

        // Entrando no app
        await preencherCampo(driver, "//*[@aria-label='Usuário']", 'admin');
        await preencherCampo(driver, "//*[@aria-label='Senha']", '1234');
        await clickAndSearchElement(driver, "//flt-semantics[text()='Entrar']");

        // Home Screen
        await driver.sleep(5000);
        await takeScreenshot(driver, '../fotos/APOS/home_screen.png', 'Gravou Foto da Tela Inicial');

        // About Screen
        await clickAndSearchElement(driver, "//flt-semantics[@role='button' and contains(text(), 'Sobre')]");
        await driver.sleep(5000);
        await takeScreenshot(driver, '../fotos/APOS/about_screen.png', 'Gravou Foto da Tela Sobre');
        await clickAndSearchElement(driver, "//flt-semantics[@role='button' and contains(text(), 'Back')]");

        // Help Screen
        await clickAndSearchElement(driver, "//flt-semantics[@role='button' and contains(text(), 'Ajuda')]");
        await driver.sleep(5000);
        await takeScreenshot(driver, '../fotos/APOS/help_screen.png', 'Gravou Foto da Tela de Ajuda');
        await clickAndSearchElement(driver, "//flt-semantics[@role='button' and contains(text(), 'Back')]");

        // Calcular Aposentadoria Screen
        await clickAndSearchElement(driver, "//flt-semantics[@role='button' and contains(text(), 'Calcular aposentadoria')]");
        await takeScreenshot(driver, '../fotos/APOS/calculo_aposentadoria.png', 'Gravou Foto da Tela de Calculo de Aposentadoria');

        // Preenchendo campos
        await clickAndSearchElement(driver, "//flt-semantics[@role='button' and contains(text(), 'Sexo')]");
        await driver.sleep(15000);
        await clickAndSearchElement(driver, "//flt-semantics[@role='menuitem' and @aria-label='Feminino']");
        await preencherCampo(driver, "//*[@aria-label='Idade atual']", "62");
        await preencherCampo(driver, "//*[@aria-label='Anos de contribuição']", "35");
        await clickAndSearchElement(driver, "//flt-semantics[@role='button' and contains(text(), 'Calcular')]");

        // Calcular Aposentadoria Screen Preenchida
        await driver.sleep(30000);
        await takeScreenshot(driver, '../fotos/APOS/calculo_aposentadoria_result.png', 'Gravou Foto da Tela de Calculo de Aposentadoria Resultado');
        await clickAndSearchElement(driver, "//flt-semantics[@role='button' and contains(text(), 'Back')]");

        // Simulação da Aposentadoria Screen
        await clickAndSearchElement(driver, "//flt-semantics[text()='Simular tempo restante']");
        await takeScreenshot(driver, '../fotos/APOS/simulacao_screen.png', 'Gravou Foto da Tela de Simulação de Aposentadoria');

        // Preenchendo os campos
        await preencherCampo(driver, "//*[@aria-label='Sua Idade Atual']", "62");
        await preencherCampo(driver, "//*[@aria-label='Anos de Contribuição Atuais']", "35");
        await clickAndSearchElement(driver, "//flt-semantics[@role='button' and contains(text(), 'Sexo')]");
        await driver.sleep(15000);
        await clickAndSearchElement(driver, "//flt-semantics[@role='menuitem' and @aria-label='Feminino']");
        await clickAndSearchElement(driver, "//flt-semantics[@role='button' and contains(text(), 'Simular Projeção')]");

        // Simulação de Aposentadoria Screen Resultado
        await driver.sleep(30000);
        await takeScreenshot(driver, '../fotos/APOS/simulacao_screen_result.png', 'Gravou Foto da Tela de Simulação de Aposentadoria Resultado');
        await clickAndSearchElement(driver, "//flt-semantics[@role='button' and contains(text(), 'Back')]");

        // Regras Atuais Screen
        await clickAndSearchElement(driver, "//flt-semantics[text()='Ver regras atuais']");
        await takeScreenshot(driver, '../fotos/APOS/regras_screen.png', 'Gravou Foto da Tela de Regras Atuais');

        // Preenchendo campos
        await clickAndSearchElement(driver, "//flt-semantics[@role='button' and contains(text(), 'Sexo')]");
        await driver.sleep(15000);
        await clickAndSearchElement(driver, "//flt-semantics[@role='menuitem' and @aria-label='Masculino']");
        await preencherCampo(driver, "//*[@aria-label='Idade']", "55");
        await preencherCampo(driver, "//*[@aria-label='Tempo de Contribuição']", "25");
        await clickAndSearchElement(driver, "//flt-semantics[@role='button' and contains(text(), 'Categoria')]");
        await driver.sleep(15000);
        await clickAndSearchElement(driver, "//flt-semantics[@role='menuitem' and @aria-label='Incapacidade']");
        await clickAndSearchElement(driver, "//flt-semantics[@role='button' and contains(text(), 'Ver Regras Aplicáveis')]");

        // Regras Atuais Screen Resultado
        await driver.sleep(30000);
        await takeScreenshot(driver, '../fotos/APOS/regras_screen_result.png', 'Gravou Foto da Tela de Regras de Aposentadoria Resultado');
        await clickAndSearchElement(driver, "//flt-semantics[@role='button' and contains(text(), 'Back')]");

        // Quando Aposentar Screen
        await clickAndSearchElement(driver, "//flt-semantics[text()='Quando posso me aposentar?']");
        await takeScreenshot(driver, '../fotos/APOS/quando_screen.png', 'Gravou Foto da Tela de Quando Aposenar');

        // Preenchendo campos
        await preencherCampo(driver, "//*[@aria-label='Idade']", "45");
        await preencherCampo(driver, "//*[@aria-label='Tempo de Contribuição (anos)']", "11");
        await clickAndSearchElement(driver, "//flt-semantics[@role='button' and contains(text(), 'Calcular')]");

        // Quando Aposentar Screen Resultado
        await driver.sleep(30000);
        await takeScreenshot(driver, '../fotos/APOS/quando_screen_result.png', 'Gravou Foto da Tela de Quando Aposentar Resultado');
        await clickAndSearchElement(driver, "//flt-semantics[@role='button' and contains(text(), 'Back')]");

        // Histórico de Simulações Screen
        await driver.sleep(1500);
        await clickAndSearchElement(driver, "//flt-semantics[text()='Histórico de simulações']");
        await takeScreenshot(driver, '../fotos/APOS/historico_screen.png', 'Gravou Foto da Tela de Histórico de Simulações');

        // Usando Filtros
        await clickAndSearchElement(driver, "//flt-semantics[@role='button' and contains(text(), 'Escolha um tipo')]");
        await driver.sleep(15000);
        await clickAndSearchElement(driver, "//flt-semantics[@role='menuitem' and @aria-label='/calculoAposentadoria']");
        await driver.sleep(15000);
        await takeScreenshot(driver, '../fotos/APOS/historico_filtro1.png', 'Gravou Foto da Tela de Histórico - Filtro 1');

        await clickAndSearchElement(driver, "//flt-semantics[@role='menuitem' and contains(text(), '/calculoAposentadoria')]");
        await driver.sleep(15000);
        await clickAndSearchElement(driver, "//flt-semantics[@role='menuitem' and contains(text(), '/calculoRegra')]");
        await driver.sleep(15000);
        await takeScreenshot(driver, '../fotos/APOS/historico_filtro2.png', 'Gravou Foto da Tela de Histórico - Filtro 2');

        await clickAndSearchElement(driver, "//flt-semantics[@role='menuitem' and contains(text(), '/calculoRegra')]");
        await driver.sleep(15000);
        await clickAndSearchElement(driver, "//flt-semantics[@role='menuitem' and contains(text(), '/calculoPontuacao')]");
        await driver.sleep(15000);
        await takeScreenshot(driver, '../fotos/APOS/historico_filtro3.png', 'Gravou Foto da Tela de Histórico - Filtro 3');

        await clickAndSearchElement(driver, "//flt-semantics[@role='menuitem' and contains(text(), '/calculoPontuacao')]");
        await driver.sleep(15000);
        await clickAndSearchElement(driver, "//flt-semantics[@role='menuitem' and contains(text(), '/calculoTempoAposentadoria')]");
        await driver.sleep(15000);
        await takeScreenshot(driver, '../fotos/APOS/historico_filtro4.png', 'Gravou Foto da Tela de Histórico - Filtro 4');

        // Voltando
        await clickAndSearchElement(driver, "//flt-semantics[@role='button' and contains(text(), 'Back')]");

        // Saindo
        await driver.sleep(8000);
        await driver.quit();
    } catch (err) {
        console.error('[ERRO CRÍTICO]', err);
    }
})();
