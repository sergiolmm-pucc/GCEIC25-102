const { Builder, By, until } = require('selenium-webdriver');
const fs = require('fs');

async function runTest() {
  const driver = await new Builder().forBrowser('chrome').build();

  try {
    await driver.get('http://localhost:8080/calculadora');
    await driver.sleep(5000);
    let screenshot = await driver.takeScreenshot();
    fs.writeFileSync('tela_inicial.png', screenshot, 'base64');
    const botaoCalculadora = await driver.wait(
      until.elementLocated(By.css('[aria-label="Botão Calculadora equipe 7"]')),
      10000
    );
    await botaoCalculadora.click();
    const calculateButton = await driver.wait(
      until.elementLocated(By.css('[aria-label="Botão Calcular Custo"]')),
      10000
    );

    screenshot = await driver.takeScreenshot();
    fs.writeFileSync('inicio_calculadora.png', screenshot, 'base64');

    await calculateButton.click();

    const resultElement = await driver.wait(
    until.elementLocated(By.xpath("//*[contains(text(), 'Custo Total')]")),
    10000
    );

    await driver.sleep(5000);
    screenshot = await driver.takeScreenshot();
    fs.writeFileSync('resultado_calculadora.png', screenshot, 'base64');

    const resultText = await resultElement.getText();
    console.log('Resultado da calculadora:', resultText);
    await driver.sleep(5000);

  } catch (err) {
    console.error('Erro no teste:', err);
  } finally {
    await driver.quit();
  }
}

runTest();
