const { Builder, By, Key } = require("selenium-webdriver");
const { Options } = require("selenium-webdriver/chrome");
const fs = require("fs");

fs.mkdirSync("./fotos/impostoEquipe1", { recursive: true });

(async () => {
	const screen = { width: 1024, height: 720 };
	const chromeOptions = new Options();
	chromeOptions.addArguments("--headless");
	chromeOptions.addArguments("--no-sandbox");
	chromeOptions.windowSize(screen);

	const builder = new Builder()
		.forBrowser("chrome")
		.setChromeOptions(chromeOptions);

	let driver = await builder.build();

	try {
		// 1. Acesse o app Flutter Web
		console.log("Acessando o app Flutter Web...");
		await driver.get("https://sergi3607.c35.integrator.host/");
		await driver.sleep(8000);

		// Screenshot da tela inicial para debug
		await driver.takeScreenshot().then((image) => {
			fs.writeFileSync(
				"./fotos/impostoEquipe1/debug-inicio.png",
				image,
				"base64"
			);
			console.log("Screenshot da tela inicial salva em debug-inicio.png");
		});

		// 2. Clique em "Abrir Equipe 1"
		// Busca pelo Semantics label
		console.log('Procurando botão "Abrir Equipe 1"...');
		let equipe1Button;
		try {
			equipe1Button = await driver.findElement(
				By.xpath("//flt-semantics[@aria-label='Abrir Equipe 1']")
			);
			console.log('Botão "Abrir Equipe 1" encontrado!');
		} catch (e) {
			console.error('Botão "Abrir Equipe 1" NÃO encontrado!');
			// Tira screenshot para depuração
			await driver.takeScreenshot().then((image) => {
				fs.writeFileSync(
					"./fotos/impostoEquipe1/erro-abrir-equipe1.png",
					image,
					"base64"
				);
				console.log("Screenshot de erro salva em erro-abrir-equipe1.png");
			});
			throw e;
		}
		await equipe1Button.click();
		await driver.sleep(15000);

		// Screenshot da tela de login
		await driver.takeScreenshot().then((image) => {
			fs.writeFileSync(
				"./fotos/impostoEquipe1/tela-login-equipe1.png",
				image,
				"base64"
			);
			console.log("Screenshot da tela de login salva.");
		});

		// 3. Preencher login e senha

		// Busca os campos de login primeiro por Semantics, depois por busca genérica se necessário
		let userInput, passInput;
		try {
			userInput = await driver.findElement(
				By.xpath(
					"//flt-semantics[@aria-label='Usuário']//following-sibling::textarea | //flt-semantics[@aria-label='Usuário']//following-sibling::input"
				)
			);
			passInput = await driver.findElement(
				By.xpath(
					"//flt-semantics[@aria-label='Senha']//following-sibling::textarea | //flt-semantics[@aria-label='Senha']//following-sibling::input"
				)
			);
			console.log("Campos de login encontrados por Semantics!");
		} catch (e) {
			console.error(
				"Campos de login NÃO encontrados por Semantics. Tentando busca genérica por <input>/<textarea>..."
			);
			// Busca genérica: pega os dois primeiros inputs/textarea visíveis na tela
			const allInputs = await driver.findElements(By.css("input, textarea"));
			if (allInputs.length >= 2) {
				userInput = allInputs[0];
				passInput = allInputs[1];
				console.log("Campos de login encontrados por busca genérica!");
			} else {
				await driver.takeScreenshot().then((image) => {
					fs.writeFileSync(
						"./fotos/impostoEquipe1/erro-login-campos.png",
						image,
						"base64"
					);
					console.log("Screenshot de erro salva em erro-login-campos.png");
				});
				throw new Error("Não foi possível encontrar os campos de login!");
			}
		}
		await userInput.sendKeys("admin");
		await passInput.sendKeys("1234");

		// Screenshot após preencher login
		await driver.takeScreenshot().then((image) => {
			fs.writeFileSync(
				"./fotos/impostoEquipe1/preenchido-login-equipe1.png",
				image,
				"base64"
			);
			console.log("Screenshot após preencher login salva.");
		});

		// 4. Clicar no botão de login (assumindo que é o terceiro botão visível ou pelo texto "Entrar")
		let loginButton;
		try {
			loginButton = await driver.findElement(
				By.xpath("//flt-semantics[@aria-label='Entrar']")
			);
		} catch (e) {
			// fallback: pega o primeiro botão
			const allButtons = await driver.findElements(
				By.css('flt-semantics[role="button"]')
			);
			loginButton = allButtons[0];
		}
		await loginButton.click();
		await driver.sleep(3000);

		// Screenshot após login
		await driver.takeScreenshot().then((image) => {
			fs.writeFileSync(
				"./fotos/impostoEquipe1/tela-pos-login-equipe1.png",
				image,
				"base64"
			);
		});

		// 5. Clique em "Cálculo ICMS"
		const icmsButton = await driver.findElement(
			By.xpath("//flt-semantics[@aria-label='Cálculo ICMS']")
		);
		await icmsButton.click();
		await driver.sleep(3000);

		// Screenshot da tela de cálculo de ICMS
		await driver.takeScreenshot().then((image) => {
			fs.writeFileSync("./fotos/impostoEquipe1/tela-icms.png", image, "base64");
		});

		// 6. Preencha os campos de valor e alíquota

		// Busca genérica por todos os campos de input/textarea/contenteditable na tela de ICMS
		let icmsInputs;
		try {
			icmsInputs = await driver.findElements(
				By.css('textarea, input, [contenteditable="true"]')
			);
			if (icmsInputs.length < 2)
				throw new Error(
					"Menos de 2 campos de input encontrados na tela de ICMS!"
				);
			console.log(`Campos de ICMS encontrados: ${icmsInputs.length}`);
		} catch (e) {
			console.error("Campos de ICMS NÃO encontrados!");
			await driver.takeScreenshot().then((image) => {
				fs.writeFileSync(
					"./fotos/impostoEquipe1/erro-campos-icms.png",
					image,
					"base64"
				);
				console.log("Screenshot de erro salva em erro-campos-icms.png");
			});
			throw e;
		}

		// Preenche os dois primeiros campos (valor, alíquota)
		(await icmsInputs[0].clear) && (await icmsInputs[0].clear());
		await icmsInputs[0].sendKeys("1000");
		(await icmsInputs[1].clear) && (await icmsInputs[1].clear());
		await icmsInputs[1].sendKeys("18");

		// Screenshot após preencher os campos
		await driver.takeScreenshot().then((image) => {
			fs.writeFileSync(
				"./fotos/impostoEquipe1/preenchido-icms.png",
				image,
				"base64"
			);
			console.log("Screenshot após preencher campos de ICMS salva.");
		});

		// 7. Clique no botão "Calcular ICMS"
		const calcularButton = await driver.findElement(
			By.xpath("//flt-semantics[@aria-label='Calcular ICMS']")
		);
		await calcularButton.click();
		await driver.sleep(3000);

		// Screenshot do resultado
		await driver.takeScreenshot().then((image) => {
			fs.writeFileSync(
				"./fotos/impostoEquipe1/resultado-icms.png",
				image,
				"base64"
			);
		});

		console.log("Teste de ICMS da Equipe 1 finalizado com sucesso!");
	} catch (error) {
		console.error("Erro no teste de ICMS da Equipe 1:", error);
	} finally {
		await driver.quit();
	}
})();
