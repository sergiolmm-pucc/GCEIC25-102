const { Builder, By } = require("selenium-webdriver");
const { Options } = require("selenium-webdriver/chrome");
const fs = require("fs");

const screenshotDir = "./fotos/equipeTres";
fs.mkdirSync(screenshotDir, { recursive: true });

function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

async function snap(driver, nome) {
  const pathName = `${screenshotDir}/${nome}.png`;
  await driver.takeScreenshot().then(img =>
    fs.writeFileSync(pathName, img, "base64")
  );
  console.log("Screenshot:", pathName);
}

async function getVisibleInputs(driver, min = 1, maxTentativas = 7, sleepTime = 600) {
  let inputs = [];
  for (let tent = 0; tent < maxTentativas; tent++) {
    const all = await driver.findElements(By.css("input, textarea"));
    inputs = [];
    for (let i = 0; i < all.length; i++) {
      try {
        if (await all[i].isDisplayed() && await all[i].isEnabled()) {
          inputs.push(all[i]);
          console.log(`Input[${i}]: displayed=true, enabled=true`);
        }
      } catch (e) {}
    }
    console.log(`Inputs visíveis na tela: ${inputs.length}`);
    if (inputs.length >= min) break;
    await sleep(sleepTime);
  }
  return inputs;
}

async function fillInput(driver, el, value) {
  await driver.wait(async () => await el.isDisplayed() && await el.isEnabled(), 5000);
  await el.click();
  await sleep(100);
  if (el.clear) await el.clear();
  await el.sendKeys(value);
  await sleep(100);
}

async function findButtonByTextOrPosition(driver, text, minY = 200) {
  // Primeiro tenta por texto:
  try {
    let el = await driver.findElement(By.xpath(`//*[text()='${text}']`));
    if (el && await el.isDisplayed() && await el.isEnabled()) return el;
  } catch (e) {}

  // Se não achar por texto, tenta pegar todos flt-semantics com role button visíveis e pega o centralizado
  let btns = await driver.findElements(By.css("flt-semantics[role='button']"));
  let bestBtn = null;
  let bestY = 0;
  for (let btn of btns) {
    try {
      if (await btn.isDisplayed() && await btn.isEnabled()) {
        let rect = await btn.getRect();
        if (rect.y > minY && rect.y > bestY) { // Y alto = central ou baixo na tela
          bestY = rect.y;
          bestBtn = btn;
        }
      }
    } catch {}
  }
  return bestBtn;
}

