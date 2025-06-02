// const { Builder, By, Key } = require("selenium-webdriver");
// const { Options } = require("selenium-webdriver/chrome");
// const fs = require("fs");
// const { until } = require("selenium-webdriver");

// fs.mkdirSync("./fotos/impostoEquipe1", { recursive: true });

// (async () => {
// 	const screen = { width: 1024, height: 720 };
// 	const chromeOptions = new Options();
// 	chromeOptions.addArguments("--headless");
// 	chromeOptions.addArguments("--no-sandbox");
// 	chromeOptions.windowSize(screen);

// 	const builder = new Builder()
// 		.forBrowser("chrome")
// 		.setChromeOptions(chromeOptions);

// 	let driver = await builder.build();

// 	try {
// 		// 1. Acesse o app Flutter Web
// 		console.log("Acessando o app Flutter Web...");
// 		await driver.get("https://sergi3607.c35.integrator.host/");
// 		await driver.sleep(8000);

// 		// Screenshot da tela inicial para debug
// 		await driver.takeScreenshot().then((image) => {
// 			fs.writeFileSync(
// 				"./fotos/impostoEquipe1/debug-inicio.png",
// 				image,
// 				"base64"
// 			);
// 			console.log("Screenshot da tela inicial salva em debug-inicio.png");
// 		});

// 		// 2. Clique em "Abrir Equipe 1"
// 		// Busca pelo Semantics label
// 		console.log('Procurando botão "Abrir Equipe 1"...');
// 		let equipe1Button;
// 		try {
// 			equipe1Button = await driver.findElement(
// 				By.xpath("//flt-semantics[@aria-label='Abrir Equipe 1']")
// 			);
// 			console.log('Botão "Abrir Equipe 1" encontrado!');
// 		} catch (e) {
// 			console.error('Botão "Abrir Equipe 1" NÃO encontrado!');
// 			// Tira screenshot para depuração
// 			await driver.takeScreenshot().then((image) => {
// 				fs.writeFileSync(
// 					"./fotos/impostoEquipe1/erro-abrir-equipe1.png",
// 					image,
// 					"base64"
// 				);
// 				console.log("Screenshot de erro salva em erro-abrir-equipe1.png");
// 			});
// 			throw e;
// 		}
// 		await equipe1Button.click();
// 		await driver.sleep(15000);

// 		// Screenshot da tela de login
// 		await driver.takeScreenshot().then((image) => {
// 			fs.writeFileSync(
// 				"./fotos/impostoEquipe1/tela-login-equipe1.png",
// 				image,
// 				"base64"
// 			);
// 			console.log("Screenshot da tela de login salva.");
// 		});

// 		// 3. Preencher login e senha

// 		// Busca os campos de login primeiro por Semantics, depois por busca genérica se necessário
// 		let userInput, passInput;
// 		try {
// 			userInput = await driver.findElement(
// 				By.xpath(
// 					"//flt-semantics[@aria-label='Usuário']//following-sibling::textarea | //flt-semantics[@aria-label='Usuário']//following-sibling::input"
// 				)
// 			);
// 			passInput = await driver.findElement(
// 				By.xpath(
// 					"//flt-semantics[@aria-label='Senha']//following-sibling::textarea | //flt-semantics[@aria-label='Senha']//following-sibling::input"
// 				)
// 			);
// 			console.log("Campos de login encontrados por Semantics!");
// 		} catch (e) {
// 			console.error(
// 				"Campos de login NÃO encontrados por Semantics. Tentando busca genérica por <input>/<textarea>..."
// 			);
// 			// Busca genérica: pega os dois primeiros inputs/textarea visíveis e habilitados na tela
// 			const allInputs = await driver.findElements(By.css("input, textarea"));
// 			const visibleInputs = [];
// 			for (const el of allInputs) {
// 				const displayed = await el.isDisplayed();
// 				const enabled = await el.isEnabled();
// 				if (displayed && enabled) visibleInputs.push(el);
// 				if (visibleInputs.length === 2) break;
// 			}
// 			if (visibleInputs.length >= 2) {
// 				userInput = visibleInputs[0];
// 				passInput = visibleInputs[1];
// 				console.log("Campos de login encontrados por busca genérica (visíveis e habilitados)!");
// 			} else {
// 				await driver.takeScreenshot().then((image) => {
// 					fs.writeFileSync(
// 						"./fotos/impostoEquipe1/erro-login-campos.png",
// 						image,
// 						"base64"
// 					);
// 					console.log("Screenshot de erro salva em erro-login-campos.png");
// 				});
// 				throw new Error("Não foi possível encontrar os campos de login visíveis e habilitados!");
// 			}
// 		}

