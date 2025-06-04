const { Builder } = require('selenium-webdriver');
const { By } = require('selenium-webdriver');
const { Options } = require('selenium-webdriver/chrome');

(async () => {
  // Configuração do ambiente do WebDriver e opções do navegador
  const screen = {
    width: 1024,
    height: 720
  };

  console.log('Config chrome');
  const chromeOptions = new Options();
  chromeOptions.addArguments('--headless');
  chromeOptions.addArguments('--no-sandbox');
  chromeOptions.addArguments('--force-device-scale-factor=0.75'); // Zoom out para 75%
  chromeOptions.windowSize(screen);

  console.log('ini builder');
  const builder = new Builder()
    .forBrowser('chrome')
    .setChromeOptions(chromeOptions);

  console.log('driver creation');  
  let driver = await builder.build();

  try {
    //console.log('http://localhost:8000/');
    //await driver.get('http://localhost:8000/');
    console.log('https://sergio.dev.br/');
    await driver.get('https://sergio.dev.br/'); 
    await driver.sleep(10000);

    // Screenshot 1: Tela inicial
    await driver.takeScreenshot().then((image) => {
      require('fs').writeFile('./fotos/mkp1/tela_inicial.png', image, 'base64', function (err) {
        if (err == null) {
          console.log('Gravou Foto 1: tela_inicial');
        } else {
          console.log('Erro ->' + err);
        }
      });
    });

    // Botão Calculadora de Markup
    const markupBtn = await driver.findElement(By.xpath("//flt-semantics[@aria-label='Botão Calculadora de Markup']"));
    await markupBtn.click();
    await driver.sleep(15000);

    // Screenshot 2: Tela login
    await driver.takeScreenshot().then((image) => {
      require('fs').writeFile('./fotos/mkp1/tela_login.png', image, 'base64', function (err) {
        if (err == null) {
          console.log('Gravou Foto 2: tela_login');
        } else {
          console.log('Erro ->' + err);
        }
      });
    });

    // Botão Sobre
    const sobreBtn = await driver.findElement(By.xpath("//flt-semantics[text()='Sobre']"));
    await sobreBtn.click();
    await driver.sleep(20000);
    await driver.takeScreenshot().then((image) => {
      require('fs').writeFile('./fotos/mkp1/tela_sobre.png', image, 'base64', function (err) {
        if (err == null) {
          console.log('Gravou Foto 3: tela_sobre');
        } else {
          console.log('Erro ->' + err);
        }
      });
    });
    await driver.navigate().back();
    await driver.sleep(2000);

    // Botão Ajuda
    const ajudaBtn = await driver.findElement(By.xpath("//flt-semantics[text()='Ajuda']"));
    await ajudaBtn.click();
    await driver.sleep(2000);
    await driver.takeScreenshot().then((image) => {
      require('fs').writeFile('./fotos/mkp1/tela_ajuda.png', image, 'base64', function (err) {
        if (err == null) {
          console.log('Gravou Foto 4: tela_ajuda');
        } else {
          console.log('Erro ->' + err);
        }
      });
    });
    await driver.navigate().back();
    await driver.sleep(2000);

    // Buscar os campos como no exemplo, mas filtrar apenas os habilitados
    const allInputs = await driver.findElements(By.css('textarea, input, [contenteditable="true"]'));
    const enabledInputs = [];
    for (let el of allInputs) {
      const disabled = await el.getAttribute('disabled');
      if (!disabled) {
        enabledInputs.push(el);
      }
    }
    // Itera e coleta os dados
    const results = [];
    for (let el of enabledInputs) {
      const tag = await el.getTagName();
      let value = await el.getAttribute('value');
      if (!value) {
        value = await el.getText(); // fallback para contenteditable
      }
      const textProp = await el.getProperty('textContent');
      results.push({
        tag,
        value: value || '(vazio)',
        textProp: textProp || '(vazio)',
      });
    }
    // Preencher usuário e senha
    await enabledInputs[0].click();
    await enabledInputs[0].sendKeys('admin');
    await driver.sleep(500);
    await driver.takeScreenshot().then((image) => {
      require('fs').writeFile('./fotos/mkp1/usuario_preenchido.png', image, 'base64', function (err) {
        if (err == null) {
          console.log('Gravou Foto 5: usuario_preenchido');
        } else {
          console.log('Erro ->' + err);
        }
      });
    });
    await enabledInputs[1].click();
    await enabledInputs[1].sendKeys('admin');
    await driver.sleep(500);
    await driver.takeScreenshot().then((image) => {
      require('fs').writeFile('./fotos/mkp1/senha_preenchida.png', image, 'base64', function (err) {
        if (err == null) {
          console.log('Gravou Foto 6: senha_preenchida');
        } else {
          console.log('Erro ->' + err);
        }
      });
    });
    // Imprime em formato de tabela
    console.table(results);

    // Botão Entrar
    const loginBtn = await driver.findElement(By.xpath("//flt-semantics[text()='Entrar']"));
    await loginBtn.click();
    await driver.sleep(4000);
    await driver.takeScreenshot().then((image) => {
      require('fs').writeFile('./fotos/mkp1/apos_login.png', image, 'base64', function (err) {
        if (err == null) {
          console.log('Gravou Foto 7: apos_login');
        } else {
          console.log('Erro ->' + err);
        }
      });
    });

    // Testar funcionalidades da Home
    // Aguarda tela de home
    await driver.sleep(2000);
    // Busca todos os botões de segmento
    let homeInputs, homeEnabledInputs;
    // SIMPLES (NÃO clicar no segmento, pois já está selecionado)
    await driver.sleep(1000);
    homeInputs = await driver.findElements(By.css('textarea, input, [contenteditable="true"]'));
    homeEnabledInputs = [];
    for (let el of homeInputs) {
      const disabled = await el.getAttribute('disabled');
      if (!disabled) homeEnabledInputs.push(el);
    }
    console.log('Campos habilitados Simples:', homeEnabledInputs.length);
    await homeEnabledInputs[0].clear(); await homeEnabledInputs[0].sendKeys('100'); // custo
    await homeEnabledInputs[1].clear(); await homeEnabledInputs[1].sendKeys('20'); // lucro
    await driver.findElement(By.xpath("//flt-semantics[text()='Calcular']")).click();
    await driver.sleep(1500);
    await driver.takeScreenshot().then((image) => {
      require('fs').writeFile('./fotos/mkp1/resultado_simples.png', image, 'base64', function (err) {
        if (err == null) { console.log('Screenshot resultado Simples'); } else { console.log('Erro ->' + err); }
      });
    });

    // DETALHADO
    console.log('Tentando clicar no segmento Detalhado...');
    await driver.sleep(2000);

    try {
      const detalhadoBtn = await driver.findElement(By.xpath("//flt-semantics[@aria-label='Detalhado']"));
      console.log('Encontrou o botão Detalhado');
      await detalhadoBtn.click();
      console.log('Clicou no segmento Detalhado');
    } catch (error) {
      console.error('Erro ao clicar no segmento:', error);
      const detalhadoBtn = await driver.findElement(By.xpath("//flt-semantics[text()='Detalhado']"));
      await detalhadoBtn.click();
      console.log('Clicou no segmento Detalhado via texto');
    }

    await driver.sleep(3000);

    // Espera até que os 4 campos habilitados estejam presentes
    let tentativas = 0;
    while (tentativas < 10) {
      homeInputs = await driver.findElements(By.css('textarea, input, [contenteditable="true"]'));
      homeEnabledInputs = [];
      for (let el of homeInputs) {
        const disabled = await el.getAttribute('disabled');
        if (!disabled) homeEnabledInputs.push(el);
      }
      if (homeEnabledInputs.length >= 4) break;
      await driver.sleep(500);
      tentativas++;
    }
    if (homeEnabledInputs.length < 4) {
      throw new Error('Não encontrou campos suficientes para Detalhado');
    }
    // Limpa todos os campos antes de preencher
    for (let i = 0; i < homeEnabledInputs.length; i++) {
      await homeEnabledInputs[i].click();
      await homeEnabledInputs[i].sendKeys(require('selenium-webdriver').Key.chord(require('selenium-webdriver').Key.CONTROL, 'a'));
      await homeEnabledInputs[i].sendKeys(require('selenium-webdriver').Key.BACK_SPACE);
      console.log(`Campo ${i} limpo (Detalhado)`);
    }
    await homeEnabledInputs[0].sendKeys('100'); // custo
    await homeEnabledInputs[1].sendKeys('20'); // lucro
    await homeEnabledInputs[2].sendKeys('10'); // despesas
    await homeEnabledInputs[3].sendKeys('5'); // impostos
    console.log('Campos preenchidos Detalhado:', homeEnabledInputs.length);
    await driver.findElement(By.xpath("//flt-semantics[text()='Calcular']")).click();
    await driver.sleep(1500);
    await driver.takeScreenshot().then((image) => {
      require('fs').writeFile('./fotos/mkp1/resultado_detalhado.png', image, 'base64', function (err) {
        if (err == null) { console.log('Screenshot resultado Detalhado'); } else { console.log('Erro ->' + err); }
      });
    });

    // SUGESTÃO
    console.log('Tentando clicar no segmento Sugestão...');
    await driver.sleep(2000);

    try {
      const sugestaoBtn = await driver.findElement(By.xpath("//flt-semantics[@aria-label='Sugestão']"));
      console.log('Encontrou o botão Sugestão');
      await sugestaoBtn.click();
      console.log('Clicou no segmento Sugestão');
    } catch (error) {
      console.error('Erro ao clicar no segmento:', error);
      const sugestaoBtn = await driver.findElement(By.xpath("//flt-semantics[text()='Sugestão']"));
      await sugestaoBtn.click();
      console.log('Clicou no segmento Sugestão via texto');
    }

    await driver.sleep(3000);

    // Espera até que os 2 campos habilitados estejam presentes
    tentativas = 0;
    while (tentativas < 10) {
      homeInputs = await driver.findElements(By.css('textarea, input, [contenteditable="true"]'));
      homeEnabledInputs = [];
      for (let el of homeInputs) {
        const disabled = await el.getAttribute('disabled');
        if (!disabled) homeEnabledInputs.push(el);
      }
      if (homeEnabledInputs.length >= 2) break;
      await driver.sleep(500);
      tentativas++;
    }
    if (homeEnabledInputs.length < 2) {
      throw new Error('Não encontrou campos suficientes para Sugestão');
    }
    for (let i = 0; i < homeEnabledInputs.length; i++) {
      await homeEnabledInputs[i].click();
      await homeEnabledInputs[i].sendKeys(require('selenium-webdriver').Key.chord(require('selenium-webdriver').Key.CONTROL, 'a'));
      await homeEnabledInputs[i].sendKeys(require('selenium-webdriver').Key.BACK_SPACE);
      console.log(`Campo ${i} limpo (Sugestão)`);
    }
    await homeEnabledInputs[0].sendKeys('100'); // custo
    await homeEnabledInputs[1].sendKeys('120,130,140'); // concorrentes
    console.log('Campos preenchidos Sugestão:', homeEnabledInputs.length);
    await driver.findElement(By.xpath("//flt-semantics[text()='Calcular']")).click();
    await driver.sleep(1500);
    await driver.takeScreenshot().then((image) => {
      require('fs').writeFile('./fotos/mkp1/resultado_sugestao.png', image, 'base64', function (err) {
        if (err == null) { console.log('Screenshot resultado Sugestão'); } else { console.log('Erro ->' + err); }
      });
    });

    // SIMULAÇÃO
    console.log('Tentando clicar no segmento Simulação...');
    await driver.sleep(2000);

    try {
      const simulacaoBtn = await driver.findElement(By.xpath("//flt-semantics[@aria-label='Simulação']"));
      console.log('Encontrou o botão Simulação');
      await simulacaoBtn.click();
      console.log('Clicou no segmento Simulação');
    } catch (error) {
      console.error('Erro ao clicar no segmento:', error);
      const simulacaoBtn = await driver.findElement(By.xpath("//flt-semantics[text()='Simulação']"));
      await simulacaoBtn.click();
      console.log('Clicou no segmento Simulação via texto');
    }

    await driver.sleep(3000);

    // Espera até que os 3 campos habilitados estejam presentes
    tentativas = 0;
    while (tentativas < 10) {
      homeInputs = await driver.findElements(By.css('textarea, input, [contenteditable="true"]'));
      homeEnabledInputs = [];
      for (let el of homeInputs) {
        const disabled = await el.getAttribute('disabled');
        if (!disabled) homeEnabledInputs.push(el);
      }
      if (homeEnabledInputs.length >= 3) break;
      await driver.sleep(500);
      tentativas++;
    }
    if (homeEnabledInputs.length < 3) {
      throw new Error('Não encontrou campos suficientes para Simulação');
    }
    for (let i = 0; i < homeEnabledInputs.length; i++) {
      await homeEnabledInputs[i].click();
      await homeEnabledInputs[i].sendKeys(require('selenium-webdriver').Key.chord(require('selenium-webdriver').Key.CONTROL, 'a'));
      await homeEnabledInputs[i].sendKeys(require('selenium-webdriver').Key.BACK_SPACE);
      console.log(`Campo ${i} limpo (Simulação)`);
    }
    await homeEnabledInputs[0].sendKeys('100'); // custo
    await homeEnabledInputs[1].sendKeys('10'); // despesas
    await homeEnabledInputs[2].sendKeys('5'); // impostos
    console.log('Campos preenchidos Simulação:', homeEnabledInputs.length);
    await driver.findElement(By.xpath("//flt-semantics[text()='Calcular']")).click();
    await driver.sleep(1500);
    await driver.takeScreenshot().then((image) => {
      require('fs').writeFile('./fotos/mkp1/resultado_simulacao.png', image, 'base64', function (err) {
        if (err == null) { console.log('Screenshot resultado Simulação'); } else { console.log('Erro ->' + err); }
      });
    });

    // LUCRO OBTIDO
    console.log('Tentando clicar no segmento Lucro Obtido...');
    await driver.sleep(2000);

    try {
      const lucroObtidoBtn = await driver.findElement(By.xpath("//flt-semantics[@aria-label='Lucro Obtido']"));
      console.log('Encontrou o botão Lucro Obtido');
      await lucroObtidoBtn.click();
      console.log('Clicou no segmento Lucro Obtido');
    } catch (error) {
      console.error('Erro ao clicar no segmento:', error);
      const lucroObtidoBtn = await driver.findElement(By.xpath("//flt-semantics[text()='Lucro Obtido']"));
      await lucroObtidoBtn.click();
      console.log('Clicou no segmento Lucro Obtido via texto');
    }

    await driver.sleep(3000);

    // Espera até que os 2 campos habilitados estejam presentes
    tentativas = 0;
    while (tentativas < 10) {
      homeInputs = await driver.findElements(By.css('textarea, input, [contenteditable="true"]'));
      homeEnabledInputs = [];
      for (let el of homeInputs) {
        const disabled = await el.getAttribute('disabled');
        if (!disabled) homeEnabledInputs.push(el);
      }
      if (homeEnabledInputs.length >= 2) break;
      await driver.sleep(500);
      tentativas++;
    }
    if (homeEnabledInputs.length < 2) {
      throw new Error('Não encontrou campos suficientes para Lucro Obtido');
    }
    for (let i = 0; i < homeEnabledInputs.length; i++) {
      await homeEnabledInputs[i].click();
      await homeEnabledInputs[i].sendKeys(require('selenium-webdriver').Key.chord(require('selenium-webdriver').Key.CONTROL, 'a'));
      await homeEnabledInputs[i].sendKeys(require('selenium-webdriver').Key.BACK_SPACE);
      console.log(`Campo ${i} limpo (Lucro Obtido)`);
    }
    await homeEnabledInputs[0].sendKeys('100'); // custo
    await homeEnabledInputs[1].sendKeys('150'); // preco venda
    console.log('Campos preenchidos Lucro Obtido:', homeEnabledInputs.length);
    await driver.findElement(By.xpath("//flt-semantics[text()='Calcular']")).click();
    await driver.sleep(1500);
    await driver.takeScreenshot().then((image) => {
      require('fs').writeFile('./fotos/mkp1/resultado_lucroobtido.png', image, 'base64', function (err) {
        if (err == null) { console.log('Screenshot resultado Lucro Obtido'); } else { console.log('Erro ->' + err); }
      });
    });

  } catch (error) {
    console.error('Erro durante o teste:', error);
    await driver.takeScreenshot().then((image) => {
      require('fs').writeFile('./fotos/mkp1/erro.png', image, 'base64', function (err) {
        if (err == null) {
          console.log('Gravou Foto ERRO');
        } else {
          console.log('Erro ->' + err);
        }
      });
    });
  } finally {
    await driver.quit();
  }
})();