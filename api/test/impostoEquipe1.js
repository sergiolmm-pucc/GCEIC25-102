
const { Builder, By, Key } = require('selenium-webdriver');
const { Options } = require('selenium-webdriver/chrome');
const fs = require('fs');

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
    await driver.get('https://sergi3607.c35.integrator.host/');
    await driver.sleep(5000);

    // 2. Clique em "Abrir Equipe 1"
    // Busca pelo Semantics label
    const equipe1Button = await driver.findElement(By.xpath("//flt-semantics[@aria-label='Abrir Equipe 1']"));
    await equipe1Button.click();
    await driver.sleep(3000);

    // Screenshot da tela de login
    await driver.takeScreenshot().then(image => {
      fs.writeFileSync('./fotos/impostoEquipe1/tela-login-equipe1.png', image, 'base64');
    });

    // 3. Preencher login e senha
    // Os campos de texto do Flutter Web geralmente são <textarea> ou <input>
    // Busca os campos pelo Semantics label
    const userInput = await driver.findElement(By.xpath("//flt-semantics[@aria-label='Usuário']//following-sibling::textarea | //flt-semantics[@aria-label='Usuário']//following-sibling::input"));
    const passInput = await driver.findElement(By.xpath("//flt-semantics[@aria-label='Senha']//following-sibling::textarea | //flt-semantics[@aria-label='Senha']//following-sibling::input"));
    await userInput.sendKeys('admin');
    await passInput.sendKeys('1234');

    // Screenshot após preencher login
    await driver.takeScreenshot().then(image => {
      fs.writeFileSync('./fotos/impostoEquipe1/preenchido-login-equipe1.png', image, 'base64');
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
