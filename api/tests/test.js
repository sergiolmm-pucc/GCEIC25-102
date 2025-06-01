const { Builder, By, until } = require("selenium-webdriver");
const fs = require("fs");

async function runTest() {
  const driver = await new Builder().forBrowser("chrome").build();

  try {
    // Passo 1: Acessar a página inicial
    await driver.get("http://localhost:45289/");
    await driver.sleep(3000);
    let screenshot = await driver.takeScreenshot();
    fs.writeFileSync("tela_inicial.png", screenshot, "base64");

    // Passo 2: Clicar no botão "Calculadora equipe 7"
    const botaoCalculadora = await driver.wait(
      until.elementLocated(By.css('[aria-label="Botão Calculadora equipe 7"]')),
      10000
    );
    await botaoCalculadora.click();

    // Passo 3: Aguardar e capturar o splash screen
    await driver.sleep(1000); // Aguarda o splash aparecer
    const splashText = await driver.wait(
      until.elementLocated(
        By.xpath(
          "//*[contains(text(), 'Carregando Calculadora de Casa Container')]"
        )
      ),
      10000
    );
    screenshot = await driver.takeScreenshot();
    fs.writeFileSync("splash_calculadora.png", screenshot, "base64");
    console.log("Splash screen capturado");

    // Passo 4: Aguardar redirecionamento para tela de login (após 3 segundos)
    await driver.sleep(3500); // Aguarda o timer do splash (3s) + margem

    // Verificar se chegou na tela de login
    const loginTitle = await driver.wait(
      until.elementLocated(
        By.xpath(
          "//*[contains(text(), 'Acesso à Calculadora de Casa Container')]"
        )
      ),
      10000
    );
    screenshot = await driver.takeScreenshot();
    fs.writeFileSync("tela_login.png", screenshot, "base64");
    console.log("Tela de login capturada");

    // Passo 5: Verificar campos pré-preenchidos e fazer login
    const usernameField = await driver.findElement(
      By.css('input[type="text"]')
    );
    const passwordField = await driver.findElement(
      By.css('input[type="password"]')
    );

    const usernameValue = await usernameField.getAttribute("value");
    const passwordValue = await passwordField.getAttribute("value");
    console.log("Usuário pré-preenchido:", usernameValue);
    console.log("Senha pré-preenchida:", passwordValue);

    // Clicar no botão de login
    const loginButton = await driver.wait(
      until.elementLocated(By.css('[aria-label="Botão Login"]')),
      10000
    );
    await loginButton.click();

    // Passo 6: Aguardar chegada na calculadora
    await driver.sleep(2000);
    const calculateButton = await driver.wait(
      until.elementLocated(By.css('[aria-label="Botão Calcular Custo"]')),
      10000
    );

    screenshot = await driver.takeScreenshot();
    fs.writeFileSync("inicio_calculadora.png", screenshot, "base64");
    console.log("Tela da calculadora carregada");

    // Passo 7: Executar cálculo
    await calculateButton.click();

    const resultElement = await driver.wait(
      until.elementLocated(By.xpath("//*[contains(text(), 'Custo Total')]")),
      10000
    );

    await driver.sleep(5000);
    screenshot = await driver.takeScreenshot();
    fs.writeFileSync("resultado_calculadora.png", screenshot, "base64");

    const resultText = await resultElement.getText();
    console.log("Resultado da calculadora:", resultText);
    await driver.sleep(2000);
  } catch (err) {
    console.error("Erro no teste:", err);
  } finally {
    await driver.quit();
  }
}

runTest();
