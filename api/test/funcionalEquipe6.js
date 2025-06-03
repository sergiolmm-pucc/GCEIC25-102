const { Builder, By } = require("selenium-webdriver");
const chrome = require("selenium-webdriver/chrome");
const fs = require("fs");

const screenshotDir = "./fotos/equipe6";
fs.mkdirSync(screenshotDir, { recursive: true });

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

async function snap(driver, nome) {
  const pathName = `${screenshotDir}/${nome}.png`;
  const image = await driver.takeScreenshot();
  fs.writeFileSync(pathName, image, "base64");
  console.log("Screenshot:", pathName);
}

(async () => {
  const screen = { width: 1280, height: 900 };
  const options = new chrome.Options();
  options.addArguments("--headless", "--no-sandbox");
  options.windowSize(screen);

  const driver = await new Builder().forBrowser("chrome").setChromeOptions(options).build();

  try {
    await driver.get("https://sergi3607.c35.integrator.host/");
    await sleep(5000);
    await snap(driver, "1-home");

    const btn = await driver.findElement(By.xpath("//*[contains(text(),'Calculadora Equipe 6')]"));
    await btn.click();
    await sleep(6000);
    await snap(driver, "2-login");

    const inputs = await driver.findElements(By.css("input"));
    await inputs[0].sendKeys("admin");
    await inputs[1].sendKeys("12345");
    await snap(driver, "3-login-preenchido");

    const entrarBtn = await driver.findElement(By.xpath("//*[text()='Entrar']"));
    await entrarBtn.click();
    await sleep(4000);
    await snap(driver, "4-menu");

    const calcBtn = await driver.findElement(By.xpath("//*[contains(text(),'Calculadora')]"));
    await calcBtn.click();
    await sleep(4000);
    await snap(driver, "5-calculadora");

    const salarioInput = await driver.findElement(By.css("input"));
    await salarioInput.sendKeys("3500");
    const calcularBtn = await driver.findElement(By.xpath("//*[text()='Calcular']"));
    await calcularBtn.click();
    await sleep(4000);
    await snap(driver, "6-resultado");

    console.log("Teste funcional da Equipe 6 finalizado com sucesso!");
  } catch (err) {
    console.error("Erro no teste funcional:", err);
  } finally {
    await driver.quit();
  }
})();
