const fs = require('fs');
const { Builder, By, until } = require('selenium-webdriver');
const { FlutterSeleniumBridge } = require('@rentready/flutter-selenium-bridge');
const { Options } = require('selenium-webdriver/chrome');

// Função para capturar prints da tela
async function capturarPrint(driver, caminho, mensagem) {
    const screenshot = await driver.takeScreenshot();
    return new Promise((resolve, reject) => {
        fs.writeFile(caminho, screenshot, 'base64', (erro) => {
            if (erro) {
                console.error('Falha ao salvar screenshot:', erro);
                reject(erro);
            } else {
                console.log(mensagem);
                resolve();
            }
        });
    });
}

// Função para localizar e clicar em um elemento
async function localizarEClick(driver, xpath, tempoMaximo = 30000) {
    try {
        const elemento = await driver.wait(until.elementLocated(By.xpath(xpath)), tempoMaximo);
        await driver.wait(until.elementIsVisible(elemento), tempoMaximo);
        await driver.wait(until.elementIsEnabled(elemento), tempoMaximo);
        await elemento.click();
    } catch (erro) {
        console.error(`Erro ao clicar no XPath: ${xpath}`);
        throw erro;
    }
}

// Função para preencher campo de texto
async function preencherTexto(driver, xpath, texto, tempoMaximo = 30000) {
    try {
        const campo = await driver.wait(until.elementLocated(By.xpath(xpath)), tempoMaximo);
        await campo.sendKeys(texto);
        await driver.sleep(500);
        return campo;
    } catch (erro) {
        console.error(`Erro ao preencher campo no XPath: ${xpath}`);
        await capturarPrint(driver, `../fotos/ERRO_INPUT_${Date.now()}.png`, `Erro no preenchimento do campo: ${xpath}`);
        throw erro;
    }
}

