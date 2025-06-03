const { Builder, By } = require("selenium-webdriver");
const { Options } = require("selenium-webdriver/chrome");
const fs = require("fs");

fs.mkdirSync("./fotos/equipe5", { recursive: true });

(async function executarTesteEquipe5() {
  const dimensaoTela = { width: 1280, height: 800 };
  const configChrome = new Options();
  configChrome.addArguments("--headless", "--no-sandbox");
  configChrome.windowSize(dimensaoTela);

  const navegador = await new Builder()
    .forBrowser("chrome")
    .setChromeOptions(configChrome)
    .build();

  try {
    console.log("🔵 Acessando app Flutter...");
    await navegador.get("https://sergi3607.c35.integrator.host/");
    await navegador.sleep(8000);

    let inicio = await navegador.takeScreenshot();
    fs.writeFileSync("./fotos/equipe5/1-inicio.png", inicio, "base64");

    console.log("Clicando no botão da Equipe 5");
    let botaoEquipe5 = await navegador.findElement(
      By.xpath("//flt-semantics[contains(text(), 'Cálculo de Viagens Equipe 5')]")
    );
    await botaoEquipe5.click();

    await navegador.sleep(1500);
    let splash = await navegador.takeScreenshot();
    fs.writeFileSync("./fotos/equipe5/2-splash.png", splash, "base64");

    console.log("Tela de login");
    await navegador.sleep(4000);

    const login = await navegador.takeScreenshot();
    fs.writeFileSync("./fotos/equipe5/3-login-preenchido.png", login, "base64");

    const botaoLogin = await navegador.findElement(
      By.xpath("//flt-semantics[@role='button' and contains(., 'ENTRAR')]")
    );
    await botaoLogin.click();

    await navegador.sleep(4000);
    const selecao = await navegador.takeScreenshot();
    fs.writeFileSync("./fotos/equipe5/4-selection-screen.png", selecao, "base64");

    console.log("Acessando Calculadora de Custos");
    const btnCalcViagem = await navegador.findElement(
      By.xpath("//flt-semantics[contains(text(), 'Calculadora de Custos')]")
    );
    await btnCalcViagem.click();

    await navegador.sleep(4000);
    const camposViagem = [
      "Distância (em km)",
      "Preço do Combustível (R$/litro)",
      "Custo de Manutenção (R$)",
      "Pedágios (R$)",
      "Outras Despesas (R$)",
      "Kilometragem por Litro (km/l)",
      "Número de pessoas: "
    ];
    const valores = ["300", "5.5", "30", "20", "10", "12", "3"];

    console.log("Preenchendo formulário da viagem");
    for (let i = 0; i < camposViagem.length; i++) {
      const campo = await navegador.findElement(By.css(`input[aria-label='${camposViagem[i]}']`));
      await campo.clear();
      await campo.sendKeys(valores[i]);
    }

    const preenchido = await navegador.takeScreenshot();
    fs.writeFileSync("./fotos/equipe5/5-viagem-preenchida.png", preenchido, "base64");

    const btnCalcular = await navegador.findElement(
      By.xpath("//flt-semantics[@role='button' and contains(., 'CALCULAR')]")
    );
    await btnCalcular.click();

    await navegador.sleep(4000);
    const resultadoViagem = await navegador.takeScreenshot();
    fs.writeFileSync("./fotos/equipe5/6-viagem-resultado.png", resultadoViagem, "base64");

    const botaoOk = await navegador.findElement(
        By.xpath("//flt-semantics[contains(text(), 'OK')]")
    );
    await botaoOk.click();

    await navegador.sleep(1000);

    const btnVoltar = await navegador.findElement(
        By.xpath("//flt-semantics[@role='button' and contains(text(), 'Back')]")
    );
    await btnVoltar.click();

    await navegador.sleep(2000)

    const telaAtual = await navegador.takeScreenshot();
    fs.writeFileSync("./fotos/equipe5/debug-selection.png", telaAtual, "base64");


    const btnTempo = await navegador.findElement(
      By.xpath("//flt-semantics[contains(text(), 'Cálculo de Tempo de Viagem')]")
    );
    await btnTempo.click();

    await navegador.sleep(4000);
    const campoDist = await navegador.findElement(By.css("input[aria-label='Distância (km)']"));
    const campoVel = await navegador.findElement(By.css("input[aria-label='Velocidade Média (km/h)']"));
    await campoDist.sendKeys("320");
    await campoVel.sendKeys("80");

    const preenchidoTempo = await navegador.takeScreenshot();
    fs.writeFileSync("./fotos/equipe5/7-tempo-preenchido.png", preenchidoTempo, "base64");

    const btnCalcularTempo = await navegador.findElement(
      By.xpath("//flt-semantics[@role='button' and contains(., 'CALCULAR')]")
    );
    await btnCalcularTempo.click();

    await navegador.sleep(4000);
    const resultadoTempo = await navegador.takeScreenshot();
    fs.writeFileSync("./fotos/equipe5/8-tempo-resultado.png", resultadoTempo, "base64");

    console.log("Teste funcional da Equipe 5 finalizado com sucesso!");
  } catch (erro) {
    console.error("Erro durante o teste:", erro);
    const erroShot = await navegador.takeScreenshot();
    fs.writeFileSync("./fotos/equipe5/erro.png", erroShot, "base64");
  } finally {
    await navegador.quit();
  }
})();
