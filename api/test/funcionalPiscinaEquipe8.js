const { Builder, By } = require("selenium-webdriver");
const { Options } = require("selenium-webdriver/chrome");
const fs = require("fs");

fs.mkdirSync("./fotos/piscinaEquipe8", { recursive: true });

(async function executarTestePiscinaEquipe8() {
	const dimensaoTela = { width: 1280, height: 800 };
	const configChrome = new Options();
	configChrome.addArguments("--headless", "--no-sandbox");
	configChrome.windowSize(dimensaoTela);

	const navegador = await new Builder()
		.forBrowser("chrome")
		.setChromeOptions(configChrome)
		.build();

	try {
		console.log("Iniciando aplicação web Flutter...");
		await navegador.get("https://sergi3607.c35.integrator.host/");
		await navegador.sleep(8000);

		let imgInicio = await navegador.takeScreenshot();
		fs.writeFileSync("./fotos/piscinaEquipe8/inicio.png", imgInicio, "base64");

		// Acessando funcionalidade da equipe 8
		console.log("Localizando botão da funcionalidade da Equipe 8...");
		let botaoEquipe8 = await navegador.findElement(
			By.xpath("//flt-semantics[contains(text(), 'Cálculo Construção de Piscina - Equipe 8')]")
		);
		await botaoEquipe8.click();

		// Captura de splash screen após clique
		await navegador.sleep(1000);
		let splash = await navegador.takeScreenshot();
		fs.writeFileSync("./fotos/piscinaEquipe8/splash.png", splash, "base64");
		await navegador.sleep(5000);

		let imgCalculo = await navegador.takeScreenshot();
		fs.writeFileSync("./fotos/piscinaEquipe8/tela-calculo.png", imgCalculo, "base64");

		// Preenchendo os campos com os dados da piscina
		const campos = [
			"Largura da piscina (m)",
			"Comprimento da piscina (m)",
			"Profundidade média (m)"
		];
		const dados = ["4", "8", "1.5"];

		console.log("Preenchendo os dados da piscina...");
		for (let i = 0; i < campos.length; i++) {
			let campo = await navegador.findElement(By.css(`input[aria-label='${campos[i]}']`));
			await campo.click();
			await campo.clear();
			await campo.sendKeys(dados[i]);
		}

		let preenchido = await navegador.takeScreenshot();
		fs.writeFileSync("./fotos/piscinaEquipe8/preenchido.png", preenchido, "base64");

		// Ação do botão calcular
		let botaoCalcular = await navegador.findElement(
			By.xpath("//flt-semantics[@role='button' and contains(., 'Calcular')]")
		);
		await botaoCalcular.click();

		await navegador.sleep(4000);
		let resultado = await navegador.takeScreenshot();
		fs.writeFileSync("./fotos/piscinaEquipe8/resultado.png", resultado, "base64");

		console.log("✅ Execução concluída com sucesso!");
	} catch (erro) {
		console.error("❌ Falha durante execução do teste:", erro);
		let imagemErro = await navegador.takeScreenshot();
		fs.writeFileSync("./fotos/piscinaEquipe8/erro.png", imagemErro, "base64");
	} finally {
		await navegador.quit();
	}
})();
