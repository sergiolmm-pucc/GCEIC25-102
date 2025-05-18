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

  const chromeOptions = new Options();
  chromeOptions.addArguments('--headless');
  chromeOptions.addArguments('--no-sandbox');
  chromeOptions.windowSize(screen);

  const builder = new Builder()
    .forBrowser('chrome')
    .setChromeOptions(chromeOptions);

    // Criação da instância do WebDriver
  let driver = await builder.build();

  //const driver = await new Builder()
  //  .forBrowser('chrome')
  //  .build();

  const bridge = new FlutterSeleniumBridge(driver);
  
  //await driver.get('https://sergi3607.c35.integrator.host/'); // Replace with your Flutter Web app URL
  await driver.get('http://localhost:3030/'); // Replace with your Flutter Web app URL
  //await bridge.enableAccessibility();
  // Wait for 5 secs to let the dynamic content to load
  await driver.sleep(10000);


//
/*
  const botao = await driver.findElement(
      By.css('flt-semantics-placeholder[aria-label="Enable accessibility"]')
    );

  await driver.executeScript("arguments[0].focus(); arguments[0].click();", botao);
*/
   // diretorio deve existir...
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
        require('fs').writeFile('./fotos/exemplo/inicio-splash102.png', image, 'base64', function (err) {
          if (err == null){
              console.log('Gravou Foto 2 ');
          }else{
              console.log('Erro ->' + err);
          }
  
        });
      });

  await driver.sleep(12000);
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

/*
 // Captura todos os <flt-semantics>
    const elements = await driver.findElements(By.css('flt-semantics'));

    // Tenta capturar o conteúdo do campo de input real do Flutter (geralmente há um único textarea)
    const flutterInput = await driver.findElements(By.css('textarea, input, [contenteditable="true"]'));
    console.log(flutterInput);  
    let inputValue = '(sem input)';
    if (flutterInput.length > 0) {
      inputValue = await flutterInput[0].getAttribute('value') || '(vazio)';
    }

    // Para cada <flt-semantics>, exibe informações
    for (let el of elements) {
      const id = await el.getAttribute('id') || '(sem id)';
      const role = await el.getAttribute('role') || '(sem role)';
      const label = await el.getAttribute('aria-label') || '(sem label)';
      const text = await el.getText() || '(sem texto)';

      // Se for um campo de texto, mostra o valor capturado do textarea do Flutter
      const value = role === 'textbox' ? inputValue : '(n/a)';

      console.log({ id, role, label, text, value });
    }
*/
  const buttonXPath2 = "//flt-semantics[text()='Consultar API']";
  const clickMeButton2 = await driver.findElement(By.xpath(buttonXPath2));
  await clickMeButton2.click();
  await driver.sleep(5000);  
 // diretorio deve existir...
    await driver.takeScreenshot().then((image, err) => {
        require('fs').writeFile('./fotos/exemplo/resultado_102-b3.png', image, 'base64', function (err) {
          if (err == null){
              console.log('Gravou Foto 4');
          }else{
              console.log('Erro ->' + err);
          }
  
        });
      });
  await driver.sleep(1000);  
  console.log('Input text');
/*
  const semantics = driver.querySelectorAll('flt-semantics[id]');
  const textareas = driver.querySelectorAll('textarea, input, [contenteditable="true"]');

const infoList = Array.from(semantics).map(el => {
  const role = el.getAttribute('role') || '(sem role)';
  const label = el.getAttribute('aria-label') || '(sem label)';
  const text = el.innerText.trim() || '(sem texto)';
  let value = '(n/a)';

  // Se for um textbox, tenta capturar valor do input/textarea associado
  if (role === 'textbox') {
    // Captura o valor do primeiro textarea ou input visível
    const inputEl = Array.from(textareas).find(el => !!el.value?.trim() || !!el.textContent?.trim());
    if (inputEl) {
      value = inputEl.value || inputEl.textContent || '(vazio)';
    }
  }

  return {
    id: el.id,
    role,
    label,
    text,
    value,
  };
});

console.table(infoList);

*/

  const buttonXPath3 = "//flt-semantics[text()='Concatenar']";
  const clickMeButton3 = await driver.findElement(By.xpath(buttonXPath3));
  await clickMeButton3.click();
  await driver.sleep(5000);  
 // diretorio deve existir...
    await driver.takeScreenshot().then((image, err) => {
        require('fs').writeFile('./fotos/exemplo/resultado-3.png', image, 'base64', function (err) {
          if (err == null){
              console.log('Gravou Foto 4');
          }else{
              console.log('Erro ->' + err);
          }
  
        });
      });

  driver.quit();    
})();
  
  //  await driver.findElement(By.name('valorBase')).sendKeys(4, Key.RETURN);
  //  await driver.findElement(By.name('valorAltura')).sendKeys(4, Key.RETURN);
/*
   // Captura de tela final
    await driver.takeScreenshot().then((image, err) => {
      require('fs').writeFile('./fotos/exemplo/valorDigitado-example.png', image, 'base64', function (err) {
        if (err == null){
            console.log('Gravou Foto');
        }else{
            console.log('Erro ->' + err);
        }
      });
    });
    
    
    // Verificação dos botões 
    const calculaButton = await driver.findElement(By.name('calcula'));
    // Verifica se os botões estão visíveis
    if ( (await calculaButton.isDisplayed()) ) {
      console.log('Passou: Botões de impostos estão visíveis');
    } else {
      console.log('Falhou: Botões de impostos não estão visíveis');
    }

   // valorAltura = await driver.findElement(By.id('valorAltura'));
   // await valorAltura.sendKeys('10');

   // valorBase = await driver.findElement(By.id('valorBase'));
   // await valorBase.sendKeys('4');

    // Clique no botão 
    await calculaButton.click();

    // Captura de tela final
    await driver.takeScreenshot().then((image, err) => {
      require('fs').writeFile('./fotos/exemplo/fim-example.png', image, 'base64', function (err) {
        if (err == null){
            console.log('Gravou Foto');
        }else{
            console.log('Erro ->' + err);
        }

      });
    });
    // Encerramento do WebDriver
  } catch (error) {
    console.error('Teste funcional falhou:', error);
  } finally {
    await driver.quit();
  }

})();
*/