// 		// Função robusta para preencher campo
// 		async function fillInput(driver, el, value) {
// 			await driver.wait(async () => await el.isDisplayed() && await el.isEnabled(), 5000);
// 			await el.click();
// 			await driver.sleep(100);
// 			if (el.clear) await el.clear();
// 			await el.sendKeys(value);
// 			await driver.sleep(100);
// 			// Validação: tenta ler o valor digitado
// 			let typed = null;
// 			try {
// 				typed = await el.getAttribute('value');
// 			} catch (e) {}
// 			if (typed !== null && typed !== value) {
// 				throw new Error(`Valor digitado não corresponde: esperado=${value}, obtido=${typed}`);
// 			}
// 		}

// 		await fillInput(driver, userInput, "admin");
// 		await fillInput(driver, passInput, "1234");

// 		// Screenshot após preencher login
// 		await driver.takeScreenshot().then((image) => {
// 			fs.writeFileSync(
// 				"./fotos/impostoEquipe1/preenchido-login-equipe1.png",
// 				image,
// 				"base64"
// 			);
// 			console.log("Screenshot após preencher login salva.");
// 		});

// 		// 4. Clicar no botão de login (assumindo que é o terceiro botão visível ou pelo texto "Entrar")
// 		let loginButton;
// 		try {
// 			loginButton = await driver.findElement(
// 				By.xpath("//flt-semantics[@aria-label='Entrar']")
// 			);
// 		} catch (e) {
// 			// fallback: pega o primeiro botão
// 			const allButtons = await driver.findElements(
// 				By.css('flt-semantics[role="button"]')
// 			);
// 			loginButton = allButtons[0];
// 		}
// 		await loginButton.click();
// 		await driver.sleep(10000);

// 		// Screenshot após login
// 		await driver.takeScreenshot().then((image) => {
// 			fs.writeFileSync(
// 				"./fotos/impostoEquipe1/tela-pos-login-equipe1.png",
// 				image,
// 				"base64"
// 			);
// 		});

// 		// 5. Clique em "Cálculo ICMS"
// 		const icmsButton = await driver.findElement(
// 			By.xpath("//flt-semantics[@aria-label='Cálculo ICMS']")
// 		);
// 		await icmsButton.click();
// 		await driver.sleep(10000);

// 		// Screenshot da tela de cálculo de ICMS
// 		await driver.takeScreenshot().then((image) => {
// 			fs.writeFileSync("./fotos/impostoEquipe1/tela-icms.png", image, "base64");
// 		});

// 		// 6. Preencha os campos de valor e alíquota

// 		// Busca genérica por todos os campos de input/textarea na tela de ICMS (simples)
// 		let icmsInputs;
// 		try {
// 			icmsInputs = await driver.findElements(
// 				By.css('input, textarea')
// 			);
// 			// Filtra apenas visíveis e habilitados
// 			const visibleInputs = [];
// 			for (const el of icmsInputs) {
// 				const displayed = await el.isDisplayed();
// 				const enabled = await el.isEnabled();
// 				if (displayed && enabled) visibleInputs.push(el);
// 				if (visibleInputs.length === 2) break;
// 			}
// 			if (visibleInputs.length < 2)
// 				throw new Error(
// 					"Menos de 2 campos de input visíveis/habilitados na tela de ICMS!"
// 				);
// 			icmsInputs = visibleInputs;
// 			console.log(`Campos de ICMS encontrados: ${icmsInputs.length}`);
// 		} catch (e) {
// 			console.error("Campos de ICMS NÃO encontrados!");
// 			await driver.takeScreenshot().then((image) => {
// 				fs.writeFileSync(
// 					"./fotos/impostoEquipe1/erro-campos-icms.png",
// 					image,
// 					"base64"
// 				);
// 				console.log("Screenshot de erro salva em erro-campos-icms.png");
// 			});
// 			throw e;
// 		}

// 		// Preenche os dois campos (valor, alíquota) de forma simples e robusta
// 		await fillInput(driver, icmsInputs[0], "1000");
// 		await fillInput(driver, icmsInputs[1], "18");

// 		// Screenshot após preencher os campos
// 		await driver.takeScreenshot().then((image) => {
// 			fs.writeFileSync(
// 				"./fotos/impostoEquipe1/preenchido-icms.png",
// 				image,
// 				"base64"
// 			);
// 			console.log("Screenshot após preencher campos de ICMS salva.");
// 		});

