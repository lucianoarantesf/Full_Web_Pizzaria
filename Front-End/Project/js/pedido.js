var imported = document.createElement('script');
imported.src = '../js/bootbox/bootbox.all.min.js';
document.head.appendChild(imported);

var Comando;
const GComando = [];
const pedido = [];
var ButtonEnviar = '<div class="col-md-auto" style="text-align: center; margin-top: 10px;"> <button type="button" class="btn btn-success" onclick="EnviarPedido()" >Finalizar Pedido</button> </div>'

function MontarLista(Ativo, id, Valor, Pizza, Detalhe) {
    var ID_PESSOA = localStorage.getItem("ID_PESSOA");
    // Cria a Lista
    const abreLi = `<ul id="itemCarrinho-Pedido${id}" class="list-group list-group"><li id="${id}" class="list-group-item d-flex justify-content-between align-items-start">`;
    const DivItem = `<div class="ms-2 me-auto">` +
        `<div id="itemCarrinho-PedidoTitulo${id}" class="fw-bold">${Pizza} - ${Detalhe}</div>` +
        `<p id="itemCarrinho-PedidoDetalhe${id}">Valor : R$${Valor}</p>` +
        `</div>`;
    const DivQtd = `<div style="display: grid;">` +
        `<span id="qtdProd${id}" style="width: 25px;margin-left: auto;" class="badge bg-primary rounded-pill">1</span>` +
        `</div>`;
    const fechaLi = `</li></ul>`;
    var lista = window.document.getElementById('itemCarrinho-Pedido' + id)
    Comando = abreLi + DivItem + DivQtd + fechaLi

    if (Ativo === true) {
        if (lista === null) {
            // inseirindo a lista de comandos
            GComando.push(Comando);
            pedido.push({ "ID_PESSOA": ID_PESSOA, "id": id, "valor": Valor, "quantidade": 1, "pizza": Pizza, "detalhe": Detalhe });

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

        var indicePedido = pedido.findIndex(obj => obj.id == id);
        while (indicePedido >= 0) {
            pedido.splice(indicePedido, 1);
            indicePedido = pedido.findIndex(obj => obj.id == id);
        }

        var indice = GComando.indexOf(Comando);
        while (indice >= 0) {
            GComando.splice(indice, 1);
            indice = GComando.indexOf(Comando);
        }

        if (GComando.length === 1) { // verificando se a lista esta com apensa 1 registro
            var indice2 = GComando.indexOf(ButtonEnviar);
            if (indice2 === 0) { // se este registro for o index do buttun então devo apagar
                GComando.splice(indice2, 1);
            }
        }
    }

    return window.document.getElementById('itemCarrinho-Pedido').innerHTML = GComando;
}



function EnviarPedido() {
    var myHeaders = new Headers();
    myHeaders.append("Authorization", "Basic QWRtaW46QWFTbEDDp1EqaFQldlFNcHZ6");
    myHeaders.append("Content-Type", "application/json");

    var Body = JSON.stringify(pedido);

    var requestOptions = {
        method: 'POST',
        headers: myHeaders,
        body: Body,
        redirect: 'follow'
    };

    fetch(`http://127.0.0.1:9000/pizzas/post`, requestOptions)
        .then(async(response) => {
            response.json()
                .then(data => {
                    const Result = data => data.retorno === 'OK';
                    var resultado = data.retorno;
                    if (resultado === 'OK') {
                        GComando.splice(0, GComando.length)
                        pedido.splice(0, pedido.length);

                        window.document.getElementById('itemCarrinho-Pedido').innerHTML = GComando;
                        bootbox.alert('Seu pedido foi enviado com Sucesso.')

                        for (let i = 1; i < 9; i++) {
                            if (window.document.getElementById(`ckbP-${i}`).checked) {
                                window.document.getElementById(`ckbP-${i}`).checked = false;
                            }
                            if (window.document.getElementById(`ckbM-${i}`).checked) {
                                window.document.getElementById(`ckbM-${i}`).checked = false;
                            }
                            if (window.document.getElementById(`ckbM-${i}`).checked) {
                                window.document.getElementById(`ckbM-${i}`).checked = false;
                            }
                        }

                    } else {
                        bootbox.alert('Erro ao enviar pedido: ' + resultado)
                    }
                })
        });
}






//PEDIDO
// COMANDO QUE VERIFICA O PREÇO DOS PEDIDOS
function preco(tam, tag) {
    var id = tam + '-' + tag;

    const options = {
        method: 'GET',
        mode: 'cors',
        headers: { 'Authorization': 'Basic QWRtaW46QWFTbEDDp1EqaFQldlFNcHZ6' }
    };

    fetch(`http://127.0.0.1:9000/pizzas?id=` + id, options)
        .then(async(response) => {
            response.json()
                .then(data => {
                    const verificaPizza = data => data.id == id;
                    const preco = data.filter(verificaPizza);
                    var Valor = preco[0].valor;
                    window.document.getElementById('tagId' + tag).innerText = 'Valor R$' + Valor;
                })
        })
        .catch(e => alert('Erro: ' + e, message));


}
//SAINDO COM O CURSOR SOBRE O TAMANHO //
function saidapreco(tag) {
    return window.document.getElementById('tagId' + tag).innerText = 'Selecione o Tamanho:';
}

// forma o pedido 
function formaPedido(id, campo) {
    var input = window.document.getElementsByName(campo);
    var Ativo = input[0].checked

    const options = {
        method: 'GET',
        mode: 'cors',
        headers: { 'Authorization': 'Basic QWRtaW46QWFTbEDDp1EqaFQldlFNcHZ6' }
    };

    fetch(`http://127.0.0.1:9000/pizzas?id=` + id, options)
        .then(async(response) => {
            response.json()
                .then(data => {
                    const verificaPizza = data => data.id == id;
                    const preco = data.filter(verificaPizza)
                    var Pizza = preco[0].pizza;
                    var Detalhe = preco[0].detalhe;
                    var Valor = preco[0].valor;
                    MontarLista(Ativo, id, Valor, Pizza, Detalhe);
                })
        })
        .catch(e => alert('Erro: ' + e, message));
}



// faz voltar ao carrinho de compras
function Carrinho() {
    return window.location.href = "../page/pedido.html#itemCarrinho-Pedido";

}