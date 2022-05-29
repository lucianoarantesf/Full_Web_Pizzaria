function sleep(milliseconds) {
    return new Promise(resolve => setTimeout(resolve, milliseconds))
}


async function CarregaAcompPedidos() {
    var separador = `<hr class="hr1"></hr>`;
    const GData = [];
    window.document.getElementById('acomp-pedido-details').innerHTML = `<div class="c-loader"></div>`
    const ID_PESSOA = localStorage.getItem("ID_PESSOA");
    const options = {
        method: 'GET',
        mode: 'cors',
        headers: { 'Authorization': 'Basic QWRtaW46QWFTbEDDp1EqaFQldlFNcHZ6' }
    };

    fetch(`http://127.0.0.1:9000/acompanhamento/pedidos?id=` + ID_PESSOA, options)
        .then(async(response) => {
            response.json()
                .then(data => {
                    window.document.getElementById('acomp-pedido-details').innerHTML = data + separador;

                })
        })
        .catch(e => alert('Erro: ' + e, message));

}