// 		// 7. Clique no botão "Calcular ICMS"
// 		const calcularButton = await driver.findElement(
// 			By.xpath("//flt-semantics[@aria-label='Calcular ICMS']")
// 		);
// 		await calcularButton.click();
// 		await driver.sleep(3000);

// 		// Screenshot do resultado
// 		await driver.takeScreenshot().then((image) => {
// 			fs.writeFileSync(
// 				"./fotos/impostoEquipe1/resultado-icms.png",
// 				image,
// 				"base64"
// 			);
// 		});

// 		await driver.navigate().back();
// 		await driver.sleep(5000);

// 		// 8. Clique no botão "Nota Fiscal"
// 		console.log('Procurando botão "Nota Fiscal"...');
// 		const notaFiscalButton = await driver.findElement(
// 		By.xpath("//flt-semantics[@aria-label='Nota Fiscal']")
// 		);
// 		await notaFiscalButton.click();
// 		console.log('Botão "Nota Fiscal" clicado, aguardando nova tela...');
// 		await driver.sleep(10000);  // Ajuste o tempo conforme a velocidade do app

// 		// Screenshot da nova tela após clicar em "Nota Fiscal"
// 		await driver.takeScreenshot().then((image) => {
// 		fs.writeFileSync("./fotos/impostoEquipe1/tela-nota-fiscal.png", image, "base64");
// 		console.log("Screenshot da nova tela de Nota Fiscal salva.");
// 		});

// 		// 9. Clique no botão "Consultar API"
// 		console.log('Procurando botão "Consultar API"...');
// 		const consultarApiButton = await driver.findElement(
// 			By.xpath("//*[text()='Consultar API']")
// 		);
// 		await consultarApiButton.click();
// 		console.log('Botão "Consultar API" clicado.');
// 		await driver.sleep(5000);  // Ajuste conforme a resposta da API

// 		// Screenshot após clicar em "Consultar API"
// 		await driver.takeScreenshot().then((image) => {
// 		fs.writeFileSync("./fotos/impostoEquipe1/resultado-consultar-api.png", image, "base64");
// 		console.log("Screenshot do resultado de Consultar API salva.");
// 		});

// 		console.log("Parte de Consulta da Nota Fiscal finalizada com sucesso!");

// 		console.log("Parte de Consulta da Nota Fiscal finalizada com sucesso!");

// 		// Voltar à tela principal para acessar o cálculo de PIS/COFINS
// 		await driver.navigate().back();
// 		await driver.sleep(5000);

// 		// 10. Clique no botão "PIS/COFINS"
// 		console.log('Procurando botão "PIS/COFINS"...');

// 		let pisCofinsButton;
// 		try {
// 			pisCofinsButton = await driver.findElement(By.xpath("//flt-semantics[@aria-label='PIS/COFINS']"));
// 		} catch (error) {
// 			console.log("Não foi possível encontrar o botão 'PIS/COFINS' por Semantics. Tentando busca genérica...");

// 			try {
// 				pisCofinsButton = await driver.findElement(By.xpath("//*[contains(text(),'PIS/COFINS')]"));
// 			} catch (error) {
// 				try {
// 					pisCofinsButton = await driver.findElement(By.xpath("//*[contains(., 'PIS') and contains(., 'COFINS')]"));
// 				} catch (error) {
// 					// Tire screenshot para debug
// 					await driver.takeScreenshot().then((image) => {
// 						fs.writeFileSync("./fotos/impostoEquipe1/erro-botao-pis-cofins.png", image, "base64");
// 						console.log("Screenshot do erro salva em erro-botao-pis-cofins.png");
// 					});
// 					throw new Error("Não foi possível encontrar o botão PIS/COFINS por nenhum método");
// 				}
// 			}
// 		}
		
// 		await pisCofinsButton.click();
// 		console.log('Botão "PIS/COFINS" clicado, aguardando nova tela...');
// 		await driver.sleep(5000);

// 		// Screenshot da tela de cálculo de PIS/COFINS
// 		await driver.takeScreenshot().then((image) => {
//     		fs.writeFileSync("./fotos/impostoEquipe1/tela-pis-cofins.png", image, "base64");
//     		console.log("Screenshot da tela de PIS/COFINS salva.");
// 		});

// 		// 11. Selecionar o regime (cumulativo ou não-cumulativo)
// 		// Por padrão, cumulativo já está selecionado, então não precisamos clicar

