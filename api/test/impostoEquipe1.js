
const { Builder, By, Key } = require('selenium-webdriver');
const { Options } = require('selenium-webdriver/chrome');
const fs = require('fs');

fs.mkdirSync('./fotos/impostoEquipe1', { recursive: true });

(async () => {
  const screen = { width: 1024, height: 720 };
  const chromeOptions = new Options();
  chromeOptions.addArguments('--headless');
  chromeOptions.addArguments('--no-sandbox');
  chromeOptions.windowSize(screen);

  const builder = new Builder()
    .forBrowser('chrome')
    .setChromeOptions(chromeOptions);

  let driver = await builder.build();

  try {
    // 1. Acesse o app Flutter Web
    console.log('Acessando o app Flutter Web...');
    await driver.get('https://sergi3607.c35.integrator.host/');
    await driver.sleep(8000);

    // Screenshot da tela inicial para debug
    await driver.takeScreenshot().then(image => {
      fs.writeFileSync('./fotos/impostoEquipe1/debug-inicio.png', image, 'base64');
      console.log('Screenshot da tela inicial salva em debug-inicio.png');
    });

    // 2. Clique em "Abrir Equipe 1"
    // Busca pelo Semantics label
    console.log('Procurando botão "Abrir Equipe 1"...');
    let equipe1Button;
    try {
      equipe1Button = await driver.findElement(By.xpath("//flt-semantics[@aria-label='Abrir Equipe 1']"));
      console.log('Botão "Abrir Equipe 1" encontrado!');
    } catch (e) {
      console.error('Botão "Abrir Equipe 1" NÃO encontrado!');
      // Tira screenshot para depuração
      await driver.takeScreenshot().then(image => {
        fs.writeFileSync('./fotos/impostoEquipe1/erro-abrir-equipe1.png', image, 'base64');
        console.log('Screenshot de erro salva em erro-abrir-equipe1.png');
      });
      throw e;
    }
    await equipe1Button.click();
    await driver.sleep(4000);

    // Screenshot da tela de login
    await driver.takeScreenshot().then(image => {
      fs.writeFileSync('./fotos/impostoEquipe1/tela-login-equipe1.png', image, 'base64');
      console.log('Screenshot da tela de login salva.');
    });

    // 3. Preencher login e senha
    // Os campos de texto do Flutter Web geralmente são <textarea> ou <input>
    // Busca os campos pelo Semantics label
    let userInput, passInput;
    try {
      userInput = await driver.findElement(By.xpath("//flt-semantics[@aria-label='Usuário']//following-sibling::textarea | //flt-semantics[@aria-label='Usuário']//following-sibling::input"));
      passInput = await driver.findElement(By.xpath("//flt-semantics[@aria-label='Senha']//following-sibling::textarea | //flt-semantics[@aria-label='Senha']//following-sibling::input"));
      console.log('Campos de login encontrados!');
    } catch (e) {
      console.error('Campos de login NÃO encontrados!');
      await driver.takeScreenshot().then(image => {
        fs.writeFileSync('./fotos/impostoEquipe1/erro-login-campos.png', image, 'base64');
        console.log('Screenshot de erro salva em erro-login-campos.png');
      });
      throw e;
    }
    await userInput.sendKeys('admin');
    await passInput.sendKeys('1234');

    // Screenshot após preencher login
    await driver.takeScreenshot().then(image => {
      fs.writeFileSync('./fotos/impostoEquipe1/preenchido-login-equipe1.png', image, 'base64');
      console.log('Screenshot após preencher login salva.');
    });

    // 4. Clicar no botão de login (assumindo que é o terceiro botão visível ou pelo texto "Entrar")
    let loginButton;
    try {
      loginButton = await driver.findElement(By.xpath("//flt-semantics[@aria-label='Entrar']"));
    } catch (e) {
      // fallback: pega o primeiro botão
      const allButtons = await driver.findElements(By.css('flt-semantics[role="button"]'));
      loginButton = allButtons[0];
    }
    await loginButton.click();
    await driver.sleep(3000);

    // Screenshot após login
    await driver.takeScreenshot().then(image => {
      fs.writeFileSync('./fotos/impostoEquipe1/tela-pos-login-equipe1.png', image, 'base64');
    });

    // 5. Clique em "Cálculo ICMS"
    const icmsButton = await driver.findElement(By.xpath("//flt-semantics[@aria-label='Cálculo ICMS']"));
    await icmsButton.click();
    await driver.sleep(3000);

    // Screenshot da tela de cálculo de ICMS
    await driver.takeScreenshot().then(image => {
      fs.writeFileSync('./fotos/impostoEquipe1/tela-icms.png', image, 'base64');
    });

    // 6. Preencha os campos de valor e alíquota
    const valorInput = await driver.findElement(By.xpath("//flt-semantics[@aria-label='Valor do produto']//following-sibling::textarea | //flt-semantics[@aria-label='Valor do produto']//following-sibling::input"));
    const aliquotaInput = await driver.findElement(By.xpath("//flt-semantics[@aria-label='Alíquota ICMS']//following-sibling::textarea | //flt-semantics[@aria-label='Alíquota ICMS']//following-sibling::input"));
    await valorInput.sendKeys('1000');
    await aliquotaInput.sendKeys('18');

    // Screenshot após preencher os campos
    await driver.takeScreenshot().then(image => {
      fs.writeFileSync('./fotos/impostoEquipe1/preenchido-icms.png', image, 'base64');
    });

    // 7. Clique no botão "Calcular ICMS"
    const calcularButton = await driver.findElement(By.xpath("//flt-semantics[@aria-label='Calcular ICMS']"));
    await calcularButton.click();
    await driver.sleep(3000);

    // Screenshot do resultado
    await driver.takeScreenshot().then(image => {
      fs.writeFileSync('./fotos/impostoEquipe1/resultado-icms.png', image, 'base64');
    });

    console.log('Teste de ICMS da Equipe 1 finalizado com sucesso!');
  } catch (error) {
    console.error('Erro no teste de ICMS da Equipe 1:', error);
  } finally {
    await driver.quit();
  }
})();
