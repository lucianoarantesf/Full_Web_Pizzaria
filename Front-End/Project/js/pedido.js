const pizzas = [
    { title: "Pizzas", id: "P-1", pizza: "Calabresa", valor: 25.99, detalhe: "Pequena" },
    { title: "Pizzas", id: "M-1", pizza: "Calabresa", valor: 35.99, detalhe: "Media" },
    { title: "Pizzas", id: "G-1", pizza: "Calabresa", valor: 49.99, detalhe: "Grande" },
    { title: "Pizzas", id: "P-2", pizza: "Frango Catupiry", valor: 23.99, detalhe: "Pequena" },
    { title: "Pizzas", id: "M-2", pizza: "Frango Catupiry", valor: 34.99, detalhe: "Media" },
    { title: "Pizzas", id: "G-2", pizza: "Frango Catupiry", valor: 44.99, detalhe: "Grande" },
    { title: "Pizzas", id: "P-3", pizza: "Marguerita", valor: 28.99, detalhe: "Pequena" },
    { title: "Pizzas", id: "M-3", pizza: "Marguerita", valor: 38.99, detalhe: "Media" },
    { title: "Pizzas", id: "G-3", pizza: "Marguerita", valor: 52.99, detalhe: "Grande" },
    { title: "Pizzas", id: "P-4", pizza: "4 Queijo", valor: 19.99, detalhe: "Pequena" },
    { title: "Pizzas", id: "M-4", pizza: "4 Queijo", valor: 24.99, detalhe: "Media" },
    { title: "Pizzas", id: "G-4", pizza: "4 Queijo", valor: 29.99, detalhe: "Grande" },
    { title: "Pizzas", id: "P-5", pizza: "Carne Seca", valor: 26.99, detalhe: "Pequena" },
    { title: "Pizzas", id: "M-5", pizza: "Carne Seca", valor: 38.99, detalhe: "Media" },
    { title: "Pizzas", id: "G-5", pizza: "Carne Seca", valor: 48.99, detalhe: "Grande" },
    { title: "Pizzas", id: "P-6", pizza: "Portuguesa", valor: 24.99, detalhe: "Pequena" },
    { title: "Pizzas", id: "M-6", pizza: "Portuguesa", valor: 33.99, detalhe: "Media" },
    { title: "Pizzas", id: "G-6", pizza: "Portuguesa", valor: 48.99, detalhe: "Grande" },
    { title: "Pizzas", id: "P-7", pizza: "Leite em Pó", valor: 33.99, detalhe: "Pequena" },
    { title: "Pizzas", id: "M-7", pizza: "Leite em Pó", valor: 44.99, detalhe: "Media" },
    { title: "Pizzas", id: "G-7", pizza: "Leite em Pó", valor: 54.99, detalhe: "Grande" },
    { title: "Pizzas", id: "P-8", pizza: "Nutella e Sorvete", valor: 38.99, detalhe: "Pequena" },
    { title: "Pizzas", id: "M-8", pizza: "Nutella e Sorvete", valor: 48.99, detalhe: "Media" },
    { title: "Pizzas", id: "G-8", pizza: "Nutella e Sorvete", valor: 59.99, detalhe: "Grande" }
]

var Comando;
var GComando = [];
var ButtonEnviar = '<div class="col-md-auto" style="text-align: center; margin-top: 10px;"> <button type="button" class="btn btn-success">Finalizar Pedido</button> </div>'

//PEDIDO
// COMANDO QUE VERIFICA O PREÇO DOS PEDIDOS
//POR ENQUANTO ESTA NO ARRAY ATÉ EU CONECTAR COM O BANCO DE DADOS
function preco(tam, tag) {
    // TABELA DE PREÇOS // 
    const verificaPizza = pizzas => pizzas.id == tam + '-' + tag;
    const preco = pizzas.filter(verificaPizza)
    return window.document.getElementById('preco' + tag).innerText = 'Valor R$' + preco[0].valor;
}
//SAINDO COM O CURSOR SOBRE O TAMANHO //
function saidapreco(tag) {
    return window.document.getElementById('preco' + tag).innerText = 'Selecione o Tamanho:';
}

