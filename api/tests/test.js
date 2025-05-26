const { Builder, By, until } = require('selenium-webdriver');
const fs = require('fs');

async function runTest() {
  const driver = await new Builder().forBrowser('chrome').build();

  try {
    // Abra a URL da aplicação (substitua pela URL correta do seu app Flutter Web)
    await driver.get('http://localhost:8080/calculadora');

    // Aguarde o botão "Botão Calcular Custo" estar presente (aria-label = "Botão Calcular Custo")
    const calculateButton = await driver.wait(
      until.elementLocated(By.css('[aria-label="Botão Calcular Custo"]')),
      10000
    );

    // Tira screenshot da tela inicial da calculadora
    let screenshot = await driver.takeScreenshot();
    fs.writeFileSync('inicio_calculadora.png', screenshot, 'base64');

    // Clique no botão Calcular Custo
    await calculateButton.click();

    // Aguarde que o resultado apareça (elemento com key 'Resultado do Custo Total')
    const resultElement = await driver.wait(
    until.elementLocated(By.xpath("//*[contains(text(), 'Custo Total')]")),
    10000
    );


    // Tira screenshot do resultado
    screenshot = await driver.takeScreenshot();
    fs.writeFileSync('resultado_calculadora.png', screenshot, 'base64');

    // Opcional: leia o texto do resultado e imprima no console
    const resultText = await resultElement.getText();
    console.log('Resultado da calculadora:', resultText);

  } catch (err) {
    console.error('Erro no teste:', err);
  } finally {
    await driver.quit();
  }
}

runTest();
