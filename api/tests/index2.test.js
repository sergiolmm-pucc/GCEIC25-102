 
//index.test.js
const {aplicarDesconto} = require('../controllers/funcoes_base.js')

describe('Texte exemplo', () => {
    test('Aplicar desconto', () => {
        const result = aplicarDesconto(10,5);
        expect(result).toEqual(5);
    })
})

