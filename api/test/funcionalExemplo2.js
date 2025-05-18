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
  
  await driver.get('https://sergi3607.c35.integrator.host/'); // Replace with your Flutter Web app URL
  //await driver.get('http://localhost:3030/'); // Replace with your Flutter Web app URL
 // await bridge.enableAccessibility();
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