function Carrinho() {
    return window.location.href = "../page/pedido.html#itemCarrinho-Pedido";

}

function formaPedido(id, campo) {

    var input = window.document.getElementsByName(campo);
    var Ativo = input[0].checked


    const verificaPizza = pizzas => pizzas.id == id;
    const preco = pizzas.filter(verificaPizza)
    var Pizza = preco[0].pizza;
    var Detalhe = preco[0].detalhe;
    var Valor = preco[0].valor;

    // Cria a Lista
    const abreLi = `<ul id="itemCarrinho-Pedido${id}" class="list-group list-group"><li id="${id}" class="list-group-item d-flex justify-content-between align-items-start">`
    const DivItem = `<div class="ms-2 me-auto">` +
        `<div id="itemCarrinho-PedidoTitulo${id}" class="fw-bold">${Pizza} - ${Detalhe}</div>` +
        `<p id="itemCarrinho-PedidoDetalhe${id}">Valor : R$${Valor}</p>` +
        `</div>`
    const DivQtd = `<div style="display: grid;">` +
        `<span id="qtdProd${id}" style="width: 25px;margin-left: auto;" class="badge bg-primary rounded-pill">1</span>` +
        `<div style="display: inline;margin-top: 8px;">` +
        `<span style="width: 25px;margin-left: auto; background-color: green;" type="button" class="badge rounded-pill" onclick="quantidade('${id}',1,0)">+</span>` +
        `<span style="width: 25px;margin-left: auto; background-color: red;" type="button" class="badge rounded-pill" onclick="quantidade('${id}',0,1)">-</span>` +
        `</div>` +
        `</div>`
    const fechaLi = `</li></ul>`
    var lista = window.document.getElementById('itemCarrinho-Pedido' + id)
    Comando = abreLi + DivItem + DivQtd + fechaLi

    if (Ativo === true) {
        if (lista === null) {
            // inseirindo a lista de comandos
            GComando.push(Comando);

            // apagando e dps inserindo o botão de enviar
            var buscar = ButtonEnviar;
            var indice = GComando.indexOf(buscar);
            while (indice >= 0) {
                GComando.splice(indice, 1);
                indice = GComando.indexOf(buscar);
            }
            GComando.push(ButtonEnviar);
        }
    } else {
        var buscar = Comando;
        var indice = GComando.indexOf(buscar);
        while (indice >= 0) {
            GComando.splice(indice, 1);
            indice = GComando.indexOf(buscar);
        }

        if (GComando.length === 1) { // verificando se a lista esta com apensa 1 registro
            var buscar2 = ButtonEnviar;
            var indice2 = GComando.indexOf(buscar2);
            if (indice2 === 0) { // se este registro for o index do buttun então devo apagar
                GComando.splice(indice2, 1);
            }
        }
    }

    return window.document.getElementById('itemCarrinho-Pedido').innerHTML = GComando;
}




// COMANDO BOTÃO DE SOMA E SUB DO PEDIDO
function quantidade(id, suma, subi) {
    input = window.document.getElementById('qtdProd' + id);
    qtd = parseInt(input.innerText);
    resultado = null;
    if (suma == 1) {
        var qtd = qtd + 1;
        resultado = window.document.getElementById('qtdProd' + id).innerText = qtd;
    }
    if (subi == 1) {
        var qtd = qtd - 1;
        resultado = window.document.getElementById('qtdProd' + id).innerText = qtd;
    }
    if (qtd <= 0) {
        qtd = 0
        resultado = window.document.getElementById('qtdProd' + id).innerText = qtd;
    } else if (qtd == 10 || qtd > 10) {
        var qtd = 10;
        resultado = window.document.getElementById('qtdProd' + id).innerText = qtd;
    } else {
        resultado = null;


    }
    return resultado;
}