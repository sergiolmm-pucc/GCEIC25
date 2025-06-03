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

async function clickAndSearchElement(driver, xpath, timeout = 15000) {
    const element = await driver.wait(until.elementLocated(By.xpath(xpath)), timeout);
    await element.click();
    return element;
}

async function preencherCampo(driver, xpath, texto, timeout = 15000) {
    const campo = await driver.wait(until.elementLocated(By.xpath(xpath)), timeout);
    await campo.sendKeys(texto);
    return campo;
}

(async () => {
    const screen = { width: 1024, height: 920 };

    try {
        console.log('Config chrome');
        const chromeOptions = new Options();
        // chromeOptions.addArguments('--headless');
        // chromeOptions.addArguments('--no-sandbox');
        // chromeOptions.windowSize(screen);

        const builder = new Builder().forBrowser('chrome').setChromeOptions(chromeOptions);
        console.log('driver creation');
        const driver = await builder.build();

        const bridge = new FlutterSeleniumBridge(driver);
        await driver.manage().window().setRect(screen);
        await driver.get('http://localhost:59686/');

        console.log('Esperando 10s para o app carregar...');
        await driver.sleep(10000);

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
        await clickAndSearchElement(driver, "//flt-semantics[@role='button' and contains(text(), 'Feminino')]");
        await preencherCampo(driver, "//*[@aria-label='Idade atual']", "62");
        await preencherCampo(driver, "//*[@aria-label='Anos de contribuição']", "35");
        await clickAndSearchElement(driver, "//flt-semantics[@role='button' and contains(text(), 'Calcular')]");

        // Calcular Aposentadoria Screen Preenchida
        await driver.sleep(15000);
        await takeScreenshot(driver, '../fotos/APOS/calculo_aposentadoria_result.png', 'Gravou Foto da Tela de Calculo de Aposentadoria Resultado');
        await clickAndSearchElement(driver, "//flt-semantics[@role='button' and contains(text(), 'Back')]");

        // Simulação da Aposentadoria Screen
        await clickAndSearchElement(driver, "//flt-semantics[text()='Simular tempo restante']");
        await takeScreenshot(driver, '../fotos/APOS/simulacao_aposentadoria.png', 'Gravou Foto da Tela de Simulação de Aposentadoria');

        // Preenchendo os campos
        await preencherCampo(driver, "//*[@aria-label='Sua Idade Atual']", "62");
        await preencherCampo(driver, "//*[@aria-label='Anos de Contribuição Atuais']", "35");
        await clickAndSearchElement(driver, "//flt-semantics[@role='button' and contains(text(), 'Sexo')]");
        await clickAndSearchElement(driver, "//flt-semantics[@role='button' and contains(text(), 'Feminino')]");
        await clickAndSearchElement(driver, "//flt-semantics[@role='button' and contains(text(), 'Simular Projeção')]");

        // Simulação de Aposentadoria Screen Resultado
        await driver.sleep(15000);
        await takeScreenshot(driver, '../fotos/APOS/simulacao_aposentadoria_result.png', 'Gravou Foto da Tela de Simulação de Aposentadoria Resultado');
        await clickAndSearchElement(driver, "//flt-semantics[@role='button' and contains(text(), 'Back')]");






        // Saindo
        await driver.sleep(15000);
        await driver.quit();
    } catch (err) {
        console.error('[ERRO CRÍTICO]', err);
    }
})();