(async () => {
  const screen = { width: 1280, height: 900 };
  const chromeOptions = new Options();
  chromeOptions.addArguments("--headless");
  chromeOptions.addArguments("--no-sandbox");
  chromeOptions.windowSize(screen);

  let driver = await new Builder()
    .forBrowser("chrome")
    .setChromeOptions(chromeOptions)
    .build();

  try {
    // 1. Acesse o app Flutter Web
    console.log("Acessando o app Flutter Web...");
    await driver.get("https://sergi3607.c35.integrator.host/"); 
    await sleep(6000);
    await snap(driver, "1-inicio");

    // 2. Clique em "Gestor de Finanças Equipe 3"
    console.log("Procurando botão 'Gestor de Finanças Equipe 3'...");
    let gestorBtn = null;
    for (let tent = 0; tent < 6; tent++) {
      try {
        gestorBtn = await driver.findElement(By.xpath("//*[text()='Gestor de Finanças Equipe 3']"));
        if (gestorBtn && await gestorBtn.isDisplayed() && await gestorBtn.isEnabled()) break;
      } catch {}
      await sleep(1200);
    }
    if (!gestorBtn) {
      gestorBtn = await driver.findElement(By.xpath("//flt-semantics[contains(.,'Gestor de Finanças Equipe 3')]"));
    }
    if (!gestorBtn) throw new Error("Botão 'Gestor de Finanças Equipe 3' não encontrado!");
    await gestorBtn.click();
    await sleep(11000); // Splashscreen
    await snap(driver, "2-apos-splash");

    // 3. Login
    let loginInputs = await getVisibleInputs(driver, 2, 15, 1000);
    if (loginInputs.length < 2) throw new Error("Não achou campos de login!");
    await fillInput(driver, loginInputs[0], "admin");
    await fillInput(driver, loginInputs[1], "admin123");
    await snap(driver, "3-login-preenchido");

    // 4. Entrar
    let btnEntrar = await findButtonByTextOrPosition(driver, "Entrar", 200);
    if (!btnEntrar) throw new Error("Botão Entrar não encontrado!");
    await btnEntrar.click();
    await sleep(6000);
    await snap(driver, "4-apos-login");

    // 5. Salário + Próximo (central, nunca topo!)
    let salarioInputs = await getVisibleInputs(driver, 1, 10, 700);
    if (!salarioInputs.length) throw new Error("Input de salário não encontrado!");
    await fillInput(driver, salarioInputs[0], "3500");
    await snap(driver, "5-salario-preenchido");
    let btnProximoSalario = await findButtonByTextOrPosition(driver, "Próximo", 200);
    if (!btnProximoSalario) throw new Error("Botão Próximo do salário não encontrado!");
    await btnProximoSalario.click();
    await sleep(4000);

    
    // 6. Gastos fixos
    let inputsGastos = await getVisibleInputs(driver, 2, 15, 800);
    if (inputsGastos.length < 2) throw new Error("Inputs de gasto não encontrados!");
    await fillInput(driver, inputsGastos[0], "Aluguel");
    await fillInput(driver, inputsGastos[1], "1200");

    // Botão adicionar gasto (sempre o mais à direita/abaixo)
    let btnAdd = null;
    let btns = await driver.findElements(By.css("flt-semantics[role='button']"));
    let maxX = 0;
    for (let btn of btns) {
      try {
        if (await btn.isDisplayed() && await btn.isEnabled()) {
          let rect = await btn.getRect();
          if (rect.x > maxX) {
            maxX = rect.x;
            btnAdd = btn;
          }
        }
      } catch {}
    }
    if (!btnAdd) throw new Error("Não achou botão adicionar gasto!");
    await btnAdd.click();
    await sleep(2000);

    // Rebusca campos para adicionar mais um gasto
    let inputsNovos = await getVisibleInputs(driver, 2, 10, 900);
    await fillInput(driver, inputsNovos[0], "Internet");
    await fillInput(driver, inputsNovos[1], "120");
    await btnAdd.click();
    await sleep(1300);

    await snap(driver, "6-gastos-preenchidos");

    // Próximo (gastos)
    let btnProximoGastos = await findButtonByTextOrPosition(driver, "Próximo", 200);
    if (!btnProximoGastos) throw new Error("Botão Próximo dos gastos não encontrado!");
    await btnProximoGastos.click();
    await sleep(3000);

    // 7. PERCENTUAIS
    let percInputs = await getVisibleInputs(driver, 2, 12, 900);
    if (percInputs.length < 2) throw new Error("Inputs de percentuais não encontrados!");
    await fillInput(driver, percInputs[0], "20"); // Investimento
    await fillInput(driver, percInputs[1], "10"); // Lazer

    let btnCalcular = await findButtonByTextOrPosition(driver, "Calcular", 200);
    if (!btnCalcular) throw new Error("Botão Calcular não encontrado!");
    await btnCalcular.click();
    await sleep(4500);

    await snap(driver, "7-resultado");

    // 8. Calcular novamente
    let btnCalcularNovamente = await findButtonByTextOrPosition(driver, "Calcular Novamente", 200);
    if (btnCalcularNovamente) {
      await btnCalcularNovamente.click();
      await sleep(1500);
      await snap(driver, "8-calcular-novamente");
    } else {
      console.log("Botão Calcular Novamente não encontrado!");
    }

    console.log("Teste funcional da Equipe 3 finalizado com sucesso!");

  } catch (error) {
    console.error("Erro no teste funcional da Equipe 3:", error);
  } finally {
    await driver.quit();
  }
})();