// Função principal
(async () => {
    const resolucaoTela = { width: 1920, height: 1080 };

    try {
        console.log('Configurando navegador Chrome...');
        const opcoesChrome = new Options();
        opcoesChrome.addArguments('--headless');
        opcoesChrome.addArguments('--no-sandbox');
        opcoesChrome.windowSize(resolucaoTela);

        const driver = await new Builder().forBrowser('chrome').setChromeOptions(opcoesChrome).build();
        const bridge = new FlutterSeleniumBridge(driver);

        await driver.manage().window().setRect(resolucaoTela);
        // await driver.get('http://localhost:58313/');
        await driver.get('https://sergio.dev.br/');

        console.log('Aguardando carregamento inicial...');
        await driver.sleep(6000);

        // Tela Inicial
        await capturarPrint(driver, '../fotos/Pool2/tela_inicial.png', 'Print da Tela Inicial');

        // Clicando no card do app
        const xpathBotaoApp = "//flt-semantics[text()='Grupo 2 - Cálculo Piscina']";
        await localizarEClick(driver, xpathBotaoApp);

        // Splash Screen
        await driver.sleep(3000);
        await capturarPrint(driver, '../fotos/Pool2/splash_screen.png', 'Print do Splash Screen');

        // Tela de Login
        await driver.sleep(10000);
        await capturarPrint(driver, '../fotos/Pool2/login.png', 'Print da Tela de Login');

        // Realizando login
        await preencherTexto(driver, "//*[@aria-label='E-mail']", 'adm@adm.com');
        await preencherTexto(driver, "//*[@aria-label='Senha']", 'adm');
        await capturarPrint(driver, '../fotos/Pool2/login_preenchido.png', 'Print da Tela de Login preenchida');
        await localizarEClick(driver, "//flt-semantics[text()='LOGIN']");

        console.log('Login efetuado com sucesso.');

        // Home
        await driver.sleep(5000);
        await capturarPrint(driver, '../fotos/Pool2/home_screen.png', 'Print da Home');

        // Sobre
        await localizarEClick(driver, "//flt-semantics[@role='button' and contains(text(), 'Sobre')]");
        await driver.sleep(5000);
        await capturarPrint(driver, '../fotos/Pool2/tela_sobre.png', 'Print Tela Sobre');
        await localizarEClick(driver, "//flt-semantics[@role='button' and contains(text(), 'Back')]");

        // Ajuda
        await driver.sleep(3000);
        await localizarEClick(driver, "//flt-semantics[@role='button' and contains(text(), 'Ajuda')]");
        await driver.sleep(5000);
        await capturarPrint(driver, '../fotos/Pool2/ajuda.png', 'Print Tela de Ajuda');
        await localizarEClick(driver, "//flt-semantics[@role='button' and contains(text(), 'Back')]");

        // Calcular Manutenção
        await driver.sleep(3000);
        await localizarEClick(driver, "//flt-semantics[@role='button' and contains(text(), 'Manutenção')]");
        await capturarPrint(driver, '../fotos/Pool2/calculo_manutenção.png', 'Print Tela de Calculo de Manutenção');

        // Preenchendo os campos do cálculo de manutenção
        await preencherTexto(driver, "//*[@aria-label='Produtos químicos (R$)']", '150');
        await preencherTexto(driver, "//*[@aria-label='Uso mensal da bomba (horas)']", '40');
        await preencherTexto(driver, "//*[@aria-label='Preço/hora da bomba ligada (R$)']", '0.85');
        await preencherTexto(driver, "//*[@aria-label='Mão de obra (R$)']", '200');

        await capturarPrint(driver, '../fotos/Pool2/preenchido_manutencao.png', 'Campos do cálculo preenchidos');

        // Clicar no botão de calcular (exemplo, ajuste o texto conforme seu app)
        await localizarEClick(driver, "//flt-semantics[text()='CALCULAR']");

        await driver.sleep(3000);
        await capturarPrint(driver, '../fotos/Pool2/resultado_manutencao.png', 'Resultado do cálculo');
        await localizarEClick(driver, "//flt-semantics[@role='button' and contains(text(), 'Back')]");

        // Calcular Custo de Agua
        await driver.sleep(3000);
        await localizarEClick(driver, "//flt-semantics[@role='button' and contains(text(), 'Custo de água')]");
        await driver.sleep(3000);
        await capturarPrint(driver, '../fotos/Pool2/calculo_agua.png', 'Print Tela de Calculo de Custo de água');

        // Preenchendo os campos do cálculo de custo da agua
        await preencherTexto(driver, "//*[@aria-label='Volume (m³)']", '22.50');
        await preencherTexto(driver, "//*[@aria-label='Tarifa por m³']", '8');

        await capturarPrint(driver, '../fotos/Pool2/preenchido_agua.png', 'Campos do cálculo preenchidos');

        // Clicar no botão de calcular (exemplo, ajuste o texto conforme seu app)
        await localizarEClick(driver, "//flt-semantics[text()='CALCULAR']");

        await driver.sleep(3000);
        await capturarPrint(driver, '../fotos/Pool2/resultado_agua.png', 'Resultado do cálculo');
        await localizarEClick(driver, "//flt-semantics[@role='button' and contains(text(), 'Back')]");

        // Calcular Custo Hidraulico
        await driver.sleep(3000);
        await localizarEClick(driver, "//flt-semantics[@role='button' and contains(text(), 'Hidráulica')]");
        await driver.sleep(3000);
        await capturarPrint(driver, '../fotos/Pool2/calculo_hidraulico.png', 'Print Tela de Calculo de Material Hidráulico');
        await localizarEClick(driver, "//flt-semantics[@role='button' and contains(text(), 'Back')]");

        // Preenchendo campos de texto
        await preencherTexto(driver, "//*[@aria-label='Bomba (R$)']", '1200');
        await preencherTexto(driver, "//*[@aria-label='Filtro (R$)']", '850');
        await preencherTexto(driver, "//*[@aria-label='Tubulações (m)']", '30');
        await preencherTexto(driver, "//*[@aria-label='Preço por metro (R$)']", '15');
        await preencherTexto(driver, "//*[@aria-label='Conexões (un)']", '12');

        // Selecionar Tipo da Tubulação
        await driver.sleep(3000);
        await localizarEClick(driver, "//*[@data-key='dropdown-tipo-tubulacao']");
        await driver.sleep(1000);  // Pequeno delay para abrir
        await localizarEClick(driver, "//flt-semantics[contains(@label, 'PVC')]");

        // Print dos dados preenchidos
        await driver.sleep(3000);
        await capturarPrint(driver, '../fotos/Pool2/hidraulica_preenchida.png', 'Campos Hidráulica preenchidos');

        // Clicar no botão CALCULAR
        await localizarEClick(driver, "//flt-semantics[contains(@label, 'CALCULAR')]");

        // Aguardar processamento e capturar resultado
        await driver.sleep(3000);
        await capturarPrint(driver, '../fotos/Pool2/resultado_hidraulica.png', 'Resultado do cálculo hidráulico');
        await localizarEClick(driver, "//flt-semantics[@role='button' and contains(text(), 'Back')]");

        // Calcular Custo de MOB
        await driver.sleep(3000);
        await localizarEClick(driver, "//flt-semantics[@role='button' and contains(text(), 'MOB')]");
        await driver.sleep(3000);
        await capturarPrint(driver, '../fotos/Pool2/calculo_mob.png', 'Print Tela de Calculo de MOB');

        // Preenchendo os campos do cálculo de MOB
        await preencherTexto(driver, "//*[@aria-label='Transporte de materiais']", '500');
        await preencherTexto(driver, "//*[@aria-label='Instalação de canteiros']", '1200');
        await preencherTexto(driver, "//*[@aria-label='Mão de obra']", '3000');
        await preencherTexto(driver, "//*[@aria-label='Equipamentos']", '1500');

        await capturarPrint(driver, '../fotos/Pool2/preenchido_mob.png', 'Campos do cálculo MOB preenchidos');

        // Clicar no botão de calcular
        await localizarEClick(driver, "//flt-semantics[text()='CALCULAR']");

        await driver.sleep(3000);
        await capturarPrint(driver, '../fotos/Pool2/resultado_mob.png', 'Resultado do cálculo MOB');

        // Voltar
        await localizarEClick(driver, "//flt-semantics[@role='button' and contains(text(), 'Back')]");

        // Calcular Custo de Material Elétrico
        await driver.sleep(3000);
        await localizarEClick(driver, "//flt-semantics[@role='button' and contains(text(), 'Material Elétrico')]");
        await driver.sleep(3000);
        await capturarPrint(driver, '../fotos/Pool2/calculo_mob.png', 'Print Tela de Calculo de Material Elétrico');

        // Preencher Luminária subaquática
        await preencherTexto(driver, "//*[@aria-label='Quantidade']", '4');
        await preencherTexto(driver, "//*[@aria-label='Preço unitário (R$)']", '150.00');

        // Preencher Cabo elétrico
        await preencherTexto(driver, "//*[@aria-label='Metros de fio']", '30');
        await preencherTexto(driver, "//*[@aria-label='Preço por metro (R$)']", '6.50');

        // Preencher Quadro de comando
        await preencherTexto(driver, "//*[@aria-label='Quantidade' and ancestor::flt-semantics[contains(., 'Quadro de comando')]]", '1');
        await preencherTexto(driver, "//*[@aria-label='Preço unitário (R$)' and ancestor::flt-semantics[contains(., 'Quadro de comando')]]", '450.00');

        // Preencher Disjuntor
        await preencherTexto(driver, "//*[@aria-label='Quantidade' and ancestor::flt-semantics[contains(., 'Disjuntor')]]", '2');
        await preencherTexto(driver, "//*[@aria-label='Preço unitário (R$)' and ancestor::flt-semantics[contains(., 'Disjuntor')]]", '60.00');

        // Preencher Programador
        await driver.sleep(1000);
        await preencherTexto(driver, "//*[@aria-label='Quantidade' and ancestor::flt-semantics[contains(., 'Programador')]]", '1');
        await preencherTexto(driver, "//*[@aria-label='Preço unitário (R$)' and ancestor::flt-semantics[contains(., 'Programador')]]", '200.00');

        await capturarPrint(driver, '../fotos/Pool2/preenchido_eletrico.png', 'Campos preenchidos Cálculo Elétrico');

        // Clicar no botão calcular
        await localizarEClick(driver, "//flt-semantics[@role='button' and contains(text(), 'CALCULAR')]");

        await driver.sleep(3000);
        await capturarPrint(driver, '../fotos/Pool2/resultado_eletrico.png', 'Resultado do cálculo elétrico');

        // Voltar
        await localizarEClick(driver, "//flt-semantics[@role='button' and contains(text(), 'Back')]");

        // await localizarEClick(driver, "//flt-semantics[@role='button' and contains(text(), 'Back')]");

        await driver.sleep(5000);
        await driver.quit();
    } catch (err) {
        console.error('Erro:', err);
    }
})();
