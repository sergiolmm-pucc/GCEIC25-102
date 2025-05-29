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
			// Busca genérica: pega os dois primeiros inputs/textarea visíveis e habilitados na tela
			const allInputs = await driver.findElements(By.css("input, textarea"));
			const visibleInputs = [];
			for (const el of allInputs) {
				const displayed = await el.isDisplayed();
				const enabled = await el.isEnabled();
				if (displayed && enabled) visibleInputs.push(el);
				if (visibleInputs.length === 2) break;
			}
			if (visibleInputs.length >= 2) {
				userInput = visibleInputs[0];
				passInput = visibleInputs[1];
				console.log("Campos de login encontrados por busca genérica (visíveis e habilitados)!");
			} else {
				await driver.takeScreenshot().then((image) => {
					fs.writeFileSync(
						"./fotos/impostoEquipe1/erro-login-campos.png",
						image,
						"base64"
					);
					console.log("Screenshot de erro salva em erro-login-campos.png");
				});
				throw new Error("Não foi possível encontrar os campos de login visíveis e habilitados!");
			}
		}

		// Função robusta para preencher campo
		async function fillInput(driver, el, value) {
			await driver.wait(async () => await el.isDisplayed() && await el.isEnabled(), 5000);
			await el.click();
			await driver.sleep(100);
			if (el.clear) await el.clear();
			await el.sendKeys(value);
			await driver.sleep(100);
			// Validação: tenta ler o valor digitado
			let typed = null;
			try {
				typed = await el.getAttribute('value');
			} catch (e) {}
			if (typed !== null && typed !== value) {
				throw new Error(`Valor digitado não corresponde: esperado=${value}, obtido=${typed}`);
			}
		}

		await fillInput(driver, userInput, "admin");
		await fillInput(driver, passInput, "1234");

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

		// Tenta preencher todos os pares possíveis de campos visíveis/habilitados
		let preenchido = false;
		for (let i = 0; i < icmsInputs.length; i++) {
			for (let j = 0; j < icmsInputs.length; j++) {
				if (i === j) continue;
				try {
					await fillInput(driver, icmsInputs[i], "1000");
					await fillInput(driver, icmsInputs[j], "18");
					// Validação: se ambos os campos ficaram com o valor correto, considera sucesso
					const v1 = await icmsInputs[i].getAttribute('value');
					const v2 = await icmsInputs[j].getAttribute('value');
					if (v1 === "1000" && v2 === "18") {
						preenchido = true;
						console.log(`Campos de ICMS preenchidos nos índices [${i},${j}]`);
						break;
					}
				} catch (e) {
					// Tenta o próximo par
				}
			}
			if (preenchido) break;
		}
		if (!preenchido) {
			await driver.takeScreenshot().then((image) => {
				fs.writeFileSync(
					"./fotos/impostoEquipe1/erro-preencher-icms.png",
					image,
					"base64"
				);
				console.log("Screenshot de erro salva em erro-preencher-icms.png");
			});
			throw new Error("Não foi possível preencher corretamente os campos de ICMS!");
		}

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

		console.log("Teste funcional da Equipe 1 finalizado com sucesso!");
	} catch (error) {
		console.error("Erro no teste funcional da Equipe 1:", error);
	} finally {
		await driver.quit();
	}
})();
