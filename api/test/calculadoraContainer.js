const { Builder, By, until } = require("selenium-webdriver");
const { Options } = require("selenium-webdriver/chrome");
const fs = require("fs");

fs.mkdirSync("./fotos/equipe7", { recursive: true });

(async () => {
  const screen = { width: 1024, height: 720 };
  const chromeOptions = new Options();
  chromeOptions.addArguments("--headless");
  chromeOptions.addArguments("--no-sandbox");
  chromeOptions.addArguments("--disable-dev-shm-usage");
  chromeOptions.windowSize(screen);

  const builder = new Builder()
    .forBrowser("chrome")
    .setChromeOptions(chromeOptions);

  let driver = await builder.build();

  try {
    await driver.get("https://sergi3607.c35.integrator.host/");
    await driver.sleep(3000);
    let screenshot = await driver.takeScreenshot();
    fs.writeFileSync("./fotos/equipe7/tela_inicial.png", screenshot, "base64");

    const botaoCalculadora = await driver.wait(
      until.elementLocated(By.css('[aria-label="Botão Calculadora equipe 7"]')),
      10000
    );
    await botaoCalculadora.click();

    await driver.sleep(1000);
    const splashText = await driver.wait(
      until.elementLocated(
        By.xpath(
          "//*[contains(text(), 'Carregando Calculadora de Casa Container')]"
        )
      ),
      10000
    );
    screenshot = await driver.takeScreenshot();
    fs.writeFileSync(
      "./fotos/equipe7/splash_calculadora.png",
      screenshot,
      "base64"
    );
    console.log("Splash screen capturado");

    await driver.sleep(3500);

    const loginTitle = await driver.wait(
      until.elementLocated(
        By.xpath(
          "//*[contains(text(), 'Acesso à Calculadora de Casa Container')]"
        )
      ),
      10000
    );
    screenshot = await driver.takeScreenshot();
    fs.writeFileSync("./fotos/equipe7/tela_login.png", screenshot, "base64");
    console.log("Tela de login capturada");

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

    const loginButton = await driver.wait(
      until.elementLocated(By.css('[aria-label="Botão Login"]')),
      10000
    );
    await loginButton.click();

    await driver.sleep(2000);
    const calculateButton = await driver.wait(
      until.elementLocated(By.css('[aria-label="Botão Calcular Custo"]')),
      10000
    );

    screenshot = await driver.takeScreenshot();
    fs.writeFileSync(
      "./fotos/equipe7/inicio_calculadora.png",
      screenshot,
      "base64"
    );
    console.log("Tela da calculadora carregada");

    await calculateButton.click();

    const resultElement = await driver.wait(
      until.elementLocated(By.xpath("//*[contains(text(), 'Custo Total')]")),
      10000
    );

    await driver.sleep(5000);
    screenshot = await driver.takeScreenshot();
    fs.writeFileSync(
      "./fotos/equipe7/resultado_calculadora.png",
      screenshot,
      "base64"
    );

    const resultText = await resultElement.getText();
    console.log("Resultado da calculadora:", resultText);
    await driver.sleep(2000);
  } catch (err) {
    console.error("Erro no teste:", err);
  } finally {
    await driver.quit();
  }
})();
