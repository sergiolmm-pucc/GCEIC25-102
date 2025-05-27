 
//index.test.js
const index = require('./../controllers/funcoes_base.js')

describe('Texte exemplo', () => {
    test('Aplicar desconto', () => {
        const result = index.aplicarDesconto(10,5);
        expect(result).toEqual(5);
    })
})