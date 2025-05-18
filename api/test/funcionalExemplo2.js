const { Builder } = require('selenium-webdriver');
const { FlutterSeleniumBridge } = require('@rentready/flutter-selenium-bridge');

(async () => {

  const driver = await new Builder()
    .forBrowser('chrome')
    .build();

  const bridge = new FlutterSeleniumBridge(driver);
  await driver.get('https://sergi3607.c35.integrator.host/'); // Replace with your Flutter Web app URL
  await bridge.enableAccessibility();
  // Wait for 5 secs to let the dynamic content to load
  await driver.sleep(15000);


// Clica no primeiro "semantics" clicável
const root = document.querySelector('flt-glass-pane')?.shadowRoot;
if (root) {
  console.log([...root.querySelectorAll('*')]);
    console.log(root);
  const targets = root.querySelectorAll('[aria-label]');
  for (const el of targets) {
    if (el.getAttribute('aria-label') === 'Entrar') {
      el.click();
      break;
    }
  }
}


  const botao = await driver.findElement(
      By.css('flt-semantics-placeholder[aria-label="Enable accessibility"]')
    );

  await driver.executeScript("arguments[0].focus(); arguments[0].click();", botao);


  const buttonXPath = '//flt-semantics[contains(@aria-label, "Entrar")]';
  const clickMeButton = await driver.findElement(By.xpath(buttonXPath));
  await clickMeButton.click();  


    // diretorio deve existir...
    await driver.takeScreenshot().then((image, err) => {
        require('fs').writeFile('./fotos/exemplo/inicio-example_102b.png', image, 'base64', function (err) {
          if (err == null){
              console.log('Gravou Foto');
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