// 		// 12. Preencher os campos de receita bruta e alíquota
// 		let pisCofinsInputs;
// 		try {
//     		pisCofinsInputs = await driver.findElements(By.css('input, textarea'));
//     		// Filtra apenas visíveis e habilitados
//     		const visibleInputs = [];
//     		for (const el of pisCofinsInputs) {
//         		const displayed = await el.isDisplayed();
//         		const enabled = await el.isEnabled();
//         		if (displayed && enabled) visibleInputs.push(el);
//         		if (visibleInputs.length === 2) break;
//     		}
//     		if (visibleInputs.length < 2)
//         		throw new Error("Menos de 2 campos de input visíveis/habilitados na tela de PIS/COFINS!");
//     		pisCofinsInputs = visibleInputs;
//     		console.log(`Campos de PIS/COFINS encontrados: ${pisCofinsInputs.length}`);
// 		} catch (e) {
//     		console.error("Campos de PIS/COFINS NÃO encontrados!");
//     		await driver.takeScreenshot().then((image) => {
//         		fs.writeFileSync("./fotos/impostoEquipe1/erro-campos-pis-cofins.png", image, "base64");
//         		console.log("Screenshot de erro salva em erro-campos-pis-cofins.png");
//     		});
//     		throw e;
// 		}

// 		// Preencher os campos (receita bruta, alíquota)
// 		await fillInput(driver, pisCofinsInputs[0], "10000");
// 		await fillInput(driver, pisCofinsInputs[1], "100");

// 		// Screenshot após preencher os campos
// 		await driver.takeScreenshot().then((image) => {
//     		fs.writeFileSync("./fotos/impostoEquipe1/preenchido-pis-cofins.png", image, "base64");
//     		console.log("Screenshot após preencher campos de PIS/COFINS salva.");
// 		});

// 		// 13. Clique no botão "Calcular PIS/COFINS"
// 		let calcularPisCofinsButton;
// 		try {
// 			calcularPisCofinsButton = await driver.findElement(
// 				By.xpath("//flt-semantics[@aria-label='Calcular PIS/COFINS']")
// 			);
// 		} catch (error) {
// 			console.log("Não foi possível encontrar o botão 'Calcular PIS/COFINS' por Semantics. Tentando busca genérica...");

// 			try {
// 				calcularPisCofinsButton = await driver.findElement(By.xpath("//*[contains(text(),'Calcular PIS/COFINS')]"));
// 			} catch (error) {
// 				try {
// 					calcularPisCofinsButton = await driver.findElement(By.xpath("//*[contains(., 'Calcular')]"));
// 				} catch (error) {
// 					// Busca por qualquer botão visível
// 					const allButtons = await driver.findElements(By.css('flt-semantics[role="button"]'));
// 					const visibleButtons = [];
// 					for (const button of allButtons) {
// 						if (await button.isDisplayed()) {
// 							visibleButtons.push(button);
// 						}
// 					}
					
// 					if (visibleButtons.length > 0) {
// 						calcularPisCofinsButton = visibleButtons[0];  // Usa o primeiro botão visível
// 						console.log("Usando o primeiro botão visível como fallback");
// 					} else {
// 						// Tire screenshot para debug
// 						await driver.takeScreenshot().then((image) => {
// 							fs.writeFileSync("./fotos/impostoEquipe1/erro-botao-calcular-pis-cofins.png", image, "base64");
// 							console.log("Screenshot do erro salva em erro-botao-calcular-pis-cofins.png");
// 						});
// 						throw new Error("Não foi possível encontrar nenhum botão para calcular PIS/COFINS");
// 					}
// 				}
// 			}
// 		}

// 		await calcularPisCofinsButton.click();
// 		console.log('Botão "Calcular PIS/COFINS" clicado.');
// 		await driver.sleep(3000);

// 		// Screenshot do resultado
// 		await driver.takeScreenshot().then((image) => {
//     		fs.writeFileSync("./fotos/impostoEquipe1/resultado-pis-cofins.png", image, "base64");
//     		console.log("Screenshot do resultado de PIS/COFINS salva.");
// 		});

// 		console.log("Parte de Cálculo de PIS/COFINS finalizada com sucesso!");

// 		// 14. Voltar para a tela principal antes de buscar o botão "Cálculo IPI"
// 		try {
// 			// Tenta clicar no botão de voltar (seta)
// 			const backButton = await driver.findElement(By.xpath("//flt-semantics[@aria-label='Voltar']"));
// 			await backButton.click();
// 			await driver.sleep(2000); // Aguarda a navegação
// 		} catch (e) {
// 			// Se não encontrar o botão de voltar, pode tentar usar o navegador
// 			await driver.navigate().back();
// 			await driver.sleep(2000);
// 		}

// 		// Screenshot antes de buscar o botão
// 		await driver.takeScreenshot().then((image) => {
// 			fs.writeFileSync("./fotos/impostoEquipe1/debug-antes-botao-ipi.png", image, "base64");
// 			console.log("Screenshot antes de buscar o botão IPI salva.");
// 		});

// 		// Rola a tela para baixo
// 		await driver.executeScript("window.scrollTo(0, document.body.scrollHeight);");
// 		await driver.sleep(1000);

// 		let ipiButton;
// 		try {
// 			await driver.wait(until.elementLocated(By.xpath("//*[contains(text(),'Cálculo IPI')]")), 10000);
// 			ipiButton = await driver.findElement(By.xpath("//*[contains(text(),'Cálculo IPI')]"));
// 			await driver.wait(until.elementIsVisible(ipiButton), 5000);
// 			console.log('Botão "Cálculo IPI" encontrado pelo texto!');
// 		} catch (error) {
// 			await driver.takeScreenshot().then((image) => {
// 				fs.writeFileSync("./fotos/impostoEquipe1/erro-botao-ipi.png", image, "base64");
// 				console.log("Screenshot do erro salva em erro-botao-ipi.png");
// 			});
// 			throw new Error("Não foi possível encontrar o botão Cálculo IPI por nenhum método");
// 		}
// 		await ipiButton.click();
// 		await driver.sleep(5000);

// 		// Screenshot da tela de cálculo de IPI
// 		await driver.takeScreenshot().then((image) => {
// 			fs.writeFileSync("./fotos/impostoEquipe1/tela-ipi.png", image, "base64");
// 			console.log("Screenshot da tela de IPI salva.");
// 		});

// 		// 15.  Preencher os campos de valor, quantidade e alíquota
// 		let ipiInputs;
// 		try {
// 			ipiInputs = await driver.findElements(By.css('input, textarea'));
// 			// Filtra apenas visíveis e habilitados
// 			const visibleInputs = [];
// 			for (const el of ipiInputs) {
// 				const displayed = await el.isDisplayed();
// 				const enabled = await el.isEnabled();
// 				if (displayed && enabled) visibleInputs.push(el);
// 				if (visibleInputs.length === 3) break;
// 			}
// 			if (visibleInputs.length < 3)
// 				throw new Error("Menos de 3 campos de input visíveis/habilitados na tela de IPI!");
// 			ipiInputs = visibleInputs;
// 			console.log(`Campos de IPI encontrados: ${ipiInputs.length}`);
// 		} catch (e) {
// 			console.error("Campos de IPI NÃO encontrados!");
// 			await driver.takeScreenshot().then((image) => {
// 				fs.writeFileSync("./fotos/impostoEquipe1/erro-campos-ipi.png", image, "base64");
// 				console.log("Screenshot de erro salva em erro-campos-ipi.png");
// 			});
// 			throw e;
// 		}

// 		// Preenche os três campos (valor, quantidade, alíquota)
// 		await fillInput(driver, ipiInputs[0], "1000");
// 		await fillInput(driver, ipiInputs[1], "5");    
// 		await fillInput(driver, ipiInputs[2], "10");  

// 		// Screenshot após preencher os campos
// 		await driver.takeScreenshot().then((image) => {
// 			fs.writeFileSync("./fotos/impostoEquipe1/preenchido-ipi.png", image, "base64");
// 			console.log("Screenshot após preencher campos de IPI salva.");
// 		});

// 		// 16.Clique no botão "Calcular IPI"
// 		let calcularIpiButton;
// 		try {
// 			calcularIpiButton = await driver.findElement(By.xpath("//flt-semantics[@aria-label='Calcular IPI']"));
// 		} catch (error) {
// 			try {
// 				calcularIpiButton = await driver.findElement(By.xpath("//*[contains(text(),'Calcular IPI')]"));
// 			} catch (error) {
// 				calcularIpiButton = await driver.findElement(By.xpath("//*[contains(., 'Calcular')]"));
// 			}
// 		}
// 		await calcularIpiButton.click();
// 		console.log('Botão "Calcular IPI" clicado.');
// 		await driver.sleep(3000);

// 		// Screenshot do resultado
// 		await driver.takeScreenshot().then((image) => {
// 			fs.writeFileSync("./fotos/impostoEquipe1/resultado-ipi.png", image, "base64");
// 			console.log("Screenshot do resultado de IPI salva.");
// 		});

// 		// Voltar à tela principal
// 		await driver.navigate().back();
// 		await driver.sleep(5000);

// 		console.log("Teste funcional da Equipe 1 finalizado com sucesso!");
// 	} catch (error) {
// 		console.error("Erro no teste funcional da Equipe 1:", error);
// 	} finally {
// 		await driver.quit();
// 	}
// })();
